package com.glow.openbook.api;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Data;

@Data
@Builder(access = AccessLevel.PRIVATE)
public class ApiResponse<T> {
    private StatusMessage statusMessage;
    private T data;

    public static <T> ApiResponse<T> successfulResponse(final T data) {
        return (ApiResponse<T>)(builder().statusMessage(StatusMessage.SUCCESS).data(data).build());
    }

    public static <T> ApiResponse<T> notFoundResponse() {
        return (ApiResponse<T>)(builder().statusMessage(StatusMessage.NOT_FOUND).build());
    }
}
