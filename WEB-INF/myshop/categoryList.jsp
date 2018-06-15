<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 


<c:if test="${categoryList != null && not empty categoryList}">
	
	<div style="width: 95%; border: solid gray 1px;
	            padding-top: 5px;
	            padding-bottom: 5px;
	            text-align: center; ">
	   <span style="color: navy; font-size: 14pt; font-weight: bold;">
	        CATEGORY LIST
	   </span>         
	</div>
	
	<div style="width: 95%; border: solid gray 1px;
	            border-top: hidden;
	            padding-top: 5px;
	            padding-bottom: 5px;
	            text-align: center; ">
	    <c:forEach var="categoryVO" items="${categoryList}">
	    	<a href="<%= request.getContextPath() %>/mallByCategory.do?code=${categoryVO.code}&cname=${categoryVO.cname}">${categoryVO.cname}</a>&nbsp;
	    </c:forEach>
	</div>

</c:if>



    