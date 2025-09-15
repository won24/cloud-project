package com.cloud.cloudproject.RequestItem;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class ImageService {

    private final ImageRepository imageRepository;

    @Autowired
    public ImageService(ImageRepository imageRepository) {
        this.imageRepository = imageRepository;
    }

    // 여러 이미지 URL 저장
    public void addImages(Long postId, List<String> imageUrls) {
        for (String imageUrl : imageUrls) {
            ImageDTO image = new ImageDTO(postId, imageUrl);
            imageRepository.save(image);
        }
    }

    @Transactional(readOnly = true)
    public List<ImageDTO> getImageByPostId(Long postId) {
        return imageRepository.findByPostId(postId);
    }

    public boolean deleteImg(String imageUrl, Long postId) {
        int result = imageRepository.deleteByPostIdAndImageUrl(postId, imageUrl);
        return result > 0;
    }

    public void addImageUrl(Long postId, String imageUrl) {
        ImageDTO image = new ImageDTO(postId, imageUrl);
        imageRepository.save(image);
    }

    // postId의 모든 이미지 삭제
    public void deleteAllByPostId(Long postId) {
        imageRepository.deleteByPostId(postId);
    }
}
