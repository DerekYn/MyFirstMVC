<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String name = "김남준,정서영.정영광,박정윤_안지혜";

	request.setAttribute("friend", name);
	
	RequestDispatcher dispatcher = request.getRequestDispatcher("8ForTokensView.jsp");
	dispatcher.forward(request, response);
%>