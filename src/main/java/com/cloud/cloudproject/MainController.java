package com.cloud.cloudproject;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainController {

    @RequestMapping("/")
    public String index(Model model) {
        model.addAttribute("title", "비드온 - 경매사이트");
        model.addAttribute("contentPage", "../main/index.jsp");
        return "common/layout";
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
}

