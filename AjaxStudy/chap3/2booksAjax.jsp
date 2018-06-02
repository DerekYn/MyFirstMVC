<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서정보 보기</title>

<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery-3.3.1.min.js"></script>

<script type="text/javascript">

	$(document).ready(function(){
		startAjaxCalls();
	});
	
	
	function getXMLbooks() {
		
		$.ajax({
			
			url: "2booksXML.do",
			// type: "GET",  안쓰면 GET
			// data: form_data, 안쓰면 생략
			dataType: "XML",
			
			success: function(xml){
				
				$("#fictioninfo").empty();		// ul 엘리먼트를 모두 비어서 새로운 데이터를 채울 준비를 한다.
				$("#programminginfo").empty();		// ul 엘리먼트를 모두 비어서 새로운 데이터를 채울 준비를 한다.
				
				var rootElement =$(xml).find(":root");
				// 넘겨받은 결과물 xml 에서 최상위 root 엘리먼트를 찾아주는 것.
				
				// console.log("확인용 : " + $(rootElement).prop("tagName"));
				// 확인용 : books
				
				var bookArr = $(rootElement).find("book");
				/* 
					최상위 root 엘리먼트인 books 에서 book 이라는 엘리먼트를 찾는것.
					검색되어진 book 이라는 엘리먼트가 복수개 이므로
					저장되어질 bookArr 변수의 타입은 배열타입이 된다.
				*/
				
				bookArr.each(function(){
					
					var info = "<li>도서명 : " + $(this).find("title").text() + ", 작가명 : " + $(this).find("author").text() + "</li>";
					
					if($(this).find("subject").text() == "소설"){
						$("#fictioninfo").append(info);
					}
					else if($(this).find("subject").text() == "프로그래밍") {
						$("#programminginfo").append(info);
					}
					
				});// end of each()-------------------------------------------------------
				
				
			},
			
			error: function(request, status, error){   // 실패하면
				alert("code : " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
				// 어디가 에러인지 디버깅해서 알려준다.
			}  
			
		});
		
	}// end of getXMLbooks()----------------------------
	
	
	function startAjaxCalls() {
		getXMLbooks();
		
		setTimeout(function(){
			startAjaxCalls();
		}, 10000);
		
	}// end of startAjaxCalls()--------------------------


</script>

<style type="text/css">
	h3 {color: blue;}
	ul {list-style: square;}
</style>

</head>
<body>

	<div id="fiction">
		<h3>소설</h3>
		<ul id="fictioninfo"></ul>
	</div>
	<div id="it">
		<h3>프로그래밍</h3>
		<ul id="programminginfo"></ul>
	</div>

</body>
</html>