package com.glow.openbook.note;

import lombok.Getter;
import lombok.Setter;
import org.springframework.hateoas.RepresentationModel;

import java.util.List;

@Getter
@Setter
public class NoteModel extends RepresentationModel<NoteModel> {
    private Long id;
    private String authorEmailAddress;
    private String authorNickname;
    private String createdAt;
    private String content;
    private int page;
    private List<String> imageUris;
}
