package com.glow.openbook.record;

import com.glow.openbook.member.Member;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ReadingRecordRepository extends JpaRepository<ReadingRecord, Integer> {
    List<ReadingRecord> findByMemberAndBookIsbn(Member member, String bookIsbn);
}
