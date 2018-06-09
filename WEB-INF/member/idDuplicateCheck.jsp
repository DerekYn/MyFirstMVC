<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>   
<%
    String ctxname = request.getContextPath();
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>중복 ID 검사하기</title>
<link rel="stylesheet" type="text/css" href="<%= ctxname %>/css/style.css" />
<script type="text/javascript" src="<%= ctxname %>/js/jquery-3.3.1.min.js"></script>
<script type="text/javascript">
	
	$(document).ready(function() {
		
		$("#userid").val("${userid}");
		
		$("#errmsg").hide();
		
		$("#userid").keydown(function(event){
		//	console.log(event.keyCode); 키값을 알아오는 메소드 엔터는 13
			if(event.keyCode == 13){
				// 엔터를 했을 경우
				goCheck();
			}
			
		});
		
		
	});
	
	function goCheck(){
		
		var userid = $("#userid").val().trim();
		
		if(userid == ""){
			$("#errmsg").show();
			$("#userid").val("");
			$("#userid").focus();
			return;
			
		}else{
			$("#errmsg").hide();
			var frm = document.frmIdcheck;
			frm.method = "post";
			frm.action = "idDuplicateCheck.do";
			frm.submit();   
			
		}
		
	       
		
	}
	
	/*	
	// *** 팝업창에서 부모창으로 값 넘기기 일반적인 방법 ***
	function setUserID(userid) {
		var openerfrm = opener.document.registerFrm;
		// opener는 팝업창을 열게한 부모창을 말한다.
		// 여기서 부모창은 memberform.jsp 페이지이다.
		
		openerfrm.userid.value = userid;
		openerfrm.pwd.focus();
		
		self.close();
		// 여기서 self 는 팝업창 자기자신을 말한다.
		// 지금의 self 는 idceheck.jsp 페이지이다.
		
	}// end of setUserID(userid)---------------

	*/
	// *** 팝업창에서 부모창으로 값 넘기기 jQuery를 사용한 방법 ***
 	
	function setUserID(userid) {
	//	$("#userid", opener.document).val(userid);
	//  또는 
		$(opener.document).find("#userid").val(userid);
		
	//	$("#pwd", opener.document).focus();
	//  또는
		$(opener.document).find("#pwd").focus();
		self.close();
	}
	
	
	 
</script>



</head>
<body style="background-color: #fff0f5;">
<%-- <%
	String method = request.getMethod();

%>
	<span style="font-size: 10pt; font-weight: bold;"> <%= method %> </span>
<%
	if("GET".equalsIgnoreCase(method)){
		// 전송방식이 GET 이라면 ID 중복검사를 하기위한 폼을 띄어준다.
%>		 --%>
	<form name="frmIdcheck">
		<table style="width: 95%; height: 90%;">
			<tr>
				<td style="text-align: center;">
					아이디를 입력하세요 <br style="line-height: 200%" />
					<input type="text" id="userid" name="userid" size="20" class="box"/> <br style="line-height: 300%" />
					<button type="button" class="box" onClick="goCheck();">확인</button>
					<c:if test="${check == '1'}">
						<button type="button" class="box" onClick="setUserID('${userid}');">사용하기</button>
					</c:if>
				</td>
			</tr>
			<tr>
				<td id="errmsg">
					<span style="color: red; font-size: 16pt; font-weight: bold;">아이디를 입력하세요 !!</span>
				</td>
			</tr>
		</table>
	</form>
	
	
	<c:if test="${check == '1'}">
		
		<div align="center">
			ID로[<span style="color: red; font-weight: bold;">${userid}</span>] 사용가능 합니다.
			<br style="line-height: 200%" />
		</div>
	
	</c:if>
	<c:if test="${check == '0'}">
		
		<div align="center">
			<span style="color: red; font-weight: bold;">${userid}는 이미 사용중입니다</span> 
			<br style="line-height: 200%" />
		</div>
	
	</c:if>	

</body>
</html>