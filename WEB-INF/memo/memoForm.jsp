<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:include page="../header.jsp" />

<style type="text/css">
	table#tblMemo {border: 1px solid gray;
	               border-collapse: collapse;}
	 
	table#tblMemo th {border: 1px solid gray;
	                  border-collapse: collapse;}
	                   
    table#tblMemo td {border: 1px solid gray;
	                  border-collapse: collapse;
	                  padding: 10px;}	
	                  
	input {height: 40px;}                                     
</style>

<script type="text/javascript">

	function goSubmit() {
		
		var userid = $("#userid").val().trim();
		if(userid == "") {
			alert("작성자를 입력하세요!!");
			return;
		}
		
		var msg = $("#msg").val().trim();
		if(msg == "") {
			alert("메모내용을 입력하세요!!");
			return;
		}
		
		var frm = document.memoFrm;
		frm.method = "post";
		frm.action = "memoWriteEnd.do";
		frm.submit();
	}// end of function goSubmit()-------------------

</script>

<h2> ::: 한줄 메모장 ::: </h2>
<br/>
<form name="memoFrm">
<table id="tblMemo" style="width: 90%;">
  <thead>
  	<tr style="height: 50px;">
  		<th colspan="2" style="text-align: center; font-size: 16pt;">♠♠ 한줄 메모장 ♠♠</th>
  	</tr>
  </thead>
  
  <tbody>
	<tr>	
		<td style="font-weight: bold;">작성자</td>
		<td align="left"><input type="text" name="userid" id="userid" size="40" value="${(sessionScope.loginuser).name}" class="box" readonly /></td>  
	</tr>
	<tr>
		<td style="font-weight: bold;">메모내용</td>
		<td align="left">
			<input type="text" name="msg" id="msg" size="70" maxlength="100" class="box" />
			<button type="button" style="margin-left: 20px;" onClick="goSubmit();" >메모남기기</button>
		</td>	
	</tr>  	
  </tbody>
</table>
</form>

<jsp:include page="../footer.jsp" />

    