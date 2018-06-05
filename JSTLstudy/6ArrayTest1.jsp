<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String[] nameArr = {"임규하", "윤찬영", "김시온", "박다솜"};

	request.setAttribute("friend", nameArr);
	
	RequestDispatcher dispatcher = request.getRequestDispatcher("6ArrayTest1View.jsp");
	dispatcher.forward(request, response);
%>

