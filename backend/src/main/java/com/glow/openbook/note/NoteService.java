package com.glow.openbook.note;

import com.glow.openbook.aws.S3Service;
import com.glow.openbook.book.Book;
import com.glow.openbook.member.Member;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.IOException;
import java.io.InputStream;
import java.text.MessageFormat;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class NoteService {

    @Autowired
    private NoteRepository noteRepository;

    @Autowired
    private S3Service s3Service;

    @Value("${cloud.aws.s3.note-image-bucket}")
    private String noteImageBucket;

    public Note addNote(Member member,
                        Book book,
                        int page,
                        String noteContent,
                        List<MultipartFile> files) {
        var fileNames = files.stream().map(file -> {
            String fileName = createFileName(
                    book.getIsbn(), page, FilenameUtils.getExtension(file.getOriginalFilename()));
            try {
                s3Service.putObject(noteImageBucket, fileName, file);
            } catch(IOException e) {
                throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "파일 업로드에 실패했습니다.");
            }
            return fileName;
        }).collect(Collectors.toList());
        Note note = Note.builder()
                .author(member)
                .book(book)
                .content(noteContent)
                .page(page)
                .imageFileNames(fileNames)
                .build();
        return noteRepository.save(note);
    }

    private String createFileName(String isbn, int page, String extension) {
        return MessageFormat.format("{0}/{1}/{2}.{3}",
                isbn,
                Integer.toString(page),
                UUID.randomUUID().toString(),
                extension);
    }

    public Iterable<Note> getNotes(Book book) {
        return noteRepository.findByBookIsbn(book.getIsbn());
    }
}
