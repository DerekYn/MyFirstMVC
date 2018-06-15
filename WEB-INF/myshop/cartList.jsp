<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 

<jsp:include page="../header.jsp" />

<style type="text/css" >
      table#tblCartList {width: 90%;
                         border: solid gray 1px;
                         margin-top: 20px;
                         margin-left: 10px;
                         margin-bottom: 20px;}
                         
      table#tblCartList th {border: solid gray 1px;}
      table#tblCartList td {border: dotted gray 1px;} 

      .delcss {background-color: cyan;
        	   font-weight: bold;
        	   color: red;}
        	   
      .ordershoppingcss {background-color: cyan;
        	             font-weight: bold;
        	             color: blue;}  	   
</style>

<script type="text/javascript">

	$(document).ready(function(){
		
		$(".del").hover(function(){
			              $(this).addClass("delcss");
						}, 
						function(){
						  $(this).removeClass("delcss");
			});
		
		$(".ordershopping").hover(function(){
            $(this).addClass("delcss");
			}, 
			function(){
			  $(this).removeClass("delcss");
		});
		
	});

	
	function goOqtyEdit(oqtyID, cartnoID) {
		
	//	var oqty = document.getElementById(oqtyID).value; 
		var oqty = $("#"+oqtyID).val();
	
	//  var cartno = document.getElementById(cartnoID).value;
   	    var cartno = $("#"+cartnoID).val();

	//  console.log("주문량 : " + oqty);
	//  console.log("장바구니번호 : " + cartno);
	
	    var regExp = /^[0-9]+$/g;      // 숫자만 체크하는 정규식
	    var bool = regExp.test(oqty);
	    
	    if(!bool || parseInt(oqty) < 0) {
	    	alert("수정하시려는 수량은 0개 이상이어야 합니다.");
	    	location.href="cartList.do";
	    	return;
	    }
	
	    var frm = document.updateOqtyFrm;
	    frm.oqty.value = oqty;
	    frm.cartno.value = cartno;
	    frm.goBackURL.value = '${currentURL}';
	    
	    frm.method = "post";
	    frm.action = "cartEdit.do";
	    frm.submit();
				
	}// end of goOqtyEdit(oqtyID, cartnoID)---------------------
	
	
	function goDel(cartno) {
		
		var frm = document.deleteFrm;
		frm.cartno.value = cartno;
		frm.goBackURL.value = '${currentURL}';
		
		frm.method = "post";
		frm.action = "cartDel.do";
		frm.submit();
		
	}// end of goDel(cartno)--------------
	
	
	// 체크박스 모두선택 및 모두해제 되기 위한 함수
	function allCheckBox() {

		var bool = $("#allCheckOrNone").is(':checked');
		/* $(""#allCheckOrNone").is(':checked') 은
	            선택자 $("#allCheckOrNone") 이 체크 되어지면 true 를 나타내고,
	            선택자 $("#allCheckOrNone") 이 체크가 안되어지면 false 를 나타내어주는 것이다.  
	    */
		
		$(".chkboxpnum").prop('checked', bool);
			
	}// end of allCheckBox()------------
	
		
	
	
	// **** 주문하기 *****
	function goOrder() {
		
		var pnumArr = document.getElementsByName("pnum");
		
		var cnt = 0;
		var sumtotalprice = 0;
		var sumtotalpoint = 0;
		
		for(var i=0; i<pnumArr.length; i++) {
			
			// 주문을 위해 체크한 제품인 경우 주문총액 및  주문총 포인트를 구해주도록한다
			if(pnumArr[i].checked == true) {
				// 장바구니에서 주문을 위해  체크된 제품
				cnt++;
				
				// **** 주문량의 텍스트박스의 값이 숫자로 1개 이상인지 아닌지 검사
				var oqty = document.getElementById("oqty" + i).value;
				
				// console.log(oqty);
				
				var regExp = /^[0-9]+$/g;	// 숫자만 체크하는 정규식
				var bool = regExp.test(oqty);
				
				// console.log(bool);
				
				if(!bool) {	// 주문갯수에 숫자가 아닌 문자가 들어온 경우
					alert("주문량은 숫자로만 입력이 가능합니다.");
					return;
				}
				else if(bool && parseInt(oqty) < 1) {	// 주문갯수가 1보다 작은 경우
					alert("주문량은 1개이상만 가능합니다.");
					return;
				}
				
				sumtotalprice += parseInt(document.getElementById("totalprice" + i).value);
				sumtotalpoint += parseInt(document.getElementById("totalpoint" + i).value);
			
			}
			else if(pnumArr[i].checked == false) {
				// !!! ***** 중요 ***** !!! //
				// 장바구니에서 주문을 하지 않으려고 체크하지 않은 제품인 경우
				// 폼 전송 대상에서 제외 시키기 위해서 비 활성화 시킨다.
				
				document.getElementById("pnum" + i).disabled = true;  // 비활성화(true) / 활성화(false)
				document.getElementById("oqty" + i).disabled = true;
				document.getElementById("cartno" + i).disabled = true;
				document.getElementById("totalprice" + i).disabled = true;
				document.getElementById("totalpoint" + i).disabled = true;
				
			}
			
		}
		
		// console.log("누적 총 금액 : " + sumtotalprice);
		// console.log("누적 총 포인트 : " + sumtotalpoint);		
		
		if(cnt == 0) {
			// 주문할 제품에 체크가 한개도 안되어져 있을 경우
			alert("주문하실 제품을 하나 이상 선택하세요");
			
			for(var i=0; i<pnumArr.length; i++) {
				
				document.getElementById("pnum" + i).disabled = false;
				document.getElementById("oqty" + i).disabled = false;
				document.getElementById("cartno" + i).disabled = false;
				document.getElementById("totalprice" + i).disabled = false;
				document.getElementById("totalpoint" + i).disabled = false;
				
			}
			
			return;
		}
		else if(cnt > 0) {
			// 주문할 제품에 체크가 한개 이상 되어있고, 주문갯수도 숫자로 1개 이상으로 되어진 경우
			var yn = confirm("선택한 제품을 주문하시겠습니까?");
			
			// console.log(yn);
			
			if(yn == false) { // 취소를 선택한 경우
				return;
			}
			else { // 확인을 선택한 경우
				
				// 폼 전송을 하기 앞서서 사용자의 코인액이 주문총액보다
				// 적으면 주문을 못하도록 해야한다.
				var usercoin = "${(sessionScope.loginuser).coin}";
				
				// console.log(usercoin);
				// console.log(typeof usercoin);
				// console.log(typeof parseInt(usercoin));
				// console.log(typeof sumtotalprice);
				
				/* if( parseInt(usercoin) < sumtotalprice ) {
					alert("코인액이 부족해서 주문이 불가능합니다.");
					return;
				} */
				
				var frm = document.orderFrm;
			
				frm.sumtotalprice.value = sumtotalprice;
				frm.sumtotalpoint.value = sumtotalpoint;
			
				frm.method = "post";
				frm.action = "orderAdd.do";
				frm.submit();
			}
			
		}
	
	}// end of goOrder()-------------------
	

