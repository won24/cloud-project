package com.cloud.cloudproject.Auction;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Controller  // @RestController에서 변경
@RequestMapping("/auction")
public class AuctionController {

    private final AuctionService auctionService;

    public AuctionController(AuctionService auctionService) {
        this.auctionService = auctionService;
    }

    // JSP 페이지 반환용 메소드들 (새로 추가)

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
            return auctionDetail(Integer.parseInt(category), model);
        }

        model.addAttribute("categoryCode", category);
        return auctionList(page, q, category, status, model);
    }

    // 상세 페이지
    @GetMapping("/{postId:[0-9]+}")
    public String auctionDetail(@PathVariable int postId, Model model) {
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

    // 기존 REST API 메소드들은 @ResponseBody 추가하여 유지
    @GetMapping("/api/all")
    @ResponseBody
    public ResponseEntity<List<AuctionDTO>> getAllList() {
        List<AuctionDTO> auctionList = auctionService.getAllList();
        return ResponseEntity.ok(auctionList);
    }

    // ... 기타 REST API 메소드들 유지
}

