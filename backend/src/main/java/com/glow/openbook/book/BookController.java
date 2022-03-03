package com.glow.openbook.book;

import com.glow.openbook.api.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.hateoas.CollectionModel;
import org.springframework.hateoas.EntityModel;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

@RestController
@RequestMapping("book")
@RequiredArgsConstructor
public class BookController {
    private final BookSearchService bookSearchService;
    private final IsbnLookupService isbnLookupService;

    @GetMapping("/{isbn}")
    public ResponseEntity<EntityModel<Book>> getBookByIsbn(@PathVariable("isbn") String isbn) {
        Optional<Book> book = isbnLookupService.getBookByIsbn(isbn);
        if (book.isPresent()) {
            return ResponseEntity.ok(EntityModel.of(book.get(),
                    linkTo(methodOn(BookController.class).getBookByIsbn(isbn)).withSelfRel()));
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping({"", "/"})
    public ResponseEntity<CollectionModel<EntityModel<Book>>> searchBooks(@RequestParam("query") String query) {
        List<Book> searchResult = bookSearchService.search(query);
        List<EntityModel<Book>> entities = searchResult.stream()
                .map(book -> EntityModel.of(book, linkTo(methodOn(BookController.class).getBookByIsbn(book.getIsbn())).withSelfRel()))
                .collect(Collectors.toList());
        return ResponseEntity.ok().body(CollectionModel.of(entities)
                .add(linkTo(methodOn(BookController.class).searchBooks(query)).withSelfRel()));
    }
}
