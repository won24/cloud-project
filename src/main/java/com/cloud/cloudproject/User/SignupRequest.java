package com.cloud.cloudproject.User;

import lombok.Data;
import java.time.LocalDate;

@Data
public class SignupRequest
{
    private String id;
    private String password;
    private String confirmPassword;
    private String name;
    private String email;
    private String phone;
    private String address;
    private LocalDate birth;
    private String nickname;
    private MarketingPreferences marketingPreferences;

    @Data
    public static class MarketingPreferences
    {
        private boolean sendEmail;
        private boolean sendMessage;
    }
}