<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common.jsp"%>

<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>휴가 신청</title>
<link href="css/dayOff.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css" integrity="sha512-5A8nwdMOWrSz20fDsjczgUidUBR8liPYU+WymTZP1lmY9G6Oc7HlZv156XqnsgNUzTyMefFTcsFH/tnJE/+xBg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
 </head>
 
 <script>
 
 $(function(){ init(); });
 
 
 function init(){
 	 hidePopup(); 
 	show_and_hide()
 };
 
 function hidePopup(){
 	$("#stuOff").hide();
 	$("#teaOff").hide();
 };
 

function show_and_hide(){
		
<c:if test="${whatRole eq '강사'||whatRole eq '관리자'}">
	$("#StudayOffList").show();
   $("#AlldayOffList").hide();
   
   $(".stu").mouseup(
           function(){
               	
              	$("#StudayOffList").show();
              	$("#AlldayOffList").hide();
              	$(this).addClass('active').siblings('div').removeClass('active');
            })
  	$(".tea").mouseup(
           function(){
              	$("#StudayOffList").hide();
              	$("#AlldayOffList").show();
              	$(this).addClass('active').siblings('div').removeClass('active');
              	}
   )
   </c:if>
   
}
 
 function showStuPopup(){
 	$("#stuOff").show();
 };
 
 function showTeaPopup(){
 	$("#teaOff").show();
 	
 };
 function save(){
		var stuObj = $("#stuOff");
	 	var teaObj = $("#teaOff");
	 	<c:if test="${whatRole eq '학생'}">
	 	var startclock = stuObj.find('[name=dayoff_start]').val()
		var endclock = stuObj.find('[name=dayoff_end]').val()
		if( confirm("신청 하시겠습니까?")==false ) { return; }
			 ajax(
					"/insertStuOff.do"
					,"post"
					,stuObj
					,function(responseJson){
						var StuOffRegCnt = responseJson["StuOffRegCnt"]; 
						if( StuOffRegCnt==1 ){
							alert("신청이 완료되었습니다.");
							document.dayOffFormLink.submit();
						}
						else{
							alert( "신청에 실패하였습니다. 잠시 후에 시도해주세요.");
						}
					}
			);
			</c:if>
			<c:if test="${whatRole eq '강사'}">
	    	var startclock = teaObj.find('[name=tea_dayoff_start]').val()
	    	var endclock = teaObj.find('[name=tea_dayoff_end]').val()
			if( confirm("신청 하시겠습니까?")==false ) { return; }
			 ajax(
					"/insertTeaOff.do"
					,"post"
					,teaObj
					,function(responseJson){
						var TeaOffRegCnt = responseJson["TeaOffRegCnt"]; 
						if( TeaOffRegCnt==1 ){
							alert("신청이 완료되었습니다.");
							document.dayOffFormLink.submit();
						}
						else{alert( "신청에 실패하였습니다. 잠시 후에 시도해주세요.");}
					}
			);
			 </c:if>
	 };

   function payment(e,payment){
	  var formObj = $("#StudayOffList");
	  var formAll = $("#AlldayOffList");
	 	formAll.find("[name='payment']").val(payment);
        formObj.find("[name='payment']").val(payment);
          search();
        };

