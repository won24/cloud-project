package com.cloud.cloudproject.RequestItem;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class RequestItemService {

    private final RequestItemRepository requestItemRepository;

    @Autowired
    public RequestItemService(RequestItemRepository requestItemRepository) {
        this.requestItemRepository = requestItemRepository;
    }

    public Long saveAll(RequestItem requestItem) {
        RequestItem savedItem = requestItemRepository.save(requestItem);
        return savedItem.getPostId();
    }

    @Transactional(readOnly = true)
    public RequestItem findById(Long postId) {
        return requestItemRepository.findById(postId).orElse(null);
    }

    public RequestItem update(RequestItem requestItem) {
        return requestItemRepository.save(requestItem);
    }

    public void delete(Long postId) {
        requestItemRepository.deleteById(postId);
    }
}
