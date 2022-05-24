package com.glow.openbook.note;

import com.glow.openbook.book.Book;
import com.glow.openbook.book.IsbnLookupService;
import com.glow.openbook.member.Member;
import com.glow.openbook.member.MemberRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.*;

import java.io.IOException;
import java.util.*;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.fail;

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

    @Autowired
    private ResourceLoader resourceLoader;

    @Value("${cloud.aws.s3.note-image-bucket}")
    private String noteImageBucket;

    @Autowired
    private S3Client s3Client;

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
    public void addNote_adds_new_note() throws IOException {
        // Arrange
        Member member = addTestMember();
        String bookIsbn = "9791191851069";
        Book book = isbnLookupService.getBookByIsbn(bookIsbn).get();
        String noteContent = "Some notes on the book";
        int page = 42;
        Resource testImageResource =
                resourceLoader.getResource("classpath:test_image.jpg");
        MultipartFile image = new MockMultipartFile(
                "image",
                testImageResource.getFilename(),
                "image/jpeg",
                testImageResource.getInputStream());

        // Act
        Note note = noteService.addNote(member, book, page, noteContent, List.of(image));

        // Assert
        assertThat(note.getContent()).isEqualTo(noteContent);
        assertThat(note.getBook().getIsbn()).isEqualTo(bookIsbn);
        assertThat(note.getPage()).isEqualTo(page);
        assertThat(note.getAuthor().getEmailAddress()).isEqualTo(member.getEmailAddress());
        assertThat(note.getImageFileNames()).hasSize(1);
        assertThat(note.getImageFileNames()).allSatisfy(key -> {
            var getObjectRequest = GetObjectRequest.builder()
                    .bucket(noteImageBucket)
                    .key(key)
                    .build();
            try {
                s3Client.getObject(getObjectRequest);
            } catch (NoSuchKeyException e) {
                fail();
            }
        });
    }

    @Test
    public void getNotes_returns_all_notes_for_a_book() throws IOException {
        // Arrange
        Member member = addTestMember();
        String bookIsbn = "9791191851069";
        Book book = isbnLookupService.getBookByIsbn(bookIsbn).get();
        String noteContent = "Some notes on the book";
        int page = 42;
        Resource testImageResource =
                resourceLoader.getResource("classpath:test_image.jpg");
        noteRepository.deleteAll();
        List<Note> notesAdded = new ArrayList<>();
        for(int i = 0; i < 10; i++) {
            List<MultipartFile> images = List.of(
                    new MockMultipartFile(
                            "image",
                            testImageResource.getFilename(),
                            "image/jpeg",
                            testImageResource.getInputStream()));
            notesAdded.add(noteService.addNote(member, book, page, noteContent, images));
        }

        // Act
        Iterable<Note> notes = noteService.getNotes(book);

        // Assert
        final Comparator<List<String>> stringListComparator =
                (names1, names2) -> names1.equals(names2) ? 0 : 1;
        assertThat(notes)
                .usingElementComparatorOnFields("id", "book.isbn", "content", "page", "author.emailAddress")
                .usingComparatorForElementFieldsWithType(
                        stringListComparator,
                        (Class<List<String>>)Collections.<String>emptyList().getClass())
                .containsExactlyInAnyOrderElementsOf(notesAdded);
    }
}