function pageNoClick( clickPageNo ){
	<c:if test="${whatRole eq '학생'}">
	 var formStu = $("#StudayOffList");
	 formStu.find("[name='selectPageNo']").val(clickPageNo);
          search();
          </c:if>
     <c:if test="${whatRole eq '강사'|| whatRole eq '관리자'}">
     var formAll = $("#AlldayOffList");
     formAll.find("[name='selectPageNo']").val(clickPageNo);
          search();
          </c:if>
};
       
     
    
		function search(){
			   <c:if test="${whatRole eq '학생'}">
		   ajax(
		 		 "/dayOff.do"
		         ,"post"
		         ,$("#StudayOffList")
		         ,function(responseHtml){
		            var obj = $(responseHtml);
		            var searchResultCnt = obj.find("#stuCntAll").html();
		            var searchResult = obj.find("#stu_search_list").html();
		            var pageNos = obj.find("#stu_pageNos").html();
		         	$("#stuCntAll").html( searchResultCnt );
		      		$("#stu_search_list").html( searchResult );
		            $("#stu_pageNos").html( pageNos );
		            alert(pageNos)
		          }
		   );
          </c:if>
          <c:if test="${whatRole eq '강사'|| whatRole eq '관리자'}">
          ajax(
        		 "/dayOff.do"
                ,"post"
                ,$("#AlldayOffList")
                ,function(responseHtml){
                   var obj = $(responseHtml);
                   var tea_searchResultCnt = obj.find("#tea_CntAll").html();
                   var tea_searchResult = obj.find("#tea_search_list").html();
                   var tea_pageNos = obj.find("#tea_pageNos").html();
				$("#tea_CntAll").html( tea_searchResultCnt );
                   $("#tea_search_list").html( tea_searchResult );
                   $("#tea_pageNos").html( tea_pageNos );
                  
                  })
                  ,ajax(
        		 "/dayOff.do"
                ,"post"
                ,$("#StudayOffList")
                ,function(responseHtml){
                   var obj = $(responseHtml);
                   var searchResultCnt = obj.find("#stuCntAll").html();
                   var searchResult = obj.find("#stu_search_list").html();
                   var pageNos = obj.find("#stu_pageNos").html();
                	$("#stuCntAll").html( searchResultCnt );
             		$("#stu_search_list").html( searchResult );
                   $("#stu_pageNos").html( pageNos );
                   
        		 });
          </c:if>
       };
       
       function gostuDetailForm(day_id){
    	      $("[name='DetailForm'] [name='day_id']").val(day_id);
    	      document.DetailForm.submit();
    	   }
       function goteaDetailForm(tea_day_id){
 	      $("[name='DetailForm'] [name='tea_day_id']").val(tea_day_id);
 	      document.DetailForm.submit();
 	   }
   
       function teaStu(contentId) {
           var content = document.getElementById(contentId);
           if (content.style.display === "none") {
               content.style.display = "block";
           } else {
               content.style.display = "none";
           }
       }
 </script>
 
 </head>
 <body>
 <form class="header">
        <div class="header_box">
        <c:if test="${whatRole eq '학생'}">
          	<div class="logo" onclick="location.replace('/stuMain.do')">
				<img src="">
				<div>
					학원명
				</div>
			</div>
			<table>
				<tr class="cate_box">
          			<td class="main_cate" onclick="location.replace('/mark.do')">출석 현황</td>
					<td class="main_cate active" onclick="location.replace('/dayOff.do')">휴가 신청</td>
					<td class="main_cate" onclick="location.replace('/examList.do')">시험</td>
				</tr>
			</table>
		</c:if> 
		
        <c:if test="${whatRole eq '강사'}">
          <div class="logo" onclick="location.replace('/teaMain.do')">
            <img src="">
            <div>
              ERP
            </div>
          </div>
          <table>
            <tr class="cate_box">
			<td class="main_cate" onclick="location.replace('/markTea.do')">수업 관리(출석)</td>
			<td class="main_cate" onclick="location.replace('/stuList.do')">학생 관리</td>
			<td class="main_cate active" onclick="location.replace('/dayOff.do')">휴가 관리</td>
			<td class="main_cate" onclick="location.replace('/examList.do')">시험 출제</td>
          </tr>
          </table>
		</c:if> 
		
		
		<c:if test="${whatRole eq '관리자'}">
          	<div class="logo" onclick="location.replace('/adminMain.do')">
				<img src="">
				<div>
					ERP
				</div>
			</div>
			<table>
				<tr class="cate_box">
	         		<td class="main_cate" onclick="location.replace('/stuList.do')">학생 관리</td>
					<td class="main_cate" onclick="location.replace('/teaList.do')">강사 관리</td>
					<td class="main_cate" onclick="location.replace('/classList.do')">수업 관리</td>
					<td class="main_cate active" onclick="teaStu('teaStu')">결재 관리</td>
<!-- 					 <td id="teaStu" style="display: none; margin-left: 20px;"></td> -->
        			<td class="tea" name="tea" align="center" style="float: left;" onclick="AlldayOffList">ㄴ강사</td>
        			<td class="stu" name="stu" align="center" style="float: left;" onclick="StudayOffList">ㄴ학생</td>
				</tr>
			</table>
		</c:if> 
		<div class="welcome_user">
			<div>
				<div class="welcome_name">로그아웃</div>
			</div>
			<div class="logout_btn" onclick="location.replace('/loginForm.do')"><i class="fa fa-sign-out" aria-hidden="true"></i></div>
		</div>
        </div>
        </form>
        
        <c:if test="${whatRole eq '학생'}">
        <form id="StudayOffList" class="dayOffList">
        <header>휴가 관리</header>
		<table class="search_bar"> 
			<tr>
				<td class="searchbar_box">
				 <input type="text" name="keyword1">
				 <input type="hidden" name="payment">
					<input class="search_btn" type="button" value="검색" onclick="search()" onkeydown="search()">
					<input class="search_btn" type="button" value="휴가 신청" onclick="showStuPopup()">
					
				</td>
			</tr>
		</table>
		<input type="hidden" name="selectPageNo" value="1">
		
		<input type="hidden" name="sort">
		<table>
	        <section class="count_desc">
	          <section class="searchResultCnt">
