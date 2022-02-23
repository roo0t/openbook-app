package com.glow.openbook.book;

import com.glow.openbook.book.aladin.AladinBookSearchService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class BookService {
    private final AladinBookSearchService aladinBookSearchService;

    public Optional<Book> getBookByIsbn(final String isbn) {
        return aladinBookSearchService.getBookByIsbn(isbn);
    }

    public List<Book> searchBooks(final String query) {
        return aladinBookSearchService.search(query);
    }
}
