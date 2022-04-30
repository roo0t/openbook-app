package com.glow.openbook.note;

import org.springframework.data.jpa.repository.JpaRepository;

public interface NoteRepository extends JpaRepository<Note, Long> {
    Iterable<Note> findByBookIsbn(String isbn);
}
