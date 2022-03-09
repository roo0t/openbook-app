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

    public void createReadingRecord(Member member, Book book, int startPage, int endPage) {
        ReadingRecord record = new ReadingRecord();
        record.setMember(member);
        record.setBook(book);
        record.setStartPage(startPage);
        record.setEndPage(endPage);
        record.setDeleted(false);
        readingRecordRepository.save(record);
    }
}
