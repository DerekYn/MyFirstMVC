<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="../header.jsp" />

<style>
   table#tblMemberRegister {
   	    width: 90%;
   	    
   	    /* 선을 숨기는 것 */
   	    border: hidden;
   	    
   	    margin: 10px;
   }  
   
   table#tblMemberRegister #th {
   		height: 40px;
   		text-align: center;
   		background-color: silver;
   		font-size: 14pt;
   }
   
   table#tblMemberRegister td {
   		/* border: solid 1px gray; */
   		height: 50px;
   }
   
   .star { color: red;
           font-weight: bold;
           font-size: 13pt;
   }
</style> 
 
<script type="text/javascript" src="<%= request.getContextPath() %>/utiljs/util.js"></script> 

<script type="text/javascript">
	
	$(document).ready(function(){
		
		$(".error").hide();
		$("#error_passwd").hide();
		
	//	$("#userid").focus(); 
		
	/*  $("#userid").focus(function(){
			alert("USERID 텍스트 박스에 포커스가 왔습니다.");
		}); 
		// 선택자에 포커스가 들어왔을때 발생되어지는 이벤트 처리
		
		$("#userid").blur(function(){
			alert("USERID 텍스트 박스에 포커스를 잃어버렸습니다.");
		});
		// 선택자에 포커스가 들어왔다가 잃어버릴때 발생되어지는 이벤트 처리
	*/
	
		$(".requiredInfo").each(function(){
			
			$(this).blur(function(){
				var data = $(this).val().trim();
				if(data.length == 0) {
					// 입력하지 않거나 공백만 입력했을 경우
					// alert("입력하지 않거나 공백만 입력했을 경우");
					
					$(this).parent().find(".error").show();
					$(":input").attr("disabled",true).addClass("bgcol");
					$("#btnRegister").attr("disabled",true); 
					$(this).attr("disabled",false).removeClass("bgcol");
				}
				else{
					// 공백이 아닌 글자를 입력한 경우
					// alert("공백이 아닌 글자를 입력한 경우");
					$(this).parent().find(".error").hide();
					$(":input").attr("disabled",false).removeClass("bgcol");
					$("#btnRegister").attr("disabled",false); 
				}
			});
			
		});// end of $(".requiredInfo").each()----------------
		
		
		$("#userid").bind("keyup", function(){
			alert("아이디중복확인 버튼을 클릭하여 ID중복 검사를 하세요!!");
			$(this).val("");
		});// end of $("#userid").bind()------------
		
		
		$("#pwd").blur(function() {
			
			var passwd = $(this).val();
			
			/* var regexp_pw = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g;  */
			
			var regexp_passwd = new RegExp(/^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g); 
			/* 암호는 숫자,영문자,특수문자가 포함된 형태의 8~15글자 이하만 허락해주는 정규표현식 객체 생성 */
			
			var bool = regexp_passwd.test(passwd);
			/* 암호 정규표현식 검사를 하는 것 
			      정규표현식에 만족하면 리턴값은 true,
			      정규표현식에 틀리면 리턴값은 false */
			      
			if(!bool) {
				$("#error_passwd").show();
				$(":input").attr("disabled",true).addClass("bgcol");
				$("#btnRegister").attr("disabled",true); 
				$(this).attr("disabled",false).removeClass("bgcol");
			}   
			else {
				$("#error_passwd").hide();
				$(":input").attr("disabled",false).removeClass("bgcol");
				$("#btnRegister").attr("disabled",false); 
				$("#pwdcheck").focus();
			}
			
		});// end of $("#pwd").blur()-------------------
		
		
		$("#pwdcheck").blur(function(){
			var passwd = $("#pwd").val();
			var passwdCheck = $(this).val();
			
			if(passwd != passwdCheck) {
				$(this).parent().find(".error").show();
				$(":input").attr("disabled",true).addClass("bgcol");
				$("#btnRegister").attr("disabled",true);
				
			//	$("#pwd").attr("disabled",false).removeClass("bgcol");
				$(this).attr("disabled",false).removeClass("bgcol");
			}
			else {
				$(this).parent().find(".error").hide();
				$(":input").attr("disabled",false).removeClass("bgcol");
				$("#btnRegister").attr("disabled",false);
			}
			
		});// end of $("#pwdcheck").blur()--------------		
		
/*		
		$("#jubun1").blur(function(){
			
		  var jubun1 = $(this).val();
		  var regexp_jubun1 = /\d{6}/g;  // 숫자 6자리만 들어와야 하는 정규표현식 
		  var bool = regexp_jubun1.test(jubun1);
		  
		  if(!bool) {
			  $(this).parent().find(".error").show();
			  $(":input").attr("disabled",true).addClass("bgcol");
			  $("#btnRegister").attr("disabled",true);
			
			  $(this).attr("disabled",false).removeClass("bgcol");
		  }
		  else {
			  $(this).parent().find(".error").hide();
			  $(":input").attr("disabled",false).removeClass("bgcol");
			  $("#btnRegister").attr("disabled",false);
		  }
			
		});// end of $("#jubun1").blur()---------------
		
		
		$("#jubun2").blur(function(){
			
		  var jubun2 = $(this).val();
		  var regexp_jubun2 = /[1-4][0-9][0-9][0-9][0-9][0-9][0-9]/g;  
		  // 숫자 7자리만 들어오되
		  // 첫번째 숫자는 1 or 2 or 3 or 4 가 들어와야 하는 정규표현식. 
		  
		  var bool = regexp_jubun2.test(jubun2);
		  
		  if(!bool) {
			  $(this).parent().find(".error").show();
			  $(":input").attr("disabled",true).addClass("bgcol");
			  $("#btnRegister").attr("disabled",true);
			
			  $(this).attr("disabled",false).removeClass("bgcol");
		  }
		  else {
			  $(this).parent().find(".error").hide();
			  $(":input").attr("disabled",false).removeClass("bgcol");
			  $("#btnRegister").attr("disabled",false);
		  }
		  
		  var jubun = $("#jubun1").val() + $(this).val();
		  
		  var n = funChkJumin(jubun);
		  
		  if(n==0) { // 주민번호 공식에 틀린 경우
			  $(this).parent().find(".error").show();
			  $(":input").attr("disabled",true).addClass("bgcol");
			  $("#btnRegister").attr("disabled",true);
			
			  $("#jubun1").attr("disabled",false).removeClass("bgcol");  
			  $(this).attr("disabled",false).removeClass("bgcol");  
		  }
		  
		});// end of $("#jubun1").blur()---------------	
*/

		$("#hp2").blur(function(){
			
			var hp2 = $(this).val().trim();
			
			if(hp2 != "") {
				// 휴대폰 국번이 데이터가 들어온 경우
				
				var regexp_hp2 = /\d{3,4}/g; 
				// 숫자 3자리 또는 4자리만 들어오도록 허락해주는 정규표현식	
				
				var bool = regexp_hp2.test(hp2);
				
				if(!bool) {
					$(this).parent().find(".error").show();
					$(":input").attr("disabled",true).addClass("bgcol");
					$("#btnRegister").attr("disabled",true);
					
					$(this).attr("disabled",false).removeClass("bgcol");
				}
				else {
					$(this).parent().find(".error").hide();
					$(":input").attr("disabled",false).removeClass("bgcol");
					$("#btnRegister").attr("disabled",false);
				}
				
			}
			else {
				// 휴대폰 국번에 공백만 들어오거나 데이터가 안들어온 경우
				$(this).parent().find(".error").show();
				$(":input").attr("disabled",true).addClass("bgcol");
				$("#btnRegister").attr("disabled",true);
				
				$(this).attr("disabled",false).removeClass("bgcol");
			}
			
		});// end of $("#hp2").blur()--------------
		
		
		$("#hp3").blur(function(){
			var hp3 = $(this).val().trim();
			
			if(hp3 != "") {
				// 휴대폰 4자리에 데이터가 들어온 경우
				
				var regexp_hp3 = /\d{4}/g; 
				// 숫자 4자리만 들어오도록 허락해주는 정규표현식	
				
				var bool = regexp_hp3.test(hp3);
				
				if(!bool) {
					$(this).parent().find(".error").show();
					$(":input").attr("disabled",true).addClass("bgcol");
					$("#btnRegister").attr("disabled",true);
					
					$(this).attr("disabled",false).removeClass("bgcol");
				}
				else {
					$(this).parent().find(".error").hide();
					$(":input").attr("disabled",false).removeClass("bgcol");
					$("#btnRegister").attr("disabled",false);
				}
				
			}
			else {
				// 휴대폰 4자리에 공백만 들어오거나 데이터가 안들어온 경우
				$(this).parent().find(".error").show();
				$(":input").attr("disabled",true).addClass("bgcol");
				$("#btnRegister").attr("disabled",true);
				
				$(this).attr("disabled",false).removeClass("bgcol");
			}
			
		});// end of $("#hp3").blur()--------------
		
		$("#email").blur(function() {
			var email = $(this).val();
			
			var regexp_email = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i; 
	         // e메일을 검사해주는 정규표현식 객체 생성
	         
			var bool = regexp_email.test(email);
	         
	        if(!bool) {
	        	$(this).parent().find(".error").show();
				$(":input").attr("disabled",true).addClass("bgcol");
				$("#btnRegister").attr("disabled",true);
				
				$(this).attr("disabled",false).removeClass("bgcol");
	        } 
	        else {
	        	$(this).parent().find(".error").hide();
				$(":input").attr("disabled",false).removeClass("bgcol");
				$("#btnRegister").attr("disabled",false);
	        }
			
		});	// end of $("#email").blur()--------------------
		
		
	////////////////////////////////////////////////////
	    $("#idcheck").click(function() {
	    	
	    	// 팝업창 띄우기
	    	var url = "idDuplicateCheck.do";
	    	window.open(url, "idcheck",
	    			   "left=500px, top=100px, width=300px, height=230px");
	    	// 기본적으로 아무런 조건없이 그냥 어떤 창을 띄우면 method 는 GET 방식으로 움직인다. 
	    });// end of $("#idcheck").click()--------------
		
	    
	    $("#zipcodeSearch").click(function(){
	    	
	    	// 팝업창 띄우기
	    	var url = "zipcodeSearch.do";
	    	window.open(url, "zipcodeSearch",
	    			   "left=350px, top=100px, width=650px, height=500px");
	    	// 기본적으로 아무런 조건없이 그냥 어떤 창을 띄우면 method 는 GET 방식으로 움직인다.
	    });
	    
		
	});// end of $(document).ready()--------------------
	
	
	function goRegister(event) {
		
		var flagBool = false;
		
		$(".requiredInfo").each(function(){
			var data = $(this).val().trim();
			if(data == "") {
				flagBool = true;
				return false;
				/*
				   for문에서의 continue; 와 동일한 기능을 하는것이 
				   each(); 내에서는 return true; 이고,
				   for문에서의 break; 와 동일한 기능을 하는것이 
				   each(); 내에서는 return false; 이다.
				*/
			}
		});
		
		if(flagBool) {
			alert("필수입력란은 모두 입력하셔야 합니다.");
			event.preventDefault(); // click event 를 작동치 못하도록 한다.
			return;
		}
		else if( !$("#agree").is(":checked") ) {
			/* $("#agree").is(":checked") 은 
			   $("#agree") 이 체크가 되었으면 true,
			   $("#agree") 이 체크가 안되었으면 false 를 나타낸다. 
			*/
			alert("이용약관에 동의하셔야 합니다.");
			event.preventDefault(); // click event 를 작동치 못하도록 한다.
			return;
		}
		else {
			var frm = document.registerFrm;
			frm.method = "post";
			frm.action = "memberRegisterEnd.do";
			frm.submit();
		}
		
	}// end of goRegister(event)------------------
	
