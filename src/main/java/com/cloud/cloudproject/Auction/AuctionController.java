package com.cloud.cloudproject.Auction;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/auction")
public class AuctionController {

    private final AuctionService auctionService;
    private static final Logger logger = LoggerFactory.getLogger(AuctionController.class);

    public AuctionController(AuctionService auctionService) {
        this.auctionService = auctionService;
    }

    // 전체 목록 페이지
    @GetMapping("")
    public String auctionList(@RequestParam(defaultValue = "1") int page,
                              @RequestParam(required = false) String q,
                              @RequestParam(required = false) String categoryCode,
                              @RequestParam(defaultValue = "on,off,done") String status,
                              Model model) {

        int itemsPerPage = 20;
        List<AuctionDTO> allItems;

        // 검색 또는 카테고리 필터링
        if (q != null && !q.isEmpty()) {
            if (categoryCode != null && !categoryCode.isEmpty()) {
                allItems = auctionService.searchItems(q, categoryCode);
            } else {
                allItems = auctionService.searchItemAllCategory(q);
            }
            model.addAttribute("searchKeyword", q);
        } else if (categoryCode != null) {
            allItems = getCategoryItems(categoryCode);
        } else {
            allItems = auctionService.getAllList();
        }

        // 상태별 필터링
        String[] statusArray = status.split(",");
        List<String> statusList = Arrays.asList(statusArray);
        List<AuctionDTO> filteredItems = allItems.stream()
                .filter(item -> statusList.contains(item.getPostStatus()))
                .sorted((a, b) -> {
                    List<String> order = Arrays.asList("on", "off", "done");
                    return Integer.compare(order.indexOf(a.getPostStatus()),
                            order.indexOf(b.getPostStatus()));
                })
                .collect(Collectors.toList());

        // 페이징 처리
        int totalItems = filteredItems.size();
        int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
        int startIndex = (page - 1) * itemsPerPage;
        int endIndex = Math.min(startIndex + itemsPerPage, totalItems);

        List<AuctionDTO> paginatedItems = filteredItems.subList(startIndex, endIndex);

        model.addAttribute("auctionList", paginatedItems);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalItems", totalItems);
        model.addAttribute("categoryCode", categoryCode);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("title", "경매 목록");
        model.addAttribute("contentPage", "../auction/list.jsp");

        return "common/layout";
    }

    // 카테고리별 목록 페이지
    @GetMapping("/{category}")
    public String categoryList(@PathVariable String category,
                               @RequestParam(defaultValue = "1") int page,
                               @RequestParam(required = false) String q,
                               @RequestParam(defaultValue = "on,off,done") String status,
                               Model model) {

        // 숫자인 경우 상세 페이지로 처리
        if (category.matches("\\d+")) {
            return auctionDetail(Long.parseLong(category), model);
        }

        model.addAttribute("categoryCode", category);
        return auctionList(page, q, category, status, model);
    }

    // 상세 페이지
    @GetMapping("/{postId:[0-9]+}")
    public String auctionDetail(@PathVariable Long postId, Model model) {
        AuctionDTO auction = auctionService.detail(postId);

        if (auction == null) {
            model.addAttribute("errorMessage", "존재하지 않는 경매품입니다.");
            return "error/404";
        }

        model.addAttribute("auction", auction);
        model.addAttribute("postId", postId);
        model.addAttribute("title", auction.getTitle());
        model.addAttribute("contentPage", "../auction/detail.jsp");

        return "common/layout";
    }

    // 카테고리별 아이템 가져오기
    private List<AuctionDTO> getCategoryItems(String categoryCode) {
        switch (categoryCode) {
            case "antique": return auctionService.getAntiqueList();
            case "limited": return auctionService.getLimitedList();
            case "discontinuation": return auctionService.getDiscontinuationList();
            case "artproduct": return auctionService.getArtProductList();
            case "valuables": return auctionService.getValuablesList();
            default: return auctionService.getAllList();
        }
    }

    // REST API 메소드들
    @GetMapping("/api/all")
    @ResponseBody
    public ResponseEntity<List<AuctionDTO>> getAllList() {
        List<AuctionDTO> auctionList = auctionService.getAllList();
        return ResponseEntity.ok(auctionList);
    }

