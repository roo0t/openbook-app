package com.glow.openbook.record;

import com.glow.openbook.book.Book;
import com.glow.openbook.member.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ReadingRecordRepository extends JpaRepository<ReadingRecord, Integer> {
    List<ReadingRecord> findByMemberAndBookIsbn(Member member, String bookIsbn);

    @Query("SELECT DISTINCT record.book "
            + "FROM ReadingRecord record INNER JOIN record.member m "
            + "WHERE record.isDeleted = false AND m = ?1")
    List<Book> findBooksByMember(Member member);
}
