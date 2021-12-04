package com.glow.openbook.book;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class BookService {
    private final AladinBookSearchService aladinBookSearchService;

    Optional<Book> getBookByIsbn(final String isbn) {
        return aladinBookSearchService.lookUpBook(isbn);
    }

    List<Book> searchBooks(final String query) {
        return aladinBookSearchService.search(query);
    }
}
