<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<jsp:include page="../header.jsp" />

<style type="text/css">
   div.div_inlineblock {display: inline-block;
   						border: 0px solid red;
   						margin-top: 20px;}

   .th {text-align: center;}
   .td {text-align: center;}
   
   .namestyle {background-color: cyan;  /* cyan => 하늘색 */
      	       font-weight: bold;
    	       font-size: 12pt;
    	       color: blue;
    	       cursor: pointer; }
</style>

<script type="text/javascript">
  
  $(document).ready(function(){
	  
	  $("#searchType").val("${searchType}"); 
	  
	  $("#searchWord").val("${searchWord}");
	   
	  $("#sizePerPage").val("${sizePerPage}");
	  
	  $("#period").val("${period}");
	  
	  
	  $("#sizePerPage").bind("change", function(){
		 var frm = document.memberFrm;
		 frm.method = "get";
		 frm.action = "memberList.do";
		 frm.submit();
	  });
	  
	  $("#period").bind("change", function(){
		 var frm = document.memberFrm;
		 frm.method = "get";
		 frm.action = "memberList.do";
		 frm.submit();
	  });
	  
	  
	  $("#searchWord").bind("keydown", function(event){
		  var keyCode = event.keyCode;
		  if(keyCode == 13) {
			  goSearch();
		  }
	  }); 
	  
	  
	  $(".name").bind("mouseover", function(event){
		  var $target = $(event.target);
		  $target.addClass("namestyle");
	  });
	  
	  
	  $(".name").bind("mouseout", function(event){
		  var $target = $(event.target);
		  $target.removeClass("namestyle");
	  });
	  
  });// end of $(document).ready()----------------------------------

  
    function goDetail(idx, goBackURL) {
	  
	    var frm = document.idxFrm;
	    frm.idx.value = idx;
	    frm.goBackURL.value = goBackURL;
	 
	    frm.method = "get";
	    frm.action = "memberDetail.do";
	    frm.submit();
	  
    }// end of function goDetail()--------------------------------------
  
	
	function goDel(idx, goBackURL) {
		
	//	window.alert("대한민국");
	//	alert("서울시");
		
	//	window.confirm("강남구가 맞습니까?");
	//	confirm("역삼동이 맞습니까?");
	
	    var bool = confirm(idx + "번 회원정보를 정말로 삭제하시겠습니까?");
	//  alert(bool);  ==> true / false
	    
	    if(bool) {
	    	var frm = document.idxFrm;
	    	frm.idx.value = idx;
	    	frm.goBackURL.value = goBackURL;
	    	
	    	frm.action = "memberDelete.do";
	    	frm.method = "post";
	    	frm.submit();
	    }
		
	}// end of goDel(idx, goBackURL)--------------------------   
	
	
	function goRecover(idx, goBackURL) {
		
		var bool = confirm(idx + "번 회원정보를 정말로 복구하시겠습니까?");
		//  alert(bool);  ==> true / false
	    
		if(bool) {
	    	var frm = document.idxFrm;
	    	frm.idx.value = idx;
	    	frm.goBackURL.value = goBackURL;
	    	
	    	frm.action = "memberRecover.do";
	    	frm.method = "post";
	    	frm.submit();
	    }
			
	}// end of goRecover(idx, goBackURL)------------------------  
	
	
	function goEdit(idx, goBackURL) {
		
		// 팝업창 띄우기
		var url = "memberEdit.do?idx="+idx+"&goBackURL="+goBackURL;
		
		window.open(url,"memberEdit",
                   "left=350px, top=100px, width=700px, height=600px");
		
	}// end of goEdit(idx)------------------------------------
	
	
	function goSearch() {
			  
	     if( $("#searchWord").val().trim() == "") {
	 		// 검색어가 공백으로만 되었다면 
	 		   alert("검색어를 입력하세요!!");
	 		   $("#searchWord").val("");
	 		   $("#searchWord").focus();
	 		   return;
	 		 /*
	 		     javascript:history.go(-1); ==> 뒤로가기
	 		     javascript:history.go(1);  ==> 앞으로가기
	 		     javascript:history.go(0);  ==> 새로고침
	 		     
	 		     javascript:history.back();    ==> 뒤로가기
	 		     javascript:history.forward(); ==> 앞으로가기
	 		  */
	 	  }
	 	  else {
	 		  	var frm = document.memberFrm;
	 		  	frm.method="get";
	 		  	frm.action="memberList.do";
	 		  	frm.submit();
	 	  }
	   }// end of function goSearch()-----------------------------------
	
