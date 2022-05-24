package com.glow.openbook.aws;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.awscore.exception.AwsServiceException;
import software.amazon.awssdk.core.exception.SdkClientException;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.BucketAlreadyExistsException;
import software.amazon.awssdk.services.s3.model.CreateBucketRequest;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.IOException;
import java.io.InputStream;

@Service
public class S3Service {
    @Autowired
    private S3Client amazonS3Client;

    public void putObject(String bucket, String key, MultipartFile content) throws IOException {
        putObject(bucket, key, content.getInputStream(), content.getSize());
    }

    public void putObject(String bucket, String key, InputStream content, long contentLength) {
        PutObjectRequest request = PutObjectRequest.builder()
                .bucket(bucket)
                .key(key)
                .build();
        RequestBody body = RequestBody.fromInputStream(content, contentLength);
        amazonS3Client.putObject(request, body);
    }
}
