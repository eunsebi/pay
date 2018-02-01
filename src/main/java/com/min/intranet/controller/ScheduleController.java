package com.min.intranet.controller;

import com.min.intranet.core.CommonUtil;
import com.min.intranet.service.PayUserDataVO;
import com.min.intranet.service.ScheduleService;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.codehaus.jackson.map.ObjectMapper;
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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.*;

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

    /**
     *  시급 등록 처리
     * @param locale
     * @param model
     * @param request
     * @param time_salary
     * @param job_time
     * @param full_working_pension
     * @param family_pension
     * @param texes
     * @param position_pension
     * @param longevity_pension
     * @param pay_date
     * @return
     * @throws Exception
     */
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

		logger.info("Welcome payMonthWrite! The client locale is {}.", locale);

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

		Integer count = homeService.payMonthEkkor(paramMap);

		System.out.println("conut : " + count);

		if (count == 0) {
			System.out.println("등록했다.......");
			Integer writeCnt = homeService.payMonthWrite(paramMap);
			System.out.println("resultCnt : " +writeCnt );
			resultMap.put("resultCnt", writeCnt);
			resultMap.put("error", "ok");
            //paramMap.put("error", "10MB 이하의 파일만 업로드 가능합니다.");
        } else {
			System.out.println("이미 등록이 되어있다.....");
			resultMap.put("error", "error");
        }
		return resultMap;
	}


	/**
	 * 시급정보 불러오기
	 * @param locale
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "payMonthUpdate.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, ?> payMonthUpdate(Locale locale, HttpServletRequest request) throws Exception {
		logger.info("Welcome payMonthWrite! The client locale is {}.", locale);

		Map<String, String> paramMap = new HashMap<String, String>();
		String writer = (String) request.getSession().getAttribute(CommonUtil.SESSION_USER);

		String sYear = "2018";
		String sMonth = "1";

		if(Integer.parseInt(sMonth) < 9) {
			sMonth = "0"+ sMonth;
		}

		System.out.println("----------------------------------------------");
		System.out.println("email : " + writer);

		paramMap.put("payDate", sYear+sMonth);
		paramMap.put("user_email", writer);
		Map<String, ?> resultMap = homeService.payMonthUpdate(paramMap);

		System.out.println("result : " + resultMap);

		return resultMap;
	}

	/**
	 * 급여 계산
	 * @param locale
	 * @param request
	 * @param syear
	 * @param smonth
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "payDay.do", method = RequestMethod.GET)
	@ResponseBody
    public List<Map<String, String>> payDay(Locale locale, HttpServletRequest request,
						 /*@RequestParam Map<String, String> commandMap,*/
						 @RequestParam("syear") String syear,
						 @RequestParam("smonth") String smonth
						 ) throws Exception {

        //Map<String, Object> resultMap = new HashMap<String, Object>();
		logger.info("Welcome payDay(급여 계산)! The client locale is {}.", locale);

		String writer = (String) request.getSession().getAttribute(CommonUtil.SESSION_USER);
		Map<String, String> paramMap = new HashMap<String, String>();

		//java.util.Calendar cal = java.util.Calendar.getInstance();

		String sYear = syear;
		String sMonth = smonth;

		/*int iYear = cal.get(java.util.Calendar.YEAR);
		int iMonth = cal.get(java.util.Calendar.MONTH);
		int iDate = cal.get(java.util.Calendar.DATE);*/

		//검색 설정
		//String sSearchDate = "";
		/*if(sYear == null || sMonth == null){
			sSearchDate += Integer.toString(iYear);
			sSearchDate += Integer.toString(iMonth+1).length() == 1 ? "0" + Integer.toString(iMonth+1) : Integer.toString(iMonth+1);
		}else{
			iYear = Integer.parseInt(sYear);
			iMonth = Integer.parseInt(sMonth);
			sSearchDate += sYear;
			sSearchDate += Integer.toString(iMonth+1).length() == 1 ? "0" + Integer.toString(iMonth+1) :Integer.toString(iMonth+1);
		}*/

		if(Integer.parseInt(sMonth) < 9) {
			sMonth = "0"+ sMonth;
		}

		//sSearchDate = sYear + "-" + sMonth;

		paramMap.put("searchMonth", sYear + "-" + sMonth);
		paramMap.put("year", sYear);
		paramMap.put("month", sMonth);
		paramMap.put("searchMode", "MONTH");
		paramMap.put("writer", writer);
		paramMap.put("payDate", sYear+sMonth);
		//paramMap.put("sDay", syear + "/" + smonth + "/01");
		//paramMap.put("eDay", syear + "/" + smonth + "/01");

		// 급여 정보 얻기
		/*paramMap.put("mode", "DETAIL");
		PayUserDataVO result = homeService.selectUserMonelyDetail(paramMap);*/

		// 급여계산 메서드 호출

		//Map<String, Object> resultMap = new HashMap<String, Object>();

		// hashMap으로 받을때
		/*HashMap<String, ?> calModel = salaryCalculation(paramMap);
		resultMap.put("paySum", salaryCalculation(paramMap));*/

		// List로 받을때
		List<Map<String, String>> listResultMap = salaryCalculation(paramMap);

		System.out.println("result : " + listResultMap);

		// json으로 변경 -> string값
		/*ObjectMapper mapper = new ObjectMapper();
		resultMap.put("paySum", mapper.writeValueAsString(salaryCalculation(paramMap)));*/

		return listResultMap;
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
											 @RequestParam("contents") String contents,
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
		paramMap.put("contents", contents);
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
											  @RequestParam("seq") String seq,
											  @RequestParam("title") String title,
											  @RequestParam("endtime") String endtime,
											  @RequestParam("pay_day") String pay_day,
											  @RequestParam("pay_ot") String pay_ot,
											  @RequestParam("pay_ottime") String pay_ottime,
											  @RequestParam("contents") String contents,
											  @RequestParam("pay_latetime") String pay_latetime,
											  @RequestParam("pay_nighttime") String pay_nighttime,
											  @RequestParam("starttime") String starttime,
											  @RequestParam("etcYn") String etcYn) throws Exception {

		logger.info("Welcome scheduleUpdate! The client locale is {}.", locale);
		Map<String, String> paramMap = new HashMap<String, String>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String writer = (String) req.getSession().getAttribute(CommonUtil.SESSION_USER);
		paramMap.put("seq", seq);
		paramMap.put("writer", writer);
		paramMap.put("title", title);
		paramMap.put("contents", contents);
		paramMap.put("pay_day", pay_day);
		paramMap.put("pay_ot", pay_ot);
		paramMap.put("pay_ottime", pay_ottime);
		paramMap.put("pay_latetime", pay_latetime);
		paramMap.put("pay_nighttime", pay_nighttime);
		paramMap.put("starttime", starttime);
		paramMap.put("endtime", endtime);
		paramMap.put("etcYn", etcYn);

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

    /**
     * 월별 급여계산 식
     * @param commandMap
     * @return
     * @throws Exception
     */
    private List salaryCalculation(Map<String, String> commandMap) throws Exception {

        HashMap<String, String> hm = new HashMap<String, String>();
		List returnList = new ArrayList();

        String str_holidayNightProTime = "sumHolidayNightProTime";	// 야간 특근 잔업시간
        String str_proTime = "sumProTime";							// 주간 잔업시간
        String str_nightProDay ="sumNightProDay";					// 야간 근무일
        String str_nightTime = "sumNightTime";						// 야간 잔업시간
        String str_holidayDay = "sumHolidayDay";					// 특근 근무일
        String str_holidayProTime = "sumHolidayProTime";			// 특근 잔업시간
        String str_holidayNightDay = "sumHolidayNightDay";			// 야간 특근 근무일
		String str_paylatetime = "sumPayLatetime";					// 지각/조퇴 시간

        // DB -> String 받아오는 함수
        String str_proTime_Sum;
        String str_nightProDay_Sum;
        String str_nightTime_Sum;
        String str_holidayDay_Sum;
        String str_holidayProTime_Sum;
        String str_holidayNightDay_Sum;
        String str_holidayNightProTime_Sum;
		String str_paylatetime_sum;

        // String -> Float 변환용(근무시간 합계
        Float num_proTime_Sum = null;
        Float num_nightProDay_Sum = null;
        Float num_nightTime_Sum = null;
        Float num_holidayDay_Sum = null;
        Float num_holidayProTime_Sum = null;
        Float num_holidayNightDay_Sum = null;
        Float num_holidayNightProTime_Sum = null;
		Float num_paylatetime_sum = null;

        DecimalFormat df = new DecimalFormat("#,###");
        DecimalFormat dff = new DecimalFormat("#,###.#");
        DecimalFormat dfff = new DecimalFormat("####");
        DecimalFormat af = new DecimalFormat("####.#");

        // 자바 Type 알아보기
    	/*for (Object o : resultList)	{
			System.out.println(" Type : " + o.getClass().getCanonicalName());
			Map map = (Map) o;
			for (Object key : map.keySet()) {
				System.out.println("        - " + key + " : " + map.get(key));
			}
		}
    	*/

        // 유저 급여정보 가져오기
        commandMap.put("mode", "CAL");
        PayUserDataVO result = homeService.selectUserMonelyDetail(commandMap);

        List resultList = homeService.selectListSalaryCalculation(commandMap);

		/*String aa = commandMap.get("month");
		String cc = "";
		Integer bb = Integer.parseInt(aa);
		bb -=1;

		if (bb < 0) {
			if(bb < 9) {
				aa = Integer.toString(bb);
				cc = "0"+ Integer.parseInt(aa) ;
			}

			System.out.println("aaaaa : " + cc);

			commandMap.put("searchMonth", commandMap.get("year") + "-" + cc);

			resultList.add(homeService.selectListSalaryCalculation(commandMap));
		}

		System.out.println("resultList size: " + resultList);*/

        if(resultList.size() != 0) {

			for (int i = 0; i < 1; i++) {

				//Map<String, ?> map = (Map<String, ?>) resultList.get(i);
				String calculationList = resultList.get(i).toString();

				int int_holidayNightProTimeLength = calculationList.indexOf(str_holidayNightProTime);
				int int_proTimeLength = calculationList.indexOf(str_proTime);
				int int_nightProDayLength = calculationList.indexOf(str_nightProDay);
				int int_nightTimeLength = calculationList.indexOf(str_nightTime);
				int int_holidayDayLength = calculationList.indexOf(str_holidayDay);
				int int_holidayProTimeLength = calculationList.indexOf(str_holidayProTime);
				int int_holidayNightDayLength = calculationList.indexOf(str_holidayNightDay);
				//int int_paylatetimeLength = calculationList.indexOf(str_paylatetime);

				//특근 잔업시간
				str_holidayNightProTime_Sum = calculationList.substring(
						int_holidayNightProTimeLength + str_holidayNightProTime.length() + 1,
						calculationList.substring(int_holidayNightProTimeLength).indexOf(str_proTime) - 1);
				num_holidayNightProTime_Sum = Float.parseFloat(str_holidayNightProTime_Sum);

				//잔업 시간
				str_proTime_Sum = calculationList.substring(
						int_proTimeLength + str_proTime.length() + 1,
						calculationList.substring(int_holidayNightProTimeLength).indexOf(str_nightProDay) - 1);
				num_proTime_Sum = Float.parseFloat(str_proTime_Sum);

				str_nightProDay_Sum = calculationList.substring(
						int_nightProDayLength + str_nightProDay.length() + 1,
						calculationList.substring(int_holidayNightProTimeLength).indexOf(str_nightTime) - 1);
				num_nightProDay_Sum = Float.parseFloat(str_nightProDay_Sum);

				//야간 시간
				str_nightTime_Sum = calculationList.substring(
						int_nightTimeLength + str_nightTime.length() + 1,
						calculationList.substring(int_holidayNightProTimeLength).indexOf(str_holidayDay) - 1);
				num_nightTime_Sum = Float.parseFloat(str_nightTime_Sum);

				//야간 특근 근무일
				str_holidayDay_Sum = calculationList.substring(
						int_holidayDayLength + str_holidayDay.length() + 1,
						calculationList.substring(int_holidayNightProTimeLength).indexOf(str_holidayProTime) - 1);
				num_holidayDay_Sum = Float.parseFloat(str_holidayDay_Sum);

				// 특근 잔업시간
				str_holidayProTime_Sum = calculationList.substring(
						int_holidayProTimeLength + str_holidayProTime.length() + 1,
						calculationList.substring(int_holidayNightProTimeLength).indexOf(str_holidayNightDay) - 1);
				num_holidayProTime_Sum = Float.parseFloat(str_holidayProTime_Sum);

				str_holidayNightDay_Sum = calculationList.substring(
						int_holidayNightDayLength + str_holidayNightDay.length() + 1,
						calculationList.length() - 1);
				num_holidayNightDay_Sum = Float.parseFloat(str_holidayNightDay_Sum);

			}

			//String str_proTime = "sumProTime";							// 주간 잔업시간
			//String str_nightProDay ="sumNightProDay";					// 야간 근무일
			//String str_nightTime = "sumNightTime";						// 야간 잔업시간
			//String str_holidayDay = "sumHolidayDay";					// 특근 근무일
			//String str_holidayProTime = "sumHolidayProTime";			// 특근 잔업시간
			//String str_holidayNightDay = "sumHolidayNightDay";			// 야간 특근 근무일
			//String str_holidayHightProTime = "sumHolidayHightProTime";	// 야간 특근 잔업시간

			// 잔업수당 시급
			float jansu = Float.parseFloat(result.getTimeSalary())      // 시급
					+ (Float.parseFloat(result.getLongevityPension())   // 근속수당
					/ Float.parseFloat(result.getJobTime()))           // 근무시간
					+ (Float.parseFloat(result.getPositionPension())   // 직책수당
					/ Float.parseFloat(result.getJobTime()));           // 근무시간
		/*String aa = af.format(a);
		float jansu = Float.parseFloat(aa);
		System.out.println("잔업 시급 : " +jansu);*/
			System.out.println("잔업 시급 : " + jansu);

			float calBasicTime = Float.parseFloat(result.getJobTime()) * Float.parseFloat(result.getTimeSalary());        //기본급
			float calHolidayDay = num_holidayDay_Sum + num_holidayNightDay_Sum;                                            //특근 근무일
			float calHolidayPro = num_holidayProTime_Sum + num_holidayNightProTime_Sum;                                    // 특근 잔업시간

			System.out.println("기본급 : " + calBasicTime);

		/*LOGGER.info("num_holidayProTime_Sum : {} ", num_holidayProTime_Sum);
		LOGGER.info("num_holidayNightProTime_Sum : {} ", num_holidayNightProTime_Sum);
		LOGGER.info("특근 잔업시간 : {} ", calHolidayPro);*/

			if (num_holidayProTime_Sum != 0) {
				num_proTime_Sum = num_proTime_Sum - num_holidayProTime_Sum;
			}

			float calProTime = (jansu * num_proTime_Sum * Float.parseFloat("1.5")) +            // 잔업
					(jansu * calHolidayPro * Float.parseFloat("2"));                            // 특근 잔업

			float calHolidayPersion = calHolidayDay * 8 * jansu * Float.parseFloat("1.5");    // 특근수당
			float calNightPersion = num_nightTime_Sum * (jansu * Float.parseFloat("0.5"));    // 야간수당

			float persionSum = calBasicTime + calProTime + calHolidayPersion + calNightPersion
					+ Float.parseFloat(result.getFamilyPension()) + Float.parseFloat(result.getFullWorkingPension())
					+ Float.parseFloat(result.getPositionPension()) + Float.parseFloat(result.getLongevityPension());                            // 급여 합계

			System.out.println("총급여 : " + persionSum);
			System.out.println("세금 : " + result.getTexes());
        /*System.out.println("야간근무시간 : " + num_nightTime_Sum);
        System.out.println("잔업 수당 : " + calProTime);
		System.out.println("특근수당 : " + calHolidayPersion);
		System.out.println("야간수당 : " + calNightPersion);*/
			float calTotal = persionSum - Float.parseFloat(result.getTexes());                    // 실지급액
			//float calnightTime = num_nightTime_Sum * result.getTimeSalary();

			System.out.println("실지급액 : " + calTotal);

			hm.put("calBasicTime", df.format(calBasicTime));                    // 기본급
			hm.put("calProDay", dff.format(num_proTime_Sum));                    // 주간 잔업시간
			hm.put("calProTime", dff.format(calProTime));                        // 연장수당
			hm.put("calNightProDay", df.format(num_nightProDay_Sum));            // 야간 근무일
			hm.put("calHolidayDay", df.format(calHolidayDay));                    // 특근 근무일(야간 특근 포함)
			hm.put("calHolidayPro", dff.format(calHolidayPro));                    // 특근 잔업시간(야특 포함)
			hm.put("calNightProTime", dff.format(num_nightTime_Sum));            // 야간 잔업시간
			hm.put("calHolidayPersion", df.format(calHolidayPersion));            // 특근수당
			hm.put("calNightPersion", df.format(calNightPersion));                // 야간수당
			hm.put("persionSum", df.format(persionSum));                        // 총급여액
			hm.put("total", df.format(calTotal));                                        // 실지급액

			returnList.add(hm);
		} else {
			System.out.println("급여 등록이 없다.");

			hm.put("calBasicTime", df.format(0));                    // 기본급
			hm.put("calProDay", dff.format(0));                    // 주간 잔업시간
			hm.put("calProTime", dff.format(0));                        // 연장수당
			hm.put("calNightProDay", df.format(0));            // 야간 근무일
			hm.put("calHolidayDay", df.format(0));                    // 특근 근무일(야간 특근 포함)
			hm.put("calHolidayPro", dff.format(0));                    // 특근 잔업시간(야특 포함)
			hm.put("calNightProTime", dff.format(0));            // 야간 잔업시간
			hm.put("calHolidayPersion", df.format(0));            // 특근수당
			hm.put("calNightPersion", df.format(0));                // 야간수당
			hm.put("persionSum", df.format(0));                        // 총급여액
			hm.put("total", df.format(0));                                        // 실지급액

			resultList.add(hm);
		}

        return returnList;
    }

}
