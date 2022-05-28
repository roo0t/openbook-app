package com.glow.openbook.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.AwsCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;

import java.net.URI;
import java.net.URISyntaxException;

public class AwsS3Config {

    @Value("${cloud.aws.s3.endpoint-uri}")
    private String endpointUri;

    @Bean
    @Primary
    public AwsCredentials basicAwsCredentials() {
        return AwsBasicCredentials.create(
                "somerandomaccesskey",
                "somerandomsecretkey");
    }

    @Bean
    @Primary
    public S3Client s3Client(AwsCredentials awsCredentials) throws URISyntaxException {
        return S3Client.builder()
                .endpointOverride(new URI(endpointUri))
                .credentialsProvider(StaticCredentialsProvider.create(awsCredentials))
                .build();
    }

    @Bean
    @Primary
    public S3Presigner s3Presigner(AwsCredentials awsCredentials) throws URISyntaxException {
        return S3Presigner.builder()
                .region(Region.of("ap-northeast-2"))
                .endpointOverride(new URI(endpointUri))
                .credentialsProvider(StaticCredentialsProvider.create(awsCredentials))
                .build();
    }
}
