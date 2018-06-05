<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String[] nameArr = {"정영광", "김종성", "송지섭", "이정원", "안지혜"};

	request.setAttribute("friend", nameArr);
	
	RequestDispatcher dispatcher = request.getRequestDispatcher("6ArrayTest2View.jsp");
	dispatcher.forward(request, response);
%>

