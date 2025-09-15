//package com.cloud.cloudproject.Auction;
//
//import lombok.*;
//import java.util.Date;
//
//
//@Setter
//@Getter
//@ToString
//@AllArgsConstructor
//@NoArgsConstructor
//public class AuctionDTO {
//
//    private int postId;
//    private String title;
//    private String categoryCode;
//    private String content;
//    private Date createdAt;
//    private String postStatus;
//    private Date startDay;
//    private Date endDay;
//    private int userCode;
//    private int startCash;
//    private int finalCash;
//    private boolean usePost;
//
//}


package com.cloud.cloudproject.Auction;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "board")
@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class AuctionDTO {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "postId")
    private Long postId;

    @Column(nullable = false)
    private String title;

    @Column(name = "categoryCode")
    private String categoryCode;

    @Column(columnDefinition = "TEXT")
    private String content;

    @Column(name = "createdAt")
    private LocalDateTime createdAt;

    @Column(name = "postStatus")
    private String postStatus;

    @Column(name = "startDAY")
    private LocalDateTime startDay;

    @Column(name = "endDAY")
    private LocalDateTime endDay;

    @Column(name = "userCode")
    private Integer userCode;

    @Column(name = "startCash")
    private Integer startCash;

    @Column(name = "finalCash")
    private Integer finalCash;

    @Column(name = "usePost")
    private Boolean usePost = true;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        if (usePost == null) {
            usePost = true;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        // 업데이트 시 로직 필요시 추가
    }
}
