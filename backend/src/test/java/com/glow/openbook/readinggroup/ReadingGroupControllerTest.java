package com.glow.openbook.readinggroup;

import org.hamcrest.core.IsNull;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.filter.CharacterEncodingFilter;

import java.util.Arrays;
import java.util.List;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

@SpringBootTest
public class ReadingGroupControllerTest {

    private MockMvc mockMvc;

    @Autowired
    private ReadingGroupRepository readingGroupRepository;

    @Autowired
    private ReadingGroupService readingGroupService;

    @Autowired
    private ReadingGroupController readingGroupController;

    private List<ReadingGroup> readingGroups;

    @BeforeEach
    public void setUp() {
        mockMvc = standaloneSetup(readingGroupController)
                .addFilter(new CharacterEncodingFilter("UTF-8", true))
                .defaultRequest(get("/readinggroup").accept(MediaType.APPLICATION_JSON).characterEncoding("UTF-8"))
                .alwaysExpect(status().isOk())
                .build();
        readingGroupRepository.deleteAll();

        // Add test data
        List<ReadingGroupVo> readingGroupVos = Arrays.asList(
                ReadingGroupVo.builder().name("test group 1").build(),
                ReadingGroupVo.builder().name("test group 2").build()
        );
        readingGroups = readingGroupVos.stream()
                .map(vo -> readingGroupService.addGroup(vo))
                .toList();
    }

    @Test
    public void getGroupList() throws Exception {
        // Test
        mockMvc.perform(get("/readinggroup"))
                .andExpect(content().contentType("application/json;charset=UTF-8"))
                .andExpect(jsonPath("$.statusMessage", is("SUCCESS")))
                .andExpect(jsonPath("$.data", hasSize(readingGroups.size())));
    }

    @Test
    public void getNotExistingGroupDetail() throws Exception {
        final int nonExistingId = 123;
        assertThat(readingGroups).asList()
                .noneMatch(readingGroup -> ((ReadingGroup)readingGroup).getId() == nonExistingId);
        mockMvc.perform(get(String.format("/readinggroup/%d", nonExistingId)))
                .andExpect(content().contentType("application/json;charset=UTF-8"))
                .andExpect(jsonPath("$.statusMessage", is("NOT_FOUND")))
                .andExpect(jsonPath("$.data").value(IsNull.nullValue()));
    }

    @Test
    public void getExistingGroupDetail() throws Exception {
        for (ReadingGroup readingGroup : readingGroups) {
            mockMvc.perform(get("/readinggroup/" + readingGroup.getId()))
                    .andExpect(content().contentType("application/json;charset=UTF-8"))
                    .andExpect(jsonPath("$.statusMessage", is("SUCCESS")))
                    .andExpect(jsonPath("$.data.name", is(readingGroup.getName())));
        }

        readingGroups.forEach(readingGroup -> readingGroupService.removeGroup(readingGroup));
    }
}
