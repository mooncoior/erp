<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common.jsp"%>

<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="css/mainpage.css">
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css" integrity="sha512-5A8nwdMOWrSz20fDsjczgUidUBR8liPYU+WymTZP1lmY9G6Oc7HlZv156XqnsgNUzTyMefFTcsFH/tnJE/+xBg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script>

$(function(){init();})

function init(){ 
}

		// 구글 차트 사용
		google.charts.load('current', {'packages':['corechart']});
        google.charts.setOnLoadCallback(drawCharts);
        
        function drawCharts() {
        	drawPieChart1();
        	drawPieChart2();
            drawLineChart();
        }

     // 첫 번째 원 차트
        function drawPieChart1() {
            var data = google.visualization.arrayToDataTable([
                ['인원', '명'],
                ['근무자', ${ManaListMap.teaCnt[0].WORK_TEA_CNT}],
                ['휴가자', ${ManaListMap.teaCnt[0].DAYOFF_TEA_CNT}]
            ]);

            var options = {
            		 pieSliceText: '명'
            };

            var chart = new google.visualization.PieChart(document.getElementById('piechart1'));
            chart.draw(data, options);
        }

        // 두 번째 원 차트
        function drawPieChart2() {
            var data = google.visualization.arrayToDataTable([
                ['수업', '개'],
                ['수업 중', ${ManaListMap.classInfoCnt[0].due_class_cnt}],
                ['수업 예정', ${ManaListMap.classInfoCnt[0].yet_class_cnt}],
                ['수업 종료', ${ManaListMap.classInfoCnt[0].end_class_cnt}]
            ]);

            var options = {
            };

            var chart = new google.visualization.PieChart(document.getElementById('piechart2'));
            chart.draw(data, options);
        }

        
        // 선 차트
        function drawLineChart() {
            // 오늘 날짜 가져오기
            var today = new Date();
            var dates = [];

            // 오늘부터 6일 전까지의 날짜 계산하여 배열에 저장
            for (var i = 6; i >= 0; i--) {
                var date = new Date(today);
                date.setDate(today.getDate() - i);
                var month = date.getMonth() + 1;
                var day = date.getDate();
                var formattedDate = month + '월 ' + day + '일';
                dates.push(formattedDate);
            }

            // 데이터 가져오기
            var registStuCnt = [
                ${ManaListMap.RegistStuCnt[0].get("COUNT_6")},
                ${ManaListMap.RegistStuCnt[0].get("COUNT_5")},
                ${ManaListMap.RegistStuCnt[0].get("COUNT_4")},
                ${ManaListMap.RegistStuCnt[0].get("COUNT_3")},
                ${ManaListMap.RegistStuCnt[0].get("COUNT_2")},
                ${ManaListMap.RegistStuCnt[0].get("COUNT_1")},
                ${ManaListMap.RegistStuCnt[0].get("COUNT_0")}
            ];

            // 최대값 계산
            var maxValue = Math.max.apply(Math, registStuCnt);

            // 최대값에 5를 더하여 세로축의 최대값 설정
            var vAxisMax = maxValue + 5;

            var data = google.visualization.arrayToDataTable([
                ['날짜', '등록 학생 수'],
                [dates[0], registStuCnt[0]],
                [dates[1], registStuCnt[1]],
                [dates[2], registStuCnt[2]],
                [dates[3], registStuCnt[3]],
                [dates[4], registStuCnt[4]],
                [dates[5], registStuCnt[5]],
                [dates[6], registStuCnt[6]]
            ]);

            var options = {
                curveType: 'function',
                legend: { position: 'bottom' },
                vAxis: { maxValue: vAxisMax } // 세로축 최대값 설정
            };

            var chart = new google.visualization.LineChart(document.getElementById('curve_chart'));

            chart.draw(data, options);
        }
    
    


function goBoardDetailForm(b_no){
   $("[name='boardDetailForm'] [name='b_no']").val(b_no);
   
   document.boardDetailForm.submit();
}

function goGyeoljaeDetailForm(gyeoljae_num){
   $("[name='gyeoljaeDetailForm'] [name='gyeoljae_num']").val(gyeoljae_num);
   document.gyeoljaeDetailForm.submit();
}

</script>

<title>메인</title>
</head>
<body>
  <form class="header">
    <div class="header_box">
      <div class="logo" onclick="location.replace('/adminMain.do')">
        <img src="">
        <div>
          ERP
        </div>
      </div>
      <table>
          <tr>
          <td class="main_cate" onclick="location.replace('/stuList.do')">학생 관리</td>
          <td class="main_cate" onclick="location.replace('/teaList.do')">강사 관리</td>
          <td class="main_cate" onclick="location.replace('/classList.do')">수업 관리</td>
          <td class="main_cate" onclick="location.replace('/dayOff.do')">결재 관리</td>
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
          <div class="box_title">
				등록 학생 수 현황 
            <div class="doc_more more" style="cursor: pointer;" onclick="location.replace('/stuList.do')">
              <i class="fa fa-plus-square-o" aria-hidden="true"></i>
            </div>
          </div>
          <div class="list">
	          <form name="boardSearchForm" class="boardForm">
	           <div id="curve_chart" style="width: 600px; height: 350px"></div>
	          </form>
          </div>
        </div>
        
        <div class="document_box">
          <div class="box_title">강사 현황
            <div class="notice_more more" onclick="location.replace('/teaList.do')">
              <i class="fa fa-plus-square-o" aria-hidden="true"></i>
            </div>
          </div>
          <div class="list">
           <form name="gyeoljaeSearchForm" class="boardForm" action="hh">
           <div id="piechart1" style="width: 600px; height: 350px;"></div>
           </form>
          </div>
        </div>
        </div>
      <div class="main_info">
        <div class="document_box">
          <div class="box_title">수업 현황
            <div class="notice_more more" onclick="location.replace('/classList.do')">
              <i class="fa fa-plus-square-o" aria-hidden="true"></i>
            </div>
          </div>
          <div class="list">
           <form name="gyeoljaeSearchForm" class="boardForm" action="hh">
           <div id="piechart2" style="width: 600px; height: 350px;"></div>
           </form>
          </div>
        </div>
        <div class="document_box">
          <div class="box_title">결재 현황
            <div class="notice_more more" onclick="location.replace('/dayoff.do')">
              <i class="fa fa-plus-square-o" aria-hidden="true"></i>
            </div>
          </div>
          <div class="list">
           <form name="gyeoljaeSearchForm" class="boardForm" action="hh">
           <c:forEach var="dayoffInfo" items="${ManaListMap.dayoffInfo}" varStatus="vs">
	           <div class="flex">
		           <div class="status">${dayoffInfo.status }</div>
		           <div>${dayoffInfo.dayoff_kind }</div>
		           <div>${dayoffInfo.who_name }</div>
		           <div>${dayoffInfo.regist_date }</div>
	           </div>
           </c:forEach>
           </form>
          </div>
        </div>
      </div>
    </div>
  
</body>
</html>