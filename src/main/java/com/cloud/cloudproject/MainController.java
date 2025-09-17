package com.cloud.cloudproject;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainController {

//    @RequestMapping("/")
//    public String index(Model model) {
//        model.addAttribute("title", "비드온 - 경매사이트");
//        model.addAttribute("contentPage", "../main/index.jsp");
//        return "common/layout";
//    }

    @RequestMapping("/")
    public String index(Model model) {
        return "main/index";
    }

    @RequestMapping("/terms")
    public String terms(Model model) {
        model.addAttribute("title", "이용약관");
        model.addAttribute("contentPage", "../policy/terms.jsp");
        return "common/layout";
    }

    @RequestMapping("/privacy")
    public String privacy(Model model) {
        model.addAttribute("title", "개인정보취급방침");
        model.addAttribute("contentPage", "../policy/privacy.jsp");
        return "common/layout";
    }

    @RequestMapping("/mypage/**")
    public String mypage(HttpServletRequest request, Model model) {
        model.addAttribute("title", "마이페이지");
        model.addAttribute("contentPage", "../mypage/layout.jsp");

        // URL에 따른 하위 컨텐츠 설정
        String uri = request.getRequestURI();
        if (uri.contains("/myfar")) {
            model.addAttribute("mypageContent", "../mypage/myfar.jsp");
        } else if (uri.contains("/myprofile")) {
            model.addAttribute("mypageContent", "../mypage/myprofile.jsp");
        } else if (uri.contains("/myauctionitem")) {
            model.addAttribute("mypageContent", "../mypage/myauctionitem.jsp");
        } else if (uri.contains("/myauction")) {
            model.addAttribute("mypageContent", "../mypage/myauction.jsp");
        } else {
            model.addAttribute("mypageContent", "../mypage/main.jsp");
        }

        return "common/layout";
    }
}

