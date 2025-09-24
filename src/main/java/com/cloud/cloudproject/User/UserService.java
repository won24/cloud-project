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

    public boolean checkIfIdExists(String id) {
        return userRepository.existsById(id);
    }

//    public void registerUser(SignupRequest signupRequest)
//    {
//        UserDTO user = new UserDTO();
//        user.setId(signupRequest.getId());
//        user.setPassword(signupRequest.getPassword());
//        user.setName(signupRequest.getName());
//        user.setEmail(signupRequest.getEmail());
//        user.setPhone(signupRequest.getPhone());
//        user.setAddress(signupRequest.getAddress());
//        user.setBirth(signupRequest.getBirth());
//        user.setNickname(signupRequest.getNickname());
//        user.setSendEmail(signupRequest.getMarketingPreferences().isSendEmail());
//        user.setSendMessage(signupRequest.getMarketingPreferences().isSendMessage());
//        user.setCash(0);
//        user.setIsAdmin(false);
//
//        LocalDate today = LocalDate.now();
//        LocalDate checkAdult = LocalDate.of(today.getYear() - 19, today.getMonth(), today.getDayOfMonth());
//
//        user.setIsAdult(isDateValid(signupRequest.getBirth(), checkAdult));
//        userRepository.save(user);
//    }

    // Pass API를 못쓰니까 성인인증도 양심에 맡기는 걸로 하자
    public static boolean isDateValid(LocalDate userInputDate, LocalDate specificDate)
    {
        return !userInputDate.isBefore(specificDate);
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

    public Optional<String> findIdByNameAndPhone(String name, String phone)
    {
        return userRepository.findIdByNameAndPhone(name, phone);
    }

    public Optional<String> findIdByNameAndEmail(String name, String email)
    {
        return userRepository.findIdByNameAndEmail(name, email);
    }

    public boolean existsByIdAndNameAndPhone(String id, String name, String phone)
    {
        return userRepository.existsByIdAndNameAndPhone(id, name, phone);
    }

    public boolean existsByIdAndNameAndEmail(String id, String name, String email)
    {
        return userRepository.existsByIdAndNameAndEmail(id, name, email);
    }

    public void updatePassword(PasswordUpdateRequest request) throws UserNotFoundException
    {
        // Find user by id (not primary key) and name
        UserDTO user = userRepository.findById(request.getId());

        // Update the user's password
        user.setPassword(request.getPassword());

        userRepository.save(user);
    }
}