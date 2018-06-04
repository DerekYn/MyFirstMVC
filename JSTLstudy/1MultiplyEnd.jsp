<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 1. 변수의 선언방법 --%>
<c:set var="no1" value="${param.num1}" />
<c:set var="no2" value="${param.num2}" />  
<c:set var="result" value="${no1 * no2}" />    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>두개의 수를 입력받아서 곱셈하기 결과 출력</title>
</head>
<body>
	${param.num1} 와 ${param.num2} 의 곱은 ? ${result}<br/><br/>
	${no1} 와 ${no2} 의 곱은 ? ${result}
</body>
</html>


