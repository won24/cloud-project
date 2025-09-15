package com.cloud.cloudproject.Auction;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface AuctionRepository extends JpaRepository<AuctionDTO, Long> {

    // 기본 조회 (usePost = true인 것만)
    List<AuctionDTO> findByUsePostTrue();

    // 카테고리별 조회
    List<AuctionDTO> findByCategoryCodeAndUsePostTrue(String categoryCode);

    // 상세 조회
    Optional<AuctionDTO> findByPostIdAndUsePostTrue(Long postId);

    // 검색 조회 (카테고리별)
    @Query("SELECT a FROM AuctionDTO a WHERE a.title LIKE %:keyword% AND a.categoryCode = :categoryCode AND a.usePost = true")
    List<AuctionDTO> findByTitleContainingAndCategoryCode(@Param("keyword") String keyword, @Param("categoryCode") String categoryCode);

    // 검색 조회 (전체 카테고리)
    @Query("SELECT a FROM AuctionDTO a WHERE a.title LIKE %:keyword% AND a.usePost = true")
    List<AuctionDTO> findByTitleContainingAndUsePostTrue(@Param("keyword") String keyword);

    // 라이브 경매 목록
    @Query("SELECT a FROM AuctionDTO a WHERE a.postStatus = 'on' AND a.usePost = true")
    List<AuctionDTO> findLiveAuctions();

    // 게시글 논리적 삭제
    @Modifying
    @Transactional
    @Query("UPDATE AuctionDTO a SET a.usePost = false WHERE a.postId = :postId")
    int softDeleteByPostId(@Param("postId") Long postId);

    // 게시글 승인 (상태 변경)
    @Modifying
    @Transactional
    @Query("UPDATE AuctionDTO a SET a.postStatus = 'off' WHERE a.postId = :postId")
    int approveAuction(@Param("postId") Long postId);

    // 라이브 경매 시작 (off -> on)
    @Modifying
    @Transactional
    @Query("UPDATE AuctionDTO a SET a.postStatus = 'on' WHERE a.postId = :postId")
    int startLiveAuction(@Param("postId") Long postId);

    // 라이브 경매 종료 (on -> done)
    @Modifying
    @Transactional
    @Query("UPDATE AuctionDTO a SET a.postStatus = 'done' WHERE a.postId = :postId")
    int endLiveAuction(@Param("postId") Long postId);

    // 라이브 경매 후 정보 업데이트
    @Modifying
    @Transactional
    @Query("UPDATE AuctionDTO a SET a.finalCash = :finalCash, a.endDay = :endDay WHERE a.postId = :postId")
    int updateAuctionAfterLive(@Param("postId") Long postId, @Param("finalCash") Integer finalCash, @Param("endDay") java.time.LocalDateTime endDay);
}
