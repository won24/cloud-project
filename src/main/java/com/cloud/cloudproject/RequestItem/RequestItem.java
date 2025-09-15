package com.cloud.cloudproject.RequestItem;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "board")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RequestItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "postId")
    private Long postId;

    @Column(name = "Title", nullable = false)
    private String title;

    @Column(name = "Content", columnDefinition = "TEXT")
    private String content;

    @Column(name = "StartDAY")
    private LocalDateTime date;

    @Column(name = "categoryCode")
    private String categoryCode;

    @Column(name = "userCode")
    private Integer userCode;

    @Column(name = "startCash")
    private Integer startCash;

    // 기본값 설정
    @Column(name = "postStatus")
    private String postStatus = "wait"; // 신청 상태

    @Column(name = "usePost")
    private Boolean usePost = true;

    @Column(name = "createdAt")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        if (usePost == null) {
            usePost = true;
        }
        if (postStatus == null) {
            postStatus = "wait";
        }
    }
}
