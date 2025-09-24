package com.cloud.cloudproject.User;

import org.apache.ibatis.annotations.Param;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<UserDTO, Integer>
{
    // 아이디 중복 검사
    boolean existsById(String id);

    // 닉네임 중복 검사
    boolean existsByNickname(String nickname);

    // 로그인
    Optional<UserDTO> findByIdAndPassword(String id, String password);

    UserDTO findById(String id);
}
