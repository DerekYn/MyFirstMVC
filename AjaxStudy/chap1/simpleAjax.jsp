<%-- 
	 ※ Ajax(Asynchronous JavaScript and XML)란?
	 ==> 이름만 보면 알 수 있듯이 '비동기 방식의 자바스크립트와 XML' 로서
	     Asynchronous JavaScript + XML 인 것이다.
	     한마디로 말하면, Ajax 란? Client 와 Server 간에 XML 데이터를 JavaScript 를 사용하여
	     비동기 통신으로 주고 받는 기술이다.
	     그런데 요즘에는 데이터 전송을 위한 데이터 포맷방법으로 XML을 사용하기 보다는 JSON 을 더많이 사용한다. 
	     참고로 HTML은 데이터 표현을 위한 포맷방법이다.
	     그리고, 비동기방식이란 어떤 하나의 웹페이지에서 여러가지 서로 다른 다양한 일처리가 개별적으로 발생한다는 뜻으로서,
	     어떤 하나의 웹페이지에서 서버와 통신하는 일처리가 발생하는 동안 그 일처리가 마무리 되기전에 또 다른 작업을 하는 것을 말한다.
	 
	     
	 ※ Ajax 의 주요 구성요소
	   1). XMLHttpRequest : 웹서버와 통신을 담당하는 것으로서
	                        사용자의 요청을 웹서버에 전송해주고, 
	                        웹서버로 부터 받은 결과를 
	                        사용자의 웹브라우저에 전달해준다. 
	   2). DOM(Document Object Model) : DOM 은 HTML 과 XML 문서에 대하여,
	                                      이들 문서의 구조적인 표현방법을 제공하며,
	                                      어떻게 하면 스크립트를 이용하여 이러한 구조에 
	                                      접근할 수 있는지를 정의하는 API 이다.
	                                    DOM 객체는 텍스트와 이미지, 하이퍼링크, 폼 엘리먼트 등의 
	                                      각 문서 엘리먼트를 나타낸다. 
	                                        
	   3). CSS : 글자색, 배경색, 위치 등 UI 관련 부분을 담당한다.
	   4). JavaScript : 사용자가 마우스로 드래그하거나 버튼을 클릭하면 
	                    XMLHttprequest 객체를 통해 웹서버에 사용자의 요청을 전송한다.
	                    웹서버로 부터의 응답은 XMLHttprequest 객체를 통해 얻어오는데 
	                    응답결과를 받으면 DOM, CSS 등을 사용해서 화면을 조작하면 된다.    
	       
 --%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>jQuery Ajax 예제1(서버의 응답을 텍스트로 받아서 text 타입으로 출력하는 예제)</title>

<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery-3.3.1.min.js"></script>

<script type="text/javascript">

	$(document).ready(function() {
		
		$("#btn1").click(function(){
			
			$.ajax({
				url: "simple1.txt",
				type: "GET",
				dataType: "text",   // xml, json, html, script, text
				success: function(data) { // 데이터 받아왔으니까 이제 뭐 해라~ 
					$("#mydiv").empty();
					// 해당 요소 ${"#mydiv"}의 내용을 모두 비워서 새 데이터를 채울 준비를 한다.
					
					$("#mydiv").text(data);
				}
			});	
			
		});
		
		$("#btn2").click(function(){
			
			$.ajax({
				url: "simple2.jsp",
				type: "GET",
				dataType: "text",   // xml, json, html, script, text
				success: function(data) { // 데이터 받아왔으니까 이제 뭐 해라~ 
					$("#mydiv").empty();
					// 해당 요소 ${"#mydiv"}의 내용을 모두 비워서 새 데이터를 채울 준비를 한다.
					
					$("#mydiv").text(data);
				}
			});
			
		});
		
	});

</script>

</head>
<body>

	<button type="button" id="btn1">simple1.txt</button>&nbsp;&nbsp;
	<button type="button" id="btn2">simple2.jsp</button>
	
	<p>
	여기는 simpleAjax.jsp 페이지입니다.
	<p>
	<div id="mydiv"></div>


</body>
</html>
















