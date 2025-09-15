package com.cloud.cloudproject.RequestItem;

import lombok.*;
import java.util.Date;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class RequestItemDTO {
    private Long postId;  // int → Long 변경
    private String title;
    private String content;
    private Date date;
    private String categoryCode;
    private Integer userCode;  // int → Integer 변경 (null 허용)
    private Integer startCash;  // int → Integer 변경 (null 허용)
}
