package com.glow.openbook.record;

import com.glow.openbook.book.Book;
import com.glow.openbook.book.BookRepository;
import com.glow.openbook.book.BookService;
import com.glow.openbook.user.Member;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ReadingRecordService {

    private final ReadingRecordRepository readingRecordRepository;

    private final BookService bookService;

    public List<ReadingRecord> getReadingRecords(Member member, String bookIsbn) {
        return readingRecordRepository.findByMemberAndBookIsbn(member, bookIsbn);
    }

    public void createReadingRecord(Member member, Book book, int page) {
        ReadingRecord record = new ReadingRecord();
        record.setMember(member);
        record.setBook(book);
        record.setPage(page);
        record.setDeleted(false);
        readingRecordRepository.save(record);
    }
}
