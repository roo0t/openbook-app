package com.glow.openbook.member;

import com.glow.openbook.member.auth.JwtProvider;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

import java.time.*;
import java.util.Arrays;
import java.util.Date;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;

@SpringBootTest
@TestPropertySource(properties = {
    "spring-jwt-secret=Y9jPSwDSp1m4R4T616gBV9Lx7yWGrJQmwkNeAs12h9eYgrrlXnLRZ22nhxddL0uAKRx2S1514WC22tGvcxJMTg",
})
public class JwtProviderTest {
    @Value("${spring-jwt-secret}")
    private String secretKeyString;

    @Autowired
    private JwtProvider jwtProvider;

    @Test
    void createdTokenMatchesTheReference() {
        final String emailAddress = "i.am.me@glowingreaders.club";
        final var roles = Arrays.asList("ROLE_USER", "ROLE_ADMIN");

        Instant beforeCreationDate = new Date().toInstant();
        beforeCreationDate = beforeCreationDate.minusNanos(beforeCreationDate.getNano());
        final var token = jwtProvider.createToken(emailAddress, roles);
        Instant afterCreationDate = new Date().toInstant();
        afterCreationDate = afterCreationDate.minusNanos(afterCreationDate.getNano());

        var secretKey = Keys.hmacShaKeyFor(secretKeyString.getBytes());
        final var claims = Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token);
        assertThat(claims.getBody().getSubject()).isEqualTo(emailAddress);
        assertThat(claims.getBody().getIssuedAt())
                .isAfterOrEqualTo(beforeCreationDate)
                .isBeforeOrEqualTo(afterCreationDate);
        LocalDateTime issuedDateTime = LocalDateTime.ofInstant(
                claims.getBody().getIssuedAt().toInstant(), ZoneOffset.UTC);
        LocalDateTime expectedExpiryDateTime = issuedDateTime.plusHours(1);
        assertThat(claims.getBody().getExpiration())
                .isEqualToIgnoringSeconds(Date.from(expectedExpiryDateTime.toInstant(ZoneOffset.UTC)));
    }
}
