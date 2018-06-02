<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원들의 개인정보 출력</title>

<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css" />

<style type="text/css">
	table, th, td {
		border: solid 2px #FBAD1C;
		border-collapse: collapse;
		font-size: 14pt;
	}
	.namestyle {
		background-color: yellow;
		font-weight: bold;
		color: red;
		font-size: 15pt;
		font-family: "굴림", Gulim, Arial, sans-serif;
	}
</style>

<script type="text/javascript" src="<%= request.getContextPath() %>/js/jquery-3.3.1.min.js"></script> 
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.js"></script>
<script type="text/javascript">

	$(document).ready(function(){
		
		$("#displayArea").hide();
		
		$("#btn").click(function(){
			
			$.ajax({
				
				url: "1personJSONArray.do",
				// type: "GET", 안쓰면 GET
				// data: form_data, 폼없음
				dataType: "JSON",
				
				success: function(json){
					// json 은 ajax 요청에 의해 URL 페이지로 부터 리턴 받은 데이터 (JSONArray 형태)이다.
					
					$("#displayArea").show();
					
					var html = "";
					
					if(json != null && json.length > 0) {
						
						$.each(json, function(entryIndex, entry){
							/* 
								현재 json 은 [{"key":val, "key":val, "key":val}, {"key":val, "key":val, "key":val}, {"key":val, "key":val, "key":val}]
								형태로 되어있으므로 그 타입이 배열이다.
								그래서 function(첫번째 파라미터, 두번째 파라미터) 에서
								첫번째 파라미터인 entryIndex 는 배열의 index 이고,
								두번째 파라미터인 entry 는 데이터 객체{"key":val, "key":val, "key":val}을 말한다.
								
								그러므로 데이터를 얻어오기 위해서는 두번째 파라미터인 entry 를 사용한다.
								우리는 두번째 파라미터를 entry 라고 했으므로 entry.키 값으로 얻어오면 된다.
								예) entry.address -> 주소 값 / entry.phone -> 전화번호 값 / entry.name -> 이름 값 
							*/
							
							html += "<tr>"
								 +  "<td class='name'>"+entry.name+"</td>"
								 +  "<td>"+entry.age+"</td>"
								 +  "<td>"+entry.height+"</td>"
								 +  "<td>"+entry.phone+"</td>"
								 +  "<td>"+entry.email+"</td>"
								 +  "<td class='address'>"+entry.address+"</td>"
								 +  "</tr>";
							
						});
						
					}// end of if()------------------------------------------------------------------
					else {
						
						html += "<tr>"
						     +  "<td colspan='6' style=\"text-align: center; color: red;\">데이터가 없습니다.</td>"
						     +  "</tr>"
						
					}// end of else()----------------------------------------------------------------------
					
					$("#personinfo").empty();
					$("#personinfo").append(html);
					
				},// end of success: function(json)--------------
				
				error: function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
						
			});// end of $.ajax({---------------------------------------------------
			
		});// end of $("#btn").click(function()-------------------------------
				
			// **** !!!!! 중요 !!!!! ****//
			/* 
				ajax 로 구현되어진 내용물에서 선택자를 잡을 때는 아래와 같이 해야한다.
				$(document).on("click","선택자",function() {});
				 으로 해야 한다.
			
			*/
				
			$(document).on("mouseover",".name",function(event){
				var $target = $(event.target);
				$target.addClass("namestyle");
			});
			
			$(document).on("mouseout",".name",function(event){
				var $target = $(event.target);
				$target.removeClass("namestyle");
			});	
				
			$(document).on("click", ".name", function(event){
				var $target = $(event.target);
				var addrval = $target.parent().find(".address").text();
				// alert($target.text() + " 님의 주소는 \n" + addrval + " 입니다.");
				swal($target.text() + " 님의 주소는 \n" + addrval + " 입니다.");
			});
			
	});// end of ready();---------------------------------------------------

</script>

</head>
<body>
	<div>
		<button type="button" id="btn">회원보기</button>
	</div>
	<h3>회원내역</h3>
	<div id="displayArea">
		<table>
	      <thead>
	      	 <tr>
	      	 	<th>성명</th>
	      	 	<th>나이</th>
	      	 	<th>신장</th>
	      	 	<th>전화번호</th>
	      	 	<th>이메일</th>
	      	 	<th>주소</th>
	      	 </tr>
	      </thead>		
	      <tbody id="personinfo"></tbody>
		</table>
	</div>
</body>
</html>