package com.glow.openbook.book;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
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
                .title("난치의 상상력")
                .publisher("동녘")
                .description("크론병으로 투병 중인 20대 청년이 써내려간 ‘청춘 고발기’이자 아픈 몸을 대하는 한국 사회의 모순을 비판한 날카로운 보고서다. 저자의 몸은 청춘과 나이듦, 질병과 장애, 정상과 비정상이 교차하는 전쟁터다. 사람들은 아파 보이지 않는다는 이유로 저자를 의심하며 장애인 옆에서는 ‘비장애인’으로, 비장애인 옆에서는 ‘장애인’으로 대했다.")
                .build();
        testBook1.addAuthor("안희제", "지은이");

        Book testBook2 = Book.builder()
                .isbn("9788966262472")
                .title("클린 아키텍처")
                .publisher("인사이트")
                .description("소프트웨어 아키텍처의 보편 원칙을 적용하면 소프트웨어 수명 전반에서 개발자 생산성을 획기적으로 끌어올릴 수 있다. 《클린 코드》와 《클린 코더》의 저자이자 전설적인 소프트웨어 장인인 로버트 C. 마틴은 이 책 《클린 아키텍처》에서 이러한 보편 원칙들을 설명하고 여러분이 실무에 적용할 수 있도록 도와준다.")
                .build();
        testBook2.addAuthor("로버트 C. 마틴", "지은이");
        testBook2.addAuthor("송준이", "옮긴이");

        books = Arrays.asList(testBook1, testBook2);
        bookRepository.saveAll(books);

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