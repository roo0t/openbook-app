package com.glow.openbook.book;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
public class AladinBookSearchServiceTest {
    @Autowired
    private AladinBookSearchService aladinBookSearchService;

    @Test
    public void testSearchBookFromAladin() {
        final String query = "위대한 이야기";
        final List<Book> searchResult = aladinBookSearchService.search(query);

        final String title = "위대한 이야기 - 아름다움, 선함, 진리에 대한 메타 내러티브";
        assertThat(searchResult).filteredOn("title", title).isNotEmpty();
    }
}
