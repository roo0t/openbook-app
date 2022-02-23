package com.glow.openbook.book;

import com.glow.openbook.api.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("book")
@RequiredArgsConstructor
public class BookController {
    private final BookSearchService bookSearchService;
    private final IsbnLookupService isbnLookupService;

    @GetMapping("/{isbn}")
    public ApiResponse<Book> getBookByIsbn(@PathVariable("isbn") String isbn) {
        Optional<Book> book = isbnLookupService.getBookByIsbn(isbn);
        if (book.isPresent()) {
            return ApiResponse.successfulResponse(book.get());
        } else {
            return ApiResponse.notFoundResponse();
        }
    }

    @GetMapping({"", "/"})
    public ApiResponse<List<Book>> searchBooks(@RequestParam("query") String query) {
        List<Book> searchResult = bookSearchService.search(query);
        return ApiResponse.successfulResponse(searchResult);
    }
}
