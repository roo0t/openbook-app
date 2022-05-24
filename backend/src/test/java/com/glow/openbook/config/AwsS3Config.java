package com.glow.openbook.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.services.s3.S3Client;

import java.net.URI;
import java.net.URISyntaxException;

public class AwsS3Config {
    @Bean
    @Primary
    public S3Client s3Client() throws URISyntaxException {
        var credentials = AwsBasicCredentials.create(
                "somerandomaccesskey",
                "somerandomsecretkey");
        return S3Client.builder()
                .endpointOverride(new URI("http://localhost:9090"))
                .credentialsProvider(StaticCredentialsProvider.create(credentials))
                .build();
    }
}
