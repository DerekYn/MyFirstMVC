<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String ctxname = request.getContextPath();
%>

<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" type="text/css" href="<%= ctxname %>/bootstrap-3.3.7-dist/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="<%= ctxname %>/css/style.css" />
<script type="text/javascript" src="<%= ctxname %>/js/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="<%= ctxname %>/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script> 

<style>
	#div_name {
		width: 70%;
		height: 15%;
		margin-bottom: 5%;
		margin-left: 10%;
		position: relative;
	}
	
	#div_mobile {
		width: 70%;
		height: 15%;
		margin-bottom: 5%;
		margin-left: 10%;
		position: relative;
	}
	
	#div_findResult {
		width: 70%;
		height: 15%;
		margin-bottom: 5%;
		margin-left: 10%;		
		position: relative;
	}
	
	#div_btnFind {
		width: 70%;
		height: 15%;
		margin-bottom: 5%;
		margin-left: 10%;
		position: relative;
	}
	
</style>

<script type="text/javascript">
	
	$(document).ready(function(){
		 
		var method = "${method}";
	 // console.log(method);
	    
	    if(method == "GET") {
	    	$("#div_findResult").hide();
	    }
	    
	    $("#btnFind").click(function(){
	    	var frm = document.idFindFrm;
	    	frm.method = "post";
	    	frm.action = "<%= ctxname %>/idFind.do";
	    	frm.submit();
	    });
	    
	    if(method == "POST") {
	    	var name = "${name}";
		    var mobile = "${mobile}";

		    $("#name").val(name);
		    $("#mobile").val(mobile);
		    $("#div_findResult").show();
	    }
	    
	});
	
</script>


<form name="idFindFrm">
   <div id="div_name" align="center">
      <span style="color: blue; font-size: 12pt;">성명</span><br/> 
      <input type="text" name="name" id="name" size="15" placeholder="홍길동" required />
   </div>
   
   <div id="div_mobile" align="center">
   	  <span style="color: blue; font-size: 12pt;">휴대전화</span><br/>
      <input type="text" name="mobile" id="mobile" size="15" placeholder="-없이 입력하세요" required />
   </div>
   
   <div id="div_findResult" align="center">
   	  ID : <span style="color: red; font-size: 16pt; font-weight: bold;">${userid}</span> 
   </div>
   
   <div id="div_btnFind" align="center">
   		<button type="button" class="btn btn-success" id="btnFind">찾기</button>
   </div>
   
</form>

    