</script>

<form name="memberFrm">
	<div class="div_inlineblock" style="padding-left: 80px;">
		<h2>::: 회원전체 정보보기 :::</h2>
	</div>
	
	<div class="div_inlineblock" style="margin-left: 80px;">	
		<span style="color: red; font-weight: bold; font-size: 12pt;">페이지당 회원명수-</span>
		<select name="sizePerPage" id="sizePerPage">
			<option value="10">10</option>
			<option value="5">5</option>
			<option value="3">3</option>
		</select>
	</div>
	
	<div style="margin-top: 20px;">
		<select id="searchType" name="searchType">
			<option value="name">회원명</option>
			<option value="userid">아이디</option>
			<option value="email">이메일</option>
		</select>
	
		<input type="text" name="searchWord" id="searchWord" size="25" class="box" />
		
		<select id="period" name="period">
			    <option value="">날짜선택</option>
				<option value="-1">전체</option>
				<option value="3">최근 3일 이내</option>
				<option value="10">최근 10일 이내</option>
				<option value="30">최근 30일 이내</option>
				<option value="60">최근 60일 이내</option>
		</select>
			
		<input type="button" value="검색" onClick="goSearch();" style="margin-left: 10px;" />	
    </div>
</form>

<table class="outline" style="margin-top: 20px;">
	<thead>
	<tr>
		<th class="th">회원번호</th>
		<th class="th">회원명</th>
		<th class="th">아이디</th>
		<th class="th">이메일</th>
		<th class="th">휴대폰</th>
		<th class="th">가입일자</th>
		<c:if test="${(sessionScope.loginuser).userid == 'admin' }">
		<th class="th">수정&nbsp;|&nbsp;삭제</th>
		</c:if>
	</tr>
	</thead>
	
	<tbody>
	<c:if test="${empty memberList }">
	    <tr>
	       <td colspan="7">
	       		가입된 회원이 없습니다.
	       </td>
	    </tr>
	</c:if>
	
	<c:if test="${not empty memberList }">
		<c:forEach var="mbrvo" items="${memberList}">
			<c:if test="${mbrvo.status == 0 }">
				<tr style="background-color: pink;">
			</c:if>
			<c:if test="${mbrvo.status != 0 }">
				<tr>
			</c:if>
					<td class="td">${mbrvo.idx}</td>
					<td class="td name" onClick="goDetail('${mbrvo.idx}','${currentURL}');">${mbrvo.name}</td>
					<td class="td">${mbrvo.userid}</td>
					<td class="td">${mbrvo.email}</td>
					<td class="td">${mbrvo.allHp}</td>
					<td class="td">${mbrvo.joindate}</td>
				<c:if test="${(sessionScope.loginuser).userid == 'admin' }">	
					<c:if test="${mbrvo.status == 0 }">
						<td class="td" style="background-color: gray; color: white; cursor: pointer;" onclick="goRecover('${mbrvo.idx}','${currentURL}');">복구&nbsp;</td>
					</c:if>
					<c:if test="${mbrvo.status != 0 }">
						<td class="td"><a href="javascript:goEdit('${mbrvo.idx}','${currentURL}')">수정</a>&nbsp;<a href="javascript:goDel('${mbrvo.idx}','${currentURL}');">삭제</a></td>
					</c:if>
				</c:if>
			</tr>
		</c:forEach>
	</c:if>
	
	<tr>
		<th colspan="5" style="text-align: center;">
			${pageBar}
		</th>
		
		<th colspan="2" style="text-align: right;">
			<span style="color: red; font-weight: bold;">현재[${currentShowPageNo}]페이지</span> / 총[${totalPage}]페이지 &nbsp; 
			회원수 : 총${totalMemberCount}명
		</th>
	</tr>
	</tbody>
</table>

<%-- 특정 회원의 정보를 조회후 변경/삭제/복구 해주는 폼생성하기 --%>
<form name="idxFrm">
	<input type="hidden" name="idx" />
	<input type="hidden" name="goBackURL" />
</form>

<jsp:include page="../footer.jsp" />


