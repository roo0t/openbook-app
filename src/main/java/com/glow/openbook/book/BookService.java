package com.glow.openbook.book;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class BookService {

    private final BookRepository bookRepository;

    Optional<Book> getBookByIsbn(final String isbn) {
        Optional<Book> existingBook = bookRepository.findById(isbn);

        // TODO: if not present in the database, retrieve the book information from the web

        return existingBook;
    }
}
