package com.cloud.cloudproject.RequestItem;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller  // @RestController에서 변경
@RequestMapping("/requestitem")
public class RequestItemController {

    private final RequestItemService requestItemService;

    @Autowired
    public RequestItemController(RequestItemService requestItemService) {
        this.requestItemService = requestItemService;
    }

    // JSP 페이지 반환 (새로 추가)
    @GetMapping("")
    public String requestItemPage(Model model, HttpSession session) {
        // 로그인 체크
        Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
        if (isLoggedIn == null || !isLoggedIn) {
            return "redirect:/member/login";
        }

        model.addAttribute("title", "경매품 신청");
        model.addAttribute("contentPage", "../requestitem/write.jsp");
        return "common/layout";
    }

    // 기존 REST API 유지 (JSP에서 AJAX로 호출)
    @PostMapping("")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> requestItem(@RequestBody RequestItemDTO requestItemDTO) {
        System.out.println(requestItemDTO + "첫번째 리퀘스트바디");
        int postId = requestItemService.saveAll(requestItemDTO);

        Map<String, Object> response = new HashMap<>();
        response.put("postId", postId);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    // 성공 페이지
    @GetMapping("/success")
    public String successPage(Model model) {
        model.addAttribute("title", "신청 완료");
        model.addAttribute("contentPage", "../requestitem/success.jsp");
        return "common/layout";
    }
}
