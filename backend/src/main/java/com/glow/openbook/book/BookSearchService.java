package com.glow.openbook.book;

import java.util.List;
import java.util.Optional;

public interface BookSearchService {
    List<Book> search(final String query);
}
