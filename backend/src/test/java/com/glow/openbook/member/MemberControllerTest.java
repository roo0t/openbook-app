package com.glow.openbook.member;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.glow.openbook.member.auth.AuthenticationRequest;
import com.jayway.jsonpath.JsonPath;
import org.hamcrest.Matchers;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.web.FilterChainProxy;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.web.filter.CharacterEncodingFilter;

import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

@SpringBootTest
public class MemberControllerTest {
    private MockMvc mockMvc;

    @Autowired
    private MemberService memberService;

    @Autowired
    private MemberController memberController;

    @Autowired
    private FilterChainProxy springSecurityFilterChain;

    @BeforeEach
    public void setUp() {
        mockMvc = standaloneSetup(memberController)
                .apply(springSecurity(springSecurityFilterChain))
                .addFilter(new CharacterEncodingFilter("UTF-8", true))
                .defaultRequest(get("/member").accept(MediaType.APPLICATION_JSON).characterEncoding("UTF-8"))
                .build();
    }

    @Test
    public void testMemberPageUnauthorized() throws Exception {
        mockMvc.perform(get("/member"))
                .andExpect(status().isForbidden());
    }

    @Test
    public void testSignIn() throws Exception {
        AuthenticationRequest request = new AuthenticationRequest();
        request.setEmailAddress("test@glowingreaders.club");
        request.setPassword("abcd1234");
        ObjectMapper mapper = new ObjectMapper();
        MvcResult signInResult = mockMvc.perform(post("/member/signin")
                        .contentType("application/json;charset=UTF-8")
                        .content(mapper.writeValueAsString(request)))
                .andExpect(content().contentType("application/json;charset=UTF-8"))
                .andExpect(jsonPath("$.data.username", Matchers.is(request.getEmailAddress())))
                .andExpect(jsonPath("$.data.authorities", Matchers.hasSize(1)))
                .andExpect(jsonPath("$.data.authorities[0].authority", Matchers.is("ROLE_MEMBER")))
                .andReturn();
        String token = JsonPath.read(signInResult.getResponse().getContentAsString(), "$.data.token");
        mockMvc.perform(get("/member").header("X-AUTH-TOKEN", token))
                .andExpect(content().contentType("application/json;charset=UTF-8"))
                .andExpect(jsonPath("$.statusMessage", Matchers.is("SUCCESS")))
                .andExpect(jsonPath("$.data.emailAddress", Matchers.is(request.getEmailAddress())));
    }
}
