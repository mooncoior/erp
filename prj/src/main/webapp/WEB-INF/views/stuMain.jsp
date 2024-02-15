<%@page import="org.apache.jasper.tagplugins.jstl.core.Import"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common.jsp"%>

<!doctype html>
<html>
<head>
<title>학생페이지</title>
<link href="css/mainpage.css" rel="stylesheet">
<link rel="stylesheet" href="/js/main.min.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="/js/main.min.js"></script>
 <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js'></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css" integrity="sha512-5A8nwdMOWrSz20fDsjczgUidUBR8liPYU+WymTZP1lmY9G6Oc7HlZv156XqnsgNUzTyMefFTcsFH/tnJE/+xBg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script src="https://cdn.jsdelivr.net/npm/chart.js@2.9.0/dist/Chart.min.js"></script> 
</head>
<script>
$(function(){
	  
	   window.onpageshow = function(event) {
	   if (event.persisted) {
	              ﻿location.reload(true);﻿
		    }
		}
		$(window).bind("pageshow", function(event) {
		if (event.originalEvent && event.originalEvent.persisted){
		              ﻿location.reload(true);﻿
		    }
		});﻿

})

document.addEventListener('DOMContentLoaded', function() {
	
    var calendarEl = document.getElementById('calendar');
    	var calendar = new FullCalendar.Calendar(calendarEl, {
            timeZone: 'UTC',
            initialView: 'dayGridMonth',
            events:[ <c:forEach var="calendar" items="${selectCalendarMap.selectCalendar}" varStatus="vs">
            <c:if test="${sessionScope.stu_id==calendar.stu_id}">
            {
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
       		</c:if>
            </c:forEach>
            ],
            editable: true,
        });
        calendar.render();
    });

function godayForm(){
    document.dayOffFormLink.submit();
 }
</script>
		<body>
				<form name="stuSearch" class="header">
						<div class="header_box">
							<div class="logo" onclick="location.replace('/stuMain.do')">
								<img src="">
								<div>
									학원명
								</div>
							</div>
							<table>
								<tr class="cate_box">
              						<td class="main_cate" onclick="location.replace('/mark.do')">출석현황</td>
									<td class="main_cate" onclick="location.replace('/dayOff.do')">휴가신청</td>
									<td class="main_cate" onclick="location.replace('/examList.do')">시험응시</td>
									<td class="main_cate" onclick="location.replace('/checkGrade.do')">성적확인</td>
								</tr>
							</table>
							<div class="welcome_user">
								<div>
									<div class="welcome_name" onclick="location.replace('/loginForm.do')">로그아웃</div>
								</div>
								<div class="logout_btn" onclick="location.replace('/loginForm.do')"><i class="fa fa-sign-out" aria-hidden="true"></i></div>
							</div>
							<br>
						</div>
			</form>

			<div onscroll="checkScroll(this)">
				<form name="CalendarForm" class="boardForm">
					<header>
					반갑습니다 ${stu_id}님
					</header>
					<div class="main_info" style="width: 1300px; ">
					 <div class="notice_box" style="height: 600px; ">
			          <div class="box_title">
			            출석 현황 
			            <div class="doc_more more" style="cursor: pointer;" onclick="location.replace('/stuList.do')">
			              <i class="fa fa-plus-square-o" aria-hidden="true"></i>
			            </div>
			          </div>
			          <div >
			             <form class="boardForm">
						<div id='calendar'></div>
			             </form>
			          </div>
			        </div>
			        <div class="notice_box" style="height: 600px; ">
			          <div class="box_title">
			            수업 참여율 
			            <div class="doc_more more" style="cursor: pointer;" onclick="location.replace('/stuList.do')">
			              <i class="fa fa-plus-square-o" aria-hidden="true"></i>
			            </div>
			          </div>
			          <div class="list">
			             <form  class="boardForm">
						<canvas id=chart style="margin-top: 15%"></canvas>
			             </form>
			          </div>
			        </div>
			        </div>
			        <div class="main_info">
			        <div class="notice_box" style="height: 350px; " >
			          <div class="box_title">
			            다가오는 시험정보
			            <div class="doc_more more" style="cursor: pointer;" onclick="location.replace('/stuList.do')">
			              <i class="fa fa-plus-square-o" aria-hidden="true"></i>
			            </div>
			          </div>
			          <div class="flex">
			             <form class="boardForm">
						<c:forEach var="exam" items="${exam}" varStatus="vs">
					<c:if test="${sessionScope.stu_id==stu_id}" >
					<li style="font-size: 13px; margin-top: 20%">시험여부 : ${exam.is_end} / 시험명 : ${exam.exam_name} / 시험날짜 : ${exam.exam_date} / 담당강사 : ${exam.tea_name}</li><br>
					 </c:if>
					</c:forEach>
			             </form>
			          </div>
			        </div>
			        <div class="notice_box" style="height: 350px; ">
			          <div class="box_title">
			            <b>휴가 신청 현황</b>
			            <div class="doc_more more" style="cursor: pointer;" onclick="location.replace('/stuList.do')">
			              <i class="fa fa-plus-square-o" aria-hidden="true"></i>
			            </div>
			          </div>
			          <div class="flex">
			             <form class="boardForm">
						<c:forEach var="stu" items="${stu}" varStatus="vs" end="5">
					<c:if test="${sessionScope.stu_id==stu.stu_id}" >
					<li style="font-size: 13px;">이름 : ${stu.stu_name} / 신청일 : ${stu.application_date} / 종류 : ${stu.dayoff_kind} / 승인여부 : ${stu.payment_status}</li><br>
					</c:if>
					</c:forEach>
					<span onclick="godayForm()" style="cursor: pointer;font-size: 13px; color: blue;">더보기</span>
			             </form>
			          </div>
			        </div>
			        </div>
			        </div>
				
			<form name="dayOffFormLink" method="post" action="/dayOff.do"></form> 
 </body>
<script>
var ATTEND_DATE = [];
<c:forEach var="map" items="${selectCalendarMap.selectCalendar}" varStatus="vs">
ATTEND_DATE.push("${map.attend_date}")
</c:forEach>

var ATTEND_STATUS = [];
<c:forEach var="map" items="${selectCalendarMap.selectCalendar}" varStatus="vs">
<c:if test="${sessionScope.stu_id==map.stu_id}">
ATTEND_STATUS.push("${map.stu_name}")
</c:if>
</c:forEach>

new Chart(document.getElementById("chart"), {
    type: 'pie',
    data: {
      labels: ['출석','지각','조퇴','결석'],
      datasets: [{ 
          data: ['50','30','10','10'],
          label: "출석률",
          backgroundColor: ['blue','green','gold','red'],
          hoverOffset: 4,
          fill: false
        }
      ]
    },
    options: {
    	legend: {
        labels: {
            fontColor: 'black',
            fontSize:14,
        }
    },
      title: {
        display: true,
        position:'bottom',
        fontSize: 15,
        fontStyle:'bold',
        text: ATTEND_STATUS[0]+ '님의 출석률입니다.',
      }
    }
  });
    
</script>

</html>