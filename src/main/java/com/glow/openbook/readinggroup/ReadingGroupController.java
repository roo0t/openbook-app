package com.glow.openbook.readinggroup;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("readinggroup")
public class ReadingGroupController {

    private final ReadingGroupRepository readingGroupRepository;

    public ReadingGroupController(ReadingGroupRepository readingGroupRepository) {
        this.readingGroupRepository = readingGroupRepository;
    }

    @GetMapping({"", "/"})
    public List<ReadingGroup> getGroupList() {
        return readingGroupRepository.findAll();
    }

    @GetMapping("/{groupId}")
    public ReadingGroup getGroupDetail(@PathVariable("groupId") Long groupId) throws Exception {
        var group = readingGroupRepository.findById(groupId);
        if (group.isPresent()) {
            return group.get();
        } else {
            throw new Exception("No group found");
        }
    }
}
