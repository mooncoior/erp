package com.naver.erp;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
@MapperScan
@Mapper
public interface CalendarDAO {
	 List<Map<String,Object>> selectCalendar(CalendarDTO calendarDTO);
	 List<Map<String,Object>> getCalendar();
	 int insertCalendar(CalendarDTO calendarDTO);
	 int updateCalendar(CalendarDTO calendarDTO);
	 int deleteCalendar(CalendarDTO calendarDTO);
}