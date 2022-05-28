package com.glow.openbook.note;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AddNoteRequest {
    private String content;
}
