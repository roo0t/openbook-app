package com.glow.openbook.member;

import com.glow.openbook.api.ApiResponse;
import com.glow.openbook.member.auth.AuthenticationRequest;
import com.glow.openbook.member.auth.AuthenticationToken;
import com.glow.openbook.member.auth.JwtProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

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
            @RequestBody AuthenticationRequest authenticationRequest) {
        final String emailAddress = authenticationRequest.getEmailAddress();
        final String password = authenticationRequest.getPassword();

        UserDetails userDetails = memberService.authenticate(authenticationManager, emailAddress, password);
        return ApiResponse.successfulResponse(makeAuthenticationToken(userDetails));
    }

    @PostMapping("/signup")
    public ApiResponse<AuthenticationToken> signUp(@RequestBody SignUpRequest signUpRequest) {
        UserDetails userDetails;
        try {
            userDetails = memberService.signUpAndSignIn(
                    authenticationManager,
                    signUpRequest.getEmailAddress(),
                    signUpRequest.getPassword());
        } catch (MemberAlreadyExistsException e) {
            return ApiResponse.invalidOperationResponse();
        }
        return ApiResponse.successfulResponse(makeAuthenticationToken(userDetails));
    }

    private AuthenticationToken makeAuthenticationToken(UserDetails userDetails) {
        String accessToken = jwtProvider.createToken(
                userDetails.getUsername(),
                userDetails.getAuthorities().stream().map((auth) -> auth.getAuthority()).toList());
        AuthenticationToken token = new AuthenticationToken(
                userDetails.getUsername(),
                userDetails.getAuthorities(),
                accessToken);
        return token;
    }
}
