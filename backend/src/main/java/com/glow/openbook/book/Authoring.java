package com.glow.openbook.book;

import com.fasterxml.jackson.annotation.JsonBackReference;
import lombok.*;

import javax.persistence.*;

@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
public class Authoring {
    @Id
    @GeneratedValue(strategy= GenerationType.AUTO)
    private long id;

    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @JoinColumn(name = "book_isbn", nullable = false)
    @JsonBackReference
    private Book book;

    private String name;
    private String role;

    public Authoring(Book book, String name, String role) {
        this.book = book;
        this.name = name;
        this.role = role;
    }
}
