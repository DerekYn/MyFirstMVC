<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 

<jsp:include page="../header.jsp" />

<style type="text/css" >
      table#tblOrderList {width: 90%;
                         border: solid gray 1px;
                         margin-top: 20px;
                         margin-left: 10px;
                         margin-bottom: 20px;}
                         
      table#tblOrderList th {border: solid gray 1px;}
      table#tblOrderList td {border: dotted gray 1px;} 

      .delcss {background-color: cyan;
        	   font-weight: bold;
        	   color: red;}
        	   
      .ordershoppingcss {background-color: cyan;
        	             font-weight: bold;
        	             color: blue;}  	   
</style>

<script type="text/javascript">

	$(document).ready(function(){
				
		$("#sizePerPage").bind("change", function(){
			var frm = document.sizePerPageFrm;
			
			frm.sizePerPage.value = document.getElementById("sizePerPage").value;
			
			frm.method = "get";
			frm.action = "orderList.do";
			frm.submit();
		});
		
		$("#sizePerPage").val("${sizePerPage}");
	
		$("#btnDeliverStart").click(function(){
			
			var flag = false;
			
			$(".odrcode").prop("disabled", true); // 비활성화
			
			$(".deliverStartPnum").each(function(){ // 선택자 : 배송시작 체크박스
				var bool = $(this).is(":checked");  // 체크박스의 체크유무 검사
				
				if(bool == true) { // 체크박스에 체크가 되어 있으면
					 $(this).next().next().prop("disabled", false); // 활성화
					 flag = true;
				 } 
			}); 
			
			if(flag == false) {
				alert("먼저 하나이상의 배송을 시작할 제품을 선택하셔야 합니다.");
			}
			else {
				frmDeliver.method = "post";
				frmDeliver.action = "deliverStart.do";
				frmDeliver.submit();
			}
			
		});
		
		
		
		$("#btnDeliverEnd").click(function(){
			
			var flag = false;
			
			$(".odrcode").prop("disabled", true); // 비활성화
			
			$(".deliverEndPnum").each(function(){ // 선택자 : 배송완료 체크박스
				var bool = $(this).is(":checked"); // 체크박스의 체크유무 검사
				
				if(bool == true) { // 체크박스에 체크가 되어 있으면
					 $(this).next().next().prop("disabled", false); // 활성화
					 flag = true;
				}
			});
			
			if(flag == false) {
				alert("먼저 하나이상의 배송완료된 제품을 선택하셔야 합니다.");
			}
			else {
				var frm = document.frmDeliver;
				frm.method = "post";
				frm.action = "deliverEnd.do";
				frm.submit();
			}
		});
		
		
	});// end of $(document).ready();-----------------------------
	

	function allCheckBoxStart() { 
	   var bool = document.getElementById("allCheckStart").checked;
	   var deliverStartPnumArr = document.getElementsByName("deliverStartPnum");
	   
	   for(var i=0; i < deliverStartPnumArr.length; i++) { 
		   deliverStartPnumArr[i].checked = bool;
	   } 
	   
	} // end of allCheckBoxStart()----------------------------
	
	
	function allCheckBoxEnd() { 
		   var bool = document.getElementById("allCheckEnd").checked; 
		   var deliverEndPnumArr = document.getElementsByName("deliverEndPnum"); 
		   
		   for(var i=0; i < deliverEndPnumArr.length; i++) { 
			   deliverEndPnumArr[i].checked = bool;
		   } 
		   
	} // end of allCheckBoxEnd()----------------------------
			
	function showBuyerInfo(userid) {
		
		// 팝업창 띄우기
		var url="showBuyerInfo.do?userid="+userid;
		
		window.open(url, "showBuyerInfo",
				    "left=350px, top=100px, width=650px, height=570px");
		
	}// end of goLogOut()---------------------
	

		
</script>
<c:if test="${sessionScope.loginuser != null && (sessionScope.loginuser).userid eq 'admin'}">
	<h2>::: 모든 회원들의 최근 1년 이내 주문내역 목록 :::</h2>	
</c:if>

<c:if test="${sessionScope.loginuser != null && (sessionScope.loginuser).userid ne 'admin'}">
	<h2>::: ${(sessionScope.loginuser).name} 님[ ${(sessionScope.loginuser).userid} ] 최근 1년 이내 주문내역 목록 :::</h2>	
