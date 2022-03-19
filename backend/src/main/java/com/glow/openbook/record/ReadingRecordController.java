package com.glow.openbook.record;

import com.glow.openbook.book.Book;
import com.glow.openbook.book.BookController;
import com.glow.openbook.book.IsbnLookupService;
import com.glow.openbook.member.Member;
import com.glow.openbook.member.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.hateoas.CollectionModel;
import org.springframework.hateoas.EntityModel;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

@Controller
@RequestMapping("record")
public class ReadingRecordController {
    @Autowired
    private ReadingRecordService service;

    @Autowired
    private MemberService memberService;

    @Autowired
    private IsbnLookupService isbnLookupService;

    @GetMapping("/book/{isbn}")
    public ResponseEntity<CollectionModel<EntityModel<ReadingRecord>>> getReadingRecord(@PathVariable("isbn") String isbn) {
        Member currentMember = memberService.getCurrentMember();
        List<ReadingRecord> records = service.getReadingRecords(currentMember, isbn);
        List<EntityModel<ReadingRecord>> recordEntityModels =
                records.stream().map(record -> EntityModel.of(record)).collect(Collectors.toList());
        return ResponseEntity.ok().body(CollectionModel.of(
                recordEntityModels,
                linkTo(methodOn(ReadingRecordController.class).getReadingRecord(isbn)).withSelfRel()));
    }

    @PutMapping("/book/{isbn}")
    public ResponseEntity<EntityModel<ReadingRecord>> putReadingRecord(
            @PathVariable("isbn") String isbn,
            @RequestBody ReadingRecordPutRequest request) {
        Member currentMember = memberService.getCurrentMember();
        Optional<Book> book = isbnLookupService.getBookByIsbn(isbn);
        if (!book.isPresent()) {
            return ResponseEntity.notFound().build();
        }
        ReadingRecord record = service.createReadingRecord(
                currentMember, book.get(), request.getStartPage(), request.getEndPage());
        return ResponseEntity.ok().body(EntityModel.of(record));
    }

    @GetMapping("/books")
    public ResponseEntity<CollectionModel<EntityModel<Book>>> getBooksWithRecord() {
        Member currentMember = memberService.getCurrentMember();
        List<Book> books = service.getBooksWithRecord(currentMember);
        List<EntityModel<Book>> bookEntityModels = books.stream()
                .map(book -> EntityModel.of(book, linkTo(methodOn(BookController.class).getBookByIsbn(book.getIsbn())).withSelfRel()))
                .collect(Collectors.toList());
        return ResponseEntity.ok().body(CollectionModel.of(
                bookEntityModels,
                linkTo(methodOn(ReadingRecordController.class).getBooksWithRecord()).withSelfRel()));
    }
}
