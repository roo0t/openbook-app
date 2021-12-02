package com.glow.openbook.book;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import lombok.*;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
public class Book {
    @Id
    private String isbn;

    private String title;
    @OneToMany(fetch= FetchType.EAGER, mappedBy = "book", cascade = CascadeType.ALL)
    @Builder.Default
    @JsonManagedReference
    private List<Authoring> authors = new ArrayList<>();
    private String publisher;
    @Column(length = 65535)
    private String description;
    private String coverImageUrl;
    private String publishedOn;
    private int totalPages;
    @ElementCollection
    @Builder.Default
    private List<String> tags = new ArrayList<>();

    public Authoring addAuthor(final String name, final String role) {
        Authoring authoring = new Authoring(this, name, role);
        authors.add(authoring);
        return authoring;
    }

    public void setAuthors(String authorsString) {
        Pattern authoringPattern = Pattern.compile("(.+) ?\\((.+)\\)");
        Arrays.stream(authorsString.split(", ?")).forEach(authoringString -> {
            var matcher = authoringPattern.matcher(authoringString);
            if (matcher.matches()) {
                addAuthor(matcher.group(1), matcher.group(2));
            } else {
                addAuthor(authoringString, null);
            }
        });
    }
}
