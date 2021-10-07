package com.glow.openbook.readinggroup;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.websocket.server.PathParam;

@RestController
@RequestMapping("readinggroup")
public class ReadingGroupController {

    private final ReadingGroupRepository readingGroupRepository;

    public ReadingGroupController(ReadingGroupRepository readingGroupRepository) {
        this.readingGroupRepository = readingGroupRepository;
    }

    @GetMapping("{groupId}")
    public ReadingGroup getGroupDetail(@PathParam("groupId") long groupId) throws Exception {
        var group = readingGroupRepository.findById(groupId);
        if (group.isPresent()) {
            return group.get();
        } else {
            throw new Exception("No group found");
        }
    }
}
