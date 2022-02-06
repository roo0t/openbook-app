package com.glow.openbook.member.auth;

import com.glow.openbook.member.MemberService;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.crypto.SecretKey;
import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;

@RequiredArgsConstructor
@Component
public class JwtProvider {
    public static String AUTH_TOKEN_HEADER = "X-AUTH-TOKEN";

    @Value("${spring-jwt-secret}")
    private String secretKeyString;

    private SecretKey secretKey;

    private Long tokenValidMillisecond = 60 * 60 * 1000L;

    private final MemberService userDetailsService;

    @PostConstruct
    protected void initialize() {
        secretKey = Keys.hmacShaKeyFor(secretKeyString.getBytes());
    }

    // Jwt 생성
    public String createToken(String emailAddress, List<String> roles) {

        // user 구분을 위해 Claims에 User Pk값 넣어줌
        Claims claims = Jwts.claims().setSubject(emailAddress);
        claims.put("roles", roles);
        // 생성날짜, 만료날짜를 위한 Date
        Date now = new Date();

        return Jwts.builder()
                .setClaims(claims)
                .setIssuedAt(now)
                .setExpiration(new Date(now.getTime() + tokenValidMillisecond))
                .signWith(secretKey)
                .compact();
    }

    // Jwt 로 인증정보를 조회
    public Authentication getAuthentication (String token) {
        UserDetails userDetails = userDetailsService.loadUserByUsername(this.getUserPk(token));
        return new UsernamePasswordAuthenticationToken(userDetails, "", userDetails.getAuthorities());
    }

    // jwt 에서 회원 구분 Pk 추출
    public String getUserPk(String token) {
        return Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token).getBody().getSubject();
    }

    // HTTP Request 의 Header 에서 Token Parsing -> "X-AUTH-TOKEN: jwt"
    public String resolveToken(HttpServletRequest request) {
        return request.getHeader(AUTH_TOKEN_HEADER);
    }

    // jwt 의 유효성 및 만료일자 확인
    public boolean validationToken(String token) {
        try {
            Jws<Claims> claimsJws = parseJwt(token);
            return !claimsJws.getBody().getExpiration().before(new Date()); // 만료날짜가 현재보다 이전이면 false
        } catch (Exception e) {
            return false;
        }
    }

    public Jws<Claims> parseJwt(String token) {
        return Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token);
    }
}