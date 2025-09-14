package com.cloud.cloudproject.User;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/finder/pw")
public class PasswordController
{
    private final UserService userService;

    public PasswordController(UserService userService)
    {
        this.userService = userService;
    }

    @PostMapping("/update")
    public ResponseEntity<String> updatePassword(@RequestBody PasswordUpdateRequest request)
    {
        try {
            userService.updatePassword(request);
            return ResponseEntity.ok("Password updated successfully.");
        } catch (UserNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to update password.");
        }
    }
}