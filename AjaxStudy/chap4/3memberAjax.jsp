<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예제 (서버의 응답을 JSON으로 받아서 JSON로 출력해주는 예제)</title>

<style type="text/css">
	table, th, td {border: 1px solid gray;
				   border-collapse: collapse;}
				   
	.imgs {opacity: 0.3;}
	
	.realimgs {opacity: 1.0;}
	
	.userid {opacity: 0.0;}
	
</style>

<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/css/ajaxstyle.css">

<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery-3.3.1.min.js"></script>

<script type="text/javascript">

	$(document).ready(function() {
		
		$("#btn1").click(function(){
		
			var form_data = {name : $("#name").val()};
						    
			$.ajax({
				
				url: "3memberInfoJSON.do",
				type: "GET",
				data: form_data,                 
				dataType: "JSON",                
				
				success: function(data){
					
					var memberInfoHtml = "<table><thead><tr><th>회원명</th><th>이메일</th><th>주소</th></tr></thead><tbody>";
					
					var length = data.length;
					
					if(data != null && length > 0) {
						$.each(data,function(entryIndex, entry){
							memberInfoHtml += "<tr><td>" + entry.name + "</td>" 
							               +  "<td>" + entry.email + "</td>"
										   +  "<td>" + entry.addr1 + "&nbsp;" + entry.addr2 + "</td></tr>"
						});
						memberInfoHtml += "</tbody></table>"
					}
					else {
						memberInfoHtml = "<tr><td colspan='3'>데이터가 없습니다.</td></tr>";
					}
					$("#memberInfo").empty();
					
					$("#memberInfo").html(memberInfoHtml);
		
				},                    
				error: function(request, status, error){   // 실패하면
					alert("code : " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
					// 어디가 에러인지 디버깅해서 알려준다.
				}    
			});
			
			
		});// end of #btn1---------------
		
		
		$("#btn2").click(function(){
			
			$.ajax({
				
				url: "3memberImageJSON.do",
				type: "GET",
				dataType: "JSON",		
				
				success: function(data){
					
					var imgInfoHtml = "";
					
					var length = data.length;
					
					if(data != null && length > 0) {
						$.each(data,function(entryIndex, entry){
							imgInfoHtml += "<a><span class='imgs'><img src='/MyMVC/images/" + entry.img + "'/></span><br/>"
										+   entry.name + "<br/>"
										+   "<span class='userid'>아이디명 : " + entry.userid + "</span></a><br/>";
						});
					}
					else {
						imgInfoHtml = "<li>해당이름은 없는 사용자입니다.</li>";
					}
					$("#imgInfo").empty();
					
					$("#imgInfo").html(imgInfoHtml);
					
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
			
			url: "3newsTitleJSON.do",
			type: "GET",
			dataType: "JSON",
			
			success: function(data){
				$("#newsTitle").html(data);
				
				var newsTitleHtml = "";
				var a = 0;
				
				var length = data.length;
				
				if(data != null && length > 0) {
					$.each(data,function(entryIndex, entry){
						if(entryIndex == 0) {
							newsTitleHtml += "<div style='float: left; width:60%; min-height: 30px; margin-left: 0px; margin-right: 10px; '>"
							              +  "<span style='color: red; font-weight: bold; font-size: 14pt;'>" + entry.title + "</span></div>";
						}
						else {
							newsTitleHtml += "<div style='float: left; width:60%; min-height: 30px; margin-left: 0px; margin-right: 10px; '>"
							              +  "<span style='color: blue; font-size: 12pt;'>" + entry.title + "</span></div>";
						}
						newsTitleHtml += "<div style='float: left; min-height: 30px; margin-left: 10px; margin-right: 0px; '>"
									  +  "[기사입력 : <span style='color: blue; font-size: 10pt; '>" + entry.registerday + "</span>]<br/></div>";
					});
				}
				else {
					newsTitleHtml = "<li>해당이름은 없는 사용자입니다.</li>";
				}
				
				$("#newsTitle").html(newsTitleHtml);
				
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
		
		$(document).on("mouseover",".imgs",function(event){
			$(this).addClass("realimgs");
		});
		
		$(document).on("mouseout",".imgs",function(event){
			$(this).removeClass("realimgs");
			$(this).addClass("imgs"); 
		});
		 
		$(document).on("click",".imgs",function(event){
			$(this).parent().find(".userid").css({
				'opacity': '1.0'
			});
			
		});
		 
	}// end of startAjaxCalls()-----------------------------------

</script>	

</head>
<body>
	<h2>이곳은 MyMVC/3member.do 페이지의 데이터가 보이는 곳입니다.</h2>
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
	
	<div style="width: 40%; min-height: 200px; margin: 10px auto; padding: 10px; border: solid orange 1px; overflow: auto;">
		<div id="newsTitle" style="margin-top: 20px; margin-bottom: 20px;">
			<%-- newsTitle.do 의 내용이 들어가는 곳이다. --%>
		</div>
	</div>
	
	
	<div id="container">
		<div id="memberInfo"></div>
		<div id="imgInfo" style="margin-bottom: 20px;"></div>
	</div>
</body>
</html>
