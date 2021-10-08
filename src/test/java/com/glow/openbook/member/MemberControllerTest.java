package com.glow.openbook.member;

import com.glow.openbook.user.MemberRepository;
import com.glow.openbook.user.MemberService;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class MemberControllerTest {

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private MemberService memberService;

    @Test
    public void testMyinfo() {
        memberService.register("test@glowingreaders.club", "abcd1234");
    }
}
