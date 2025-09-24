package com.cloud.cloudproject.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Optional;

@Service
public class UserService
{
    private final UserRepository userRepository;

    @Autowired
    public UserService(UserRepository userRepository)
    {
        this.userRepository = userRepository;
    }

    public Optional<UserDTO> getUserById(String userId)
    {
        return Optional.ofNullable(userRepository.findById(userId));
    }

    public UserDTO validateLogin(String id, String password)
    {
        UserDTO user = userRepository.findByIdAndPassword(id, password)
                .orElseThrow(() -> new RuntimeException("Invalid credentials"));

        // Map User entity to UserDTO
        UserDTO userDTO = new UserDTO();
        userDTO.setUserCode(user.getUserCode());
        userDTO.setId(user.getId());
        userDTO.setName(user.getName());
        userDTO.setEmail(user.getEmail());
        userDTO.setPhone(user.getPhone());
        userDTO.setAddress(user.getAddress());
        userDTO.setBirth(user.getBirth());
        userDTO.setNickname(user.getNickname());
        userDTO.setSendEmail(user.isSendEmail());
        userDTO.setSendMessage(user.isSendMessage());
        userDTO.setCash(user.getCash());
        userDTO.setIsAdmin(user.getIsAdmin());
        userDTO.setIsAdult(user.getIsAdult());
        userDTO.setIsSuspended(user.getIsSuspended());
        return userDTO;
    }

}