package com.glow.openbook.book;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AladinBookSearchService {
    @Value("${aladin-ttb-key}")
    private String aladinTtbKey;

    private final BookRepository bookRepository;

    public List<Book> search(final String query) {
        final UriComponents uriComponents = UriComponentsBuilder.newInstance()
                .scheme("http")
                .host("www.aladin.co.kr")
                .path("/ttb/api/ItemSearch.aspx")
                .queryParam("Version", "20131101")
                .queryParam("Output", "JS")
                .queryParam("Cover", "Big")
                .queryParam("TTBKey", aladinTtbKey)
                .queryParam("Query", query)
                .build();
        RestTemplate restTemplate = new RestTemplate();
        final AladinBookSearchResult result =
                restTemplate.getForObject(uriComponents.toUriString(), AladinBookSearchResult.class);

        var books = result
                .getItem().stream()
                .map((entry) -> mapAladinBookEntryToBookEntity(entry)).toList();
        return bookRepository.saveAll(books);
    }

    private Book mapAladinBookEntryToBookEntity(AladinBookEntry bookEntry) {
        Book book = Book.builder()
                .isbn(bookEntry.getIsbn13())
                .title(bookEntry.getTitle())
                .publisher(bookEntry.getPublisher())
                .description(bookEntry.getDescription())
                .smallCoverUrl(bookEntry.getCover())
                .largeCoverUrl(bookEntry.getCover())
                .build();
        book.setAuthors(bookEntry.getAuthor());
        return book;
    }
}
