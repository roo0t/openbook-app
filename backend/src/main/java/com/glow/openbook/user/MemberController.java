package com.glow.openbook.user;

import com.glow.openbook.api.ApiResponse;
import com.glow.openbook.user.auth.AuthenticationRequest;
import com.glow.openbook.user.auth.AuthenticationToken;
import com.glow.openbook.user.auth.JwtProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@RestController
@RequiredArgsConstructor
@RequestMapping("member")
public class MemberController {

    private final MemberService memberService;
    private final AuthenticationManager authenticationManager;
    private final JwtProvider jwtProvider;

    @GetMapping({"", "/"})
    public ApiResponse<Member> getCurrentMemberDetail() {
        return ApiResponse.successfulResponse(memberService.getCurrentMember());
    }

    @PostMapping("/signin")
    public AuthenticationToken signIn(
            @RequestBody AuthenticationRequest authenticationRequest,
            HttpSession session) {
        final String emailAddress = authenticationRequest.getEmailAddress();
        final String password = authenticationRequest.getPassword();

        UsernamePasswordAuthenticationToken token =
                new UsernamePasswordAuthenticationToken(emailAddress, password);
        Authentication authentication = authenticationManager.authenticate(token);
        SecurityContextHolder.getContext().setAuthentication(authentication);

        UserDetails member = memberService.loadUserByUsername(emailAddress);
        String accessToken = jwtProvider.createToken(
                emailAddress,
                member.getAuthorities().stream().map((auth) -> auth.getAuthority()).toList());
        return new AuthenticationToken(
                member.getUsername(),
                member.getAuthorities(),
                accessToken);
    }
}
