<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서정보 보기</title>

<style>
	.namestyle {
		font-weight: bold;
		color: red;
		font-family: "굴림", Gulim, Arial, sans-serif;
	}
	
	.registerday {opacity: 0.0;}
	
	
</style>

<script type="text/javascript" src="<%= request.getContextPath() %>/js/jquery-3.3.1.min.js"></script>
<script type="text/javascript">

	$(document).ready(function(){
		
		startAjaxCalls();
				
	});
	
	function getJSONbooks() {
		$.getJSON("2booksInfoJSON.do",function(json){
			var fictionHtml = "";
			var programmingHtml = "";
			
			var length = json.length;
			
			if(json != null && length > 0) {
				$.each(json,function(entryIndex, entry){
					if(entry.subject == "소설") { 
						fictionHtml += "<li>도서명: <span class='bookname'>" + entry.title + "</span>, 작가명: " + entry.author + "<span class='registerday'>, 발행일자 : " + entry.registerday + "</span></li>";
					}
					if(entry.subject == "프로그래밍") {
						programmingHtml += "<li>도서명: <span class='bookname'>" + entry.title + "</span>, 작가명: " + entry.author + "<span class='registerday'>, 발행일자 : " + entry.registerday + "</span></li>";
					}
				});
			}
			else {
				fictionHtml = "<li>도서명: 없음</li>";
				programmingHtml = "<li>도서명: 없음</li>";
			}
			$("#fictioninfo").empty();
			$("#programminginfo").empty();
			
			$("#fictioninfo").html(fictionHtml);
			$("#programminginfo").html(programmingHtml);
		});
		
		$.getJSON("2newbooksInfoJSON.do",function(json){
			var newfictionHtml = "";
			var newprogrammingHtml = "";
			
			var length = json.length;
			
			if(json != null && length > 0) {
				$.each(json,function(entryIndex, entry){
					if(entry.subject == "소설") {
						newfictionHtml += "<li>도서명: <span class='bookname'>" + entry.title + "</span>, 작가명: " + entry.author + "<span class='registerday'>, 발행일자 : " + entry.registerday + "</span></li>";
					}
					if(entry.subject == "프로그래밍") {
						newprogrammingHtml += "<li>도서명: <span class='bookname'>" + entry.title + "</span>, 작가명: " + entry.author + "<span class='registerday'>, 발행일자 : " + entry.registerday + "</span></li>";
					}
				});
			}
			else {
				newfictionHtml = "<li>도서명: 없음</li>";
				newprogrammingHtml = "<li>도서명: 없음</li>";
			}
			$("#newfictioninfo").empty();
			$("#newprogramminginfo").empty();
			
			$("#newfictioninfo").html(newfictionHtml);
			$("#newprogramminginfo").html(newprogrammingHtml);
		});
	}

	function startAjaxCalls() { 
		$("#registerday").hide();
		getJSONbooks();
		
		setTimeout(function(){
			startAjaxCalls();
		}, 10000);
			
		$(document).on("mouseover",".bookname",function(event){
			$(this).addClass("namestyle");
			$(this).next().css({
				'opacity': '1.0',
				'color':'white',
				'background-color':'navy',
				'font-weight': 'bold'
			});
		});
		
		$(document).on("mouseout",".bookname",function(event){
			$(this).removeClass("namestyle"); 
			$(this).next().css({
				'opacity': '0.0'
			});
		});	
		
	}
</script>
<style type="text/css">
	h3 {color: blue;}
	ul {list-style: square;}
</style>
</head>
<body>
	<div id="fiction">
		<h3>모든소설</h3>
		<ul id="fictioninfo"></ul>
	</div>
	<div id="it">
		<h3>모든프로그래밍</h3>
		<ul id="programminginfo"></ul>
	</div>
	
	<hr style="background-color: orange; height: 2px; border-style: none;">
	
	<div id="newfiction">
		<h3>신간소설</h3>
		<ul id="newfictioninfo"></ul>
	</div>
	<div id="newit">
		<h3>신간프로그래밍</h3>
		<ul id="newprogramminginfo"></ul>
	</div>
</body>
</html>