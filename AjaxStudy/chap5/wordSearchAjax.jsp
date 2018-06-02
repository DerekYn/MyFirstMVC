<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문자열 검색시 글 자동 완성 하기</title>

<script type="text/javascript" src="<%= request.getContextPath() %>/js/jquery-3.3.1.min.js"></script>

<script type="text/javascript">

	$(document).ready(function(){
		
		$("#searchword").keyup(function(){
			// 사용자가 텍스트박스 안에서 키보드를 눌렀다가 up 했을때
			
			var form_data = {searchword : $("#searchword").val()};
			                 // 키값 : 밸류값
			
			$.ajax({
				
				url: "wordSearchJSON.do",
				type: "GET",
				data: form_data,
				dataType: "JSON",
				
				success: function(json) {
					
					if(json.length > 0) {
						// 검색된 데이터가 있는 경우임.
						// 조심할 것은 if(json == null) 이 아니라
						// if(json.length > 0) 으로 해야 한다.!!
						
						var html = "";
						
						$.each(json, function(entryIndex, entry){
							
							var word = entry.resultstr.trim();
							// "ajax 프로그래밍"
							
							
							var index = word.toLowerCase().indexOf( $("#searchword").val().toLowerCase() ); // 모든 영문자를 소문자로 만든후에 비교.
							// $("#searchword").val().toLowerCase() 이 "ja" 이라면
							// index 는 1이 된다.
							
							var len = $("#searchword").val().length;
							
							var str = "";
							
							str = "<span class='first' style='color: blue;'>" + word.substr(0, index) + "</span>" + "<span class='second' style='color: red; font-weight: bold;'>" + word.substr(index, len) + "</span>" + "<span class='third' style='color: blue;'>" +  word.substr(index + len) + "</span>";
							
							html += "<span style='cursor: pointer;'>" + str + "</span><br/>";
						});
						
						$("#displayData").html(html);
						$("#displayData").show();
						
					}
					else {
						// 검색된 데이터가 없는 경우임.
						$("#displayData").hide();
						
					}
					
				},
				error: function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
				
				
			});
			
			
		});// end of $("#searchword").keyup(function()---------------------
				
		$("#displayData").click(function(event){
			
			var $target = $(event.target);
			
			if($target.is(".first")) {
				word = $target.text() + $target.next().text() + $target.next().next().text();
			}
			else if($target.is(".second")) {
				word = $target.prev().text() + $target.text() + $target.next().text();
			}
			else if($target.is(".third")) {
				word = $target.prev().prev().text() + $target.prev().text() + $target.text();
			}
			
			$("#searchword").val(word);
			
			$("#display").hide();
			
			goSearch(word);
			
		});// end of $("#displayData").click(function(event)-----------------------

	});// end of $(document).ready(function()-------------------------
			
	function goSearch(word) {
				
		var frm = document.goSearchFrm;
		frm.method = "get";
		frm.action = "wordSearchShowcontent.do";
		frm.submit();	
		
	}// end of goSearch()---------------------------------------
	


</script>


</head>
<body>
	<h2 style="color:red;">단어검색</h2>
	<form name="goSearchFrm">
		<input type="text" name="searchword" id="searchword" /> <button type="button">검색</button>
		<div id="display" style="width: 300px; border: solid 0px gray; position: relative; left: 3%; top: 5px; align="left">
			<div id="displayData"></div>
		</div>
	</form>
</body>
</html>