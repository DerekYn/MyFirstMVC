<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>반복문 연습</title>
</head>
<body>
	<c:forEach var="i" begin="1" end="5">
		<h${i}>반복문 연습</h${i}>
	</c:forEach>
</body>
</html>