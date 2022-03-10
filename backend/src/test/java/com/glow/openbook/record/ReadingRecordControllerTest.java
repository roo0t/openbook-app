package com.glow.openbook.record;

import com.glow.openbook.book.Book;
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

import java.util.List;

import static org.hamcrest.Matchers.endsWith;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.core.Is.is;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
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

    @BeforeEach
    public void setUp() {
        mockMvc = standaloneSetup(controller)
                .addFilter(new CharacterEncodingFilter("UTF-8", true))
                .defaultRequest(get("/record").accept(MediaType.APPLICATION_JSON).characterEncoding("UTF-8"))
                .build();
    }

    @Test
    void getReadingRecords_returns_existing_records_correctly() throws Exception {
        Member member = Member.builder().emailAddress("test@glowingreaders.club").nickname("testname").build();
        String isbn = "9784873113685";
        Book book = Book.builder().isbn(isbn).title("아름다운 세계").publisher("에이콘출판사").build();
        List<ReadingRecord> records = List.of(
                ReadingRecord.builder().id(1L).book(book).member(member).startPage(1).endPage(100).build(),
                ReadingRecord.builder().id(2L).book(book).member(member).startPage(101).endPage(200).build());
        when(memberService.getCurrentMember()).thenReturn(member);
        when(service.getReadingRecords(member, isbn)).thenReturn(records);
        String url = "/record/" + isbn;

        final ResultActions resultActions = mockMvc.perform(
                get(url).contentType(MediaType.APPLICATION_JSON));

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
}