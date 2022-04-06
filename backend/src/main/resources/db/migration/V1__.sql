CREATE SEQUENCE  IF NOT EXISTS hibernate_sequence START WITH 1 INCREMENT BY 1;

CREATE TABLE authoring (
  id BIGINT NOT NULL,
   book_isbn VARCHAR(255) NOT NULL,
   name VARCHAR(255),
   role VARCHAR(255),
   CONSTRAINT pk_authoring PRIMARY KEY (id)
);

CREATE TABLE book (
  isbn VARCHAR(255) NOT NULL,
   title VARCHAR(255),
   publisher VARCHAR(255),
   description VARCHAR(65535),
   cover_image_url VARCHAR(255),
   published_on VARCHAR(255),
   total_pages INTEGER,
   tags VARCHAR(255),
   CONSTRAINT pk_book PRIMARY KEY (isbn)
);

CREATE TABLE member (
  email_address VARCHAR(255) NOT NULL,
   password VARCHAR(255),
   nickname VARCHAR(255),
   CONSTRAINT pk_member PRIMARY KEY (email_address)
);

CREATE TABLE reading_group (
  id BIGINT NOT NULL,
   name VARCHAR(255),
   CONSTRAINT pk_readinggroup PRIMARY KEY (id)
);

CREATE TABLE reading_record (
  id BIGINT NOT NULL,
   member_email_address VARCHAR(255) NOT NULL,
   book_isbn VARCHAR(255) NOT NULL,
   start_page INTEGER NOT NULL,
   end_page INTEGER NOT NULL,
   recorded_at TIMESTAMP with time zone,
   is_deleted BOOLEAN,
   CONSTRAINT pk_readingrecord PRIMARY KEY (id)
);

ALTER TABLE authoring ADD CONSTRAINT FK_AUTHORING_ON_BOOK_ISBN FOREIGN KEY (book_isbn) REFERENCES book (isbn);

ALTER TABLE reading_record ADD CONSTRAINT FK_READINGRECORD_ON_BOOK_ISBN FOREIGN KEY (book_isbn) REFERENCES book (isbn);

ALTER TABLE reading_record ADD CONSTRAINT FK_READINGRECORD_ON_MEMBER_EMAIL_ADDRESS FOREIGN KEY (member_email_address) REFERENCES member (email_address);