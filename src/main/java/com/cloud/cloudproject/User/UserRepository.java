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

    // 이름, 전화번호로 아이디 찾기
    @Query("SELECT u.id FROM UserDTO u WHERE u.name = :name AND u.phone = :phone")
    Optional<String> findIdByNameAndPhone(@Param("name") String name, @Param("phone") String phone);

    // 이름, 이메일로 아이디 찾기
    @Query("SELECT u.id FROM UserDTO u WHERE u.name = :name AND u.email = :email")
    Optional<String> findIdByNameAndEmail(@Param("name") String name, @Param("email") String email);

    // 아이디, 이름, 전화번호로 비밀번호 재설정 시도
    boolean existsByIdAndNameAndPhone(@Param("id") String id, @Param("name") String name, @Param("phone") String phone);

    // 아이디, 이름, 이메일로 비밀번호 재설정 시도
    boolean existsByIdAndNameAndEmail(@Param("id") String id, @Param("name") String name, @Param("email") String email);

    UserDTO findById(String id);
}
