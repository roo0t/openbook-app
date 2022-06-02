package com.glow.openbook.note;

import com.glow.openbook.aws.S3Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.hateoas.server.mvc.RepresentationModelAssemblerSupport;
import org.springframework.stereotype.Component;

import java.time.Duration;
import java.util.stream.Collectors;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

@Component
public class NoteModelAssembler extends RepresentationModelAssemblerSupport<Note, NoteModel> {

    @Autowired
    private S3Service s3Service;

    @Value("${cloud.aws.s3.note-image-bucket}")
    private String noteImageBucket;

    public NoteModelAssembler() {
        super(NoteController.class, NoteModel.class);
    }

    @Override
    public NoteModel toModel(Note note) {
        return instantiateModel(note);
    }

    @Override
    protected NoteModel instantiateModel(Note note) {
        NoteModel noteModel = new NoteModel();
        noteModel.setId(note.getId());
        noteModel.setAuthorEmailAddress(note.getAuthor().getEmailAddress());
        noteModel.setAuthorNickname(note.getAuthor().getNickname());
        noteModel.setContent(note.getContent());
        noteModel.setPage(note.getPage());
        noteModel.setImageUris(note.getImageFileNames()
                .stream().map(fileName -> s3Service.getPresignedUrl(
                        noteImageBucket, fileName, Duration.ofHours(1)).toString())
                .collect(Collectors.toList()));
        noteModel.add(linkTo(methodOn(NoteController.class).getNote(note.getId())).withSelfRel());
        return noteModel;
    }
}
