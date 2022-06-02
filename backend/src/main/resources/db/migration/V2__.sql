CREATE TABLE note (
  id BIGINT NOT NULL,
   member_email_address VARCHAR(255) NOT NULL,
   book_isbn VARCHAR(255) NOT NULL,
   page INTEGER NOT NULL,
   content VARCHAR(255) NOT NULL,
   created_at TIMESTAMP with time zone,
   is_deleted BOOLEAN,
   CONSTRAINT pk_note PRIMARY KEY (id)
);

CREATE TABLE note_image_file_names (
  id BIGINT NOT NULL,
   image_file_names VARCHAR(255)
);

ALTER TABLE note ADD CONSTRAINT FK_NOTE_ON_BOOK_ISBN FOREIGN KEY (book_isbn) REFERENCES book (isbn);

ALTER TABLE note ADD CONSTRAINT FK_NOTE_ON_MEMBER_EMAIL_ADDRESS FOREIGN KEY (member_email_address) REFERENCES member (email_address);

ALTER TABLE note_image_file_names ADD CONSTRAINT fk_note_imagefilenames_on_note FOREIGN KEY (id) REFERENCES note (id);