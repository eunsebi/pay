package com.min.intranet.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.min.intranet.core.CommonUtil;
import com.min.intranet.service.ScheduleService;

@Controller
@RequestMapping("/home")
public class ScheduleController {
	private static final Logger logger = LoggerFactory.getLogger(ScheduleController.class);

	@Value("${niee.fileDir}")
	private String fileDir;

	@Value("${niee.imageDir}")
	private String imageDir;

	@Autowired
	private ScheduleService homeService;

	@RequestMapping(value = "scheduleFileDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> scheduleFileDelete(Locale locale, Model model, @RequestParam("name") String name)
			throws Exception {
		logger.info("Welcome userFileDelete! The client locale is {}.", locale);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		File file = new File(fileDir + name);
		if (file.isFile()) {
			resultMap.put("isDel", file.delete());
			resultMap.put("dbDel", homeService.deleteScheduleFiles(name));
		}
		return resultMap;
	}

	/**
	 * Simply selects the home view to render by returning its name.
	 * 
	 * @throws Exception
	 */
	@RequestMapping(value = "scheduleArticle.do", method = RequestMethod.GET)
	@ResponseBody
	public List<Map<String, String>> scheduleArticle(Locale locale, Model model, HttpServletRequest req,
													 @RequestParam("syear") String syear,
			@RequestParam("smonth") String smonth, @RequestParam("eyear") String eyear,
			@RequestParam("emonth") String emonth) throws Exception {
		logger.info("Welcome scheduleArticle! The client locale is {}.", locale);

		String writer = (String) req.getSession().getAttribute(CommonUtil.SESSION_USER);

		System.out.println("write : "  + writer);
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("write", writer);
		paramMap.put("sDay", syear + "/" + smonth + "/01");
		paramMap.put("eDay", eyear + "/" + emonth + "/01");
		List<Map<String, String>> resultMap = homeService.getScheduleArticles(paramMap);

		return resultMap;
	}

	/**
	 * Simply selects the home view to render by returning its name.
	 * 
	 * @throws Exception
	 */
	@RequestMapping(value = "scheduleFiles.do", method = RequestMethod.GET)
	@ResponseBody
	public List<Map<String, String>> scheduleFiles(Locale locale, Model model, @RequestParam("seq") String seq)
			throws Exception {
		logger.info("Welcome scheduleArticle! The client locale is {}.", locale);

		List<Map<String, String>> resultMap = homeService.getScheduleFiles(seq);

		return resultMap;
	}

	@RequestMapping(value = "payMonthWrite.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> payMonthWrite(Locale locale, Model model, HttpServletRequest request,
											 @RequestParam("time_salary") String time_salary,
											 @RequestParam("job_time") String job_time,
											 @RequestParam("full_working_pension") String full_working_pension,
											 @RequestParam("family_pension") String family_pension,
											 @RequestParam("texes") String texes,
											 @RequestParam("position_pension") String position_pension,
                                             @RequestParam("longevity_pension") String longevity_pension,
											 @RequestParam("pay_date") String pay_date
											 ) throws Exception {

		logger.info("Welcome scheduleArticle! The client locale is {}.", locale);

		Map<String, String> paramMap = new HashMap<String, String>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String writer = (String) request.getSession().getAttribute(CommonUtil.SESSION_USER);

		//int seq = homeService.getScheduleMaxSeq();
		//paramMap.put("seq", "" + (seq + 1));
		paramMap.put("time_salary", time_salary);
		paramMap.put("job_time", job_time);
		paramMap.put("full_working_pension", full_working_pension);
		paramMap.put("family_pension", family_pension);
		paramMap.put("texes", texes);
		paramMap.put("position_pension", position_pension);
        paramMap.put("longevity_pension", longevity_pension);
		paramMap.put("user_email", writer);
		paramMap.put("pay_date", pay_date);

		resultMap.put("resultCnt", homeService.payMonthWrite(paramMap));

		return resultMap;
	}

	/**
	 * Simply selects the home view to render by returning its name.
	 * 
	 * @throws Exception
	 */
	@RequestMapping(value = "scheduleWrite.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> scheduleWrite(Locale locale, Model model, HttpServletRequest req,
			@RequestParam("title") String title, @RequestParam("endtime") String endtime,
			@RequestParam("pay_day") String pay_day, @RequestParam("pay_ot") String pay_ot,
			@RequestParam("pay_ottime") String pay_ottime,
			@RequestParam("pay_latetime") String pay_latetime,
			@RequestParam("pay_nighttime") String pay_nighttime,
			@RequestParam("starttime") String starttime,
			/*@RequestParam("realnames") String realnames, @RequestParam("subnames") String subnames,*/
			@RequestParam("etcYn") String etcYn) throws Exception {
		logger.info("Welcome scheduleArticle! The client locale is {}.", locale);

		Map<String, String> paramMap = new HashMap<String, String>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String writer = (String) req.getSession().getAttribute(CommonUtil.SESSION_USER);
		//StringTokenizer realname = new StringTokenizer(realnames, ",");
		//StringTokenizer subname = new StringTokenizer(subnames, ",");

		int seq = homeService.getScheduleMaxSeq();
		paramMap.put("seq", "" + (seq + 1));
		paramMap.put("writer", writer);
		paramMap.put("title", title);
		paramMap.put("pay_day", pay_day);
		paramMap.put("pay_ot", pay_ot);
		paramMap.put("pay_ottime", pay_ottime);
		paramMap.put("pay_latetime", pay_latetime);
		paramMap.put("pay_nighttime", pay_nighttime);
		paramMap.put("starttime", starttime);
		paramMap.put("endtime", endtime);
		paramMap.put("etcYn", etcYn);
		resultMap.put("resultCnt", homeService.scheduleWrite(paramMap));

		/*while (realname.hasMoreElements() && subname.hasMoreElements()) {
			Map<String, String> fileMap = new HashMap<String, String>();
			String rname = realname.nextToken();
			String sname = subname.nextToken();
			fileMap.put("scheduleSeq", "" + (seq + 1));
			fileMap.put("realname", rname);
			fileMap.put("subname", sname);
			resultMap.put("fileCnt", homeService.scheduleFileWrite(fileMap));
		}*/
		return resultMap;
	}

	/**
	 * Simply selects the home view to render by returning its name.
	 * 
	 * @throws Exception
	 */
	@RequestMapping(value = "scheduleUpdate.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> scheduleUpdate(Locale locale, Model model, HttpServletRequest req,
			@RequestParam("seq") String seq, @RequestParam("title") String title,
			@RequestParam("endtime") String endtime, @RequestParam("contents") String contents,
			@RequestParam("starttime") String starttime, @RequestParam("realnames") String realnames,
			@RequestParam("subnames") String subnames, @RequestParam("etcYn") String etcYn) throws Exception {
		logger.info("Welcome scheduleUpdate! The client locale is {}.", locale);
		Map<String, String> paramMap = new HashMap<String, String>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String writer = (String) req.getSession().getAttribute(CommonUtil.SESSION_USER);
		StringTokenizer realname = new StringTokenizer(realnames, ",");
		StringTokenizer subname = new StringTokenizer(subnames, ",");
		paramMap.put("seq", seq);
		paramMap.put("writer", writer);
		paramMap.put("title", title);
		paramMap.put("contents", contents);
		paramMap.put("starttime", starttime);
		paramMap.put("endtime", endtime);
		paramMap.put("etcYn", etcYn);
		while (realname.hasMoreElements()) {
			Map<String, String> fileMap = new HashMap<String, String>();
			String rname = realname.nextToken();
			String sname = subname.nextToken();
			fileMap.put("scheduleSeq", seq);
			fileMap.put("realname", rname);
			fileMap.put("subname", sname);
			resultMap.put("fileCnt", homeService.scheduleFileWrite(fileMap));
		}
		resultMap.put("resultCnt", homeService.scheduleUpdate(paramMap));
		return resultMap;
	}

	/**
	 * Simply selects the home view to render by returning its name.
	 * 
	 * @throws Exception
	 */
	@RequestMapping(value = "scheduleDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> scheduleDelete(Locale locale, Model model, HttpServletRequest req,
			@RequestParam("seq") String seq) throws Exception {
		logger.info("Welcome scheculeDelete! The client locale is {}.", locale);

		Map<String, String> paramMap = new HashMap<String, String>();
		String writer = (String) req.getSession().getAttribute(CommonUtil.SESSION_USER);
		paramMap.put("writer", writer);
		paramMap.put("seq", seq);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("fileCnt", homeService.scheduleDeleteFiles(paramMap));
		resultMap.put("resultCnt", homeService.scheduleDelete(paramMap));

		return resultMap;
	}

	/**
	 * Simply selects the home view to render by returning its name.
	 * 
	 * @throws Exception
	 */
	@RequestMapping(value = "getSchedule.do", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, String> getSchedule(Locale locale, Model model, @RequestParam("seq") String seq,
			HttpServletRequest req) throws Exception {
		logger.info("Welcome getSchedule! The client locale is {}.", locale);

		String user = (String) req.getSession().getAttribute(CommonUtil.SESSION_USER);
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("seq", seq);
		Map<String, String> schedule = homeService.getSchedule(paramMap);
		String contents = schedule.get("contents");
		schedule.put("contents", contents);
		if (user.equals(schedule.get("email"))) {
			schedule.put("isWriter", "true");
		}
		return schedule;
	}

	/**
	 * Simply selects the home view to render by returning its name.
	 * 
	 * @throws Exception
	 */
	@RequestMapping(value = "scheduledownload.do", method = RequestMethod.POST)
	public ModelAndView scheduledownload(Locale locale, Model model, @RequestParam("seq") String seq) throws Exception {
		logger.info("Welcome userfiledownload! The client locale is {}.", locale);

		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("seq", seq);
		Map<String, String> fileMap = homeService.getScheduleFile(paramMap);
		return new ModelAndView("fileDownloadView", "downloadFile", fileMap);
	}

	/**
	 * Simply selects the home view to render by returning its name.
	 * 
	 * @throws IOException
	 * 
	 * @throws Exception
	 */
	@RequestMapping(value = "imgupload.do", method = RequestMethod.POST)
	public void imgupload(Locale locale, Model model, HttpServletRequest req, HttpServletResponse res)
			throws IOException {
		logger.info("Welcome mailFileUpload! The client locale is {}.", locale);
		DiskFileItemFactory factory = new DiskFileItemFactory();
		factory.setSizeThreshold(1024 * 1024 * 10);
		// factory.setRepository(new File("c:/upload/"));
		ServletFileUpload upload = new ServletFileUpload(factory);
		upload.setSizeMax(1024 * 1024 * 10);
		upload.setHeaderEncoding("UTF-8");
		System.out.println(upload.getHeaderEncoding());
		List<FileItem> items;
		String callback_func = "";
		String realname = "";
		String imgName = "";
		try {
			items = upload.parseRequest(req);
			Iterator<FileItem> iter = items.iterator();
			while (iter.hasNext()) {
				FileItem item = (FileItem) iter.next();
				if (item.isFormField()) {
					if (item.getFieldName().equals("callback_func")) {
						callback_func = item.getString();
					}
				} else {
					if (item.getName() != null && !item.getName().equals("")) {
						String ranName = UUID.randomUUID().toString();
						realname = item.getName();
						System.out.println(item.getName());
						imgName = ranName + "." + item.getName().split("\\.")[1];
						File file = new File(imageDir + imgName);
						item.write(file);
						System.out.println(file.getPath());
					}
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			logger.debug("image upload exception");
		}

		res.sendRedirect(req.getContextPath() + "/resources/SE/photo_uploader/popup/callback.html?sFileName=" + realname
				+ "&callback_func=" + callback_func + "&bNewLine=true&sFileURL=" + req.getContextPath()
				+ "/resources/images/" + imgName);
	}

}
