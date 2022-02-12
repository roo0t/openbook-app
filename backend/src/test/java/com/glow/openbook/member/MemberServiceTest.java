package com.glow.openbook.member;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.assertj.core.api.Assertions.catchThrowable;
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
    public void register_adds_member_to_repository_with_password_encoded() throws MemberAlreadyExistsException {
        // Arrange
        final String emailAddress = "sign-up-test@glowingreaders.club";
        final String password = "password";
        final String encodedPassword = "encodedPassword";
        when(memberRepository.findById(any())).thenReturn(Optional.empty());
        when(memberRepository.save(any()))
                .thenAnswer(invocation -> invocation.getArguments()[0]);
        when(passwordEncoder.encode(password)).thenReturn(encodedPassword);

        // Action
        Member member = memberService.register(emailAddress, password);

        // Assert
        verify(memberRepository, times(1))
                .save(argThat(m -> m.getEmailAddress().equals(emailAddress)));

        assertThat(member.getEmailAddress()).isEqualTo(emailAddress);
        assertThat(member.getPassword()).isEqualTo(encodedPassword);
        assertThat(member.getNickname()).isNotBlank();
    }

    @Test
    public void registering_existing_member_fails() {
        // Arrange
        final String emailAddress = "sign-up-test@glowingreaders.club";
        final String password = "password";
        Member member = Member.builder()
                              .emailAddress(emailAddress)
                              .password(password)
                              .build();
        when(memberRepository.getById(emailAddress)).thenReturn(member);
        when(memberRepository.findById(emailAddress)).thenReturn(Optional.of(member));
        when(memberRepository.save(argThat(m -> m.getEmailAddress().equals(emailAddress)))).thenReturn(member);

        // Action
        Throwable thrown = catchThrowable(() -> memberService.register(emailAddress, password));

        // Assert
        assertThat(thrown).isInstanceOf(MemberAlreadyExistsException.class);
    }
}