</script>

<div align="center">
<form name="registerFrm">

<table id="tblMemberRegister">
	<thead>
	<tr>
		<th colspan="2" id="th">::: 회원가입 (<span style="font-size: 10pt; font-style: italic;"><span class="star">*</span>표시는 필수입력사항</span>) :::</th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<td style="width: 20%; font-weight: bold;">성명&nbsp;<span class="star">*</span></td>
		<td style="width: 80%; text-align: left;">
		    <input type="text" name="name" id="name" class="requiredInfo" required /> 
			<span class="error">성명은 필수입력 사항입니다.</span>
		</td>
	</tr>
	<tr>
		<td style="width: 20%; font-weight: bold;">아이디&nbsp;<span class="star">*</span></td>
		<td style="width: 80%; text-align: left;">
		    <input type="text" name="userid" id="userid" class="requiredInfo" required />&nbsp;&nbsp;
		    <!-- 아이디중복체크 -->
		    <img id="idcheck" src="images/b_id_check.gif" style="vertical-align: middle;" />
		    <span class="error">아이디는 필수입력 사항입니다.</span>
		</td> 
	</tr>
	<tr>
		<td style="width: 20%; font-weight: bold;">비밀번호&nbsp;<span class="star">*</span></td>
		<td style="width: 80%; text-align: left;"><input type="password" name="pwd" id="pwd" class="requiredInfo" required />
			<span id="error_passwd">암호는 영문자,숫자,특수기호가 혼합된 8~15 글자로만 입력가능합니다.</span>
		</td>
	</tr>
	<tr>
		<td style="width: 20%; font-weight: bold;">비밀번호확인&nbsp;<span class="star">*</span></td>
		<td style="width: 80%; text-align: left;"><input type="password" id="pwdcheck" class="requiredInfo" required /> 
			<span class="error">암호가 일치하지 않습니다.</span>
		</td>
	</tr>
	<tr>
		<td style="width: 20%; font-weight: bold;">이메일&nbsp;<span class="star">*</span></td>
		<td style="width: 80%; text-align: left;"><input type="text" name="email" id="email" class="requiredInfo" placeholder="abc@def.com" /> 
		    <span class="error">이메일 형식에 맞지 않습니다.</span>
		</td>
	</tr>
	<tr>
		<td style="width: 20%; font-weight: bold;">연락처</td>
		<td style="width: 80%; text-align: left;">
		   <select name="hp1" id="hp1">
				<option value="010" selected>010</option>
				<option value="011">011</option>
				<option value="016">016</option>
				<option value="017">017</option>
				<option value="018">018</option>
				<option value="019">019</option>
			</select>&nbsp;-&nbsp;
		    <input type="text" name="hp2" id="hp2" size="4" maxlength="4" />&nbsp;-&nbsp;
		    <input type="text" name="hp3" id="hp3" size="4" maxlength="4" />
		    <span class="error error_hp">휴대폰 형식이 아닙니다.</span>
		</td>
	</tr>
	<tr>
		<td style="width: 20%; font-weight: bold;">우편번호</td>
		<td style="width: 80%; text-align: left;">
		   <input type="text" name="post1" id="post1" size="4" maxlength="3" />-
		   <input type="text" name="post2" id="post2" size="4" maxlength="3" />&nbsp;&nbsp;
		   <!-- 우편번호 찾기 -->
		   <img id="zipcodeSearch" src="images/b_zipcode.gif" style="vertical-align: middle;" />
		   <span class="error error_post">우편번호 형식이 아닙니다.</span>
		</td>
	</tr>
	<tr>
		<td style="width: 20%; font-weight: bold;">주소</td>
		<td style="width: 80%; text-align: left;">
		   <input type="text" id="addr1" name="addr1" size="60" maxlength="100" /><br style="line-height: 200%"/>
		   <input type="text" id="addr2" name="addr2" size="60" maxlength="100" />
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<label for="agree">이용약관에 동의합니다</label>&nbsp;<input type="checkbox" id="agree" />
		</td>
	</tr>
	<tr>
		<td colspan="2" style="text-align: center; vertical-align: middle;">
			<iframe src="agree/agree.html" width="85%" height="150px" class="box" ></iframe>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<button type="button" id="btnRegister" style="background-image:url('images/join.png'); border:none; width: 135px; height: 34px; margin-left: 30%;" onClick="goRegister(event);"></button>
		</td>
	</tr>
	</tbody>
</table>
</form>
</div>

<jsp:include page="../footer.jsp" />

