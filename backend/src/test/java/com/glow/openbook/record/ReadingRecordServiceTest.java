package com.glow.openbook.record;

import com.glow.openbook.book.Book;
import com.glow.openbook.book.BookService;
import com.glow.openbook.user.MemberService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.Optional;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;

@SpringBootTest
public class ReadingRecordServiceTest {

    @Autowired
    private ReadingRecordService readingRecordService;

    @Autowired
    private MemberService memberService;

    @Autowired
    private BookService bookService;

    @Autowired
    private ReadingRecordRepository readingRecordRepository;

    @BeforeEach
    public void setUp() {
        memberService.register("test@example.com", "abcd1234");
    }

    @Test
    public void createReadingRecord() {
        assertThat(readingRecordRepository.findAll()).asList().isEmpty();

        var member = memberService.getMember("test@example.com").get();
        var isbn = "9788998439798";
        var page = 108;
        Optional<Book> book = bookService.getBookByIsbn(isbn);
        assertThat(book.isPresent()).isTrue();

        readingRecordService.createReadingRecord(
                member, book.get(), 108);

        var records = readingRecordRepository.findAll();
        assertThat(records).asList().hasSize(1);
        assertThat(records.get(0).getBook().getIsbn()).isEqualTo(isbn);
        assertThat(records.get(0).getMember().getEmailAddress()).isEqualTo(member.getEmailAddress());
        assertThat(records.get(0).getPage()).isEqualTo(page);
    }
}
