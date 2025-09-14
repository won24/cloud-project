package com.cloud.cloudproject.RequestItem;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface ImageMapper  {

    @Insert("INSERT INTO imageurl (postId, imageUrl) VALUES (#{postId}, #{imageUrl})")
    void insertImage(ImageDTO imageDTO);

    @Select("SELECT * FROM imageurl WHERE postId = #{postId}")
    List<ImageDTO> selectImageByPostId(int postId);

    @Delete("DELETE FROM imageurl WHERE postId = #{postId} AND imageUrl = #{imageUrl}")
    int delete(String imageUrl, int postId);

    void saveImageUrl(int postId, String imageUrl);
}