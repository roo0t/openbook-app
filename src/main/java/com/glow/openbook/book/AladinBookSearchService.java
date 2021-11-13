package com.glow.openbook.book;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.List;
import java.util.Optional;

@Service
public class AladinBookSearchService {
    @Value("${aladin-ttb-key}")
    private String aladinTtbKey;

    List<Book> search(final String query) {
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

        return result
                .getItem().stream()
                .map((entry) -> mapAladinBookEntryToBookEntity(entry)).toList();
    }

    Book mapAladinBookEntryToBookEntity(AladinBookEntry bookEntry) {
        return new Book(
                bookEntry.getIsbn13(),
                bookEntry.getTitle(),
                bookEntry.getAuthor(),
                bookEntry.getPublisher(),
                bookEntry.getDescription(),
                "",
                bookEntry.getCover()
        );
    }
}
