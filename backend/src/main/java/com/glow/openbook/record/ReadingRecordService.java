package com.glow.openbook.record;

import com.glow.openbook.book.Book;
import com.glow.openbook.member.Member;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ReadingRecordService {

    private final ReadingRecordRepository readingRecordRepository;

    public List<ReadingRecord> getReadingRecords(Member member, String bookIsbn) {
        return readingRecordRepository.findByMemberAndBookIsbn(member, bookIsbn);
    }

    public ReadingRecord createReadingRecord(Member member, Book book, int startPage, int endPage) {
        ReadingRecord record = ReadingRecord.builder()
                .member(member)
                .book(book)
                .startPage(startPage)
                .endPage(endPage)
                .isDeleted(false)
                .build();
        return readingRecordRepository.save(record);
    }

    public List<Book> getBooksWithRecord(Member member) {
        return readingRecordRepository.findBooksByMember(member);
    }
}
