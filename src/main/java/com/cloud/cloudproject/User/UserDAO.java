package com.cloud.cloudproject.User;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface UserDAO
{
    List<UserDTO> selectAllUsers();
}