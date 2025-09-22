package com.cloud.cloudproject.User;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/member")
public class LoginController {

    @Autowired
    private UserService userService;

    // 로그인 페이지 표시
    @GetMapping("/login")
    public String loginPage(Model model, HttpSession session) {
        // 이미 로그인된 경우 메인 페이지로 리다이렉트
        if (session.getAttribute("isLoggedIn") != null &&
                (Boolean) session.getAttribute("isLoggedIn")) {
            return "redirect:/";
        }

        model.addAttribute("title", "로그인");
        model.addAttribute("contentPage", "../member/login.jsp");
        return "common/layout";
    }

    // 로그인 처리
    @PostMapping("/login")
    public String login(@RequestParam String id,
                        @RequestParam String password,
                        @RequestParam(required = false) String rememberMe,
                        HttpSession session,
                        HttpServletResponse response,
                        RedirectAttributes redirectAttributes) {
        try {
            UserDTO user = userService.validateLogin(id, password);
            if (user != null) {
                // 세션에 사용자 정보 저장
                session.setAttribute("isLoggedIn", true);
                session.setAttribute("userCode", user.getUserCode());
                session.setAttribute("id", user.getId());
                session.setAttribute("name", user.getName());
                session.setAttribute("nickname", user.getNickname());
                session.setAttribute("email", user.getEmail());
                session.setAttribute("phone", user.getPhone());
                session.setAttribute("birth", user.getBirth());
                session.setAttribute("address", user.getAddress());
                session.setAttribute("cash", user.getCash());
                session.setAttribute("isAdult", user.getIsAdult());
                session.setAttribute("isAdmin", user.getIsAdmin());
                session.setAttribute("isSuspended", user.getIsSuspended());
                session.setAttribute("sendEmail", user.isSendEmail());
                session.setAttribute("sendMessage", user.isSendMessage());

                // 아이디 저장 쿠키 처리
                if ("on".equals(rememberMe)) {
                    Cookie cookie = new Cookie("rememberId", id);
                    cookie.setMaxAge(30 * 24 * 60 * 60); // 30일
                    cookie.setPath("/");
                    response.addCookie(cookie);
                } else {
                    Cookie cookie = new Cookie("rememberId", "");
                    cookie.setMaxAge(0);
                    cookie.setPath("/");
                    response.addCookie(cookie);
                }

                return "redirect:/";
            } else {
                redirectAttributes.addFlashAttribute("loginError", "아이디 또는 비밀번호가 일치하지 않습니다.");
                return "redirect:/member/login";
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("loginError", "로그인 중 오류가 발생했습니다.");
            return "redirect:/member/login";
        }
    }

    // 로그아웃 처리
    @PostMapping("/logout")
    @ResponseBody
    public ResponseEntity<String> logout(HttpSession session) {
        session.invalidate();
        return ResponseEntity.ok("로그아웃 되었습니다.");
    }

    // REST API는 기존과 동일하게 유지 (AJAX 요청용)
    @PostMapping("/api/auth/login")
    @ResponseBody
    public ResponseEntity<?> apiLogin(@RequestBody LoginRequest request, HttpSession session) {
        // 기존 REST API 로직 유지 (AJAX용)
        UserDTO user = userService.validateLogin(request.getId(), request.getPassword());
        if (user != null) {
            Map<String, Object> response = new HashMap<>();
            response.put("userCode", user.getUserCode());
            response.put("id", user.getId());
            response.put("name", user.getName());
            response.put("nickname", user.getNickname());
            response.put("email", user.getEmail());
            response.put("phone", user.getPhone());
            response.put("birth", user.getBirth());
            response.put("address", user.getAddress());
            response.put("cash", user.getCash());
            response.put("isAdult", user.getIsAdult());
            response.put("isAdmin", user.getIsAdmin());
            response.put("isSuspended", user.getIsSuspended());
            response.put("sendEmail", user.isSendEmail());
            response.put("sendMessage", user.isSendMessage());

            // 세션에도 저장
            session.setAttribute("isLoggedIn", true);
            // ... 기타 세션 정보 저장

            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid credentials");
        }
    }

    @GetMapping("/member/signup")
    public String signupView() {
        return "signup/signup"; // WEB-INF/views/signup/signup.jsp 반환
    }

}
