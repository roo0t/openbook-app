package com.glow.openbook.record;

import com.glow.openbook.member.Member;
import com.glow.openbook.member.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.hateoas.CollectionModel;
import org.springframework.hateoas.EntityModel;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.stream.Collectors;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

@Controller
@RequestMapping("record")
public class ReadingRecordController {
    @Autowired
    private ReadingRecordService service;

    @Autowired
    private MemberService memberService;

    // Get controller for getReadingRecord
    @GetMapping("/{isbn}")
    public ResponseEntity<CollectionModel<EntityModel<ReadingRecord>>> getReadingRecord(@PathVariable("isbn") String isbn) {
        Member currentMember = memberService.getCurrentMember();
        List<ReadingRecord> records = service.getReadingRecords(currentMember, isbn);
        List<EntityModel<ReadingRecord>> recordEntityModels =
                records.stream().map(record -> EntityModel.of(record)).collect(Collectors.toList());
        return ResponseEntity.ok().body(CollectionModel.of(
                recordEntityModels,
                linkTo(methodOn(ReadingRecordController.class).getReadingRecord(isbn)).withSelfRel()));
    }
}
