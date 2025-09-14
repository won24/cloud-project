package com.cloud.cloudproject.User;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class PasswordUpdateRequest
{
    private String id;
    private String password;
    private String name;
    private String email;
}
