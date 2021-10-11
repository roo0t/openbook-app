package com.glow.openbook.book;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Optional;

@RestController
@RequestMapping("book")
@RequiredArgsConstructor
public class BookController {
    private final BookService bookService;

    @GetMapping("/{isbn}")
    public Book getBookByIsbn(@PathVariable("isbn") String isbn) throws Exception {
        Optional<Book> book = bookService.getBookByIsbn(isbn);
        if (book.isPresent()) {
            return book.get();
        } else {
            throw new Exception("Not found");
        }
    }
}
