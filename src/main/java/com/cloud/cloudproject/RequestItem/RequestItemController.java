package com.cloud.cloudproject.RequestItem;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/requestitem")
public class RequestItemController {

    private final RequestItemService requestItemService;

    @Autowired
    public RequestItemController(RequestItemService requestItemService) {
        this.requestItemService = requestItemService;
    }

    // JSP 페이지 반환
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

    // REST API - Entity 사용
    @PostMapping("")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> requestItem(@RequestBody RequestItemDTO requestItemDTO) {
        System.out.println(requestItemDTO + "첫번째 리퀘스트바디");

        // DTO를 Entity로 변환
        RequestItem requestItem = new RequestItem();
        requestItem.setTitle(requestItemDTO.getTitle());
        requestItem.setContent(requestItemDTO.getContent());
        requestItem.setDate(requestItemDTO.getDate() != null ?
                requestItemDTO.getDate().toInstant().atZone(java.time.ZoneId.systemDefault()).toLocalDateTime() :
                LocalDateTime.now());
        requestItem.setCategoryCode(requestItemDTO.getCategoryCode());
        requestItem.setUserCode(requestItemDTO.getUserCode());
        requestItem.setStartCash(requestItemDTO.getStartCash());

        Long postId = requestItemService.saveAll(requestItem);

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

    // 추가 API - 상세 조회
    @GetMapping("/{postId}")
    @ResponseBody
    public ResponseEntity<RequestItem> getRequestItem(@PathVariable Long postId) {
        RequestItem requestItem = requestItemService.findById(postId);
        if (requestItem != null) {
            return ResponseEntity.ok(requestItem);
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}
