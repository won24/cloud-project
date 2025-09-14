package com.cloud.cloudproject.Auction;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;


@Mapper
public interface AuctionDAO {

    List<AuctionDTO> selectAllAuction();

    List<AuctionDTO> antiqueList();

    List<AuctionDTO> limitedList();

    List<AuctionDTO> discontinuationList();

    List<AuctionDTO> artProductList();

    List<AuctionDTO> valuablesList();

    AuctionDTO selectAuctionDetail(int postId);

    List<AuctionDTO> selectSearchItems(String q, String categoryCode);

    List<AuctionDTO> selectSearchItemsAllCategory(String decodedQ);

    int update(AuctionDTO auctionDTO);

    int notUsePost(int postId);

    int approval(int postId);

    List<AuctionDTO> getLiveList();

    int setPostStatus(int postId);

    int updateLivePost(int postId);

    int updatePostAfterLive(AuctionDTO auctionDTO);
}