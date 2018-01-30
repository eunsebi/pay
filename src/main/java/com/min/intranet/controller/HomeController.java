package com.min.intranet.controller;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.min.intranet.core.CommonUtil;
import com.min.intranet.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/home")
public class HomeController {

	@Value("${niee.adminEmail}")
	private String adminEmail;

	@Value("${niee.adminPass}")
	private String adminPass;

	@Autowired
	private UserService userService;

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "main.do", method = RequestMethod.GET)
	public String main(Locale locale, Model model, HttpServletRequest req) {
		/*
		 * logger.info("Welcome main! The client locale is {}.", locale); String
		 * userSys = req.getHeader("user-agent"); boolean isM = false; String []
		 * checkM = {"iPhone", "iPod", "BlackBerry", "Android", "Windows CE",
		 * "LG", "MOT", "SAMSUNG", "SonyEricsson"}; for(String m : checkM){
		 * if(userSys.indexOf(m)!=-1){ isM = true; break; } } if(isM){ return
		 * "/mobile/main"; }else{ }
		 */
		logger.info("Welcome main! The client locale is {}.", locale);
		String writer = (String) req.getSession().getAttribute(CommonUtil.SESSION_USER);

		if (writer == null) return "redirect:/user/loginPage.do";
		else return "/home/main";
	}

	@RequestMapping(value = "payLogin.do", method = RequestMethod.POST)
	public String payLogin (Locale locale, HttpServletRequest request,
							@RequestParam("email") String email,
							@RequestParam("passwd") String passwd)
			throws Exception {
		logger.info("Welcome ekkor to payLogin! The client locale is {}.", locale);

		System.out.println("email : " + email);
		System.out.println("passwd : " + passwd);

		Map<String, String> paramMap = new HashMap<String, String>();
		Map<String, Object> userMap = new HashMap<String, Object>();
		HttpSession session = request.getSession();

		if (adminEmail.equals(email)) {
			paramMap.put("email", adminEmail);
			if (userService.getUser(paramMap).isEmpty()) {
				paramMap.put("email", adminEmail);
				paramMap.put("name", "admin");
				paramMap.put("passwd", adminPass);
				paramMap.put("phone", "000-0000-0000");
				userService.addEmployee(paramMap);
			}
			session.setAttribute(CommonUtil.SESSION_USER, adminEmail);
			session.setAttribute("isAdmin", true);
			userMap.put("isLogin", true);
			userMap.put("passwd", "");
			return "redirect:/http://ekkor.ze.am/pay/home/main.do";
		}

		if ("".equals(email)) {
			userMap.put("isLogin", false);
			userMap.put("msg", "메일주소를 입력하세요.");
		} else {
			paramMap.put("email", email);
			userMap = userService.getUser(paramMap);
			if (passwd.equals(userMap.get("passwd"))) {
				session.setAttribute(CommonUtil.SESSION_USER, userMap.get("email"));
				userMap.put("isLogin", true);
			} else {
				userMap.put("isLogin", false);
				userMap.put("msg", "입력하신 정보가 일치하지 않습니다.");
			}
		}
		userMap.put("passwd", "");

		return "redirect:/http://ekkor.ze.am/pay/home/main.do";
	}
}
