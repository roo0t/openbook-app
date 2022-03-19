package com.glow.openbook.record;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.glow.openbook.book.Book;
import com.glow.openbook.book.aladin.AladinBookSearchService;
import com.glow.openbook.member.Member;
import com.glow.openbook.member.MemberService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.web.filter.CharacterEncodingFilter;

import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

import static org.hamcrest.Matchers.endsWith;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.core.Is.is;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

@SpringBootTest
class ReadingRecordControllerTest {

    private MockMvc mockMvc;

    @Autowired
    private ReadingRecordController controller;

    @MockBean
    private ReadingRecordService service;

    @MockBean
    private MemberService memberService;

    @MockBean
    private AladinBookSearchService aladinBookSearchService;

    @Autowired
    private ObjectMapper objectMapper;

    @BeforeEach
    public void setUp() {
        mockMvc = standaloneSetup(controller)
                .addFilter(new CharacterEncodingFilter("UTF-8", true))
                .defaultRequest(get("/record").accept(MediaType.APPLICATION_JSON).characterEncoding("UTF-8"))
                .build();
    }

    @Test
    void getReadingRecords_returns_existing_records_correctly() throws Exception {
        // Arrange
        Member member = Member.builder().emailAddress("test@glowingreaders.club").nickname("testname").build();
        String isbn = "9784873113685";
        Book book = Book.builder().isbn(isbn).title("아름다운 세계").publisher("에이콘출판사").build();
        List<ReadingRecord> records = List.of(
                ReadingRecord.builder().id(1L).book(book).member(member).startPage(1).endPage(100).build(),
                ReadingRecord.builder().id(2L).book(book).member(member).startPage(101).endPage(200).build());
        when(memberService.getCurrentMember()).thenReturn(member);
        when(service.getReadingRecords(member, isbn)).thenReturn(records);
        String url = "/record/book/" + isbn;

        // Act
        final ResultActions resultActions = mockMvc.perform(get(url).contentType(MediaType.APPLICATION_JSON));

        // Assert
        resultActions
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.links", hasSize(1)))
                .andExpect(jsonPath("$.links[0].rel", is("self")))
                .andExpect(jsonPath("$.links[0].href", endsWith(url)))
                .andExpect(jsonPath("$.content", hasSize(2)))
                .andExpect(jsonPath("$.content[0].id", is(1)))
                .andExpect(jsonPath("$.content[0].startPage", is(1)))
                .andExpect(jsonPath("$.content[0].endPage", is(100)))
                .andExpect(jsonPath("$.content[1].id", is(2)))
                .andExpect(jsonPath("$.content[1].startPage", is(101)))
                .andExpect(jsonPath("$.content[1].endPage", is(200)));
    }

    @Test
    void putReadingRecords_adds_new_records_correctly() throws Exception {
        // Arrange
        final String isbn = "9784873113685";
        final Book book = Book.builder().isbn(isbn).title("아름다운 세계").publisher("에이콘출판사").build();
        final int startPage = 100;
        final int endPage = 200;
        final Member member = Member.builder().emailAddress("test@glowingreaders.club").nickname("testname").build();
        final ReadingRecordPutRequest request = ReadingRecordPutRequest.builder()
                .startPage(startPage).endPage(endPage).build();
        final ZonedDateTime now = ZonedDateTime.now(ZoneId.of("UTC"));

        when(memberService.getCurrentMember()).thenReturn(member);
        when(aladinBookSearchService.getBookByIsbn(isbn)).thenReturn(Optional.of(book));
        when(service.createReadingRecord(any(Member.class), any(Book.class), anyInt(), anyInt()))
                .thenAnswer(invocation -> {
                    final Member memberArgument = invocation.getArgument(0, Member.class);
                    final Book bookArgument = invocation.getArgument(1, Book.class);
                    final int startPageArgument = invocation.getArgument(2, Integer.class);
                    final int endPageArgument = invocation.getArgument(3, Integer.class);
                    return ReadingRecord.builder()
                            .id(1L).book(bookArgument).member(memberArgument).recordedAt(now)
                            .startPage(startPageArgument).endPage(endPageArgument).isDeleted(false).build();
                });
        String requestString = objectMapper.writeValueAsString(request);

        // Act
        final ResultActions resultActions = mockMvc.perform(
                put("/record/book/" + isbn).contentType(MediaType.APPLICATION_JSON).content(requestString));

        // Assert
        verify(service, times(1)).createReadingRecord(member, book, startPage, endPage);
        resultActions
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.links", hasSize(0)))
                .andExpect(jsonPath("$.id", is(1)))
                .andExpect(jsonPath("$.startPage", is(startPage)))
                .andExpect(jsonPath("$.endPage", is(endPage)))
                .andExpect(jsonPath("$.recordedAt", is(now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSSZ")))));
    }

    @Test
    void putReadingRecords_fails_with_nonexistent_isbn() throws Exception {
        // Arrange
        final String isbn = "9784873113685";
        final Member member = Member.builder().emailAddress("test@glowingreaders.club").nickname("testname").build();
        final ReadingRecordPutRequest request = ReadingRecordPutRequest.builder()
                .startPage(100).endPage(200).build();
        String requestString = objectMapper.writeValueAsString(request);

        // Act
        when(aladinBookSearchService.getBookByIsbn(any())).thenReturn(Optional.empty());

        // Assert
        final ResultActions resultActions = mockMvc.perform(
                put("/record/" + isbn).contentType(MediaType.APPLICATION_JSON).content(requestString));

        verifyNoInteractions(service);
        resultActions.andExpect(status().isNotFound());
    }

    @Test
    void getBooksWithRecord_returns_books_with_records() throws Exception {
        // Arrange
        Book book1 = Book.builder().isbn("9780321336254").title("TestBook1").build();
        Book book2 = Book.builder().isbn("9780321336255").title("TestBook2").build();
        Member member = Member.builder().emailAddress("member1@example.com").build();
        List<ReadingRecord> records = List.of(
                ReadingRecord.builder().member(member).book(book1).startPage(1).endPage(10).build(),
                ReadingRecord.builder().member(member).book(book1).startPage(11).endPage(20).build(),
                ReadingRecord.builder().member(member).book(book1).startPage(21).endPage(30).build(),
                ReadingRecord.builder().member(member).book(book2).startPage(1).endPage(30).build());
        when(memberService.getCurrentMember()).thenReturn(member);
        when(service.getBooksWithRecord(member)).thenReturn(List.of(book1, book2));

        // Act
        final ResultActions resultActions = mockMvc.perform(get("/record/books"));

        // Assert
        resultActions.andExpect(status().isOk())
                .andExpect(jsonPath("$.content", hasSize(2)))
                .andExpect(jsonPath("$.content[0].isbn", is(book1.getIsbn())))
                .andExpect(jsonPath("$.content[0].title", is(book1.getTitle())))
                .andExpect(jsonPath("$.content[1].isbn", is(book2.getIsbn())))
                .andExpect(jsonPath("$.content[1].title", is(book2.getTitle())));
    }
}