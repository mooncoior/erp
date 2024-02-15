package com.naver.erp;

import java.net.http.HttpResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import javax.websocket.Session;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@RestController
@Controller
public class CalendarController{
	@Autowired
	private CalendarDAO calendarDAO;
	@Autowired
	private MainDAO mainDAO;
	@Autowired
	private AdminDAO adminDAO;
	@Autowired
	private DayOffDAO dayOffDAO;
	@Autowired
	private ExamDAO examDAO;
	

	
	@RequestMapping(value="/stuMain.do")
	public ModelAndView studentMain(
			HttpSession session
			,CalendarDTO calendarDTO
			,AdminDTO adminDTO
			,DayOffDTO dayoffDTO
			,ExamDTO examDTO
			
	){
		session.getAttribute("stu_id");
		Map<String, Object> studentMainMap = StudentMainList();
		Map<String, Object> selectCalendarMap = selectCalendar(calendarDTO);
		List<Map<String, String>> classListMap = adminDAO.getClassList(adminDTO);
		List<Map<String, String>> stu = this.dayOffDAO.getStuOff(dayoffDTO);
		List<Map<String, String>> exam = this.examDAO.getExamList(examDTO);
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("studentMain.jsp");
	    mav.addObject("studentMainMap", studentMainMap);
	    mav.addObject("selectCalendarMap", selectCalendarMap);
	    mav.addObject("classListMap",classListMap);
	    mav.addObject("stu",stu);
	    mav.addObject("exam",exam);
		return mav;}
	

	   public Map<String, Object> StudentMainList(
			   ) {
		 Map<String, Object> resultMap = new HashMap<String, Object>();
		 List<Map<String, String>> StudentMainMap; 
		StudentMainMap = this.mainDAO.StudentMainList();
		resultMap.put("StudentMainMap", StudentMainMap);
		return resultMap; 
		 }
	
	   // 학생 출석확인 페이지
	@RequestMapping(value="/mark.do")
	public ModelAndView mark(
			HttpSession session,
			CalendarDTO calendarDTO){
		session.getAttribute("stu_id");
		Map<String,Object> selectCalendarMap = selectCalendar(calendarDTO);
		ModelAndView mav = new ModelAndView();
		mav.setViewName("mark.jsp");
		mav.addObject("selectCalendarMap",selectCalendarMap);
		mav.addObject("stu_id");
		return mav;
	}
	
	 
	
	// 강사용 학생 출석확인 페이지
	@RequestMapping( value="/markTea.do")
	public ModelAndView markTea(HttpSession session,
			CalendarDTO calendarDTO,AdminDTO adminDTO){
		session.getAttribute("tea_id");
		AdminStuController astu = new AdminStuController();
		Map<String,Object> getCalendarMap = getCalendar(calendarDTO);
		List<Map<String, String>> getstuMap = adminDAO.getStuList(adminDTO);

		System.out.println(getstuMap.get(0).get("phone_num"));
		ModelAndView mav = new ModelAndView();
		mav.setViewName("markTea.jsp");
		mav.addObject("getCalendarMap",getCalendarMap);
		mav.addObject("student",getstuMap );
		return mav;
	}
	
	
	/// 일정 등록
	@RequestMapping(value ="/insertCalendar.do"
					,method=RequestMethod.POST
					,produces="application/json;charset=UTF-8")
			@ResponseBody
			public Map<String,String> insertCalendar(
					@Valid
					CalendarDTO calendarDTO,BindingResult bindingResult
					){
				Map<String,String> responseMap = new HashMap<String,String>();
				String errorMsg = "";
				int insertcalendarCnt = 0;
				try{
					errorMsg = Util.getErrorMsgFromBindingResult(bindingResult);
					if(errorMsg!=null && errorMsg.length()>0) {
						insertcalendarCnt = -21;
					}
					else {
						insertcalendarCnt = this.calendarDAO.insertCalendar(calendarDTO);
					}
					
					}
				catch(Exception ex){
					System.out.println(ex);
					insertcalendarCnt = -1;
				}
				responseMap.put("errorMsg", errorMsg);
				responseMap.put("insertcalendarCnt" , insertcalendarCnt+"" );
				
				return responseMap;
			};
			
		
			
			/// 일정 수정
			@RequestMapping(value = "/updateCalendar.do"
					,method=RequestMethod.POST
					,produces="application/json;charset=UTF-8")
			@ResponseBody
			public int updateCalendar(CalendarDTO calendarDTO)
					 throws Exception{
				
			int calendarRegCnt = 0;
				
			try{
				calendarRegCnt = this.calendarDAO.updateCalendar(calendarDTO);
							}
				catch(Exception ex){
					calendarRegCnt = -1;
				}
			System.out.println(calendarRegCnt);
				return calendarRegCnt;
				
			};
			/// 일정 삭제
			@RequestMapping(value = "/deleteCalendar.do"
					,method=RequestMethod.POST
					,produces="application/json;charset=UTF-8")
			@ResponseBody
			public int deleteCalendar(CalendarDTO calendarDTO)throws Exception {
				
				int calendarRegCnt = 0;
				try{
					calendarRegCnt = this.calendarDAO.deleteCalendar(calendarDTO);
								}
					catch(Exception ex){
						System.out.println(ex);
						calendarRegCnt = -1;
					}
					return calendarRegCnt;
					
				}
			
// 모든 일정 불러오기
		// 성공함	
			public Map<String, Object> getCalendar(
					 CalendarDTO calendarDTO   ) {
				 Map<String, Object> resultMap = new HashMap<String, Object>();
				 List<Map<String, Object>> getCalendar; 
				 getCalendar = this.calendarDAO.getCalendar();
				resultMap.put("getCalendar", getCalendar); 
				return resultMap; 
				 }
			
// 선택된 일정 불러오기 (학생페이지)
			//이거안되네..
			 public Map<String, Object> selectCalendar(
					 CalendarDTO calendarDTO   ) {
				 Map<String, Object> resultMap = new HashMap<String, Object>();
				 List<Map<String, Object>> selectCalendar; 
				 selectCalendar = this.calendarDAO.selectCalendar(calendarDTO);
				resultMap.put("selectCalendar", selectCalendar); 
				return resultMap; 
				 }
			
			
}
