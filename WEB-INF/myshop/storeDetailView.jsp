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
<title>매장 상세정보 보기</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" type="text/css" href="<%= ctxname %>/bootstrap-3.3.7-dist/css/bootstrap.min.css">
<script type="text/javascript" src="<%= ctxname %>/js/jquery-3.3.1.min.js"></script>  
<script type="text/javascript" src="<%= ctxname %>/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>
<div class="container" style="margin-top: 10px;">
  <table class="table table-bordered">
    <thead>
      <tr>
        <th colspan="2" align="center">${storeDetailList.get(0).storeName} 상세정보</th>
      </tr>
    </thead>
    <tbody>
    	<tr>
      		<td>매장번호</td>
      		<td>${storeDetailList.get(0).storeno}</td>
      	</tr>
      	<tr>
      		<td>매장명</td>
      		<td>${storeDetailList.get(0).storeName}</td>
      	</tr>
      	<tr>
      		<td>전화번호</td>
      		<td>${storeDetailList.get(0).tel}</td>
      	</tr>
      	<tr>
      		<td>주소</td>
      		<td>${storeDetailList.get(0).addr}</td>
      	</tr>
      	<tr>
      		<td>오시는길</td>
      		<td>${storeDetailList.get(0).transport}</td>
      	</tr>
	      
	    <c:forEach var="map" items="${storeDetailList}" varStatus="status">
	    	<c:if test="${status.count > 1}">
		    	<tr>
		    		<td colspan="2" align="center"><img src="<%=ctxname%>/images/${map.img}"></td>
		    	</tr>
	    	</c:if>
	    </c:forEach>
    </tbody>
  </table>
  <div align="center" style="margin-bottom: 10px;">
  	<button type="button" class="btn btn-success" onClick="javascript:self.close();">닫기</button>
  </div>
</div>
	
</body>
</html>