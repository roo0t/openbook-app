package com.glow.openbook.record;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.glow.openbook.book.Book;
import com.glow.openbook.user.Member;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.time.ZoneId;
import java.time.ZonedDateTime;

@Entity
@Getter
@Setter
public class ReadingRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @JoinColumn(name = "member_email_address", nullable = false)
    @JsonBackReference
    private Member member;

    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @JoinColumn(name = "book_isbn", nullable = false)
    @JsonBackReference
    private Book book;

    private int page;

    private ZonedDateTime recordedAt;

    @JsonIgnore
    private boolean isDeleted;

    @PrePersist
    protected void onCreate() {
        recordedAt = ZonedDateTime.now(ZoneId.of("UTC"));
    }
}
