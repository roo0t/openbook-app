package com.glow.openbook.member;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.glow.openbook.member.auth.AuthenticationRequest;
import com.glow.openbook.member.auth.JwtProvider;
import com.jayway.jsonpath.JsonPath;
import org.hamcrest.Matchers;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.FilterChainProxy;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.web.filter.CharacterEncodingFilter;

import java.util.ArrayList;
import java.util.List;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.when;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

@SpringBootTest
@TestPropertySource(properties = {
        "spring-jwt-secret=Y9jPSwDSp1m4R4T616gBV9Lx7yWGrJQmwkNeAs12h9eYgrrlXnLRZ22nhxddL0uAKRx2S1514WC22tGvcxJMTg",
})
public class MemberControllerTest {
    private MockMvc mockMvc;

    @Value("${spring-jwt-secret}")
    private String secretKeyString;

    @MockBean
    private JwtProvider jwtProvider;

    @MockBean
    private MemberService memberService;

    @Autowired
    @InjectMocks
    private MemberController memberController;

    @Autowired
    private FilterChainProxy springSecurityFilterChain;

    @Autowired
    private ObjectMapper objectMapper;

    @BeforeEach
    public void setUp() {
        mockMvc = standaloneSetup(memberController)
                .apply(springSecurity(springSecurityFilterChain))
                .addFilter(new CharacterEncodingFilter("UTF-8", true))
                .defaultRequest(get("/member").accept(MediaType.APPLICATION_JSON).characterEncoding("UTF-8"))
                .build();
    }

    @Test
    public void unauthenticated_access_is_not_allowed_to_member_detail() throws Exception {
        mockMvc.perform(get("/member"))
                .andExpect(status().isForbidden());
    }

    @Test
    public void valid_authentication_grants_access_to_member_detail() throws Exception {
        // Arrange
        final String emailAddress = "test@glowingreaders.club";
        final String password = "abcd1233";
        final String mockToken = "generatedmocktoken";

        List<GrantedAuthority> authorities = new ArrayList<>();
        authorities.add(new SimpleGrantedAuthority("ROLE_MEMBER"));
        UserDetails userDetails = new User(emailAddress, password, authorities);

        when(jwtProvider.createToken(eq(emailAddress), anyList())).thenReturn(mockToken);
        when(jwtProvider.getUserPk(mockToken)).thenReturn(emailAddress);
        when(jwtProvider.validationToken(mockToken)).thenReturn(true);
        when(memberService.loadUserByUsername(emailAddress)).thenReturn(userDetails);
        when(memberService.authenticate(any(), eq(emailAddress), eq(password))).thenReturn(userDetails);

        AuthenticationRequest request = AuthenticationRequest.builder()
                .emailAddress(emailAddress).password(password).build();
        var requestString = objectMapper.writeValueAsString(request);

        // Action
        final ResultActions signInResultActions = mockMvc.perform(post("/member/signin")
                        .contentType("application/json;charset=UTF-8")
                        .content(requestString));

        // Assert
        final var signInResult = signInResultActions
                .andExpect(content().contentType("application/json;charset=UTF-8"))
                .andExpect(jsonPath("$.username", Matchers.is(request.getEmailAddress())))
                .andExpect(jsonPath("$.authorities", Matchers.hasSize(1)))
                .andExpect(jsonPath("$.authorities[0].authority", Matchers.is("ROLE_MEMBER")))
                .andReturn();
        final String token = JsonPath.read(signInResult.getResponse().getContentAsString(), "$.token");
        assertThat(token).isEqualTo(mockToken);
    }

    @Test
    public void sign_up_request_creates_new_account() throws Exception {
        // Arrange
        final String emailAddress = "test@glowingreaders.club";
        final String password = "password";
        SignUpRequest request = SignUpRequest.builder()
                .emailAddress(emailAddress).password(password).build();
        String requestString = objectMapper.writeValueAsString(request);

        List<GrantedAuthority> authorities = new ArrayList<>();
        authorities.add(new SimpleGrantedAuthority("ROLE_1"));
        authorities.add(new SimpleGrantedAuthority("ROLE_2"));
        UserDetails userDetails = new User(emailAddress, password, authorities);
        when(memberService.signUpAndSignIn(any(), eq(emailAddress), eq(password))).thenReturn(userDetails);

        // Action
        var actionResult = mockMvc.perform(post("/member/signup")
                        .contentType("application/json;charset=UTF-8")
                        .content(requestString));

        // Assert
        actionResult
                .andDo(print())
                .andExpect(content().contentType("application/json;charset=UTF-8"))
                .andExpect(jsonPath("$.username", Matchers.is(request.getEmailAddress())))
                .andExpect(jsonPath("$.authorities", Matchers.hasSize(2)))
                .andExpect(jsonPath("$.authorities[0].authority", Matchers.is("ROLE_1")))
                .andExpect(jsonPath("$.authorities[1].authority", Matchers.is("ROLE_2")));
    }
}
