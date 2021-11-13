package com.glow.openbook.book;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
public class BookServiceTest {
    @Autowired
    private BookService bookService;

    @Test
    public void testSearchBooks() {
        final String query = "위대한 이야기";
        final String title = "위대한 이야기 - 아름다움, 선함, 진리에 대한 메타 내러티브";

        // Perform search
        List<Book> searchResult = bookService.searchBooks(query);
        assertThat(searchResult).filteredOn("title", title).isNotEmpty();

        // Perform search again
        searchResult = bookService.searchBooks(query);
        assertThat(searchResult).filteredOn("title", title).isNotEmpty();

        // Verify that the searched book is persisted
        final String isbn = searchResult.stream()
                .filter((book) -> book.getTitle().equals(title)).findFirst().get()
                .getIsbn();
        Optional<Book> persistentEntity = bookService.getBookByIsbn(isbn);
        assertThat(persistentEntity).isNotEmpty();
    }
}
