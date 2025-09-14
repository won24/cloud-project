package com.cloud.cloudproject.Auction;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AuctionService {

    private final AuctionDAO auctionDAO;

    @Autowired
    public AuctionService(AuctionDAO auctionDAO) {
        this.auctionDAO = auctionDAO;
    }


    public List<AuctionDTO> getAllList() {
        return auctionDAO.selectAllAuction();
    }

    public List<AuctionDTO> getAntiqueList() {
        return auctionDAO.antiqueList();
    }

    public List<AuctionDTO> getLimitedList() {
        return auctionDAO.limitedList();
    }

    public List<AuctionDTO> getDiscontinuationList() {
        return auctionDAO.discontinuationList();
    }

    public List<AuctionDTO> getArtProductList() {
        return auctionDAO.artProductList();
    }

    public List<AuctionDTO> getValuablesList() {
        return auctionDAO.valuablesList();
    }


    public AuctionDTO detail(int postId) {
        AuctionDTO auctionDTO = auctionDAO.selectAuctionDetail(postId);
        return auctionDTO;
    }

    public List<AuctionDTO> searchItems(String q, String categoryCode) {
        return auctionDAO.selectSearchItems(q, categoryCode);
    }

    public List<AuctionDTO> searchItemAllCategory(String decodedQ) {
        return auctionDAO.selectSearchItemsAllCategory(decodedQ);
    }


    public int update(AuctionDTO auctionDTO) {
        int result = auctionDAO.update(auctionDTO);
        return result;
    }

    public int notUsePost(int postId) {
        int result = auctionDAO.notUsePost(postId);
        return result;
    }

    public int approval(int postId) {
        int result = auctionDAO.approval(postId);
        return result;
    }

    public List<AuctionDTO> getLiveList() {
        return auctionDAO.getLiveList();
    }

    public int setPostStatus(int postId) {
        int result = auctionDAO.setPostStatus(postId);
        return result;
    }

    public int updateLivePost(int postId) {
        int result = auctionDAO.updateLivePost(postId);
        return result;
    }

    public int updatePostAfterLive(AuctionDTO auctionDTO) {
        int result = auctionDAO.updatePostAfterLive(auctionDTO);
        return result;
    }
}