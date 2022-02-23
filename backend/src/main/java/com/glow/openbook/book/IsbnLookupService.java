package com.glow.openbook.book;

import java.util.Optional;

public interface IsbnLookupService {
    Optional<Book> getBookByIsbn(final String isbn);
}
