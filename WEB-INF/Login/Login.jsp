<%@page import="member.model.MemberVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script type="text/javascript" src="<%= request.getContextPath() %>/js/jquery-3.3.1.min.js"></script>
<script type="text/javascript">

	$(document).ready(function(){
		
		$("#urlText").val("${urlText}")
		
		$("#btnSubmit").click(function(event){
			goSubmit(event);
		
		}); // end of ("#btnSubmit").click() ----------------------
		
		
		$("#LoginPwd").keydown(function(event){
			//	console.log(event.keyCode); 키값을 알아오는 메소드 엔터는 13
				if(event.keyCode == 13){
					// 엔터를 했을 경우
					 goSubmit(event);
				}
				
		});// end of $("#LoginPwd").keydown() ----------------------------
		
	});
	
	function goSubmit(event){
		
		var userid = $("#LoginUserid").val().trim();
		var pwd = $("#LoginPwd").val().trim();

		if(userid.length == 0){
			alert("아이디를 입력해주세요");
			$("#LoginUserid").val("");
			$("#LoginUserid").focus();
			return;
			
		}else if(pwd.length == 0){
			alert("비밀번호를 입력해주세요");
			$("#LoginPwd").val("");
			$("#LoginPwd").focus();
			return;
		}
		
		var frm = document.LoginFrm;
		frm.method = "post";
		frm.action = "loginEnd.do";
		frm.submit();
		
	}
	
	function goLogout() {
		
		location.href="<%= request.getContextPath() %>/logout.do";
		
	}// end of goLogOut() ---------------------------
	
</script>
<style type="text/css">
	table#loginTbl{width: 95%;
				   border: solid gray 1px;
				   border-collapse: collapse;}
    #th {background-color: silver;
         font-size: 14pt;}
         
    table#loginTbl td {border: solid gray 1px;}     				   
	
</style>

<%
	String goBackURL = util.my.MyUtil.getCurrentURL(request);
	// WEB-INF/member/memberList.jsp?currentShowPageNo=6&sizePerPage=10

	// http://localhost:9090/MyMVC/memoList.do?currentShowPageNo=8&sizePerPage=10
	
	int index = goBackURL.indexOf("?");
	
	String addURL = "";
	
	if(index > 0){ // GET 방식 
		addURL = goBackURL.substring(index);
		// ?currentShowPageNo=6&sizePerPage=10
				
		goBackURL = goBackURL.substring(0, index);
		// WEB-INF/member/memberList.jsp 
		
		
	}
	// get,post 모두 적용되는것
	
	int lastindex = goBackURL.lastIndexOf("/"); // 마지막으로 나오는 "/" 의 index를 알려준다
	goBackURL = goBackURL.substring(lastindex+1);
 
	switch (goBackURL) {
		case "index.jsp":
			goBackURL = "index.do";
			break;
			
		case "memoForm.jsp":
			goBackURL = "memo.do";
			break;
		
			
		case "memoListJST.jsp":
			goBackURL = "memoList.do"+addURL;
			break;
		
		case "memoListJSTVO.jsp":
			goBackURL = "memoVOList.do"+addURL;
			break;
			
		default:
			break;
	}  
	
	
	
%>

<%-- 로그인 하기 이전 상태 ==> session 에 키값 "loginuser"이 없는 상태이다. --%>
<%
	MemberVO membervo = (MemberVO)session.getAttribute("loginuser");

	if(membervo == null) {
%>
	<form name="LoginFrm">
		<input type="hidden" name="goBackURL" value="<%= goBackURL %>" />
		<table id="loginTbl">
			<thead>
				<tr>
					<th colspan="2" id="th" style="text-align: center;">LOGIN</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td style="width: 30%; border-bottom: hidden; border-right: hidden; padding: 10px;">ID</td>
					<td style="width: 70%; border-bottom: hidden; border-left: hidden; padding: 10px;"><input type="text" name="userid" id="LoginUserid" size="13" class="box"/></td>
				</tr>
				<tr>
					<td style="width: 30%; border-top: hidden; border-bottom: hidden; border-right: hidden; padding: 10px;">암호</td>
					<td style="width: 70%; border-top: hidden; border-bottom: hidden; border-left: hidden; padding: 10px;"><input type="password" name="pwd" id="LoginPwd" size="13" class="box"/></td>
				</tr>
				<%-- 아이디 찾기, 비밀번호 찾기 --%>
				<tr>
					<td colspan="2" align="center">
						<a style="cursor: pointer;">아이디찾기</a>
						<a style="cursor: pointer;">비밀번호찾기</a>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center" style="padding: 10px;">
						<input type="checkbox" name="saveid" id="saveid" /><label for="saveid">아이디 저장</label>
						<button type="button" id="btnSubmit" style="width: 67px; height: 27px; background-image: url('<%= request.getContextPath() %>/images/login.png'); vertical-align: middle; border: none;" />
					</td>
				</tr>
			</tbody>
		</table>
	</form>
<%
	}else{
%>
	<table style="width: 95%; height: 130px;">
		<tr style="background-color: pink;">
			<td align="center">
				<span style="color: blue; font-weight: bold;"><%= membervo.getName() %></span>
				[<span style="color: red; font-weight: bold;"><%= membervo.getUserid() %></span>]	
				
				<span style="color: blue; font-weight: bold;">${(sessionScope.loginuser).name}</span>
				[<span style="color: red; font-weight: bold;">${(sessionScope.loginuser).userid}</span>]	
				<br/>
				<div align="left">
					<br/>로그인 중...<br/><br/>
					[<a href="">나의정보</a>]
					<button type="button" onclick="goLogout();">로그아웃</button>
				</div>	
			</td>
		</tr>
	</table>

<%		
	}
	
	
%>
		

	


 

    