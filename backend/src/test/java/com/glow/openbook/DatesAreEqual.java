package com.glow.openbook;

import lombok.AllArgsConstructor;
import org.hamcrest.Description;
import org.hamcrest.TypeSafeMatcher;

import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

@AllArgsConstructor
public class DatesAreEqual extends TypeSafeMatcher<String> {

    private ZonedDateTime comparedDateTime;
    private DateTimeFormatter parsingPattern;

    @Override
    public void describeTo(Description description) {
        description.appendText("same as " + comparedDateTime.toString());
    }

    @Override
    protected boolean matchesSafely(String s) {
        try {
            return ZonedDateTime.parse(s, parsingPattern).isEqual(comparedDateTime);
        } catch(DateTimeParseException e) {
            return false;
        }
    }

    public static DatesAreEqual datesAreEqual(ZonedDateTime comparedDateTime, DateTimeFormatter parsingPattern) {
        return new DatesAreEqual(comparedDateTime, parsingPattern);
    }

    public static DatesAreEqual datesAreEqual(ZonedDateTime comparedDateTime) {
        return new DatesAreEqual(comparedDateTime, DateTimeFormatter.BASIC_ISO_DATE);
    }
}
