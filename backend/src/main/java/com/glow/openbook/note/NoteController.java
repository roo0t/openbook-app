package com.glow.openbook.note;

import com.glow.openbook.book.Book;
import com.glow.openbook.book.IsbnLookupService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.hateoas.CollectionModel;
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.MediaTypes;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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

    @GetMapping(value = "/{isbn}", produces = MediaTypes.HAL_JSON_VALUE)
    public ResponseEntity getNotes(@PathVariable("isbn") String isbn) {
        Optional<Book> optionalBook = isbnLookupService.getBookByIsbn(isbn);
        if (optionalBook.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        Book book = optionalBook.get();
        Iterable<Note> notes = noteService.getNotes(book);
        List<EntityModel<Note>> entities = StreamSupport.stream(notes.spliterator(), false)
                .map(note -> EntityModel.of(note))
                .collect(Collectors.toList());
        return ResponseEntity.ok().body(
                CollectionModel
                        .of(entities)
                        .add(linkTo(methodOn(NoteController.class).getNotes(isbn)).withSelfRel()));
    }
}
