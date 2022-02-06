package com.glow.openbook.member;

import com.glow.openbook.api.ApiResponse;
import com.glow.openbook.member.auth.AuthenticationRequest;
import com.glow.openbook.member.auth.AuthenticationToken;
import com.glow.openbook.member.auth.JwtProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@RestController
@RequiredArgsConstructor
@RequestMapping("member")
public class MemberController {
    private final MemberService memberService;
    private final JwtProvider jwtProvider;
    private final AuthenticationManager authenticationManager;

    @GetMapping({"", "/"})
    public ApiResponse<Member> getCurrentMemberDetail() {
        return ApiResponse.successfulResponse(memberService.getCurrentMember());
    }

    @PostMapping("/signin")
    public ApiResponse<AuthenticationToken> signIn(
            @RequestBody AuthenticationRequest authenticationRequest,
            HttpSession session) {
        final String emailAddress = authenticationRequest.getEmailAddress();
        final String password = authenticationRequest.getPassword();

        UserDetails member = memberService.authenticate(authenticationManager, emailAddress, password);
        String accessToken = jwtProvider.createToken(
                emailAddress,
                member.getAuthorities().stream().map((auth) -> auth.getAuthority()).toList());
        AuthenticationToken token = new AuthenticationToken(
                member.getUsername(),
                member.getAuthorities(),
                accessToken);
        return ApiResponse.successfulResponse(token);
    }
}
