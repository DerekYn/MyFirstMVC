<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../header.jsp" />

<style type="text/css">
  .th, .td {border: 0px solid gray;}
  a:hover {text-decoration: none;}
</style>
    
<script type="text/javascript">
	
	$(document).ready(function(){
		
		$("#totalHITCount").hide();
		$("#countHIT").hide();
		
		// HIT상품 게시물을 더보기 위하여 더보기.. 버튼 클릭액션에 대한 초기값 호출
		displayHitAppend("1");
		
		// HIT상품 더보기.. 버튼 클릭 이벤트 등록
		$("#btnMoreHIT").bind("click", function() {
			
			if( $(this).text() == "처음으로" ) {
				$("#displayResult").empty();
				displayHitAppend("1");
				$(this).text("더보기...");
			}
			else {
				displayHitAppend($(this).val());
			}
		});
		
	////////////////////////////////////////////
		
		$("#totalNEWCount").hide();
		$("#countNEW").hide();
		
		// NEW상품 게시물을 더보기 위하여 더보기.. 버튼 클릭액션에 대한 초기값 호출
		displayNewAppend("1");
		
		// NEW상품 더보기.. 버튼 클릭 이벤트 등록
		$("#btnMoreNEW").bind("click", function() {
			
			if( $(this).text() == "처음으로" ) {
				$("#displayResultNEW").empty();
				displayNewAppend("1");
				$(this).text("더보기...");
			}
			else {
				displayNewAppend($(this).val());
			}
		});
		
	});// end of $(document).ready()--------------
	
	
	var lenHIT = 3; // HIT상품 더보기.. 클릭에 보여줄 상품의 갯수 단위크기 
	
	function displayHitAppend(start) {
	
	// display 할 HIT 제품정보 추가 요청하기(Ajax로 처리함.)
	    
	    var form_data = {"start" : start,
		                 "len" : lenHIT,
		                 "pspec" : "HIT"};
	
		$.ajax({
			url: "malldisplayXML.do",
			type: "GET",
			data: form_data,
			dataType: "XML",
			success: function(xml){
				var rootElement = $(xml).find(":root");
			//	console.log($(rootElement).prop("tagName")); // ==> start 

			    var productArr = $(rootElement).find("product");
			
			    var html = "";
			    
			    if(productArr.length == 0) {
			    	// 데이터가 아예 없는 경우이라면 
			    	// 주의!!! productArr == null 이 아님!!!!
			    	
			    	html += "<tr>"
			    	      + "  <td colspan=\"3\" align=\"center\" >"
			    	      + "      상품준비중 입니다..."
			    	      + "  </td>"
			    	      + "</tr>";
			    	
			    	// *** HIT 상품 결과를 출력해주기
			    	$("#displayResult").html(html);
			    	
			    	// 더보기 버튼의 비활성화 처리
			    	$("#btnMoreHIT").attr("disabled", true);
			    	$("#btnMoreHIT").css("cursor","not-allowed");
			    	      
			    }
			    else {
			    	// 데이터가 존재하는 경우이라면
			    	html += "<tr>";
			    	for(var i=0; i<productArr.length; i++) {
			    		var product = $(productArr).eq(i);
			    		/* 
			    		   .eq(index)는 선택된 요소들을 인덱스 번호로 찾을 수 있는 선택자이다.
			    		      마치 배열의 인덱스(index)로 값(value)을 찾는것과 같은 효과를 낸다.
			    		*/
			    	//	console.log( $(product).find("pname").text() ); 확인용
			    		/* 남성여름상의복
			    		      만화한국사
			    		      세계탐험보물찾기시리즈
			    		*/
			    		html += "<td align=\"center\" style=\"padding-left: 50px; padding-right: 50px; \">"
						     +  "<br/><a href=\"/MyMVC/prodView.do?pnum="+$(product).find('pnum').text()+"\">"
						     +  "<img width=\"120px;\" height=\"130px;\" src=\"images/"+$(product).find("pimage1").text()+"\">" 
					         +  "</a>"
					         +  "<br/>"+$(product).find("pname").text()+""
					         +  "<br/><del>"+$(product).find("price").text()+"원</del>"
					         +  "<br/><span style=\"color: red; font-weight: bold;\">"+$(product).find("saleprice").text()+"원</span>"  
					         +  "<br/><span style=\"color: blue; font-weight: bold;\">["+$(product).find("percent").text()+"% 할인]</span>" 
					         +  "<br/><span style=\"color: orange;\">"+$(product).find("point").text()+" POINT</span>"
				             +  "</td>";
			    	}// end of for------------------
			    	
			    	html += "</tr>";
			    	
			    	// *** HIT 상품 결과를 출력해주기
			    	$("#displayResult").append(html);
			    	
			    	// >>>>> !!!! 중요 !!!! 더보기 버튼의 value 속성에 값을 지정해주기 <<<<<<
			    	$("#btnMoreHIT").val(parseInt(start) + lenHIT);
			    	/*
			    	    문서가 로딩되어지면 parseInt(start) 은 1이고
			    	  lenHIT는 3이므로 더보기.. 버튼의 value값은 4가 되어진다. 
			    	*/
			    	
			    	// *** 웹브라우저상에 count 출력하기
			    	$("#countHIT").text(parseInt($("#countHIT").text()) + $(productArr).length);
			    	
			    	// *** 더보기... 버튼을 계속해서 눌러서 countHIT 와  totalHITCount 가 일치하는 경우 
			    	//     버튼의 이름을 "처음으로" 라고 변경하고 countHIT 는 0 으로 초기화한다. 
			    	if( $("#totalHITCount").text() == $("#countHIT").text() ) {
			    		$("#btnMoreHIT").text("처음으로");
			    		$("#countHIT").text("0");
			    	}
			    	
			    }// end of if~else----------------------
				
			},// end of success: function(xml)----------------
			error: function(request, status, error){
			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
		
	}// end of function displayHitAppend(start)------
	

    var lenNEW = 3; // NEW상품 더보기.. 클릭에 보여줄 상품의 갯수 단위크기 
	
	function displayNewAppend(start) {
	
	// display 할 NEW 제품정보 추가 요청하기(Ajax로 처리함.)
	    
	    var form_data = {"start" : start,
		                 "len" : lenNEW,
		                 "pspec" : "NEW"};
	
		$.ajax({
			url: "malldisplayJSON.do",
			type: "GET",
			data: form_data,
			dataType: "JSON",
			success: function(json){
				 var html = "";
				    
				 if(json.length == 0) {
				   // 데이터가 아예 없는 경우이라면 
				   	html += "상품준비중 입니다...";
				    	
				   // *** NEW 상품 결과를 출력해주기
				    $("#displayResultNEW").html(html);
				    	
				   // 더보기 버튼의 비활성화 처리
				   	$("#btnMoreNEW").attr("disabled", true);
				    $("#btnMoreNEW").css("cursor","not-allowed");
				    	      
				 }
				 else {
				    	// 데이터가 존재하는 경우이라면
				    	$.each(json, function(entryIndex, entry){
				    		html += "<div align=\"left\" style=\"display: inline-block; margin: 30px;  \">"
							     +  "<br/><a href=\"/MyMVC/prodView.do?pnum="+entry.pnum+"\">"
							     +  "<img width=\"120px;\" height=\"130px;\" src=\"images/"+entry.pimage1+"\">" 
						         +  "</a>"
						         +  "<br/>"+entry.pname+""
						         +  "<br/><del>"+entry.price+"원</del>"
						         +  "<br/><span style=\"color: red; font-weight: bold;\">"+entry.saleprice+"원</span>"  
						         +  "<br/><span style=\"color: blue; font-weight: bold;\">["+entry.percent+"% 할인]</span>" 
						         +  "<br/><span style=\"color: orange;\">"+entry.point+" POINT</span>"
					             +  "</div>";	
					             
				    	});// end of $.each()------------------------------
				    	
				    	html += "<div style=\"clear: both;\">&nbsp;</div>";
				    	
				    	// *** NEW 상품 결과를 출력해주기
				    	$("#displayResultNEW").append(html);
				    	
				    	// >>>>> !!!! 중요 !!!! 더보기 버튼의 value 속성에 값을 지정해주기 <<<<<<
				    	$("#btnMoreNEW").val(parseInt(start) + lenNEW);
				    	/*
				    	    문서가 로딩되어지면 parseInt(start) 은 1이고
				    	  lenHIT는 3이므로 더보기.. 버튼의 value값은 4가 되어진다. 
				    	*/
				    	
				    	// *** 웹브라우저상에 count 출력하기
				    	$("#countNEW").text(parseInt($("#countNEW").text()) + json.length);
				    	
				    	// *** 더보기... 버튼을 계속해서 눌러서 countHIT 와  totalHITCount 가 일치하는 경우 
				    	//     버튼의 이름을 "처음으로" 라고 변경하고 countHIT 는 0 으로 초기화한다. 
				    	if( $("#totalNEWCount").text() == $("#countNEW").text() ) {
				    		$("#btnMoreNEW").text("처음으로");
				    		$("#countNEW").text("0");
				    	}
				    	
				    }// end of if~else----------------------
					
			},// end of success: function(json)----------------
			error: function(request, status, error){
			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
		
	}// end of function displayNewAppend(start)------	
	
</script>    
    
<h2>::: 쇼핑몰 상품 :::</h2>    
<br/>

<!-- HIT 상품 디스플레이 하기 -->
<table style="width: 90%; border: 0px solid gray; margin-bottom: 30px;" >
<thead>
	<tr>
		<th colspan="4" class="th" style="font-size: 14pt; background-color: #e1e1d0; height: 30px; text-align:center;">- HIT 상품(table) -</th>
	</tr>
	<tr>
		<th colspan="4" class="th">&nbsp;</th>
	</tr>
</thead>

<tbody id="displayResult"></tbody>
</table>

<div style="margin-top: 20px; margin-bottom: 20px;">
	<button type="button" id="btnMoreHIT" value="" >더보기...</button>
	<span id="totalHITCount">${totalHITCount}</span>
	<span id="countHIT">0</span>
</div>

<%--
<tbody>
<c:if test="${hitList == null || empty hitList}">
	<tr>
		<td colspan="4" class="td" align="center">현재 상품 준비중....</td>
	</tr>
</c:if>	

<c:if test="${hitList != null && not empty hitList}">
	<tr>
		<c:forEach var="prodvo" items="${hitList}" varStatus="status" >
		
			 varStatus    는 반복문의 상태정보를 알려주는 애트리뷰트 이다.   
			 status.index 는 0부터 시작한다.
			 status.count 는 반복횟수를 알려주는 것이다. 
		 
			<td class="td" align="center">
				<a href="<%= request.getContextPath() %>/prodView.do?pnum=${prodvo.pnum}">
					<img width="120px;" height="130px;" src="images/${prodvo.pimage1}">
				</a>
				<br/>${prodvo.pname}
				<br/><del><fmt:formatNumber value="${prodvo.price}" pattern="###,###" />원</del>
				<br/><span style="color: red; font-weight: bold;"><fmt:formatNumber value="${prodvo.saleprice}" pattern="###,###" />원</span>
				<br/><span style="color: blue; font-weight: bold;">[${prodvo.percent}% 할인]</span>
				<br/><span style="color: orange;">${prodvo.point} POINT</span>
			</td>
			<c:if test="${(status.count)%4 == 0}">
				</tr><tr>
			       <td colspan="4" class="td">&nbsp;</td>
				</tr><tr>
			</c:if>
		</c:forEach>
	</tr>
</c:if>
</tbody>
</table>
--%>

 <%-- ///////////////////////////////////////// --%>
 
 <!-- NEW상품 디스플레이(div 태그를 사용한 것) -->
 <div style="width: 90%; margin-top: 50px; margin-bottom: 30px;">
     <div style="text-align: center;
                 font-size: 14pt;
                 font-weight: bold;
                 background-color: #e1e1d0;
                 height: 30px;
                 margin-bottom: 15px;">
     	<span style="vertical-align: middle;">- NEW 상품(div) -</span>
     </div> 
     
     <div id="displayResultNEW" style="margin: auto; border: solid 0px red;"></div>

	 <div style="margin-top: 20px; margin-bottom: 20px;">
		 <button type="button" id="btnMoreNEW" value="" >더보기...</button>
		 <span id="totalNEWCount">${totalNEWCount}</span>
		 <span id="countNEW">0</span>
	 </div>
 
 </div>

<jsp:include page="../footer.jsp" />



    
    
    