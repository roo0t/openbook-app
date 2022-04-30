package com.glow.openbook.note;

import com.glow.openbook.book.Book;
import com.glow.openbook.member.Member;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class NoteService {

    @Autowired
    private NoteRepository noteRepository;

    public Note addNote(Member member, Book book, String noteContent, int page) {
        Note note = Note.builder()
                .author(member)
                .book(book)
                .content(noteContent)
                .page(page)
                .build();
        return noteRepository.save(note);
    }

    public Iterable<Note> getNotes(Book book) {
        return noteRepository.findByBookIsbn(book.getIsbn());
    }
}
