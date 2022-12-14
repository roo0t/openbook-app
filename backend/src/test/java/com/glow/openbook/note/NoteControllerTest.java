package com.glow.openbook.note;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.glow.openbook.aws.S3Service;
import com.glow.openbook.book.Book;
import com.glow.openbook.book.BookRepository;
import com.glow.openbook.member.Member;
import com.glow.openbook.member.MemberRepository;
import com.glow.openbook.member.MemberService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.hateoas.MediaTypes;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.web.filter.CharacterEncodingFilter;

import java.io.IOException;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import static com.glow.openbook.DatesAreEqual.datesAreEqual;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.is;
import static org.mockito.Mockito.when;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

@SpringBootTest
class NoteControllerTest {

    private MockMvc mockMvc;

    @Autowired
    private NoteController noteController;

    @Autowired
    private NoteRepository noteRepository;

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private BookRepository bookRepository;

    @Autowired
    private S3Service s3Service;

    @MockBean
    private MemberService memberService;

    @Value("${cloud.aws.s3.note-image-bucket}")
    private String noteImageBucket;

    @Autowired
    private ResourceLoader resourceLoader;

    @Autowired
    private ObjectMapper objectMapper;

    @BeforeEach
    public void setUp() {
        mockMvc = standaloneSetup(noteController)
                .addFilter(new CharacterEncodingFilter("UTF-8", true))
                .defaultRequest(get("/book").accept(MediaTypes.HAL_JSON).characterEncoding("UTF-8"))
                .build();
    }

    private String generateRandomString(int length) {
        int leftLimit = 48; // numeral '0'
        int rightLimit = 122; // letter 'z'
        int targetStringLength = 10;
        Random random = new Random();
        String generatedString = random.ints(leftLimit, rightLimit + 1)
                .filter(i -> (i <= 57 || i >= 65) && (i <= 90 || i >= 97))
                .limit(targetStringLength)
                .collect(StringBuilder::new, StringBuilder::appendCodePoint, StringBuilder::append)
                .toString();
        return generatedString;
    }

    private Note getRandomNote(Member member, Book book) throws IOException {
        Resource resource = resourceLoader.getResource("classpath:test_image.jpg");
        String key = generateRandomString(10);
        s3Service.putObject(
                noteImageBucket,
                key,
                resource.getInputStream(),
                resource.contentLength());
        return Note.builder()
                .book(book)
                .content(generateRandomString(100))
                .page(new Random().nextInt(100))
                .author(member)
                .imageFileNames(List.of(key))
                .build();
    }

    private UserDetails getUserDetails(Member member) {
        List<GrantedAuthority> authorities = new ArrayList<>();
        authorities.add(new SimpleGrantedAuthority("ROLE_MEMBER"));
        return new User(member.getEmailAddress(), member.getPassword(), authorities);
    }

    @Test
    @WithMockUser(username = "test@example.com")
    public void get_notes_returns_all_notes() throws Exception {
        // Arrange
        Member member = Member.builder()
                .emailAddress("test@example.com")
                .password("password")
                .nickname("test")
                .build();
        UserDetails testUser = getUserDetails(member);
        memberRepository.deleteAll();
        memberRepository.save(member);

        String isbn = "9780321356680";
        Book book = Book.builder().isbn(isbn).build();
        bookRepository.deleteAll();
        bookRepository.save(book);

        noteRepository.deleteAll();
        int noteCount = 10;
        List<Note> notes = new ArrayList<>();
        for(int i = 0; i < noteCount; i++) {
            Note note = getRandomNote(member, book);
            noteRepository.save(note);
            notes.add(note);
        }

        // Act
        ResultActions resultActions = mockMvc.perform(
                get("/note").param("isbn", isbn).with(user(testUser)));

        // Assert
        resultActions
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content", hasSize(notes.size())))
                .andExpect(jsonPath("$.content[0].content", is(notes.get(0).getContent())))
                .andExpect(jsonPath("$.content[0].page", is(notes.get(0).getPage())))
                .andExpect(jsonPath("$.content[0].imageUris", hasSize(notes.get(0).getImageFileNames().size())))
                .andExpect(jsonPath(
                        "$.content[0].createdAt",
                        datesAreEqual(notes.get(0).getCreatedAt(),
                                DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSSSSS[Z]"))))
                .andExpect(jsonPath("$.links[?(@.rel=='self')]").exists())
        ;
    }

    @Test
    public void add_note_adds_new_note() throws Exception {
        // Arrange
        Member member = Member.builder()
                .emailAddress("test@example.com")
                .password("password")
                .nickname("test")
                .build();
        Member memberEntity = memberRepository.save(member);
        UserDetails testUser = getUserDetails(memberEntity);

        String isbn = "9780321356680";
        int totalPages = 369;
        Book book = Book.builder().isbn(isbn).totalPages(totalPages).build();
        bookRepository.save(book);

        noteRepository.deleteAll();

        Resource resource = resourceLoader.getResource("classpath:test_image.jpg");
        int page = new Random().nextInt(totalPages);
        String content = generateRandomString(100);

        when(memberService.getCurrentMember()).thenReturn(member);

        // Act
        ResultActions resultActions = mockMvc.perform(
                multipart("/note/{isbn}/{page}", isbn, page)
                        .file("images", resource.getInputStream().readAllBytes())
                        .param("content", content)
                        .with(user(testUser)));

        // Assert
        resultActions
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").exists())
                .andExpect(jsonPath("$.content", is(content)))
                .andExpect(jsonPath("$.page", is(page)))
                .andExpect(jsonPath("$.imageUris", hasSize(1)))
                .andExpect(jsonPath("$.createdAt").exists())
                .andExpect(jsonPath("$.authorEmailAddress", is(memberEntity.getEmailAddress())))
                .andExpect(jsonPath("$.authorNickname", is(memberEntity.getNickname())));
    }
}