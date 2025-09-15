package com.cloud.cloudproject.RequestItem;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ImageDTO {

    private int postId;
    private String imageUrl;


    public ImageDTO() {
    }

    public ImageDTO(int postId, String imageUrl) {
        this.postId = postId;
        this.imageUrl = imageUrl;
    }

    @Override
    public String toString() {
        return "ImageDTO{" +
                "postId=" + postId +
                ", imageUrl='" + imageUrl + '\'' +
                '}';
    }
}