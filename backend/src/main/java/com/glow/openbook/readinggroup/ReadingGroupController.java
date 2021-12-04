package com.glow.openbook.readinggroup;

import com.glow.openbook.api.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("readinggroup")
public class ReadingGroupController {

    private final ReadingGroupRepository readingGroupRepository;

    private final ReadingGroupService readingGroupService;

    @GetMapping({"", "/"})
    public ApiResponse<List<ReadingGroup>> getGroupList() {
        return ApiResponse.successfulResponse(readingGroupService.getGroupList());
    }

    @GetMapping("/{groupId}")
    public ApiResponse<ReadingGroup> getGroupDetail(@PathVariable("groupId") Long groupId) {
        var group = readingGroupService.getGroupById(groupId);
        if (group.isPresent()) {
            return ApiResponse.successfulResponse(group.get());
        } else {
            return ApiResponse.notFoundResponse();
        }
    }
}
