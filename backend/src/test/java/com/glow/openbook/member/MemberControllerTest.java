package com.glow.openbook.member;

import com.glow.openbook.user.MemberController;
import com.glow.openbook.user.MemberService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.web.FilterChainProxy;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.filter.CharacterEncodingFilter;

import static org.hamcrest.Matchers.is;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestBuilders.formLogin;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.response.SecurityMockMvcResultMatchers.authenticated;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
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
    public void testMyinfo() throws Exception {
        final String emailAddress = "test@glowingreaders.club";
        final String plainPassword = "abcd1234";
        memberService.register(emailAddress, plainPassword);

        final MockHttpSession session = (MockHttpSession)mockMvc
                .perform(formLogin().user(emailAddress).password(plainPassword))
                .andExpect(status().is3xxRedirection())
                .andExpect(authenticated())
                .andReturn().getRequest().getSession();
        mockMvc.perform(get("/member").session(session).with(csrf().asHeader()))
                .andExpect(content().contentType("application/json;charset=UTF-8"))
                .andExpect(jsonPath("$.statusMessage", is("SUCCESS")))
                .andExpect(jsonPath("$.data.emailAddress", is(emailAddress)));
    }
}
