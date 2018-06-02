<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 사진 정보</title>
</head>
<body>

<div id="container">
	<c:set var="imgpath" value="/MyMVC/images" /> <%-- 그냥 재정의 같은것 --%>
	<c:forEach var="imgvo" items="${imgList}">
		<div style="margin-bottom: 20px;">
			<img src="${imgpath}/${imgvo.img}" />
			<br/>${imgvo.name}
		</div>
	</c:forEach>
</div>

</body>
</html>