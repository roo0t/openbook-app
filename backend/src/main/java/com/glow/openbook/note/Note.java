package com.glow.openbook.note;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.glow.openbook.book.Book;
import com.glow.openbook.member.Member;
import lombok.*;

import javax.persistence.*;
import java.time.ZoneId;
import java.time.ZonedDateTime;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Note {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @JoinColumn(name = "member_email_address", nullable = false)
    @JsonBackReference
    private Member author;

    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @JoinColumn(name = "book_isbn", nullable = false)
    @JsonBackReference
    private Book book;

    @Column(nullable = false)
    private int page;

    @Column(nullable = false)
    private String content;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss.SSSZ")
    private ZonedDateTime createdAt;

    @JsonIgnore
    private boolean isDeleted;

    @PrePersist
    protected void onCreate() {
        createdAt = ZonedDateTime.now(ZoneId.of("UTC"));
    }
}
