package com.glow.openbook.user;

import com.glow.openbook.api.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("member")
public class MemberController {

    private final MemberService memberService;

    @GetMapping({"", "/"})
    public ApiResponse<Member> getCurrentMemberDetail() {
        return ApiResponse.successfulResponse(memberService.getCurrentMember());
    }
}
