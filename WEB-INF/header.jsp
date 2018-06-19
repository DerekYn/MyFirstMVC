<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
    String ctxname = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" type="text/css" href="<%= ctxname %>/bootstrap-3.3.7-dist/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="<%= ctxname %>/css/style.css" />
<script type="text/javascript" src="<%= ctxname %>/js/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="<%= ctxname %>/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<title>:::HOMEPAGE:::</title>

<script type="text/javascript">
	$(document).ready(function(){
		
	/* 
		var vhtml = "";
		for(var i=0; i<15; i++) {
			vhtml += (i+1)+".내용물<br/>";
		}
		
		$("#sideconent").html(vhtml); 
	*/
		
	});

</script>

</head>
<body>

<div id="mycontainer">

	<div id="headerImg">
		1. 로고이미지/네비게이터
	</div>
	
	<div id="headerLink">		
		<a href="<%= ctxname %>/index.do">HOME</a>&nbsp;|&nbsp;
		<%
		   if(session.getAttribute("loginuser") == null) {
		%>
		    <a href="<%= ctxname %>/memberRegister.do">회원가입</a>&nbsp;|&nbsp;
		<%
		   }
		%>
		
		<a href="<%= ctxname %>/memberList.do">회원목록</a>&nbsp;|&nbsp;
		
		<c:if test="${sessionScope.loginuser != null}">
			<a href="<%= ctxname %>/memo.do">한줄메모쓰기</a>&nbsp;|&nbsp;
			<a href="<%= ctxname %>/memoList.do">메모조회(HashMap)</a>&nbsp;|&nbsp;
			<a href="<%= ctxname %>/memoVOList.do">메모조회(VO)</a>&nbsp;|&nbsp;
		</c:if>
	
	
		<a href="<%= ctxname %>/malldisplay.do">쇼핑몰 홈</a>&nbsp;|&nbsp;
		
		
		<%-- <c:if test="${sessionScope.loginuser != null && !(sessionScope.loginuser).userid.equals('admin') }"> --%>
		<%-- <c:if test="${sessionScope.loginuser != null && (sessionScope.loginuser).userid != 'admin'}"> --%>
		<c:if test="${sessionScope.loginuser != null && (sessionScope.loginuser).userid ne 'admin'}">
			<a href="<%= ctxname %>/cartList.do">장바구니</a>&nbsp;|&nbsp;
			<br/>
			<a href="<%= ctxname %>/orderList.do">나의 주문내역</a>&nbsp;|&nbsp;
			<a href="<%= ctxname %>/myOrderStaticsChart.do">나의 주문성향</a>&nbsp;|&nbsp;
			<a href="<%= ctxname %>/allProductLikeDislikeStaticsChart.do">Like & DisLike</a>&nbsp;|&nbsp;
		</c:if>
		
		<c:if test="${sessionScope.loginuser != null && (sessionScope.loginuser).userid eq 'admin'}">
			<br/><a href="<%= ctxname %>/orderList.do">전체 주문내역</a>&nbsp;|&nbsp;
			<a href="<%= ctxname %>/admin/totalOrderStaticsChart.do">월별 주문통계</a>&nbsp;|&nbsp;
			<a href="<%= ctxname %>/admin/productRegister.do">제품 등록</a>&nbsp;|&nbsp;
		</c:if>
		<a data-toggle="modal" data-target="#searchStore" data-dismiss="modal">매장찾기</a>&nbsp;|&nbsp;
	    	                               <!-- #searchStore 에 대한 내용은 footer.jsp 에 있음 -->
	</div>
			
    <div id="goldline"></div>
	
	<div id="sideinfo">
		<div style="padding: 10px;">
			2. 로그인<br/><br/>
			<%@ include file="/WEB-INF/login/login.jsp" %>
		</div>
		<div style="margin-top: 10px; padding: 10px;">
			<%@ include file="/WEB-INF/myshop/categoryList.jsp" %>
		</div>
	</div>
	
	<div id="content" align="center">
	