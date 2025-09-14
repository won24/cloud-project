package com.cloud.cloudproject.RequestItem;

public class ImageDTO {

    private int postId;
    private String imageUrl;


    public ImageDTO() {
    }

    public ImageDTO(int postId, String imageUrl) {
        this.postId = postId;
        this.imageUrl = imageUrl;
    }

    public int getPostId() {
        return postId;
    }

    public void setPostId(int postId) {
        this.postId = postId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
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