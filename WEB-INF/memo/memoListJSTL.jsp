<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="../header.jsp" />   
    
<script type="text/javascript">

	$(document).ready(function(){
		
		$("#sizePerPage").bind("change", function(){
			var frm = document.sizePerPageFrm;
			frm.method = "get";
			frm.action = "memoList.do";
			frm.submit();
		});
		
		$("#sizePerPage").val("${sizePerPage}");
		
		$("#allChkbox").click(function(){
			$(".delChkbox").prop('checked', $(this).is(':checked') );
			/* $(this).is(':checked') 은
			     선택자 $("#allChkbox") 이 체크 되어지면 true 를 나타내고,
			     선택자 $("#allChkbox") 이 체크가 안되어지면 false 를 나타내어주는 것이다.  
			*/
		});
		
	});// end of $(document).ready()------------------

	
	function msgDel() {
		
		var delChkboxArr = document.getElementsByName("delChkbox");
		
		var count = 0;
		for(var i=0; i<delChkboxArr.length; i++) {
			if(delChkboxArr[i].checked) {
				count++;
			}
		}// end of for---------------------
		
		if(count == 0) {
			alert("삭제할 글번호가 선택되지 않았습니다.");
			return;
		}
		else {
			var bool = confirm("선택한 글을 삭제하는 것이 맞습니까?");
			
			if(bool) {
				var frm = document.delFrm;
				frm.method = "post";
				frm.action = "memoDelete.do";
				frm.submit(); 
			}
		}
		
	}// end of msgDel()---------------------
	
	
</script>    

   <h2>::: 한줄 메모장 목록 :::</h2>
   
   <div align="left">
       <button type="button" style="margin-left: 50px; margin-top: 20px; margin-bottom: 10px;" onClick="msgDel();">메모내용 삭제</button>
   	   
   	   <form name="sizePerPageFrm" style="display: inline;">
   	      <span style="color: red; font-weight: bold; margin-left: 450px; margin-top: 20px; margin-bottom: 10px;">페이지당 글갯수-</span>
   	   	  <select name="sizePerPage" id="sizePerPage">
   	   	  	 <option value="10">10</option>
   	   	  	 <option value="5">5</option>
   	   	  	 <option value="3">3</option>
   	   	  </select>
   	   </form>
   </div>

   <table style="width: 95%;" class="outline">
   	 <thead>
   	    <tr>
   	        <th width="5%"  style="text-align: center;"><input type="checkbox" id="allChkbox" />&nbsp;<span style="color:red; font-size: 9pt;"><label for="allChkbox">전체선택</label></span></th>
   	    	<th width="5%"  style="text-align: center;">글번호</th>
   	    	<th width="35%" style="text-align: center;">글내용</th>
   	    	<th width="14%" style="text-align: center;">작성일자</th>
   	    	<th width="8%" style="text-align: center;">IP주소</th>
   	    	<th width="8%" style="text-align: center;">작성자</th>
   	    	<th width="8%" style="text-align: center;">성별</th>
   	    	<th width="8%" style="text-align: center;">나이</th>
   	    	<th width="9%" style="text-align: center;">email</th>
   	    </tr>  
   	 </thead>
   	 <tbody>
	   <c:if test="${memoList == null || empty memoList}">
		   <tr>
		       <td colspan="9">데이터가 없습니다.</td>
		   </tr>
       </c:if>
           
       <c:if test="${memoList != null && not empty memoList}">
          <form name="delFrm">
          <input type="hidden" name="url" value="memoList.do" />
          <c:forEach var="map" items="${memoList}">    
			   <tr>
			   	  <td style="text-align: center;">
			   	  	 <input type="checkbox" class="delChkbox" name="delChkbox" value="${map.idx}" />
			   	  	   <%-- 폼의 값을 action 페이지로 넘길때 체크박스는 체크가 되어진 것만 넘어간다. --%>
			   	  </td>
			   	  <td style="text-align: center;">${map.idx}</td>
		          <td style="text-align: center;">${fn:replace(map.msg, "<", "&lt;")}</td>  
			  	  <%-- HTML 에서 &nbsp; 공백     &lt; 부등호(<)  &gt; 부등호(>)    &amp; &   &quot;  " 이다.  --%>
			 <%-- <td style="text-align: center;">${map.msg}</td>  --%>
			   	  <td style="text-align: center;">${map.writedate}</td> 
			   	  <td style="text-align: center;">${map.cip}</td>
			   	  <td style="text-align: center;">${map.name}</td>
			   	  <td style="text-align: center;">${map.gender}</td>
			   	  <td style="text-align: center;">${map.age}</td>
			   	  <td style="text-align: center;">${map.email}</td>
			   </tr>
		   </c:forEach>
		   </form>
      </c:if> 
    </tbody>               
  </table> 
  
  <div align="center" style="margin-top: 20px;">
      ${pageBar}  <%-- 1 2 3 4 5 6 7 8 9 10 [다음] --%>
  </div>	   
                  
<jsp:include page="../footer.jsp" />  


                