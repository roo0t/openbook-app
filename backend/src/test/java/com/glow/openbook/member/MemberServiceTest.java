package com.glow.openbook.member;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.argThat;
import static org.mockito.Mockito.*;

@SpringBootTest
@RunWith(MockitoJUnitRunner.class)
public class MemberServiceTest {
    @Mock
    private MemberRepository memberRepository;

    @Autowired
    @InjectMocks
    private MemberService memberService;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Test
    public void register_adds_member_to_repository_with_password_encoded() {
        // Arrange
        final String emailAddress = "sign-up-test@glowingreaders.club";
        final String password = "password";
        final String encodedPassword = "encodedPassword";
        when(memberRepository.save(any()))
                .thenAnswer(invocation -> invocation.getArguments()[0]);
        when(passwordEncoder.encode(password)).thenReturn(encodedPassword);

        // Action
        Member member = memberService.register(emailAddress, password);

        // Assert
        verify(memberRepository, times(1))
                .save(argThat(m -> m.getEmailAddress().equals(emailAddress)));
        verifyNoMoreInteractions(memberRepository);

        assertThat(member.getEmailAddress()).isEqualTo(emailAddress);
        assertThat(member.getPassword()).isEqualTo(encodedPassword);
        assertThat(member.getNickname()).isNotBlank();
    }
}
