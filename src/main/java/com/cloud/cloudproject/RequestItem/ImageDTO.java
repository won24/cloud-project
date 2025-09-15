//package com.cloud.cloudproject.RequestItem;
//
//import lombok.Getter;
//import lombok.Setter;
//
//@Setter
//@Getter
//public class ImageDTO {
//
//    private int postId;
//    private String imageUrl;
//
//
//    public ImageDTO() {
//    }
//
//    public ImageDTO(int postId, String imageUrl) {
//        this.postId = postId;
//        this.imageUrl = imageUrl;
//    }
//
//    @Override
//    public String toString() {
//        return "ImageDTO{" +
//                "postId=" + postId +
//                ", imageUrl='" + imageUrl + '\'' +
//                '}';
//    }
//}

package com.cloud.cloudproject.RequestItem;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "imageurl")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class ImageDTO {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "postId", nullable = false)
    private Long postId;

    @Column(name = "imageUrl", nullable = false, length = 500)
    private String imageUrl;

    // 편의 생성자
    public ImageDTO(Long postId, String imageUrl) {
        this.postId = postId;
        this.imageUrl = imageUrl;
    }
}
