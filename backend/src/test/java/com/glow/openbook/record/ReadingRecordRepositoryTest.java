package com.glow.openbook.record;

import com.glow.openbook.book.Book;
import com.glow.openbook.book.BookRepository;
import com.glow.openbook.member.Member;
import com.glow.openbook.member.MemberRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;


@SpringBootTest
public class ReadingRecordRepositoryTest {

    @Autowired
    private BookRepository bookRepository;

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private ReadingRecordRepository repository;

    @Test
    void findBooksByMember_returns_all_distinct_books_read_by_member() {
        Book book1 = bookRepository.save(Book.builder().isbn("9780321336254").title("TestBook1").build());
        Book book2 = bookRepository.save(Book.builder().isbn("9780321336255").title("TestBook2").build());
        Book book3 = bookRepository.save(Book.builder().isbn("9780321336256").title("TestBook3").build());
        Member member1 = memberRepository.save(Member.builder().emailAddress("member1@example.com").build());
        Member member2 = memberRepository.save(Member.builder().emailAddress("member2@example.com").build());
        Member member3 = memberRepository.save(Member.builder().emailAddress("member3@example.com").build());
        List<ReadingRecord> records = List.of(
                ReadingRecord.builder().member(member1).book(book1).startPage(1).endPage(10).build(),
                ReadingRecord.builder().member(member1).book(book1).startPage(11).endPage(20).build(),
                ReadingRecord.builder().member(member1).book(book1).startPage(21).endPage(30).build(),
                ReadingRecord.builder().member(member1).book(book2).startPage(1).endPage(30).build(),
                ReadingRecord.builder().member(member2).book(book3).startPage(1).endPage(30).build(),
                ReadingRecord.builder().member(member3).book(book1).startPage(1).endPage(30).build());
        repository.saveAll(records);

        List<Book> booksByMember1 = repository.findBooksByMember(member1);

        assertThat(booksByMember1).hasSize(2)
                .anyMatch(book -> book.getIsbn().equals(book1.getIsbn()))
                .anyMatch(book -> book.getIsbn().equals(book2.getIsbn()));
    }
}