    @GetMapping("/api/{postId}")
    @ResponseBody
    public ResponseEntity<?> getAuctionDetail(@PathVariable Long postId) {
        AuctionDTO auction = auctionService.detail(postId);

        if (auction == null) {
            AuctionDTO emptyAuction = new AuctionDTO();
            emptyAuction.setTitle("데이터 없음");
            return new ResponseEntity<>(emptyAuction, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(auction, HttpStatus.OK);
        }
    }

    @GetMapping("/search")
    @ResponseBody
    public ResponseEntity<List<AuctionDTO>> searchItems(@RequestParam(required = false) String q,
                                                     @RequestParam(required = false) String categoryCode) {
        if (q == null || q.isEmpty()) {
            return ResponseEntity.badRequest().body(Collections.emptyList());
        }
        String decodedQ = URLDecoder.decode(q, StandardCharsets.UTF_8);
        List<AuctionDTO> items = auctionService.searchItems(decodedQ, categoryCode);
        return ResponseEntity.ok(items);
    }

    @GetMapping("/searchitem")
    @ResponseBody
    public ResponseEntity<List<AuctionDTO>> searchItemAllCategory(@RequestParam(required = false) String q) {
        if (q == null || q.isEmpty()) {
            return ResponseEntity.badRequest().body(Collections.emptyList());
        }
        String decodedQ = URLDecoder.decode(q, StandardCharsets.UTF_8);
        List<AuctionDTO> items = auctionService.searchItemAllCategory(decodedQ);
        return ResponseEntity.ok(items);
    }

    @PutMapping("/update")
    @ResponseBody
    public ResponseEntity<?> updatePost(@RequestBody AuctionDTO auction) {
        try {
            AuctionDTO result = auctionService.update(auction);
            if (result != null) {
                return ResponseEntity.ok(result);
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("게시글 수정 실패");
            }
        } catch (Exception e) {
            logger.error("게시글 수정 중 에러 발생: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/delete/{postId}")
    @ResponseBody
    public ResponseEntity<?> notUsePost(@PathVariable Long postId) {
        try {
            boolean result = auctionService.notUsePost(postId);
            if (result) {
                return ResponseEntity.noContent().build();
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("게시글 삭제 실패");
            }
        } catch (Exception e) {
            logger.error("게시글 삭제 중 에러 발생: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/approval/{postId}")
    @ResponseBody
    public ResponseEntity<?> approval(@PathVariable Long postId) {
        try {
            boolean result = auctionService.approval(postId);
            if (result) {
                return ResponseEntity.noContent().build();
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("게시글 승인 실패");
            }
        } catch (Exception e) {
            logger.error("게시글 승인 중 에러 발생: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/endlive/{postId}")
    @ResponseBody
    public ResponseEntity<?> setPostStatus(@PathVariable Long postId) {
        try {
            boolean result = auctionService.setPostStatus(postId);
            if (result) {
                return ResponseEntity.noContent().build();
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("라이브 후 게시글 상태 변경 실패");
            }
        } catch (Exception e) {
            logger.error("게시글 상태 on-> done 변경 중 에러 발생: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/startlive/{postId}")
    @ResponseBody
    public ResponseEntity<?> updateLivePost(@PathVariable Long postId) {
        try {
            boolean result = auctionService.updateLivePost(postId);
            if (result) {
                return ResponseEntity.noContent().build();
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("라이브 상태로 변경 실패");
            }
        } catch (Exception e) {
            logger.error("게시글 상태 off-> on 변경 중 에러 발생: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/final")
    @ResponseBody
    public ResponseEntity<?> updatePostAfterLive(@RequestBody AuctionDTO auction) {
        try {
            boolean result = auctionService.updatePostAfterLive(
                    auction.getPostId(),
                    auction.getFinalCash(),
                    auction.getEndDay()
            );
            if (result) {
                return ResponseEntity.noContent().build();
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("라이브 후 정보 수정 실패");
            }
        } catch (Exception e) {
            logger.error("라이브 후 정보 수정 중 에러 발생: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
