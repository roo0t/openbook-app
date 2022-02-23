package com.glow.openbook.book;

import com.glow.openbook.book.aladin.AladinBookSearchResult;
import com.glow.openbook.book.aladin.AladinBookSearchResultEntry;
import com.glow.openbook.book.aladin.AladinBookSearchService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.web.client.RestTemplate;

import java.util.Arrays;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@SpringBootTest
@ExtendWith(MockitoExtension.class)
public class AladinBookSearchServiceTest {
    @MockBean
    private RestTemplate restTemplate;

    @MockBean
    private BookRepository bookRepository;

    @Autowired
    @InjectMocks
    private AladinBookSearchService aladinBookSearchService;

    @Test
    public void search_makes_rest_api_request_and_returns_existing_book_entries() {
        // Arrange
        final var book1 = Book.builder()
                .isbn("9791191851069")
                .title("위대한 이야기 - 아름다움, 선함, 진리에 대한 메타 내러티브")
                .description("“기독교의 이야기는 어떤 삶을 만들어 내는가?” 인생의 중요한 질문에 답할 수 있는 큰 이야기. 신학적 통찰력과 목회적 현실 감각을 살려 우리 인생의 중요한 질문에 답을 제공하고 우리 삶을 빚어 갈 메타 내러티브를 소개한 책이다.")
                .build();
        final var book2 = Book.builder()
                .isbn("9788932530567")
                .title("세상에서 가장 위대한 이야기; search result")
                .description("베스트셀러 작가이자 설교자 케빈 드영이 누구나 알고 있는 크리스마스 이야기를 성경 본문에 충실하면서도 신선한 메시지로 전한다. 이야기와 함께 한 강렬한 그림들은 모두 디자인 업계에 잘 알려진 일러스트레이터 돈 클락의 작품이다.")
                .build();
        final var resultEntries = Arrays.asList(
                AladinBookSearchResultEntry.builder().isbn13(book1.getIsbn()).build(),
                AladinBookSearchResultEntry.builder().isbn13(book2.getIsbn()).build());
        final AladinBookSearchResult mockResponse = new AladinBookSearchResult();
        mockResponse.setVersion("20131101");
        mockResponse.setTitle("알라딘 검색결과 - 위대한 이야기");
        mockResponse.setTotalResults(resultEntries.size());
        mockResponse.setQuery("위대한 이야기");
        mockResponse.setItem(resultEntries);

        when(restTemplate.getForObject(any(String.class), eq(AladinBookSearchResult.class))).thenReturn(mockResponse);
        when(bookRepository.findById(book1.getIsbn())).thenReturn(Optional.of(book1));
        when(bookRepository.findById(book2.getIsbn())).thenReturn(Optional.of(book2));

        // Action
        final var searchResult = aladinBookSearchService.search("위대한 이야기");

        // Assert
        verify(restTemplate, times(1))
                .getForObject(ArgumentCaptor.forClass(String.class).capture(), eq(AladinBookSearchResult.class));
        verify(bookRepository, times(1)).findById(book1.getIsbn());
        verify(bookRepository, times(1)).findById(book2.getIsbn());
        assertThat(searchResult).hasSize(resultEntries.size())
                .contains(book1, book2);
    }
}
