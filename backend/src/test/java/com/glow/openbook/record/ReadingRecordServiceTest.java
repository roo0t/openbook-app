package com.glow.openbook.record;

import com.glow.openbook.book.Authoring;
import com.glow.openbook.book.Book;
import com.glow.openbook.member.Member;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;

import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.List;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;
import static org.mockito.Mockito.when;

@SpringBootTest
public class ReadingRecordServiceTest {

    @Autowired
    @InjectMocks
    private ReadingRecordService readingRecordService;

    @MockBean
    private ReadingRecordRepository readingRecordRepository;

    @Test
    public void getReadingRecords_returns_reading_records_correctly() {
        var member = Member.builder()
                .emailAddress("test@example.com")
                .nickname("testuser")
                .build();
        var isbn = "9788998439798";
        Book book = Book.builder()
                .isbn(isbn)
                .title("실격당한 자들을 위한 변론")
                .totalPages(356)
                .authors(List.of(Authoring.builder().name("김원영").role("지은이").build()))
                .build();
        List<ReadingRecord> readingRecords = List.of(
                ReadingRecord.builder()
                        .id(1L)
                        .member(member)
                        .book(book)
                        .isDeleted(false)
                        .startPage(1)
                        .endPage(50)
                        .recordedAt(ZonedDateTime.of(2022, 1, 1, 0, 0, 0, 0, ZoneId.of("Asia/Seoul")))
                        .build(),
                ReadingRecord.builder()
                        .id(2L)
                        .member(member)
                        .book(book)
                        .isDeleted(false)
                        .startPage(50)
                        .endPage(70)
                        .recordedAt(ZonedDateTime.of(2022, 1, 9, 0, 0, 0, 0, ZoneId.of("Asia/Seoul")))
                        .build(),
                ReadingRecord.builder()
                        .id(3L)
                        .member(member)
                        .book(book)
                        .isDeleted(false)
                        .startPage(71)
                        .endPage(80)
                        .recordedAt(ZonedDateTime.of(2022, 1, 18, 0, 0, 0, 0, ZoneId.of("Asia/Seoul")))
                        .build()
        );
        when(readingRecordRepository.findByMemberAndBookIsbn(member, isbn)).thenReturn(readingRecords);

        List<ReadingRecord> result = readingRecordService.getReadingRecords(member, isbn);

        assertThat(result).isEqualTo(readingRecords);
    }
}
