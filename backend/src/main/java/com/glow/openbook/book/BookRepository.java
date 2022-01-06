package com.glow.openbook.book;

import org.springframework.data.jpa.repository.JpaRepository;

public interface BookRepository extends JpaRepository<Book, String> {
    Book getByIsbn(String isbn);
}
