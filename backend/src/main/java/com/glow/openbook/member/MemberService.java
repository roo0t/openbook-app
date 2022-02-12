package com.glow.openbook.member;

import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.*;

@Service
@RequiredArgsConstructor
public class MemberService implements UserDetailsService {

    private final MemberRepository memberRepository;

    private final PasswordEncoder passwordEncoder;

    public Optional<Member> getMember(String emailAddress) {
        return memberRepository.findById(emailAddress);
    }

    @Override
    public UserDetails loadUserByUsername(String emailAddress) throws UsernameNotFoundException {
        Optional<Member> memberWrapper = memberRepository.findById(emailAddress);
        if (memberWrapper.isPresent()) {
            Member member = memberWrapper.get();
            List<GrantedAuthority> authorities = new ArrayList<>();
            authorities.add(new SimpleGrantedAuthority("ROLE_MEMBER"));
            return new User(member.getEmailAddress(), member.getPassword(), authorities);
        } else {
            throw new UsernameNotFoundException(emailAddress);
        }
    }

    public Member getCurrentMember() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Optional<Member> memberWrapper = memberRepository.findById(auth.getName());
        if (memberWrapper.isPresent()) {
            return memberWrapper.get();
        } else {
            return null;
        }
    }

    private String generateRandomNickname() {
        List<String> adjectives = Arrays.asList(
                "가려운", "강한", "갸름한", "게으른", "고소한",
                "공손한", "괴로운", "굉장한", "귀찮은", "그리운",
                "까다로운", "꼼꼼한", "날씬한", "낯선", "너그러운",
                "넉넉한", "네모난", "놀란", "느긋한", "느끼한",
                "다정한", "단순한", "단정한", "달콤한", "담백한",
                "답답한", "대단한", "독특한", "동그란", "둔한",
                "똑똑한", "뚱뚱한", "뛰어난", "멋진", "명랑한",
                "목마른", "못생긴", "믿음직한", "버릇없는", "부끄러운",
                "불쌍한", "상쾌한", "새로운", "색다른", "서운한",
                "서툰", "섭섭한", "센", "소심한", "속상한",
                "솔직한", "심심한", "쌀쌀맞은", "쑥스러운", "쓸쓸한",
                "씩씩한", "약한", "얌전한", "어색한", "엄격한",
                "엄청난", "엉뚱한", "여린", "우아한", "우울한",
                "위대한", "유쾌한", "잘난", "점잖은", "지루한",
                "지저분한", "차분한", "튼튼한", "평범한", "한가한",
                "화려한", "험상궂은", "활발한", "훌륭한", "하얀",
                "걱정하는", "공부하는", "구경하는", "기뻐하는", "꿈꾸는",
                "노력하는", "달리는", "샤워하는", "슬퍼하는", "침울한",
                "세수하는", "운전하는", "인사하는", "화내는", "춤추는"
        );
        List<String> names = Arrays.asList(
                "모비딕", "셜록홈즈", "모리아티", "볼링", "배트맨",
                "패트릭", "이니고", "몬토야", "제이", "개츠비",
                "베노", "아르킴볼리", "미카엘", "발렌타인", "스미스",
                "한니발", "렉터", "드라큘라", "프랑켄슈타인", "크리스마스",
                "앙겔라", "아르고", "허클베리핀", "스칼렛", "버틀러",
                "토마스", "제인에어", "플래그", "프랭키", "솔트",
                "우리아", "스벵갈리", "스타", "딤스데일", "분더릭",
                "큄비", "로빈슨", "크루소", "하비샴", "섄디",
                "그레이", "크레인", "피어스", "에버데인", "핀치"
        );
        Random random = new Random();
        return adjectives.get(random.nextInt(adjectives.size()))
                + " " + names.get(random.nextInt(names.size()));
    }

    @Transactional
    public Member register(String emailAddress, String plainPassword) throws MemberAlreadyExistsException {
        if (memberRepository.findById(emailAddress).isPresent()) {
            throw new MemberAlreadyExistsException();
        }
        String encryptedPassword = passwordEncoder.encode(plainPassword);
        Member member = new Member(emailAddress, encryptedPassword, generateRandomNickname());
        memberRepository.save(member);
        return member;
    }

    public UserDetails authenticate(
            AuthenticationManager authenticationManager,
            String emailAddress,
            String plainPassword) {
        UsernamePasswordAuthenticationToken token =
                new UsernamePasswordAuthenticationToken(emailAddress, plainPassword);
        Authentication authentication = authenticationManager.authenticate(token);
        SecurityContextHolder.getContext().setAuthentication(authentication);

        return loadUserByUsername(emailAddress);
    }
}
