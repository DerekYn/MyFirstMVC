<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이순신 개인정보 출력</title>

<script type="text/javascript" src="<%= request.getContextPath() %>/js/jquery-3.3.1.min.js"></script> 

<script type="text/javascript">

	$(document).ready(function(){
		/*
			$.ajax({
				url: "데이터를 가져올 URL명",
				type: "GET",
				data: form_data,
				dataType: "json",
				success: function(json){
					
					},
				error: function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			});
		
		    위의 것을 jQuery 에서는 JSON 형태의 데이터만을 처리해주는 전용메소드가 있는데 
		    바로 getJSON() 메소드이다.
		  getJSON() 메소드의 사용방법은
		  $.getJSON("데이터를 가져올 URL명", function(json){ });
		*/
		
		$("#btn").click(function(){
			
			$.ajax({
				url: "1personJSON.do",
				type: "GET",
			//	data: form_data,
				dataType: "JSON",
				success: function(json){
					    // json 는 ajax 요청에 의해 URL 페이지로 부터 리턴받은 데이터(JSONObject 형태)이다.
					    
					    $("#personinfo").empty(); // 해당 엘리먼트를 모두 비워서 새 데이터로 채울 준비를 한다.
					
					    var style1 = ' style="color:red; border: solid 1px #FBAD1C; border-collapse: collapse;" ';
						var style2 = ' style="background-color:blue; color:white; border: solid 1px #FBAD1C; border-collapse: collapse;" ';
					    
					    var html = "<table style='border: solid 2px #FBAD1C; border-collapse: collapse;'>";
					        html += "<tr><th>특성</th><th>데이터</th></tr>";
					        html += "<tr>";
							html += "<td"+style1+">성명</td>";
							html += "<td"+style1+">"+json.name+"</td>";
							html += "</tr>";
							html += "<tr>";
							html += "<td"+style2+">나이</td>";
							html += "<td"+style2+">"+json.age+"</td>";
							html += "</tr>";
							html += "<tr>";
							html += "<td"+style1+">신장</td>";
							html += "<td"+style1+">"+json.height+"</td>";
							html += "</tr>";
							html += "<tr>";
							html += "<td"+style2+">전화번호</td>";
							html += "<td"+style2+">"+json.phone+"</td>";
							html += "</tr>";
							html += "<tr>";
							html += "<td"+style1+">이메일</td>";
							html += "<td"+style1+">"+json.email+"</td>";
							html += "</tr>";
							html += "<tr>";
							html += "<td"+style2+">주소</td>";
							html += "<td"+style2+">"+json.address+"</td>";
							html += "</tr>";
						    html += "</table>";
						
						$("#personinfo").html(html);
						
					}, // end of success: function(data){}------------------------
					error: function(request, status, error){
						alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					}
			});
			
			/* 
			  $.getJSON("1personJSON.do", 
					    function(json){
				        // data 는 ajax 요청에 의해 URL 페이지로 부터 리턴받은 데이터(JSON 형태)이다.
				
							$("#personinfo").empty(); // 해당 엘리먼트를 모두 비워서 새 데이터로 채울 준비를 한다. 
							
							var style1 = ' style="color:red; border: solid 1px #FBAD1C; border-collapse: collapse;" ';
							var style2 = ' style="background-color:blue; color:white; border: solid 1px #FBAD1C; border-collapse: collapse;" ';
						    
						    var html = "<table style='border: solid 2px #FBAD1C; border-collapse: collapse;'>";
						        html += "<tr><th>특성</th><th>데이터</th></tr>";
						        html += "<tr>";
								html += "<td"+style1+">성명</td>";
								html += "<td"+style1+">"+json.name+"</td>";
								html += "</tr>";
								html += "<tr>";
								html += "<td"+style2+">나이</td>";
								html += "<td"+style2+">"+json.age+"</td>";
								html += "</tr>";
								html += "<tr>";
								html += "<td"+style1+">신장</td>";
								html += "<td"+style1+">"+json.height+"</td>";
								html += "</tr>";
								html += "<tr>";
								html += "<td"+style2+">전화번호</td>";
								html += "<td"+style2+">"+json.phone+"</td>";
								html += "</tr>";
								html += "<tr>";
								html += "<td"+style1+">이메일</td>";
								html += "<td"+style1+">"+json.email+"</td>";
								html += "</tr>";
								html += "<tr>";
								html += "<td"+style2+">주소</td>";
								html += "<td"+style2+">"+json.address+"</td>";
								html += "</tr>";
							    html += "</table>";
							    
							    $("#personinfo").html(html);
				
					}); // end of $.getJSON();----------------
			
			   */
			
		});// end of $("#btn").click();---------------
		
	});// end of ready();---------------

</script>

</head>
<body>
	<div>
		<button type="button" id="btn">회원보기</button>
	</div>
	<h3>회원내역</h3>
		<div id="personinfo"></div>
</body>
</html>