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
<title></title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" type="text/css" href="<%= ctxname %>/bootstrap-3.3.7-dist/css/bootstrap.min.css">
<script type="text/javascript" src="<%= ctxname %>/js/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="<%= ctxname %>/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>

<div class="container">
  <h2>Bordered Table</h2>
  <p>The .table-bordered class adds borders to a table:</p>            
  <table class="table table-bordered">
    <thead>
      <tr>
        <th>순서</th>
        <th>글번호</th>
        <th>글제목</th>
        <th>글내용</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="map" items="${contentList}" varStatus="status">
      	<tr>
      		<td>${status.count}</td>
      		<td>${map.seq}</td>
      		<td>${map.title}</td>
      		<td>${map.content}</td>
      	</tr>
      </c:forEach>
    </tbody>
  </table>
  <div align="center">
  	<button type="button" onClick="javascript:location.href='wordSearch.do'">돌아가기</button>
  </div>
</div>
</body>
</html>