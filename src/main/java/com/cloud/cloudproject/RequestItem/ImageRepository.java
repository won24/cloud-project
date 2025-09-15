package com.cloud.cloudproject.RequestItem;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface ImageRepository extends JpaRepository<ImageDTO, Long> {

    // postId로 이미지 목록 조회
    List<ImageDTO> findByPostId(Long postId);

    // 특정 이미지 삭제
    @Modifying
    @Transactional
    @Query("DELETE FROM ImageDTO i WHERE i.postId = :postId AND i.imageUrl = :imageUrl")
    int deleteByPostIdAndImageUrl(@Param("postId") Long postId, @Param("imageUrl") String imageUrl);

    // postId로 모든 이미지 삭제
    @Modifying
    @Transactional
    void deleteByPostId(Long postId);
}
