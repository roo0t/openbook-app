package com.glow.openbook.book;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class BookService {

    private final BookRepository bookRepository;
    private final AladinBookSearchService aladinBookSearchService;

    Optional<Book> getBookByIsbn(final String isbn) {
        Optional<Book> existingBook = bookRepository.findById(isbn);

        // TODO: if not present in the database, retrieve the book information from the web

        return existingBook;
    }

    List<Book> searchBooks(final String query) {
        final List<Book> aladinSearchResult = aladinBookSearchService.search(query);
        return bookRepository.saveAll(aladinSearchResult);
    }
}
