package com.cloud.cloudproject.Auction;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class AuctionService {

    private final AuctionRepository auctionRepository;

    @Autowired
    public AuctionService(AuctionRepository auctionRepository) {
        this.auctionRepository = auctionRepository;
    }


    public List<AuctionDTO> getAllList() {
        return auctionRepository.findByUsePostTrue();
    }

    public List<AuctionDTO> getAntiqueList() {
        return auctionRepository.findByCategoryCodeAndUsePostTrue("a");
    }

    public List<AuctionDTO> getLimitedList() {
        return auctionRepository.findByCategoryCodeAndUsePostTrue("l");
    }

    public List<AuctionDTO> getDiscontinuationList() {
        return auctionRepository.findByCategoryCodeAndUsePostTrue("d");
    }

    public List<AuctionDTO> getArtProductList() {
        return auctionRepository.findByCategoryCodeAndUsePostTrue("ap");
    }

    public List<AuctionDTO> getValuablesList() {
        return auctionRepository.findByCategoryCodeAndUsePostTrue("v");
    }


    @Transactional(readOnly = true)
    public AuctionDTO detail(Long postId) {
        Optional<AuctionDTO> auction = auctionRepository.findByPostIdAndUsePostTrue(postId);
        return auction.orElse(null);
    }

    @Transactional(readOnly = true)
    public List<AuctionDTO> searchItems(String keyword, String categoryCode) {
        return auctionRepository.findByTitleContainingAndCategoryCode(keyword, categoryCode);
    }

    @Transactional(readOnly = true)
    public List<AuctionDTO> searchItemAllCategory(String keyword) {
        return auctionRepository.findByTitleContainingAndUsePostTrue(keyword);
    }

    public AuctionDTO update(AuctionDTO auction) {
        return auctionRepository.save(auction);
    }

    public boolean notUsePost(Long postId) {
        int result = auctionRepository.softDeleteByPostId(postId);
        return result > 0;
    }

    public boolean approval(Long postId) {
        int result = auctionRepository.approveAuction(postId);
        return result > 0;
    }

    @Transactional(readOnly = true)
    public List<AuctionDTO> getLiveList() {
        return auctionRepository.findLiveAuctions();
    }

    public boolean setPostStatus(Long postId) {
        int result = auctionRepository.endLiveAuction(postId);
        return result > 0;
    }

    public boolean updateLivePost(Long postId) {
        int result = auctionRepository.startLiveAuction(postId);
        return result > 0;
    }

    public boolean updatePostAfterLive(Long postId, Integer finalCash, LocalDateTime endDay) {
        int result = auctionRepository.updateAuctionAfterLive(postId, finalCash, endDay);
        return result > 0;
    }
}