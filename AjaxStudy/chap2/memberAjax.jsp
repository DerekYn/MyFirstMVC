<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>jQuery Ajax 예제 2(서버의 응답을 HTML로 받아서 HTML로 출력해주는 예제)</title>

<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/css/ajaxstyle.css">

<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery-3.3.1.min.js"></script>

<script type="text/javascript">

	$(document).ready(function() {
		
		$("#btn1").click(function(){
		
			var form_data = {name : $("#name").val()};
						     // tel : $("#tel").val()
						     // age : $("#age").val()};
						     // 이런식으로 변수하나에 form 내의 모든 id에 값을 한번에 부여한다.
			
			// 자바 스크립트에서 변수 선언 후 값을 부여할 때 { } 라고 해주면 해당 변수는 객체가 된다.
			// 자바 스크립트에서 변수 선언 후 값을 부여할 때 키값 : 밸류값으로 준다.
			
			// 참고로 자바스크립트에서 배열변수의 선언은 변수선언 후 값을 부여할 때 [ ] 라고 해주면
			// 해당 변수는 배열타입이 된다.
			// 예) var nameArr = ["홍길동", "이순신", "엄정화"];
		
			// 그리고 자바스크립트에서 객체배열은 아래와 같이 나타낸다.
			/*
				예) var objArr = [{
					               userid: "hongkd",
					               name: "홍길동",
					               email: "hongkd@gmail.com"
					              },
					              {
					               userid: "leess",
						           name: "이순신",
						           email: "leess@gmail.com"
						          },
						          {
						           userid: "eom",
							       name: "엄정화",
							       email: "eom@gmail.com"
							      }];
			*/
					    
			$.ajax({
				
				url: "ajaxstudymemberInfo.do",
				type: "GET",
				data: form_data,                 // 위의 url 주소("ajaxstudymemberInfo.do") 로 보내질 요청 데이터이다.
				dataType: "html",                // ajax 요청에 의해 url 서버로 부터 리턴받는 데이터 타입. (url이 xml로 던지면 xml로 설정해줘야함.)
												 // xml, json, html, script, text 가 있다.
				success: function(data){                      
					// success ==> url 서버로 보낸 ajax 요청이 성공적으로 수행되었다면 
					// 수행해야할 일처리 내용을 기술하는 부분이다.(콜백함수)
					// data ==> ajax 요청에 의해 url 서버로 부터 리턴 받은 데이터이다.
					// console.log(data);
					$("#memberInfo").empty();		// 기존에 있던 데이터는 비우고 새로운 데이터를 넣는다.
					$("#memberInfo").html(data);	// 넘어온 새로운 데이터로 채워 넣어 준다.
				},                    
				error: function(request, status, error){   // 실패하면
					alert("code : " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
					// 어디가 에러인지 디버깅해서 알려준다.
				}    
			});
			
			
		});// end of #btn1---------------
		
		
		$("#btn2").click(function(){
			
			$.ajax({
				
				url: "ajaxstudymemberImage.do",
				type: "GET",
				// data: "", form이 없기때문에 데이터 또한 없다.
				dataType: "html",		// ajax 요청에 의해 url 서버로 부터 리턴받는 데이터 타입. (url이 xml로 던지면 xml로 설정해줘야함.)
				 						// xml, json, html, script, text 가 있다.
				
				success: function(data){                      
					// success ==> url 서버로 보낸 ajax 요청이 성공적으로 수행되었다면 
					// 수행해야할 일처리 내용을 기술하는 부분이다.(콜백함수)
					// data ==> ajax 요청에 의해 url 서버로 부터 리턴 받은 데이터이다.
					// console.log(data);
					$("#imgInfo").empty();		// 기존에 있던 데이터는 비우고 새로운 데이터를 넣는다.
					$("#imgInfo").html(data);	// 넘어온 새로운 데이터로 채워 넣어 준다.
				}, 
				error: function(request, status, error){   // 실패하면
					alert("code : " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
					// 어디가 에러인지 디버깅해서 알려준다.
				}  
				
			});
			
		});// end of #btn2---------------
		
		
		$("#btn3").click(function(){
			
			$("#memberInfo").empty();
			$("#name").val("");
			$("#imgInfo").empty();
			
		});// end of #btn3---------------
		
		
		// newsTitle.do 의 내용이 들어가게 하기.
		startAjaxCalls();
	
	});// end of ready(function()---------------------------
			
			
			
	function getNewsTitle() {
		
		$.ajax({
			
			url: "newsTitle.do",
			type: "GET",
			// data 생략( form 이 없어서)
			dataType: "html",
			
			success: function(html){
				$("#newsTitle").html(html);
			},
			
			error: function(request, status, error){   // 실패하면
				alert("code : " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
				// 어디가 에러인지 디버깅해서 알려준다.
			}  
			
		});// end of getNewsTitle()-------------------------------------
		
		
		
	}// end of getNewsTitle()-------------------------------
			
	
	
	function startAjaxCalls() {
		
		getNewsTitle();
		
		setTimeout(function(){
			startAjaxCalls();
		}, 10000);
		// 10초 후에 발생한다.
		// 즉, 뉴스정보를 매 10초마다 자동 갱신하려고 한다.
		
	}// end of startAjaxCalls()-----------------------------------

</script>	

</head>
<body>
	<h2>이곳은 MyMVC/ajaxstudymember.do 페이지의 데이터가 보이는 곳입니다.</h2>
	<br/><br/>
	<div align="center">
		<form name="searchFrm">
			회원명 : <input type="text" name="name" id="name" />
		</form>
		<br/>
		<button type="button" id="btn1">회원명단보기</button>&nbsp;&nbsp;
		<button type="button" id="btn2">사진보기</button>&nbsp;&nbsp;
		<button type="button" id="btn3">지우기</button>&nbsp;&nbsp;
	</div>
	
	<div id="newsTitle" style="margin-top: 20px; margin-bottom: 20px;"></div>
	<%-- newsTitle.do 의 내용이 들어가는 곳이다. --%>
	
	<div id="container">
		<div id="memberInfo"></div>
		<div id="imgInfo"></div>
	</div>
</body>
</html>
