package com.glow.openbook.note;

import com.glow.openbook.book.Book;
import com.glow.openbook.book.IsbnLookupService;
import com.glow.openbook.member.Member;
import com.glow.openbook.member.MemberRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class NoteServiceTest {

    @Autowired
    private NoteService noteService;

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private IsbnLookupService isbnLookupService;

    @Autowired
    private NoteRepository noteRepository;

    private String generateRandomString(int length) {
        int leftLimit = 48; // numeral '0'
        int rightLimit = 122; // letter 'z'
        int targetStringLength = 10;
        Random random = new Random();
        String generatedString = random.ints(leftLimit, rightLimit + 1)
                .filter(i -> (i <= 57 || i >= 65) && (i <= 90 || i >= 97))
                .limit(targetStringLength)
                .collect(StringBuilder::new, StringBuilder::appendCodePoint, StringBuilder::append)
                .toString();
        return generatedString;
    }

    private Member addTestMember() {
        Member member = Member.builder()
                .emailAddress(generateRandomString(10) + "@test.com")
                .nickname(generateRandomString(10))
                .password(generateRandomString(10))
                .build();
        return memberRepository.save(member);
    }

    @Test
    public void addNote_adds_new_note() {
        // Arrange
        Member member = addTestMember();
        String bookIsbn = "9791191851069";
        Book book = isbnLookupService.getBookByIsbn(bookIsbn).get();
        String noteContent = "Some notes on the book";
        int page = 42;

        // Act
        Note note = noteService.addNote(member, book, noteContent, page);

        // Assert
        assertThat(note.getContent()).isEqualTo(noteContent);
        assertThat(note.getBook().getIsbn()).isEqualTo(bookIsbn);
        assertThat(note.getPage()).isEqualTo(page);
        assertThat(note.getAuthor().getEmailAddress()).isEqualTo(member.getEmailAddress());
    }

    @Test
    public void getNotes_returns_all_notes_for_a_book() {
        // Arrange
        Member member = addTestMember();
        String bookIsbn = "9791191851069";
        Book book = isbnLookupService.getBookByIsbn(bookIsbn).get();
        String noteContent = "Some notes on the book";
        int page = 42;
        List<Note> notesAdded = new ArrayList<>();
        for(int i = 0; i < 10; i++) {
            notesAdded.add(noteService.addNote(member, book, noteContent, page));
        }

        // Act
        Iterable<Note> notes = noteService.getNotes(book);

        // Assert
        assertThat(notes)
                .usingElementComparatorOnFields("id", "book.isbn", "content", "page", "author.emailAddress")
                .containsExactlyInAnyOrderElementsOf(notesAdded);
    }
}