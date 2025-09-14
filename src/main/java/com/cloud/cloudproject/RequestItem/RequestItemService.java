package com.cloud.cloudproject.RequestItem;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class RequestItemService {
    private final RequestItemDAO requestItemDAO;

    @Autowired
    public RequestItemService(RequestItemDAO requestItemDAO) {
        this.requestItemDAO = requestItemDAO;
    }

    @Transactional
    public int saveAll(RequestItemDTO requestItemDTO) {
        requestItemDAO.insertRequestItem(requestItemDTO);
        return requestItemDTO.getPostId();
    }
}