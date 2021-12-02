package com.glow.openbook;

import com.glow.openbook.book.Book;
import com.glow.openbook.book.BookRepository;
import com.glow.openbook.readinggroup.ReadingGroup;
import com.glow.openbook.readinggroup.ReadingGroupRepository;
import com.glow.openbook.user.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.Arrays;
import java.util.List;

@SpringBootApplication
@RequiredArgsConstructor
public class OpenBookApplication implements CommandLineRunner {

	public static void main(String[] args) {
		SpringApplication.run(OpenBookApplication.class, args);
	}

	private final MemberService memberService;
	private final BookRepository bookRepository;
	private final ReadingGroupRepository readingGroupRepository;

	@Override
	public void run(String... args) throws Exception {
		memberService.register("test@glowingreaders.club", "abcd1234");

		final List<ReadingGroup> readingGroups = Arrays.asList(
				ReadingGroup.builder()
						.name("장애학 읽기모임")
						.build()
		);
		readingGroupRepository.saveAll(readingGroups);
	}
}
