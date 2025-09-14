package com.cloud.cloudproject.User;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Data  // getter/setter 자동 생성
@NoArgsConstructor
@AllArgsConstructor
public class UserDTO {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int userCode;

    private String id;
    private String password;
    private String name;
    private String nickname;
    private LocalDate birth;
    private String email;
    private String phone;
    private String address;
    private int cash;
    private Boolean isAdult;
    private Boolean isAdmin;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime isSuspended = null;

    private boolean sendEmail;
    private boolean sendMessage;
}