</script>

<h2>::: ${(sessionScope.loginuser).name} 님[ ${(sessionScope.loginuser).userid} ] 장바구니 목록 :::</h2>	

  <%-- 장바구니에 담긴 제품목록을 보여주고서 
       실제 주문을 하도록 form 생성한다. --%>
       
 <form name="orderFrm">
	<table id="tblCartList" >
	 <thead>
	   <tr>
		 <th style="border-right-style: none;">
		     <input type="checkbox" id="allCheckOrNone" onClick="allCheckBox();" />
			 <span style="font-size: 10pt;"><label for="allCheckOrNone">전체선택</label></span>
		 </th>
		 <th colspan="5" style="border-left-style: none; font-size: 12pt; text-align: center;">
			 주문하실 제품을 선택하신후 주문하기를 클릭하세요
		 </th>
	   </tr>
	   
	   <tr style="background-color: #cfcfcf;">
		  <th style="width:10%; text-align: center; height: 30px;">제품번호</th>
		  <th style="width:23%; text-align: center;">제품명</th>
	   	  <th style="width:17%; text-align: center;">수량</th>
	   	  <th style="width:20%; text-align: center;">판매가/포인트(개당)</th>
	   	  <th style="width:20%; text-align: center;">총액</th>
	   	  <th style="width:10%; text-align: center;">삭제</th>
	   </tr>	
	 </thead>
	 
	 <tbody>
	   <c:if test="${cartList == null || empty cartList}">
	   <tr>
	   	  <td colspan="6" align="center">
	   	    <span style="color: red; font-weight: bold;">
	   	    	장바구니에 담긴 상품이 없습니다.
	   	    </span>
	   	  </td>	
	   </tr>
	   </c:if>	
	   
	   <c:if test="${cartList != null && not empty cartList}">
	   	  <c:set var="cartTotalPrice" value="0" /> <!-- 장바구니 전체 총금액(누적)변수 및 초기치 선언 --> 
	   	  <c:set var="cartTotalPoint" value="0" /> <!-- 장바구니 전체 총포인트(누적)변수 및 초기치 선언 -->
	   	  
	   	  <c:forEach var="cartvo" items="${cartList}" varStatus="status">
	   	  	<!-- 
	   	  	     varStatus 는 반복문의 상태정보를 알려주는 애트리뷰트이다.
	   	  	     status.index ==> 0부터 시작한다.
	   	  	     status.count ==> 반복문의 횟수를 알려주는 것이다. 1부터 시작한다. 
	   	    -->
	   	  	
	   	  	<c:set var="cartTotalPrice" value="${cartTotalPrice + cartvo.item.totalPrice}" /> <!-- 누적시킴 -->
	   	  	<c:set var="cartTotalPoint" value="${cartTotalPoint + cartvo.item.totalPoint}" /> <!-- 누적시킴 --> 
	   	  	
	   	  	<tr>
	   	  		<td> <!-- 체크박스 및 제품번호 -->
	   	  			<input type="checkbox" name="pnum" id="pnum${status.index}" value="${cartvo.pnum}" class="chkboxpnum" />&nbsp;${cartvo.pnum}  
	   	  		</td>
	   	  		
	   	  		<td align="center"> <!-- 제품이미지1 및 제품명 -->
	   	  			<img src="images/${cartvo.item.pimage1}" width="130px" height="100px" />
	   	  			<br/>${cartvo.item.pname}
	   	  		</td>
	   	  		
	   	  		<td align="center"> <!-- 수량 -->
	   	  			<input type="text" name="oqty" id="oqty${status.index}" value="${cartvo.oqty}" size="2" /> 개
	   	  			
	   	  			<%-- 장바구니 번호 --%>
	   	  			<input type="hidden" name="cartno" id="cartno${status.index}" value="${cartvo.cartno}" size="4" />
                    <%-- !!!! **** 중요함 **** !!!!
	   	  		         forEach 에서 id를 고유하게 사용하는 방법
	   	  		         status.index 나 status.count 를 이용하면 된다.!!!!
	   	  		     --%>
	   	  			<button type="button" onClick="goOqtyEdit('oqty${status.index}','cartno${status.index}');">수정</button>
	   	  		</td>
	   	  		
	   	  		<td align="right"> <!-- 실판매단가 및 포인트 -->
	   	  			<fmt:formatNumber value="${cartvo.item.saleprice}" pattern="###,###" /> 원
	   	  			<input type="hidden" name="saleprice" value="${cartvo.item.saleprice}" />
	   	  			<br/>
	   	  			<span style="color: green; font-weight: bold;"><fmt:formatNumber value="${cartvo.item.point}" pattern="###,###" /> 포인트</span>
	   	  		</td>
	   	  		
	   	  		<td align="right"> <!-- 총금액 및 총포인트 -->
	   	  			<fmt:formatNumber value="${cartvo.item.totalPrice}" pattern="###,###" /> 원
	   	  			<input type=hidden id="totalprice${status.index}" value="${cartvo.item.totalPrice}" >
	   	  			<!-- 주문하기를 했을 경우 주문하려고 체크한 금액을 더해서 sumtotalprice 에 누적하기 위한 용도 -->
	   	  			<br/>
	   	  			<span style="color: green; font-weight: bold;"><fmt:formatNumber value="${cartvo.item.totalPoint}" pattern="###,###" /> 포인트</span>
	   	  			<input type="hidden" id="totalpoint${status.index}" value="${cartvo.item.totalPoint}" >
	   	  			<!-- 주문하기를 했을 경우 주문하려고 체크한 금액을 더해서 sumtotalprice 에 누적하기 위한 용도 -->
	   	  		</td>
	   	  		
	   	  		<td align="center"> <!-- 장바구니에서 해당 제품 삭제하기 -->
	   	  			<span class="del" style="cursor: pointer;" onClick="goDel('${cartvo.cartno}');" >삭제</span>
	   	  		</td>
	   	  	</tr>
	   	  </c:forEach> <%-- end of forEach --%>
	   </c:if>	
	   
	   <tr>
	   	  <td colspan="3" align="right">
	   	  	<span style="font-weight: bold;">장바구니 총액 : </span><span style="color: red; font-weight: bold;"><fmt:formatNumber value="${cartTotalPrice}" pattern="###,###" />원</span>
	   	  	<input type="hidden" name="sumtotalprice" />
	   	  	<%-- 주문하기를 클릭했을 경우 총 누적 금액을 orderAdd.do 로 넘기기 위한 용도 --%>
	   	  	<br/>
	   	  	<span style="font-weight: bold;">총 포인트 : </span><span style="color: red; font-weight: bold;"><fmt:formatNumber value="${cartTotalPoint}" pattern="###,###" />포인트</span>
	   	  	<input type="hidden" name="sumtotalpoint" />
	   	  	<%-- 주문하기를 클릭했을 경우 총 누적 포인트을 orderAdd.do 로 넘기기 위한 용도 --%>
	   	  </td>
	   	  <td colspan=" 3" align="center">
	   	     <span class="ordershopping" style="cursor: pointer;" onClick="goOrder();">[주문하기]</span>&nbsp;&nbsp;
	   	     <span class="ordershopping" style="cursor: pointer;" onClick="javascript:location.href='<%= request.getContextPath() %>/malldisplay.do'">[계속쇼핑]</span>
	   	  </td>
	   </tr>
	
	 </tbody>
	</table> 
 
 </form>          

 <div style="margin-top: 20px;">${pageBar}</div>

 <%-- 장바구니에 담긴 제품수량을 수정하는 form --%>
 <form name="updateOqtyFrm">
 	<input type="hidden" name="oqty" />
 	<input type="hidden" name="cartno" />
 	<input type="hidden" name="goBackURL" />
 </form>
 
 <%-- 장바구니에 담긴 제품을 삭제하는 form --%>
 <form name="deleteFrm">
 	<input type="hidden" name="cartno" />
 	<input type="hidden" name="goBackURL" />
 </form>
  
    
<jsp:include page="../footer.jsp" />
