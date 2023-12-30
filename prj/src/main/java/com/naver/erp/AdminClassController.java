package com.naver.erp;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@RestController
@Controller
public class AdminClassController {

	@Autowired
	private AdminDAO adminDAO;  

	@Autowired
	private AdminService adminService; 

	
	// 수업 관리(리스트) 접속, 검색
	@RequestMapping( value="/classList.admin.do")
	public ModelAndView searchFreeDev(
			AdminDTO adminDTO
			,HttpSession session
	){
		Map<String,Object> classListMap = getClassListMap( adminDTO );
		ModelAndView mav = new ModelAndView();
		mav.setViewName( "classListAdmin.jsp" );
		mav.addObject(   "classListMap" , classListMap     );
		
		return  mav;
	}
	
	// 수업 리스트 불러오는 메소드
		public Map<String,Object> getClassListMap(AdminDTO adminDTO){
			Map<String,Object> resultMap = new HashMap<String,Object>();
			List<Map<String,String>> classList;
			int classListCnt;
			int classListCntAll;
			Map<String,Integer> pagingMap;
			
			classListCntAll =  this.adminDAO.getClassListCntAll(   );
			classListCnt =  this.adminDAO.getClassListCnt(  adminDTO );
			
			pagingMap = Util.getPagingMap(
					adminDTO.getSelectPageNo()
					, adminDTO.getRowCntPerPage()
					, classListCnt
			);
			

			adminDTO.setSelectPageNo((int)pagingMap.get("selectPageNo"));
			adminDTO.setRowCntPerPage((int)pagingMap.get("rowCntPerPage"));
			adminDTO.setBegin_rowNo((int)pagingMap.get("begin_rowNo"));
			adminDTO.setEnd_rowNo((int)pagingMap.get("end_rowNo"));
			
			
			classList       =  this.adminDAO.getClassList( adminDTO  );

			resultMap.put(  "classList"       , classList        );
			resultMap.put(  "classListCnt"    , classListCnt     );
			resultMap.put(  "classListCntAll" , classListCntAll  );
			resultMap.put(  "adminDTO"  , adminDTO );
			
			resultMap.put(  "begin_pageNo"          , pagingMap.get("begin_pageNo")        );
			resultMap.put(  "end_pageNo"            , pagingMap.get("end_pageNo")          );
			resultMap.put(  "selectPageNo"          , pagingMap.get("selectPageNo")        );
			resultMap.put(  "last_pageNo"           , pagingMap.get("last_pageNo")         );
			resultMap.put(  "begin_serialNo_asc"    , pagingMap.get("begin_serialNo_asc")  );
			resultMap.put(  "begin_serialNo_desc"   , pagingMap.get("begin_serialNo_desc") );
			
			return resultMap;
		}

	// 수업 상세 정보
	@RequestMapping(
		 value="/classDetail.admin.do",
		 method = RequestMethod.POST,
		 produces ="application/json;charset=UTF-8"
	)
	@ResponseBody
	public Map<String, Object> classDetail(
			AdminDTO adminDTO,
			@RequestParam(value="id") String id
	){

		Map<String, Object> classDetailMap = getClassDetailMap(id);
		return classDetailMap;
	}

	public Map<String, Object> getClassDetailMap(String id){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, String>> classList;
		
		classList = this.adminDAO.getClassDetailInfo(id);

		resultMap.put("classList", classList);
		
		return resultMap;
	}
 
	// 수업 삭제
	@RequestMapping(
			value="/deleteClassInfo.admin.do"
			,method=RequestMethod.POST
			,produces="application/json;charset=UTF-8"
			)
	@ResponseBody
	public int deleteClassInfo(
			AdminDTO adminDTO,
			@RequestParam(value="class_no") String id
			) throws Exception {

		int deleteClassCnt = 0;
				
		try {
			deleteClassCnt = this.adminService.deleteClassInfo(id);
		} catch (Exception e) {
			deleteClassCnt = -1;
		}
		
		return deleteClassCnt;
	}
 
	// 수업 수정
	@RequestMapping(
			value="/updateClassInfo.admin.do"
			,method=RequestMethod.POST
			,produces="application/json;charset=UTF-8"
			)
	@ResponseBody
	public int updateClassInfo(
			AdminDTO adminDTO,
			@RequestParam(value="id") String id
			) throws Exception {
				
		int updateClassCnt = 0;
		
		try {
			updateClassCnt = this.adminService.updateClassInfo(id);
		} catch (Exception e) {
			updateClassCnt = -1;
		}

		return updateClassCnt;
	}
	
	
	// 수업 등록
	@RequestMapping(
			value="/registClassProc.admin.do" 
			,method=RequestMethod.POST
			,produces="application/json;charset=UTF-8"
	)
	@ResponseBody
	public Map<String,String> registClassProc(  
			AdminDTO  adminDTO

	){
		Map<String,String> responseMap = new HashMap<String,String>();
		int classRegCnt = 0;
		
				try{
					classRegCnt = this.adminService.insertClassInfo(adminDTO);
		}
		
		catch(Exception ex){
			classRegCnt = -1;
		}
		responseMap.put("classRegCnt" , classRegCnt+"" );
		return responseMap;
	}
	
	
	

}