<div class="impect" id="stuCntAll">전체 : ${getStuOff.dayoffListCnt} 개 </div>
	         </section>
	      <section>
	     <span  onclick="payment(this, '전체')">전체</span>
         <span onclick="payment(this, '미결재')">미결</span>
         <span onclick="payment(this, '승인')">승인</span>
         <span  onclick="payment(this, '반려')">반려</span>
         </section>
	       <select name="rowCntPerPage" onChange="search()" class="rownum">
	                  <option value="10">10 
	                  <option value="15">15 
	                  <option value="20">20 
	            </select>&nbsp;행 
	        </section>
		</table>
		<div>
	</div>
	<div class="search_list" id="stu_search_list">	
			<div>
			<c:if test="${empty requestScope.getStuOff.dayoffList}">
                                 <span style="margin: 45%">정보가 없습니다.</span>
                     </c:if>
				<c:forEach var="board" items="${requestScope.getStuOff.dayoffList}" varStatus="vs">
				<div onClick="gostuDetailForm(${board.day_id})" class="search_con">
						<div class="b_no">${getStuOff.begin_serialNo_desc-vs.index}</div> 
						<div class="subject">${board.dayoff_kind}</div>
						<div class="writer">${board.stu_name}</div>
						<div class="view_i">
							<div class="reg_date list_reg">
								<i class="fa fa-calendar-o" aria-hidden="true"></i>
                <span class="reg_date">${board.application_date}</span>
							</div>
							<div class="readcount">
                <span style="font-size: 12px">${board.payment_status}</span>
							</div> 
						</div>
					</div>
				</c:forEach>
			</div>
		</div>
		<div class="pageNos" id="stu_pageNos"> 
			<span onClick="pageNoClick(1)"><i class="fa fa-angle-left" aria-hidden="true"></i><i class="fa fa-angle-left" aria-hidden="true"></i></span>
			<span onClick="pageNoClick(${requestScope.getStuOff.selectPageNo}-1)"><i class="fa fa-angle-left" aria-hidden="true"></i></span>
			<c:forEach var="pageNo" begin="${requestScope.getStuOff.begin_pageNo}" end="${requestScope.getStuOff.end_pageNo}">
				<c:if test="${requestScope.getStuOff.selectPageNo==pageNo}">
					<span class="isClick">${pageNo}</span>
				</c:if>
				<c:if test="${requestScope.getStuOff.selectPageNo!=pageNo}">
					<span class="unClick" onClick="pageNoClick(${pageNo})">${pageNo}</span>
				</c:if>
			</c:forEach>
			<span onClick="pageNoClick(${requestScope.getStuOff.selectPageNo}+1)"><i class="fa fa-angle-right" aria-hidden="true"></i></span>
			<span onClick="pageNoClick(${requestScope.getStuOff.last_pageNo})"><i class="fa fa-angle-right" aria-hidden="true"></i><i class="fa fa-angle-right" aria-hidden="true"></i></span>
		</div>
		</form>
	</c:if>
	
	
	 
        <c:if test="${whatRole eq '강사'||whatRole eq '관리자'}">
        <form id="AlldayOffList" class="dayOffList">
        <header>강사</header>
		<table class="search_bar"> 
			<tr>
			<td class="searchbar_box">
			<input type="hidden" name="payment">
				<input type="text" name="keyword1">
					<input class="search_btn" type="button" value="검색" onclick="search()"onkeydown="search()">
					<c:if test="${whatRole eq '강사'}">
					<input class="search_btn" type="button" value="휴가 신청" onclick="showTeaPopup()">
					</c:if>
				</td>
			</tr>
		</table>
		<input type="hidden" name="selectPageNo" value="1">
		<input type="hidden" name="sort">
		<table>
	        <section class="count_desc">
	          <section class="searchResultCnt">
	              <div class="impect" id="tea_CntAll">전체 : ${requestScope.getTeaOff.tea_dayoffListCntAll} 개</div> 
	         </section>
	     <section>
	     <span onclick="payment(this, '전체')">전체</span>
         <span onclick="payment(this, '미결재')">미결</span>
         <span onclick="payment(this,'승인')">승인</span>
         <span onclick="payment(this,'반려')">반려</span>
         </section>
	          <select name="rowCntPerPage" onChange="search()" class="rownum">
	                  <option value="10">10 
	                  <option value="15">15 
	                  <option value="20">20 
	            </select>&nbsp;행 
	        </section>
	    </table>
		<div>
	</div>
		<div class="search_list" id="tea_search_list"> 
		
		<c:if test="${empty requestScope.getTeaOff.tea_dayoffList}">
                                 <span style="margin: 45%">정보가 없습니다.</span>
                     </c:if>
			<c:forEach var="board" items="${requestScope.getTeaOff.tea_dayoffList}" varStatus="vs">
					<div onClick="goteaDetailForm(${board.tea_day_id})" class="search_con">
						<div class="b_no">${requestScope.getTeaOff.begin_serialNo_desc-vs.index}</div> 
						<div class="subject">${board.tea_dayoff_kind}</div>
						<div class="writer">${board.tea_name}</div>
						<div class="view_i">
							<div class="reg_date list_reg">
								<i class="fa fa-calendar-o" aria-hidden="true"></i>
                <span class="reg_date">${board.tea_application_date}</span>
							</div>
							<div class="readcount">
                <span style="font-size: 12px">${board.tea_payment_status}</span>
							</div> 
						</div>
					</div>
				</c:forEach>
				<div class="pageNos" id="tea_pageNos"> 
			<span onClick="pageNoClick(1)"><i class="fa fa-angle-left" aria-hidden="true"></i><i class="fa fa-angle-left" aria-hidden="true"></i></span>
			<span onClick="pageNoClick(${requestScope.getTeaOff.selectPageNo}-1)"><i class="fa fa-angle-left" aria-hidden="true"></i></span>
			<c:forEach var="pageNo" begin="${requestScope.getTeaOff.begin_pageNo}" end="${requestScope.getTeaOff.end_pageNo}">
				<c:if test="${requestScope.getTeaOff.selectPageNo==pageNo}">
					<span class="isClick">${pageNo}</span>
				</c:if>
				<c:if test="${requestScope.getTeaOff.selectPageNo!=pageNo}">
					<span class="unClick" onClick="pageNoClick(${pageNo})">${pageNo}</span>
				</c:if>
			</c:forEach>
			<span onClick="pageNoClick(${requestScope.getTeaOff.selectPageNo}+1)"><i class="fa fa-angle-right" aria-hidden="true"></i></span>
			<span onClick="pageNoClick(${requestScope.getTeaOff.last_pageNo})"><i class="fa fa-angle-right" aria-hidden="true"></i><i class="fa fa-angle-right" aria-hidden="true"></i></span>
		</div>
			
			</div>
	</form>
	<form id="StudayOffList" class="dayOffList">
        <header>학생</header>
		<table class="search_bar"> 
			<tr>
				<td class="searchbar_box">
				 <input type="text" name="keyword1">
				 <input type="hidden" name="payment">
					<input class="search_btn" type="button" value="검색" onclick="search()" onkeydown="search()">
					<c:if test="${whatRole eq '강사'}">
					<input class="search_btn" type="button" value="휴가 신청" onclick="showTeaPopup()">
					</c:if>
				</td>
			</tr>
		</table>
		<input type="hidden" name="selectPageNo" value="1">
		<input type="hidden" name="sort">
		<table>
	        <section class="count_desc">
	          <section class="searchResultCnt">
 <div class="impect" id="stuCntAll">전체 : ${requestScope.getStuOff.dayoffListCntAll} 개 </div> 
	         </section>
		      <section>
		     <span  onclick="payment(this, '전체')">전체</span>
	         <span onclick="payment(this, '미결재')">미결</span>
	         <span onclick="payment(this, '승인')">승인</span>
	         <span  onclick="payment(this, '반려')">반려</span>
	         </section>
	       <select name="rowCntPerPage" onChange="search()" class="rownum">
	                  <option value="10">10 
	                  <option value="15">15 
	                  <option value="20">20 
	            </select>&nbsp;행 
	        </section>
		</table>
		<div>
	</div>
	<div class="search_list" id="stu_search_list">	
			<div>
			<c:if test="${empty requestScope.getStuOff.dayoffList}">
                                 <span style="margin: 45%">검색결과가 없습니다.</span>
                     </c:if>
				<c:forEach var="board" items="${requestScope.getStuOff.dayoffList}" varStatus="vs">
				<div onClick="gostuDetailForm(${board.day_id})" class="search_con">
						<div class="b_no">${requestScope.getStuOff.begin_serialNo_desc-vs.index}</div> 
						<div class="subject">${board.dayoff_kind}</div>
						<div class="writer">${board.stu_name}</div>
						<div class="view_i">
							<div class="reg_date list_reg">
								<i class="fa fa-calendar-o" aria-hidden="true"></i>
                <span class="reg_date">${board.application_date}</span>
							</div>
							<div class="readcount">
                <span style="font-size: 12px">${board.payment_status}</span>
							</div> 
						</div>
					</div>
				</c:forEach>
			</div>
		</div>
		<div class="pageNos" id="stu_pageNos"> 
			<span onClick="pageNoClick(1)"><i class="fa fa-angle-left" aria-hidden="true"></i><i class="fa fa-angle-left" aria-hidden="true"></i></span>
			<span onClick="pageNoClick(${requestScope.getStuOff.selectPageNo}-1)"><i class="fa fa-angle-left" aria-hidden="true"></i></span>
			<c:forEach var="pageNo" begin="${requestScope.getStuOff.begin_pageNo}" end="${requestScope.getStuOff.end_pageNo}">
				<c:if test="${requestScope.getStuOff.selectPageNo==pageNo}">
					<span class="isClick">${pageNo}</span>
				</c:if>
				<c:if test="${requestScope.getStuOff.selectPageNo!=pageNo}">
					<span class="unClick" onClick="pageNoClick(${pageNo})">${pageNo}</span>
				</c:if>
			</c:forEach>
			<span onClick="pageNoClick(${requestScope.getStuOff.selectPageNo}+1)"><i class="fa fa-angle-right" aria-hidden="true"></i></span>
			<span onClick="pageNoClick(${requestScope.getStuOff.last_pageNo})"><i class="fa fa-angle-right" aria-hidden="true"></i><i class="fa fa-angle-right" aria-hidden="true"></i></span>
		</div>
		</form>
	</c:if>
        
	  
