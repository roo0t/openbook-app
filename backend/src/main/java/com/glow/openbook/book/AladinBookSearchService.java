package com.glow.openbook.book;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AladinBookSearchService {
    @Value("${aladin-ttb-key}")
    private String aladinTtbKey;

    private final BookRepository bookRepository;

    public List<Book> search(final String query) {
        final List<String> isbns = searchOnAladin(query);
        return isbns.stream()
                .map((isbn) -> lookUpBook(isbn))
                .filter((book) -> book.isPresent())
                .map((book) -> book.get()).toList();
    }

    private List<String> searchOnAladin(final String query) {
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
        if (result.getItem() == null) {
            return new ArrayList<String>();
        } else {
            return result.getItem().stream().map((entry) -> entry.getIsbn13()).toList();
        }
    }

    public Optional<Book> lookUpBook(final String isbn) {
        Optional<Book> book = bookRepository.findById(isbn);
        if (book.isPresent()) {
            return book;
        } else {
            Optional<Book> bookEntity = lookUpBookOnAladin(isbn);
            if (bookEntity.isPresent()) {
                bookRepository.save(bookEntity.get());
            }
            return bookEntity;
        }
    }

    private Optional<Book> lookUpBookOnAladin(final String isbn) {
        final UriComponents uriComponents = UriComponentsBuilder.newInstance()
                .scheme("http")
                .host("www.aladin.co.kr")
                .path("/ttb/api/ItemLookUp.aspx")
                .queryParam("Version", "20131101")
                .queryParam("Output", "JS")
                .queryParam("Cover", "Big")
                .queryParam("TTBKey", aladinTtbKey)
                .queryParam("ItemIdType", "ISBN13")
                .queryParam("ItemId", isbn)
                .build();
        RestTemplate restTemplate = new RestTemplate();
        final AladinBookLookUpResult result =
                restTemplate.getForObject(uriComponents.toUriString(), AladinBookLookUpResult.class);
        if (result.getItem() != null && !result.getItem().isEmpty()) {
            Book bookEntity = mapAladinBookEntryToBookEntity(result.getItem().get(0));
            return Optional.of(bookEntity);
        } else {
            return Optional.empty();
        }
    }

    private Book mapAladinBookEntryToBookEntity(AladinBookLookUpResultEntry bookEntry) {
        var categoryHierarchy = bookEntry.getCategoryName().split(">");
        Book book = Book.builder()
                .isbn(bookEntry.getIsbn13())
                .title(bookEntry.getTitle())
                .publisher(bookEntry.getPublisher())
                .description(bookEntry.getDescription())
                .coverImageUrl(bookEntry.getCover())
                .publishedOn(bookEntry.getPubDate())
                .totalPages(bookEntry.getSubInfo().getItemPage())
                .tags(String.join(";", categoryHierarchy))
                .build();
        book.setAuthors(bookEntry.getAuthor());
        return book;
    }
}
