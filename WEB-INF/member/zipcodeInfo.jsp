<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>우편번호 조회결과</title>

<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css" >
<script type="text/javascript" src="<%= request.getContextPath() %>/js/jquery-3.3.1.min.js"></script>

<script type="text/javascript">
	
	// *** 팝업창에서 부모창으로 값 넘기기 *** //
 	function goMove(post1, post2, address) {
		var frm = opener.window.document.registerFrm;
		frm.post1.value = post1;
		frm.post2.value = post2;
		frm.addr1.value = address;
		
		frm.addr2.focus();
		
		self.window.close(); // 팝업창 닫기
	} 
 	
</script>

</head>
<body style="background-color: #fff0f5;">
<div align="center">
<table style="width: 98%;" class="outline">
	<thead>
    <tr>
    	<th style="font-size: 10pt; width: 15%; text-align: center;">우편번호1</th>
    	<th style="font-size: 10pt; width: 15%; text-align: center;">우편번호2</th>
    	<th style="font-size: 10pt; width: 70%; text-align: center;">주소</th>
    </tr>
    </thead>
    
	<c:if test="${result == '0'}">
	  <tr>
    	<td colspan="3" align="center">
    		<span style="color: red; font-weight: bold;">${zipcodeNotExist}</span>
    	</td>  	
      </tr>	
	</c:if>
	
	<c:if test="${result == '1'}">
	  <c:forEach var="zipcodeVO" items="${zipcodeList}">
	    <tr>
      	   <td style="text-align: center;">
      	      ${zipcodeVO.post1}
      	   </td>
      	   <td style="text-align: center;">
      	      ${zipcodeVO.post2}
      	   </td>
      	   <td>
      	       <span style="cursor:pointer;" onClick="goMove('${zipcodeVO.post1}','${zipcodeVO.post2}','${zipcodeVO.address}');">${zipcodeVO.address}</span>
      	   </td>
        </tr>
	  </c:forEach>
	</c:if>
   
</table>
</div>

</body>
</html>



