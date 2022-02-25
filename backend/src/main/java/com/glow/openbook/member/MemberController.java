package com.glow.openbook.member;

import com.glow.openbook.member.auth.AuthenticationRequest;
import com.glow.openbook.member.auth.AuthenticationToken;
import com.glow.openbook.member.auth.JwtProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.hateoas.EntityModel;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

@RestController
@RequiredArgsConstructor
@RequestMapping("member")
public class MemberController {
    private final MemberService memberService;
    private final JwtProvider jwtProvider;
    private final AuthenticationManager authenticationManager;

    @GetMapping({"", "/"})
    public ResponseEntity<EntityModel<Member>> getCurrentMemberDetail() {
        return ResponseEntity.ok(EntityModel.of(memberService.getCurrentMember(),
                linkTo(methodOn(MemberController.class).getCurrentMemberDetail()).withSelfRel()));
    }

    @PostMapping("/signin")
    public ResponseEntity<EntityModel<AuthenticationToken>> signIn(
            @RequestBody AuthenticationRequest authenticationRequest) {
        final String emailAddress = authenticationRequest.getEmailAddress();
        final String password = authenticationRequest.getPassword();

        UserDetails userDetails = memberService.authenticate(authenticationManager, emailAddress, password);

        return ResponseEntity.ok(EntityModel.of(makeAuthenticationToken(userDetails),
                linkTo(methodOn(MemberController.class).signIn(null)).withSelfRel()));
    }

    @PostMapping("/signup")
    public ResponseEntity<EntityModel<AuthenticationToken>> signUp(@RequestBody SignUpRequest signUpRequest) {
        UserDetails userDetails;
        try {
            userDetails = memberService.signUpAndSignIn(
                    authenticationManager,
                    signUpRequest.getEmailAddress(),
                    signUpRequest.getPassword());
        } catch (MemberAlreadyExistsException e) {
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.ok(EntityModel.of(makeAuthenticationToken(userDetails),
                linkTo(methodOn(MemberController.class).signUp(null)).withSelfRel()));
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
