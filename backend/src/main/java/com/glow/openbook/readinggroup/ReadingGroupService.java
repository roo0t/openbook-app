package com.glow.openbook.readinggroup;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ReadingGroupService {

    private final ReadingGroupRepository readingGroupRepository;

    private ReadingGroup ConvertToEntity(ReadingGroupVo vo) {
        return ReadingGroup.builder().name(vo.getName()).build();
    }

    List<ReadingGroup> getGroupList() {
        return readingGroupRepository.findAll();
    }

    public Optional<ReadingGroup> getGroupById(Long groupId) {
        return readingGroupRepository.findById(groupId);
    }

    public ReadingGroup addGroup(ReadingGroupVo vo) {
        return readingGroupRepository.save(ConvertToEntity(vo));
    }

    public void removeGroup(ReadingGroup readingGroup) {
        readingGroupRepository.delete(readingGroup);
    }
}
