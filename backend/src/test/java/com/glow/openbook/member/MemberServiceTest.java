package com.glow.openbook.member;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;

@SpringBootTest
public class MemberServiceTest {
    @Autowired
    private MemberService memberService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Test
    public void signUpTest() {
        String emailAddress = "sign-up-test@glowingreaders.club";
        String password = "password";

        assertThat(memberService.getMember(emailAddress)).isEmpty();
        Member member = memberService.register(emailAddress, password);
        assertThat(member.getEmailAddress()).isEqualTo(emailAddress);
        assertThat(member.getPassword()).isNotEqualTo(password);
        assertThat(member.getNickname()).isNotBlank();

        Optional<Member> loadedMember = memberService.getMember(emailAddress);
        assertThat(loadedMember).isNotEmpty();
        assertThat(loadedMember.get()).usingRecursiveComparison().isEqualTo(member);
    }
}
