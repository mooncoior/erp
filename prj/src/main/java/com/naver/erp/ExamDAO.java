package com.naver.erp;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.mybatis.spring.annotation.MapperScan;

@MapperScan
@Mapper
public interface ExamDAO {

	int getExamListCnt(ExamDTO examDTO);
	List<Map<String,String>> getExamList(ExamDTO examDTO);
	List<Map<String,String>> getExamDetailInfo(ExamDTO examDTO);
	List<Map<String,String>> getExamDetailProblem(ExamDTO examDTO);
	List<Map<String,String>> getExamDetailAnswer(ExamDTO examDTO);
	int insertExamInfo(ExamDTO examDTO);
	int examproblem(ExamDTO examDTO);
	int deleteExamInfo(ExamDTO examDTO);
	int updateExamInfo(ExamDTO examDTO);
	int updateExamproblem(ExamDTO examDTO);

}