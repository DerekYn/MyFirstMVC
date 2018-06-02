<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일정시간 마다 함수호출을 하는 setTimeout() 함수 예제(jQuery 사용) - 시계</title>

<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery-3.3.1.min.js"></script>
<script type="text/javascript">

	$(document).ready(function() {
		
		loopshowNowTime();
		
	});
	
	function showNowTime() {
		
		var now = new Date();	// 현재 시각을 얻어온다.
		
		var strNow = now.getFullYear() + " 년  " + (now.getMonth() + 1) + " 월  " + now.getDate() + " 일  ";
		
		var hour = "";
		if(now.getHours() > 12) {
			hour = "오후  " + (now.getHours() - 12);
		}
		else if(now.getHours() < 12) {
			hour = "오전  " + (now.getHours());
		}
		else {
			hour = "정오  " + (now.getHours());
		}
		
		var minute = "";
		if(now.getMinutes() < 10) {
			minute = "0" + now.getMinutes();
		}
		else {
			minute = now.getMinutes();
		}
		
		var second = "";
		if(now.getSeconds() < 10) {
			second = "0" + now.getSeconds(); 
		}
		else {
			second = now.getSeconds();
		}
		
		strNow += hour + " 시  " + minute + " 분  " + second + " 초";
		
		// console.log(strNow);
		
		$("#clock").html(strNow);
		
	}// end of function showNowTime()-----------------------------
	
	function loopshowNowTime() {
		showNowTime();
		
		setTimeout(function(){
			
			loopshowNowTime();
			
		}, 1000);	// 숫자 1000은 1000밀리초 즉, 1초를 말한다.
					// 1초 뒤에 function(){실행할 내용} 을 실행하라는 뜻이다.
					
		/*
		  setTimeout(function(){
			                 실행할 내용
		             }, delay);
		  ==> 실행할 내용은 dealy 밀리초가 지난 다음에 실행해라는 말이다.        
		*/
		
		
	}// end of function showNowTime()------------------------------
	

</script>
</head>
<body>

<span style="color: blue; font-size: 16pt;">현재시각 : </span>
<span id="clock" style="color: red; font-weight: bold;"></span>

</body>
</html>