package com.glow.openbook.readinggroup;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
@Getter
@Builder
@AllArgsConstructor
public class ReadingGroup {

    @Id
    private long id;

    private String name;

}
