package com.naver.erp;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class DayOffController {

	@Autowired
	private MainDAO mainDAO;
	@Autowired
	private DayOffDAO dayoffDAO;
	@Autowired
	private DayOffService dayoffservice;
	
	
	//결재 상세보기
	@RequestMapping(value="/dayOffDetailForm.do")
	public ModelAndView dayOffDetailForm(
			@RequestParam(value="day_id",required=false ) String day_id,
			@RequestParam(value="tea_day_id",required=false ) String tea_day_id,
			HttpSession session
			)
	{
	String mid;
	if((String)session.getAttribute("stu_id")!=null) {
		mid = (String)session.getAttribute("stu_id");
	}
	else if((String)session.getAttribute("tea_id")!=null) {
		mid = (String)session.getAttribute("tea_id");
	}
	else {
		mid = (String)session.getAttribute("mana_id");
	}
	
		String whatRole = mainDAO.whatRole(mid);
		DayOffDTO dayOff = this.dayoffservice.getStuOffDetail(day_id);
		DayOffDTO tea_dayOff = this.dayoffservice.getTeaOffDetail(tea_day_id);
		ModelAndView mav = new ModelAndView();
		mav.setViewName("dayOffDetail.jsp");
		mav.addObject("whatRole",whatRole);
		mav.addObject("dayOff",dayOff);
		mav.addObject("tea_dayOff",tea_dayOff);
		return mav;
	
	}
	
	//결재
	@RequestMapping(
			value="/DayOffResult.do"
			,method=RequestMethod.POST
			,produces="application/json;charset=UTF-8"
			)
	@ResponseBody
	public Map<String, String> DayOffResult(
			DayOffDTO dayOffDTO
			)
	{
		Map<String,String> responseMap = new HashMap<String,String>();
		int stu_DayoffUpCnt = 0;
		int tea_DayoffUpCnt = 0;
		try {
			stu_DayoffUpCnt = this.dayoffservice.updateStuDayoffStatus(dayOffDTO);
			tea_DayoffUpCnt = this.dayoffservice.updateTeaDayoffStatus(dayOffDTO);
		}	
		catch(Exception ex){
			stu_DayoffUpCnt = -1;	
			tea_DayoffUpCnt = -1;		
		}
		
		responseMap.put("stu_DayoffUpCnt",stu_DayoffUpCnt+"");
		responseMap.put("tea_DayoffUpCnt",tea_DayoffUpCnt+"");
		return responseMap;
	}
	
	//페이지
	@RequestMapping( value="/dayOff.do")
	public ModelAndView dayOff(
			DayOffDTO dayoffDTO,
			HttpSession session
		){
		String mid;
		if((String)session.getAttribute("stu_id")!=null) {
			mid = (String)session.getAttribute("stu_id");
		}
		else if((String)session.getAttribute("tea_id")!=null) {
			mid = (String)session.getAttribute("tea_id");
		}
		else {
			mid = (String)session.getAttribute("mana_id");
		}
		String whatRole = mainDAO.whatRole(mid);
		ModelAndView mav = new ModelAndView();
		Map<String, Object> getStuOff = getStuOff(dayoffDTO);
		Map<String, Object> getTeaOff = getTeaOff(dayoffDTO);
		
		mav.setViewName("dayOff.jsp");
		mav.addObject("whatRole",whatRole);
		mav.addObject("getStuOff",getStuOff);
		mav.addObject("getTeaOff",getTeaOff);

		return mav;
	}
	
	// 모든 결재 리스트 불러오는 메소드
			public Map<String,Object> getTeaOff(DayOffDTO dayoffDTO){
				Map<String,Object> resultMap = new HashMap<String,Object>();
				List<Map<String,String>> tea_dayoffList;
				List<Map<String,String>> stu_dayoffList;
				int tea_dayoffListCnt;
				int tea_dayoffListCntAll;
				int stu_dayoffListCnt;
				int stu_dayoffListCntAll;
				Map<String,Integer> pagingMap;
				Map<String,Integer> stu_pagingMap;
				
				tea_dayoffListCntAll =  this.dayoffDAO.getTeaOffCntAll();
				tea_dayoffListCnt =  this.dayoffDAO.getTeaOffCnt(dayoffDTO);
				stu_dayoffListCntAll =  this.dayoffDAO.getStuOffCntAll();
				stu_dayoffListCnt =  this.dayoffDAO.getStuOffCnt(dayoffDTO);
				
				pagingMap = Util.getPagingMap(
						dayoffDTO.getSelectPageNo()
						, dayoffDTO.getRowCntPerPage()
						, tea_dayoffListCnt 
						
				);
				stu_pagingMap = Util.getPagingMap(
						dayoffDTO.getSelectPageNo()
						, dayoffDTO.getRowCntPerPage()
						, stu_dayoffListCnt 
						
				);
				

				dayoffDTO.setSelectPageNo((int)pagingMap.get("selectPageNo"));
				dayoffDTO.setRowCntPerPage((int)pagingMap.get("rowCntPerPage"));
				dayoffDTO.setBegin_rowNo((int)pagingMap.get("begin_rowNo"));
				dayoffDTO.setEnd_rowNo((int)pagingMap.get("end_rowNo"));
				
				
				tea_dayoffList = this.dayoffDAO.getTeaOff(dayoffDTO);
				stu_dayoffList = this.dayoffDAO.getStuOff(dayoffDTO);

				resultMap.put(  "tea_dayoffList"       , tea_dayoffList        );
				resultMap.put(  "stu_dayoffList"       , stu_dayoffList        );
				resultMap.put(  "tea_dayoffListCnt"    , tea_dayoffListCnt     );
				resultMap.put(  "tea_dayoffListCntAll" , tea_dayoffListCntAll  );
				resultMap.put(  "stu_dayoffListCnt"    , stu_dayoffListCnt     );
				resultMap.put(  "stu_dayoffListCntAll" , stu_dayoffListCntAll  );
				resultMap.put(  "dayoffDTO"  , dayoffDTO );
				
				resultMap.put(  "begin_pageNo"          , pagingMap.get("begin_pageNo")        );
				resultMap.put(  "end_pageNo"            , pagingMap.get("end_pageNo")          );
				resultMap.put(  "selectPageNo"          , pagingMap.get("selectPageNo")        );
				resultMap.put(  "last_pageNo"           , pagingMap.get("last_pageNo")         );
				resultMap.put(  "begin_serialNo_asc"    , pagingMap.get("begin_serialNo_asc")  );
				resultMap.put(  "begin_serialNo_desc"   , pagingMap.get("begin_serialNo_desc") );
				
				resultMap.put(  "stu_begin_pageNo"          , stu_pagingMap.get("begin_pageNo")        );
				resultMap.put(  "stu_end_pageNo"            , stu_pagingMap.get("end_pageNo")          );
				resultMap.put(  "stu_selectPageNo"          , stu_pagingMap.get("selectPageNo")        );
				resultMap.put(  "stu_last_pageNo"           , stu_pagingMap.get("last_pageNo")         );
				resultMap.put(  "stu_begin_serialNo_asc"    , stu_pagingMap.get("begin_serialNo_asc")  );
				resultMap.put(  "stu_begin_serialNo_desc"   , stu_pagingMap.get("begin_serialNo_desc") );
				
				return resultMap;
			}

		
	
		
		// 강사 결재 삭제 
		@RequestMapping(
				value="/deleteTeaOff.do"
				,method=RequestMethod.POST
				,produces="application/json;charset=UTF-8"
				)
		@ResponseBody
		public int deleteTeaOff(
				DayOffDTO dayoffDTO
				) throws Exception {

			int deleteTeaOffCnt = 0;
					
			try {
				deleteTeaOffCnt = this.dayoffDAO.deleteTeaOff(dayoffDTO);
			} catch (Exception e) {
				deleteTeaOffCnt = -1;
			}
			
			return deleteTeaOffCnt;
		}
	 
		// 강사 결재 수정
		@RequestMapping(
				value="/updateTeaOff.do"
				,method=RequestMethod.POST
				,produces="application/json;charset=UTF-8"
				)
		@ResponseBody
		public int upTeaOff(
				DayOffDTO dayoffDTO
				) throws Exception {
					
			int updateTeaOffCnt = 0;
			
			try {
				updateTeaOffCnt = this.dayoffDAO.upTeaOff(dayoffDTO);
			} catch (Exception e) {
				updateTeaOffCnt = -1;
			}
			
			return updateTeaOffCnt;
		}
		
		
		// 강사 결재 등록
		@RequestMapping(
				value="/insertTeaOff.do" 
				,method=RequestMethod.POST
				,produces="application/json;charset=UTF-8"
		)
		@ResponseBody
		public Map<String,String> insertTeaOff(  
				@Valid
				DayOffDTO dayoffDTO
				,BindingResult bindingResult

		){
			Map<String,String> responseMap = new HashMap<String,String>();
			String errorMsg = "";
			int TeaOffRegCnt = 0;
			
			try{
				errorMsg = Util.getErrorMsgFromBindingResult(bindingResult);
				if( errorMsg!=null && errorMsg.length()>0 ) {
					TeaOffRegCnt = -21;
				}
				else {
					TeaOffRegCnt = this.dayoffDAO.insertTeaOff(dayoffDTO);
				}
			}
			
			catch(Exception ex){
				TeaOffRegCnt = -1;
			}
			responseMap.put("errorMsg", errorMsg);
			responseMap.put("TeaOffRegCnt" , TeaOffRegCnt+"" );
			return responseMap;
		}

		// 학생 결재 리스트 불러오는 메소드
					public Map<String,Object> getStuOff(DayOffDTO dayoffDTO){
						Map<String,Object> resultMap = new HashMap<String,Object>();
						List<Map<String,String>> dayoffList;
						int dayoffListCnt;
						int dayoffListCntAll;
					
						Map<String,Integer> pagingMap;
						
						dayoffListCntAll =  this.dayoffDAO.getStuOffCntAll();
						dayoffListCnt =  this.dayoffDAO.getStuOffCnt(dayoffDTO);
						
						
						pagingMap = Util.getPagingMap(
								dayoffDTO.getSelectPageNo()
								, dayoffDTO.getRowCntPerPage()
								, dayoffListCntAll
						);
						

						dayoffDTO.setSelectPageNo((int)pagingMap.get("selectPageNo"));
						dayoffDTO.setRowCntPerPage((int)pagingMap.get("rowCntPerPage"));
						dayoffDTO.setBegin_rowNo((int)pagingMap.get("begin_rowNo"));
						dayoffDTO.setEnd_rowNo((int)pagingMap.get("end_rowNo"));
						
						
						dayoffList       =  this.dayoffDAO.getStuOff(dayoffDTO);

						resultMap.put(  "dayoffList"       , dayoffList        );
						resultMap.put(  "dayoffListCnt"    , dayoffListCnt     );
						resultMap.put(  "dayoffListCntAll" , dayoffListCntAll  );
						resultMap.put(  "dayoffDTO"  , dayoffDTO );
						
						resultMap.put(  "begin_pageNo"          , pagingMap.get("begin_pageNo")        );
						resultMap.put(  "end_pageNo"            , pagingMap.get("end_pageNo")          );
						resultMap.put(  "selectPageNo"          , pagingMap.get("selectPageNo")        );
						resultMap.put(  "last_pageNo"           , pagingMap.get("last_pageNo")         );
						resultMap.put(  "begin_serialNo_asc"    , pagingMap.get("begin_serialNo_asc")  );
						resultMap.put(  "begin_serialNo_desc"   , pagingMap.get("begin_serialNo_desc") );
						
						return resultMap;
					}

				
				
				//학생 결재 삭제
				@RequestMapping(
						value="/deleteStuOff.do"
						,method=RequestMethod.POST
						,produces="application/json;charset=UTF-8"
						)
				@ResponseBody
				public int deleteStuOff(
						DayOffDTO dayoffDTO
						) throws Exception {

					int deleteStuOffCnt = 0;
							
					try {
						deleteStuOffCnt = this.dayoffservice.deleteStuOff(dayoffDTO);
					} catch (Exception e) {
						deleteStuOffCnt = -1;
					}
					
					return deleteStuOffCnt;
				}
			 
				//학생 결재 수정
				@RequestMapping(
						value="/updateStuOff.do"
						,method=RequestMethod.POST
						,produces="application/json;charset=UTF-8"
						)
				@ResponseBody
				public int upStuOff(
						DayOffDTO dayoffDTO
						) throws Exception {
							
					int updateStuOffCnt = 0;
					
					try {
						updateStuOffCnt = this.dayoffDAO.upStuOff(dayoffDTO);
					} catch (Exception e) {
						updateStuOffCnt = -1;
					}

					return updateStuOffCnt;
				}
				
				
				//학생 결재 등록
				@RequestMapping(
						value="/insertStuOff.do" 
						,method=RequestMethod.POST
						,produces="application/json;charset=UTF-8"
				)
				@ResponseBody
				public Map<String,String> insertStuOff(  
						@Valid
						DayOffDTO dayoffDTO
						,BindingResult bindingResult

				){
					Map<String,String> responseMap = new HashMap<String,String>();
					String errorMsg = "";
					int StuOffRegCnt = 0;
					
					try{
						errorMsg = Util.getErrorMsgFromBindingResult(bindingResult);
						if( errorMsg!=null && errorMsg.length()>0 ) {
							StuOffRegCnt = -21;
						}
						else {
							StuOffRegCnt = this.dayoffDAO.insertStuOff(dayoffDTO);
						}
					}
					
					catch(Exception ex){
						StuOffRegCnt = -1;
					}
					responseMap.put("errorMsg", errorMsg);
					responseMap.put("StuOffRegCnt" , StuOffRegCnt+"" );
					return responseMap;
				}
			
				
		
		
		
}
