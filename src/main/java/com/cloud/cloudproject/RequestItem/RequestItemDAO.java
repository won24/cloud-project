package com.cloud.cloudproject.RequestItem;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface RequestItemDAO {

    int insertRequestItem(RequestItemDTO requestItemDTO);

}