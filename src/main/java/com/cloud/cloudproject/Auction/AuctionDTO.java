package com.cloud.cloudproject.Auction;

import lombok.*;
import java.util.Date;


@ToString
@AllArgsConstructor
@NoArgsConstructor
public class AuctionDTO {

    private int postId;
    private String title;
    private String categoryCode;
    private String content;
    private Date createdAt;
    private String postStatus;
    private Date startDay;
    private Date endDay;
    private int userCode;
    private int startCash;
    private int finalCash;
    private boolean usePost;

    public int getPostId() {
        return postId;
    }

    public void setPostId(int postId) {
        this.postId = postId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCategoryCode() {
        return categoryCode;
    }

    public void setCategoryCode(String categoryCode) {
        this.categoryCode = categoryCode;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getPostStatus() {
        return postStatus;
    }

    public void setPostStatus(String postStatus) {
        this.postStatus = postStatus;
    }

    public Date getStartDay() {
        return startDay;
    }

    public void setStartDay(Date startDay) {
        this.startDay = startDay;
    }

    public Date getEndDay() {
        return endDay;
    }

    public void setEndDay(Date endDay) {
        this.endDay = endDay;
    }

    public int getUserCode() {
        return userCode;
    }

    public void setUserCode(int userCode) {
        this.userCode = userCode;
    }

    public int getStartCash() {
        return startCash;
    }

    public void setStartCash(int startCash) {
        this.startCash = startCash;
    }

    public int getFinalCash() {
        return finalCash;
    }

    public void setFinalCash(int finalCash) {
        this.finalCash = finalCash;
    }

    public boolean isUsePost() {
        return usePost;
    }

    public void setUsePost(boolean usePost) {
        this.usePost = usePost;
    }
}