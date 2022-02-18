package com.glow.openbook.api;

public enum StatusMessage {
    SUCCESS("SUCCESS"),
    NOT_FOUND("NOT_FOUND"),
    INVALID_OPERATION("INVALID_OPERATION"),
    ;

    private String message;

    StatusMessage(String message) {
        this.message = message;
    }
}
