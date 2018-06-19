<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:include page="header.jsp" />

<!-- 내용물 시작 -->

	<h2>${msg}</h2>
    <div style="width: 90%; border: 1px solid red; border-top-style: hidden; border-left-style: hidden; border-right-style: hidden;">&nbsp;</div>
	<h4>MVC패턴에 대해 공부를 해보즈아.</h4>
	
	<div style="height: 150px; text-align: center; padding: 20px;">
		3-1. Contents-1 입니다.
	</div>
	<div style="height: 150px; text-align: center; padding: 20px;">
		3-2. Contents-2 입니다.
		</div>
		<div style="height: 150px; text-align: center; padding: 20px;">
		3-3. Contents-3 입니다.
		</div>
<!-- 내용물 끝 -->
<jsp:include page="footer.jsp" />