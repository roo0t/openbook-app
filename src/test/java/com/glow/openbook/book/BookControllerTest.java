package com.glow.openbook.book;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.result.MockMvcResultHandlers;
import org.springframework.web.filter.CharacterEncodingFilter;

import java.util.Arrays;
import java.util.List;

import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.core.Is.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

@SpringBootTest
class BookControllerTest {
    private MockMvc mockMvc;

    @Autowired
    private BookController bookController;

    @Autowired
    private BookRepository bookRepository;

    private List<Book> books;

    @BeforeEach
    public void setUp() {
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

        books = Arrays.asList(testBook1, testBook2);

        mockMvc = standaloneSetup(bookController)
                .addFilter(new CharacterEncodingFilter("UTF-8", true))
                .defaultRequest(get("/book").accept(MediaType.APPLICATION_JSON).characterEncoding("UTF-8"))
                .alwaysExpect(status().isOk())
                .build();
    }

    @AfterEach
    public void tearDown() {
        bookRepository.deleteAll();
    }

    @Test
    public void getBookByIsbn() throws Exception {
        ObjectMapper objectMapper = new ObjectMapper();

        for (int i = 0; i < books.size(); i++) {
            mockMvc.perform(get(String.format("/book/%s", books.get(i).getIsbn())).contentType(MediaType.APPLICATION_JSON))
                   .andExpect(jsonPath("$.statusMessage", is("SUCCESS")))
                   .andExpect(jsonPath("$.data.isbn", is(books.get(i).getIsbn())))
                   .andExpect(jsonPath("$.data.title", is(books.get(i).getTitle())))
                   .andExpect(jsonPath("$.data.authors", hasSize(books.get(i).getAuthors().size())))
                   .andExpect(jsonPath("$.data.publisher", is(books.get(i).getPublisher())))
                   .andExpect(jsonPath("$.data.description", is(books.get(i).getDescription())))
                   .andExpect(jsonPath("$.data.coverImageUrl", is(books.get(i).getCoverImageUrl())))
                   .andExpect(jsonPath("$.data.tags", is(books.get(i).getTags())))
            ;
        }
    }

    @Test
    public void getBookByInvalidIsbn() throws Exception {
        mockMvc.perform(get("/book/invalidisbn").contentType(MediaType.APPLICATION_JSON))
               .andExpect(jsonPath("$.statusMessage", is("NOT_FOUND")));
    }

    @Test
    public void searchBooks() throws Exception {
        mockMvc.perform(get("/book?query=위대한 이야기").contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.statusMessage", is("SUCCESS")))
                .andExpect(jsonPath("$.data[0].title", is("위대한 이야기 - 아름다움, 선함, 진리에 대한 메타 내러티브")));
    }
}