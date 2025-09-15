package com.cloud.cloudproject.RequestItem;

import lombok.*;

import java.util.Date;


@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class RequestItemDTO {
    private int postId;
    private String title;
    private String content;
    private Date date;
    private String categoryCode;
    private int userCode;
    private int startCash;

}