package com.naver.erp;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.mybatis.spring.annotation.MapperScan;

@MapperScan
@Mapper
public interface MainDAO {
	List<Map<String,String>> StudentMainList();
	List<Map<String,String>> TeacherMainList();
	List<Map<String,String>> getManaList();
	List<Map<String,String>> getClassList();
	List<Map<String,String>> getRegistStuCnt();
	List<Map<String,String>> getTeaCnt();
	List<Map<String,String>> getClassInfoCnt();
	List<Map<String,String>> getdayoffInfo();
	List<Map<String,String>> getExamInfoList(ExamDTO examDTO);
	List<Map<String,String>> getDayOffInfoList(DayOffDTO dayOffDTO);
	String whatRole(String mid);
}