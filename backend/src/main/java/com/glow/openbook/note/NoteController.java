package com.glow.openbook.note;

import com.glow.openbook.book.Book;
import com.glow.openbook.book.IsbnLookupService;
import com.glow.openbook.member.Member;
import com.glow.openbook.member.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.hateoas.CollectionModel;
import org.springframework.hateoas.MediaTypes;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.websocket.server.PathParam;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

@RestController
@RequestMapping("note")
public class NoteController {

    @Autowired
    private IsbnLookupService isbnLookupService;

    @Autowired
    private NoteService noteService;

    @Autowired
    private MemberService memberService;

    @Autowired
    private NoteModelAssembler noteModelAssembler;

    @GetMapping(value = "/{id}", produces = MediaTypes.HAL_JSON_VALUE)
    public ResponseEntity getNote(@PathVariable Long id) {
        Optional<Note> note = noteService.getNote(id);
        if (note.isPresent()) {
            return ResponseEntity.ok(noteModelAssembler.toModel(note.get()));
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping(value = {"", "/"}, produces = MediaTypes.HAL_JSON_VALUE)
    public ResponseEntity getNotes(@PathParam("isbn") String isbn) {
        Optional<Book> optionalBook = isbnLookupService.getBookByIsbn(isbn);
        if (optionalBook.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        Book book = optionalBook.get();
        Iterable<Note> notes = noteService.getNotes(book);
        List<NoteModel> entities = StreamSupport.stream(notes.spliterator(), false)
                .map(noteModelAssembler::toModel)
                .collect(Collectors.toList());
        return ResponseEntity.ok().body(
                CollectionModel
                        .of(entities)
                        .add(linkTo(methodOn(NoteController.class).getNotes(isbn)).withSelfRel()));
    }

    @PostMapping("/{isbn}/{page}")
    public ResponseEntity addNote(@PathVariable("isbn") String isbn,
                                  @PathVariable("page") int page,
                                  @RequestParam("images") MultipartFile[] images,
                                  @ModelAttribute AddNoteRequest addNoteRequest) {
        Optional<Book> optionalBook = isbnLookupService.getBookByIsbn(isbn);
        if (optionalBook.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        Book book = optionalBook.get();

        if (page < 1) {
            return ResponseEntity.badRequest().build();
        }
        if (page > book.getTotalPages()) {
            return ResponseEntity.badRequest().build();
        }

        Member member = memberService.getCurrentMember();

        Note note = noteService.addNote(
                member, book, page, addNoteRequest.getContent(),
                Arrays.stream(images).collect(Collectors.toList()));

        return ResponseEntity
                .created(linkTo(methodOn(NoteController.class).getNote(note.getId())).toUri())
                .body(noteModelAssembler.toModel(note));
    }
}
