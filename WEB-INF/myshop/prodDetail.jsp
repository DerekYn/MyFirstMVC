<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../header.jsp" />

<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/jquery-ui-1.11.4.custom/jquery-ui.min.css" /> 
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css" />
<script type="text/javascript" src="<%= request.getContextPath() %>/jquery-ui-1.11.4.custom/jquery-ui.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.js"></script> 


<script type="text/javascript">
   $(document).ready(function() {
	   
	   $("#spinner").spinner( {
		   
		   spin: function(event, ui) {
			   if(ui.value > 10) {
				   $(this).spinner("value", 0);
				   return false;
			   }
			   else if(ui.value < 0) {
				   $(this).spinner("value", 10);
				   return false;
			   }
		   }
		   
	   } );// end of $("#spinner").spinner({});----------------
	   
	   goLikeDislikeCountShow();
	   
   });// end of $(document).ready(function()-------------------------
   
   function openWin(imgFilename) {
	   
   // *** 새로고침(다시읽기) 방법 3가지 ***//
   //  window.location.reload();
   //  window.location.reload(true);
	   history.go(0);
	   
	   var url = "images/"+imgFilename;
	   
	   var imgObj = new Image();
	   imgObj.src = url;
	   
	// alert("width : " + imgObj.width + ", height : " + imgObj.height);
	
	   var w = imgObj.width;
	   var h = imgObj.height;
	   
	   window.open(url, "imgpop",
			       "width="+w+"px, height="+h+"px, left=200%, top=200%");
   }// end of openWin()--------------------------
   
   
   function goCart(pnum) { // pnum 은 제품번호 이다.
	   
	  // *** 주문량에 대한 유효성 검사하기 ***//
	  var frm = document.pnumFrm;
	  var regExp = /^[0-9]+$/; // 숫자만 체크하는 정규식
	  var bool = regExp.test(frm.oqty.value);
	  
	  if(!bool) {
		  // 숫자 이외의 값이 들어온 경우
		  alert("주문갯수는 1개 이상이어야 합니다.");
		  frm.oqty.value = "0";
		  frm.oqty.focus();
		  return;
	  }
	  else {
		  // 숫자가 들어온 경우
		  var oqty = parseInt(frm.oqty.value);
		  
		  if(oqty < 1) {
			  alert("주문갯수는 1개 이상이어야 합니다.");
			  frm.oqty.value = "0";
			  frm.oqty.focus();
			  return; 
		  }
		  else { // 올바르게 1개 이상 주문한 경우
			  frm.pnum.value = pnum;
		  
			  frm.method = "post";
		      frm.action = "cartAdd.do";
		      frm.submit();
		  }
	  }
	   
	   
   }// end of function goCart(pnum)------------------
   
   
   function goOrder(pnum) {
	   
		// *** 주문량에 대한 유효성 검사하기 ***//
		var frm = document.pnumFrm;
		var regExp = /^[0-9]+$/; // 숫자만 체크하는 정규식
		var bool = regExp.test(frm.oqty.value);
		  
		if(!bool) {
			// 숫자 이외의 값이 들어온 경우
			alert("주문갯수는 1개 이상이어야 합니다.");
			frm.oqty.value = "0";
			frm.oqty.focus();
			return;
		}
		else {
			// 숫자가 들어온 경우
			var oqty = parseInt(frm.oqty.value);
			  
			if(oqty < 1) {
				alert("주문갯수는 1개 이상이어야 합니다.");
				frm.oqty.value = "0";
				frm.oqty.focus();
				return; 
			}
			else { // 올바르게 1개 이상 주문한 경우
												
				var quantity = document.getElementById("spinner").value;
				
				// console.log(quantity);
				// console.log(typeof quantity);
				
				var sumtotalprice = parseInt("${pvo.saleprice}") * parseInt(quantity);
				var sumtotalpoint = parseInt("${pvo.point}") * parseInt(quantity);
															
				frm.pnum.value = pnum;
			  	frm.sumtotalprice.value = sumtotalprice;
			  	frm.sumtotalpoint.value = sumtotalpoint;
				
				frm.method = "post";
			    frm.action = "orderAdd.do";
			    frm.submit();
			}
		}
	   
   }// end of function goOrder(pnum)----------------
   
   
   function goLikeDislikeCountShow() {
	   
	   var form_data = {"pnum" : "${pvo.pnum}"};
	   
	   $.ajax({
		   
		   url: "likeDislikeCountShow.do",
		   type: "GET",
		   data: form_data,
		   dataType: "JSON",
		   
		   success: function(json) {
			   
			   var likecnt = json.likecnt;
			   var dislikecnt = json.dislikecnt;
									
			   $("#likecnt").html(likecnt);
			   $("#dislikecnt").html(dislikecnt);
				
		   },
		   error: function(request, status, error){   // 실패하면
				alert("code : " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
				// 어디가 에러인지 디버깅해서 알려준다.
			}
		   
	   });
	   
	   
   }// end of goLikeDislikeCountShow()-------------------------------------
   
   
   
   function goLikeAdd(pnum) {
	   
	   var form_data = {"userid" : "${sessionScope.loginuser.userid}",
			            "pnum" : pnum};
	   
	   $.ajax({
		  
		   url: "likeAdd.do",
		   type: "POST",
		   data: form_data,
		   dataType: "JSON",
		   
		   success: function(json) {
			   swal(json.msg);
			   goLikeDislikeCountShow();
		   },
		   error: function(request, status, error){   // 실패하면
				alert("code : " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
				// 어디가 에러인지 디버깅해서 알려준다.
			}
		   
	   });
	   
	   
   }// end of goLikeAdd(pnum)-------------------------------
   
   
   function godisLikeAdd(pnum) {
	   
	   var form_data = {"userid" : "${sessionScope.loginuser.userid}",
	                    "pnum" : pnum};
	   
	   $.ajax({
			  
		   url: "dislikeAdd.do",
		   type: "POST",
		   data: form_data,
		   dataType: "JSON",
		   
		   success: function(json) {
			   swal(json.msg);
			   goLikeDislikeCountShow();
		   },
		   error: function(request, status, error){   // 실패하면
				alert("code : " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
				// 어디가 에러인지 디버깅해서 알려준다.
			}
		   
	   });
	   
	   
   }// end of godisLikeAdd(pnum)-------------------------------
   
</script>

<div style="width: 95%; margin-top: 30px; margin-bottom: 30px;"> 
	<div style="text-align: center; margin-bottom: 50px;">
		<span style="font-size: 15pt; font-weight: bold;">::: 제품 상세 정보 :::</span>
	</div>
	<div align="center" style="float: left; width: 20%; margin-left: 20px; margin-bottom: 50px; border: 0px solid red;">
		<img src="images/${pvo.pimage1}" style="width: 90px; height: 90px; cursor: pointer;" onClick="openWin('${pvo.pimage1}');" />            
	</div>
	<div align="left" style="float: left; width: 50%; margin-left: 60px; margin-bottom: 30px; padding-left: 130px; line-height: 170%; border: 0px solid blue;">
		<span style="color: red; font-size: 12pt; font-weight: bold;">${pvo.pspec}</span>
		<br/>제품번호: ${pvo.pnum}
		<br/>제품이름: ${pvo.pname}
        <br/>제품정가: <del><fmt:formatNumber value="${pvo.price}" pattern="###,###" />원</del> 
        <br/>제품판매가: <span style="color: blue; font-weight: bold;"><fmt:formatNumber value="${pvo.saleprice}" pattern="###,###" />원</span>
        <br/>할 인 율: <span style="color: maroon; font-weight: bold;">${pvo.percent}% 할인</span>
        <br/>포 인 트: <span style="color: green; font-weight: bold;">${pvo.point} 포인트</span>
        <br/>잔고갯수: <span style="color: maroon; font-weight: bold;">${pvo.pqty} 개</span> 
       
        <%-- *** 장바구니 담기 및 바로주문하기 폼 *** --%>
        <form name="pnumFrm" style="margin-top: 20px;">
            
            <div>
            	<label for="spinner">주문갯수:</label>
            	<input id="spinner" name="oqty" value="1" style="width: 30px; height: 20px;"> 
            </div>
            <div style="margin-top: 20px;">
            	<button type="button" class="btn btn-info" onClick="goCart('${pvo.pnum}');">장바구니담기</button>
            	<button type="button" class="btn btn-warning" onClick="goOrder('${pvo.pnum}');">바로주문하기</button>
            </div>
            
            <input type="hidden" name="pnum" />	
            <input type="hidden" name="currentURL" value="${currentURL}" />
            
            <input type="hidden" name="saleprice" value="${pvo.saleprice}" />
            <input type="hidden" name="sumtotalprice" />
            <input type="hidden" name="sumtotalpoint" />
        </form> 
	</div>
	
	<div style="clear: both; width: 95%; margin: 60px;">
		<img src="images/${pvo.pimage2}" />
	</div>
	
	<c:if test="${imgFileList != null && not empty imgFileList}">
		<div style="width: 95%;">
			<c:forEach var="imagevo" items="${imgFileList}">
				<div align="center" style="margin: 30px;">
					<img src="images/${imagevo.imgfilename}" />
				</div>
			</c:forEach>
		</div>
	</c:if>
	
	<div style="width: 95%; margin: 60px;">
		<span style="color: red; font-weight: bold; font-size: 14pt; background-color: pink;">제품설명</span>
		<p>${pvo.pcontent}</p>
	</div>
	
	<div style="width: 95%; margin-top: 30px; margin-bottom: 50px; border: solid 0px red;">
		<div style="display: inline-block; margin-right: 400px border: solid 0px gray">
			<img src="<%= request.getContextPath() %>/images/like.png" style="cursor: pointer" onClick="goLikeAdd('${pvo.pnum}');" />
			<div style="display: block;">
				<span id="likecnt" style="color: blue; font-size: 16pt;"></span>
			</div>
		</div>	
		<div style="display: inline-block; margin-right: 40px border: solid 0px gray">
			<img src="<%= request.getContextPath() %>/images/dislike.png" style="cursor: pointer" onClick="godisLikeAdd('${pvo.pnum}');" />
			<div style="display: block;">
				<span id="dislikecnt" style="color: red; font-size: 16pt;"></span>
			</div>
		</div>
	</div>
	
</div>

<jsp:include page="../footer.jsp" />
    