<c:if test="${whatRole eq '학생'}">
<form class='dayOffForm' id="stuOff">
	<div class="dim">
	<div class='dayOffForm_popup'>
    <header>
    	휴가 신청
    </header>
      <div>
          휴가 시작일
          <input type="datetime-local" name="dayoff_start">
          &nbsp;~&nbsp;  
          휴가 종료일
          <input type="datetime-local" name="dayoff_end">
     </div>
   	 <div>
   	   	휴가 종류
   	    <select name="dayoff_kind">
	   	    <option value="">	
			<option value="휴가">휴가
			<option value="병가">병가
			<option value="조퇴">조퇴
			<option value="지각">지각
			<option value="기타">기타
		</select>
   	</div>
	   <div>
			신청자 :
			<input type="text">
	   </div>
	   <div>
	         내용
	            <textarea cols="100" rows="15" name="etc"></textarea>
	   </div> <br>
   <div>
   <input type="hidden"  name="stu_id" value="${stu_id}">
    	<input type="button" value="취소" onClick="hidePopup()">
    	<input type="button" class="save_btn" value="제출" onClick="save()">
   </div> 
  </div>
  </div>
</form>
</c:if>

 
<c:if test="${whatRole eq '강사'}">
<form class='dayOffForm' id="teaOff">
	<div class="dim">
	<div class='dayOffForm_popup'>
    <header>
    	휴가 신청
    </header>
      <div>
          휴가 시작일
          <input type="datetime-local" name="tea_dayoff_start">
          &nbsp;~&nbsp;  
          휴가 종료일
          <input type="datetime-local" name="tea_dayoff_end">
     </div>
   	 <div>
   	   	휴가 종류
   	    <select name="tea_dayoff_kind">
	   	    <option value="">	
			<option value="연차">연차
			<option value="반차">반차
			<option value="병가">병가
			<option value="휴직">휴직
			<option value="기타">기타
		</select>
   	</div>
	   <div>
			신청자 :
	            <input type="text">
	   </div>
	   <div>
	         내용
	            <textarea cols="100" rows="15" name="tea_etc"></textarea>
	   </div> <br>
   <div>
     <input type="hidden" name="tea_id" value="${tea_id}">
    	<input type="button" value="취소" onClick="hidePopup()">
    	<input type="button" class="save_btn" value="제출" onClick="save()">
   </div> 
  </div>
  </div>
</form>

</c:if>
<form name="DetailForm" action="/dayOffDetailForm.do" post="post"> 
<input type="hidden" name="day_id">
<input type="hidden" name="tea_day_id">
</form>
<form name="dayOffFormLink" method="post" action="/dayOff.do"></form> 
 </body>
 </html>