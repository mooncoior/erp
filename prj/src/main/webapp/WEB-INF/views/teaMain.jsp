<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="css/mainpage.css">
<link rel="stylesheet" href="/js/main.min.css">
<script src="/js/main.min.js"></script>
 <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js'></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css" integrity="sha512-5A8nwdMOWrSz20fDsjczgUidUBR8liPYU+WymTZP1lmY9G6Oc7HlZv156XqnsgNUzTyMefFTcsFH/tnJE/+xBg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script>

$(function(){init();})

function init(){ 
	 window.onpageshow = function(event) {
		   if (event.persisted) {
		              ﻿location.reload(true);﻿
			    }
			}
			$(window).bind("pageshow", function(event) {
			if (event.originalEvent && event.originalEvent.persisted){
			              //todo
			              ﻿location.reload(true);﻿
			    }
			});
}


document.addEventListener('DOMContentLoaded', function() {
	
    var calendarEl = document.getElementById('calendar');
    	var calendar = new FullCalendar.Calendar(calendarEl, {
    		initialView: 'dayGridMonth',
    		
    		headerToolbar: {
    		      left: 'prevYear,prev',
    		      center: 'title',
    		      right: 'next,nextYear today'
    		    }, 
    		    locale:'ko',
    		    timeZone: 'Asia/Seoul',
            events:[ <c:forEach var="calendar" items="${teaMainInfoMap.ClassList}" varStatus="vs">
            {
            	id:"${calendar.att_id}",
            	title:"${calendar.stu_name}"+"-"+"${calendar.attend_status}",
                start:"${calendar.attend_date}",
                color:
                <c:if test="${calendar.attend_status eq '출석'}">
                "blue"
                </c:if>
                <c:if test="${calendar.attend_status eq '결석'}">
                "red"
                </c:if>
                <c:if test="${calendar.attend_status eq '조퇴'}">
                "gold"
                </c:if>
                <c:if test="${calendar.attend_status eq '지각'}">
                "green"
                </c:if>
       		},
            </c:forEach>
            ]
        });
        calendar.render();
    });
</script>

<title>메인</title>
</head>
<body>
  <form class="header">
    <div class="header_box">
      <div class="logo" onclick="location.replace('/teaMain.do')">
        <img src="">
        <div>
          ERP
        </div>
      </div>
      <table>
          <tr>
			<td class="main_cate" onclick="location.replace('/markTea.do')">수업 관리(출석)</td>
			<td class="main_cate" onclick="location.replace('/stuList.do')">학생 관리</td>
			<td class="main_cate" onclick="location.replace('/dayOff.do')">휴가 관리</td>
			<td class="main_cate" onclick="location.replace('/examList.do')">시험 출제</td>
			<td class="main_cate" onclick="location.replace('/??.do')">근태 관리</td>
          </tr>
      </table>
      <div class="welcome_user">
        <div>
          
          <div class="welcome_name">로그아웃</div>
               </div>
        <div class="logout_btn" onclick="location.replace('/loginForm.do')"><i class="fa fa-sign-out" aria-hidden="true"></i></div>
      </div>
      <br>
    </div>
  </form>
  <div class="middle">
      <div class="main_info">
        <div class="notice_box">
          <div class="box_title">수업 현황 
            <div class="doc_more more" style="cursor: pointer;" onclick="location.replace('/markTea.do')">
              <i class="fa fa-plus-square-o" aria-hidden="true"></i>
            </div>
          </div>
          <div class="list">
	          <form name="boardSearchForm" class="boardForm">
	            
	            <div id="calendar" style="width: 70%">
	          </form>
          </div>
        </div>
        </div>
      <div class="main_info">
        <div class="document_box">
          <div class="box_title">시험 정보
            <div class="notice_more more" onclick="location.replace('/registExample.do')">
              <i class="fa fa-plus-square-o" aria-hidden="true"></i>
            </div>
          </div>
          <div class="list">
           <form name="gyeoljaeSearchForm" class="boardForm" action="hh">
			<c:forEach var="ExamList" items="${teaMainInfoMap.ExamList}" varStatus="vs">
           			<div>${ExamList.is_end}</div>
           			<div>${ExamList.exam_name}</div>
         			<div>${ExamList.exam_date}</div>
         			<div>${ExamList.class_name}</div>
           </c:forEach>
           
         	  
           </form>
          </div>
        </div>
        <div class="document_box">
          <div class="box_title">휴가 신청 현황
            <div class="notice_more more" onclick="location.replace('/dayOff.do')">
              <i class="fa fa-plus-square-o" aria-hidden="true"></i>
            </div>
          </div>
          <div class="list">
           <form name="gyeoljaeSearchForm" class="boardForm" action="hh">
           	<c:forEach var="DayoffList" items="${teaMainInfoMap.DayoffList}" varStatus="vs">
           			<div>${DayoffList.tea_name}</div>
           			<div>${DayoffList.application_date}</div>
           			<div>${DayoffList.payment_status}</div>
           			<div>${DayoffList.tea_dayoff_kind}</div>
           </c:forEach>
           </form>
          </div>
        </div>
      </div>
    </div>
  
</body>
</html>