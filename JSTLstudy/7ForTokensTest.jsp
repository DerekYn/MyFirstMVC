<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String name = "유지웅,김민재,김남철,손승완,김규전,장성환";

	request.setAttribute("friend", name);
	
	RequestDispatcher dispatcher = request.getRequestDispatcher("7ForTokensView.jsp");
	dispatcher.forward(request, response);
%>

