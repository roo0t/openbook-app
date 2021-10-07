package com.glow.openbook.book;

import org.aspectj.lang.annotation.After;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;
import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class BookControllerTest {

    @Autowired
    private BookRepository bookRepository;

    @AfterEach
    void tearDown() {
        bookRepository.deleteAll();
    }

    @Test
    void getBookByIsbn() {
        final List<Book> books = Arrays.asList(
                Book.builder()
                        .isbn("9788972979616")
                        .title("난치의 상상력")
                        .author("안희제")
                        .publisher("동녘")
                        .description("크론병으로 투병 중인 20대 청년이 써내려간 ‘청춘 고발기’이자 아픈 몸을 대하는 한국 사회의 모순을 비판한 날카로운 보고서다. 저자의 몸은 청춘과 나이듦, 질병과 장애, 정상과 비정상이 교차하는 전쟁터다. 사람들은 아파 보이지 않는다는 이유로 저자를 의심하며 장애인 옆에서는 ‘비장애인’으로, 비장애인 옆에서는 ‘장애인’으로 대했다.")
                        .build(),
                Book.builder()
                        .isbn("9788966262472")
                        .title("클린 아키텍처")
                        .author("로버트 C. 마틴")
                        .publisher("인사이트")
                        .description("소프트웨어 아키텍처의 보편 원칙을 적용하면 소프트웨어 수명 전반에서 개발자 생산성을 획기적으로 끌어올릴 수 있다. 《클린 코드》와 《클린 코더》의 저자이자 전설적인 소프트웨어 장인인 로버트 C. 마틴은 이 책 《클린 아키텍처》에서 이러한 보편 원칙들을 설명하고 여러분이 실무에 적용할 수 있도록 도와준다.")
                        .build()
        );

        bookRepository.saveAll(books);

        assertThat(bookRepository.findById(books.get(0).getIsbn()))
                .usingRecursiveComparison()
                .isEqualTo(Optional.of(books.get(0)));
        assertThat(bookRepository.findById(books.get(1).getIsbn()))
                .usingRecursiveComparison()
                .isEqualTo(Optional.of(books.get(1)));
        assertThat(bookRepository.findById("")).isEmpty();
    }
}