</c:if>

  <%-- 장바구니에 담긴 제품목록을 보여주고서 
       실제 주문을 하도록 form 생성한다. --%>
       
   <form name="sizePerPageFrm">
		<input type="hidden" name="sizePerPage" />
   </form>
   <form name="frmDeliver">
       <table>
			<tr>
				<th colspan="4" style="text-align: center; font-size: 14pt; font-weight: bold; border-right-style: none;"> 주문내역 보기 </th>
				<th colspan="3" style="text-align: center; border-left-style: none;">
					<span style="color: red; font-weight: bold;">페이지당 갯수-</span>
					<select id="sizePerPage">
						<option value="10">10</option>
						<option value="5">5</option>
						<option value="3">3</option>
					</select>
			    </th>
			</tr>
	
		  <c:if test='${(sessionScope.loginuser).userid eq "admin"}'>
			<tr>	
				<td colspan="7" align="right" > 
					<input type="checkbox" id="allCheckStart" onClick="allCheckBoxStart();"><label for="allCheckStart"><span style="color: green; font-weight: bold; font-size: 9pt;">전체선택(배송시작)</span></label>&nbsp;
					<input type="button" name="btnDeliverStart" id="btnDeliverStart" value="배송시작" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					
					<input type="checkbox" id="allCheckEnd" onClick="allCheckBoxEnd();"><label for="allCheckEnd"><span style="color: red; font-weight: bold; font-size: 9pt;">전체선택(배송완료)</span></label>&nbsp;
					<input type="button" name="btnDeliverEnd" id="btnDeliverEnd" value="배송완료">
				</td>
			</tr>
		  </c:if>
		</table>
 
	<table id="tblOrderList" >
	 <thead>
	   
	   
	   <tr style="background-color: #cfcfcf;">
		  <th style="width:10%; text-align: center; height: 30px;">주문코드(전표)</th>
		  <th style="width:15%; text-align: center;">주문일자</th>
	   	  <th style="width:25%; text-align: center;">제품정보</th>
	   	  <th style="width:8%; text-align: center;">주문량</th>
	   	  <th style="width:10%; text-align: center;">금액</th>
	   	  <th style="width:10%; text-align: center;">배송상태 </th>
	   </tr>	
	 </thead>
	 
	 <tbody>
	   <c:if test="${orderList == null || empty orderList}">
	   <tr>
	   	  <td colspan="7" align="center">
	   	    <span style="color: red; font-weight: bold;">
	   	    	최근 1년 내에 주문내역이 없습니다.
	   	    </span>
	   	  </td>	
	   </tr>
	   </c:if>	
	   
	   <c:if test="${orderList != null && not empty orderList}">
	   	 
	   	  <c:forEach var="map" items="${orderList}" >
   	  	
	   	  	<tr>
	   	  		<td align="center">
	   	  			<c:if test="${sessionScope.loginuser != null && (sessionScope.loginuser).userid ne 'admin'}">
						${map.fk_odrcode}
					</c:if>
					
					<c:if test="${sessionScope.loginuser != null && (sessionScope.loginuser).userid eq 'admin'}">
						[ <a href="javascript:showBuyerInfo('${map.fk_userid}');">${map.fk_odrcode}</a> ]
					</c:if>
	   	  		</td>	
	   	  		
	   	  		<td align="center">
	   	  			${map.odrdate}
	   	  		</td>
	   	  		
	   	  		<td align="center">
	   	  			<img src="images/${map.pimage1}"/><br/>
	   	  			제품 번호 : ${map.pnum}<br/>
	   	  			제품명 : ${map.pname}<br/>
	   	  			판매 정가 : <del>${map.price}</del><br/>
	   	  			판매가 : ${map.odrprice}<br/>
	   	  			포인트 : ${map.point}<br/>
	   	  			
	   	  		</td>
	   	  		
	   	  		<td align="center">
	   	  			${map.oqty}
	   	  		</td>
	   	  		
	   	  		<td align="center">
	   	  			${map.odrprice * map.oqty}
	   	  		</td>
	   	  		
	   	  		<td align="center"> <!-- 배송상태 -->
				
					<c:choose>
						<c:when test="${map.deliverstatus == '주문완료'}">
							주문완료<br/>
						</c:when>
						<c:when test="${map.deliverstatus == '배송시작'}">
							<span style="color: green; font-weight: bold; font-size: 12pt;">배송시작</span><br/>
						</c:when>
						<c:when test="${map.deliverstatus == '배송완료'}">
							<span style="color: red; font-weight: bold; font-size: 12pt;">배송완료</span><br/>
						</c:when>
					</c:choose>
	
					<c:if test='${(sessionScope.loginuser).userid eq "admin" }'>
						<br/><br/>
						<c:if test="${map.deliverstatus == '주문완료'}">
							<input type="checkbox" class="deliverStartPnum" name="deliverStartPnum" id="chkDeliverStart${status.index}" value="${map.pnum}"><label for="chkDeliverStart${status.index}">배송시작</label> 
							<input type="hidden" class="odrcode" name="odrcode" value="${map.fk_odrcode}"  />
						</c:if>
						<br/>
						<c:if test="${map.deliverstatus == '주문완료' or map.deliverstatus == '배송시작'}">
							<input type="checkbox" class="deliverEndPnum" name="deliverEndPnum" id="chkDeliverEnd${status.index}" value="${map.pnum}"><label for="chkDeliverEnd${status.index}">배송완료</label>
							<input type="hidden" class="odrcode" name="odrcode" value="${map.fk_odrcode}"  />
						</c:if>
					</c:if>
				</td>
	   	  
	   	  	</tr>
	   	  </c:forEach> 
	   </c:if>	
	
	 </tbody>
	</table> 
 
 </form>          

 <div style="margin-top: 20px;">${pageBar}</div>


    
<jsp:include page="../footer.jsp" />
