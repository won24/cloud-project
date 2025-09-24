package com.cloud.cloudproject.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api")
public class UserController
{
    @Autowired
    private static UserRepository userRepository;

    private final UserService userService;

    @Autowired
    public UserController(UserService userService)
    {
        this.userService = userService;
    }

    @GetMapping("/check-id")
    public ResponseEntity<Boolean> checkId(@RequestParam(required = false)String id)
    {
        boolean isDuplicate = userRepository.existsById(id);
        return ResponseEntity.ok(isDuplicate);
    }

    @GetMapping("/check-nickname")
    public ResponseEntity<Boolean> checkNickname(@RequestParam(required = false)String nickname)
    {
        boolean isDuplicate = userRepository.existsByNickname(nickname);
        return ResponseEntity.ok(isDuplicate);
    }


    @GetMapping("/id/{userId}")
    public ResponseEntity<UserDTO> getUserById(@PathVariable String userId)
    {
        return userService.getUserById(userId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}
