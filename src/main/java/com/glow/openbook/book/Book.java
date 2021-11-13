package com.glow.openbook.book;

import lombok.*;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
public class Book {
    @Id
    private String isbn;

    private String title;
    private String author;
    private String publisher;
    @Column(length = 65535)
    private String description;
    private String smallCoverUrl;
    private String largeCoverUrl;
}
