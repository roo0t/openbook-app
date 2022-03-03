package com.glow.openbook.book;

import com.glow.openbook.book.aladin.AladinBookSearchService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;
import org.junit.jupiter.params.provider.ValueSource;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.web.filter.CharacterEncodingFilter;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Stream;

import static org.hamcrest.Matchers.array;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.core.Is.is;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

@SpringBootTest
@ExtendWith(MockitoExtension.class)
class BookControllerTest {
    private MockMvc mockMvc;

    @Autowired
    private BookController bookController;

    @MockBean
    private AladinBookSearchService aladinBookSearchService;

    private static List<Book> getBookData() {
        Book testBook1 = Book.builder()
                .isbn("9788972979616")
                .title("난치의 상상력 - 질병과 장애, 그 경계를 살아가는 청년의 한국 사회 관찰기")
                .publisher("동녘")
                .description("저자는 “아파도 청춘이다”라는 윗세대의 게으른 충고를 일갈하는 것을 넘어 “그런 청년은 없다”고 말하며 경계 자체를 부숴버린다. 질병과 장애를 없애야 할 것, 어서 빨리 교정해야 할 것으로 다루는 한국 사회의 폭력을 거침없이 비판한다.")
                .coverImageUrl("https://image.aladin.co.kr/product/24791/5/cover/8972979619_1.jpg")
                .tags("국내도서;사회과학;비평/칼럼;한국사회비평/칼럼")
                .build();
        testBook1.addAuthor("안희제", "지은이");

        Book testBook2 = Book.builder()
                .isbn("9788966262472")
                .title("클린 아키텍처 - 소프트웨어 구조와 설계의 원칙")
                .publisher("인사이트")
                .description("소프트웨어 아키텍처의 보편 원칙을 적용하면 소프트웨어 수명 전반에서 개발자 생산성을 획기적으로 끌어올릴 수 있다. 《클린 코드》와 《클린 코더》의 저자이자 전설적인 소프트웨어 장인인 로버트 C. 마틴은 이 책에서 이러한 보편 원칙들을 설명하고 여러분이 실무에 적용할 수 있도록 도와준다.")
                .coverImageUrl("https://image.aladin.co.kr/product/20232/24/cover/8966262473_1.jpg")
                .tags("국내도서;컴퓨터/모바일;컴퓨터 공학;소프트웨어 공학")
                .build();
        testBook2.addAuthor("로버트 C. 마틴", "지은이");
        testBook2.addAuthor("송준이", "옮긴이");

        return Arrays.asList(testBook1, testBook2);
    }

    private static Stream<Book> provideBooksForGetBookByIsbn() {
        return getBookData().stream();
    }

    @BeforeEach
    public void setUp() {
        mockMvc = standaloneSetup(bookController)
                .addFilter(new CharacterEncodingFilter("UTF-8", true))
                .defaultRequest(get("/book").accept(MediaType.APPLICATION_JSON).characterEncoding("UTF-8"))
                .build();
    }

    @ParameterizedTest
    @MethodSource("provideBooksForGetBookByIsbn")
    public void getBookByIsbn_valid_isbn_respond_with_book_data(Book targetBook) throws Exception {
        // Arrange
        final var books = getBookData();
        for(var book : books) {
            when(aladinBookSearchService.getBookByIsbn(book.getIsbn())).thenReturn(Optional.of(book));
        }

        // Action
        final ResultActions actionResult = mockMvc.perform(
                get(String.format("/book/%s", targetBook.getIsbn())).contentType(MediaType.APPLICATION_JSON));

        // Assert
        verify(aladinBookSearchService, times(1)).getBookByIsbn(targetBook.getIsbn());
        verifyNoMoreInteractions(aladinBookSearchService);
        actionResult
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.isbn", is(targetBook.getIsbn())))
                .andExpect(jsonPath("$.title", is(targetBook.getTitle())))
                .andExpect(jsonPath("$.authors", hasSize(targetBook.getAuthors().size())))
                .andExpect(jsonPath("$.publisher", is(targetBook.getPublisher())))
                .andExpect(jsonPath("$.description", is(targetBook.getDescription())))
                .andExpect(jsonPath("$.coverImageUrl", is(targetBook.getCoverImageUrl())))
                .andExpect(jsonPath("$.tags", is(targetBook.getTags())))
                .andExpect(jsonPath("$.links", hasSize(1)))
                .andExpect(jsonPath("$.links[0].rel", is("self")))
        ;
    }

    @ParameterizedTest
    @ValueSource(strings = {"invalidisbn", ".", "1", "97889729796160"})
    public void getBookByIsbn_invalid_isbn_respond_with_NOT_FOUND(String invalidIsbn) throws Exception {
        // Arrange
        final var books = getBookData();
        for(var book : books) {
            when(aladinBookSearchService.getBookByIsbn(book.getIsbn())).thenReturn(Optional.of(book));
        }

        // Action
        final ResultActions actionResult = mockMvc.perform(
                get("/book/" + invalidIsbn).contentType(MediaType.APPLICATION_JSON));

        // Assert
        verify(aladinBookSearchService, times(1)).getBookByIsbn(invalidIsbn);
        actionResult.andExpect(status().isNotFound());
    }

    @Test
    public void searchBooks_respond_with_search_result() throws Exception {
        // Arrange
        final String query = "위대한 이야기";
        final var bookData = getBookData();
        when(aladinBookSearchService.search(query)).thenReturn(bookData);

        // Action
        final ResultActions actionResult = mockMvc.perform(
                get("/book?query=" + query).contentType(MediaType.APPLICATION_JSON));

        // Assert
        verify(aladinBookSearchService, times(1)).search(query);
        actionResult
                .andExpect(status().isOk())
                .andDo(print())
                .andExpect(jsonPath("$.content", hasSize(bookData.size())));
        for(int i = 0; i < bookData.size(); i++) {
            actionResult
                .andExpect(jsonPath(String.format("$.content[%d].isbn", i), is(bookData.get(i).getIsbn())))
                .andExpect(jsonPath(String.format("$.content[%d].title", i), is(bookData.get(i).getTitle())))
                .andExpect(jsonPath(String.format("$.content[%d].publisher", i), is(bookData.get(i).getPublisher())))
                .andExpect(jsonPath(String.format("$.content[%d].description", i), is(bookData.get(i).getDescription())))
                .andExpect(jsonPath(String.format("$.content[%d].authors", i), hasSize(bookData.get(i).getAuthors().size())))
            ;
        }

    }
}