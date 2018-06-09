<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>  

<!DOCTYPE html>
<html>
<head>
<script type="text/javascript">

	$(document).ready(function(){
		
		/* $("#name").val("${vo.name}"); */
		
	});
	
</script>

<meta charset="UTF-8">
<title>:::회원 정보 수정:::</title>
<style>

	table#tblMemberRegister {
		width: 90%;
		border:hidden;/* 선을 숨기는 것*/
		margin: 10px;
		
	}
	
	table#tblMemberRegister #th {
		height: 40px;
		text-align: center;
		background-color: silver;
		font-size: 14pt;
		
	}
	
	table#tblMemberRegister td {
		/* border : 1px solid gray; */
		height: 50px;		
	}
	

	
	.star { color: red;
			font-weight: bold;
			font-size: 14pt;
			}


</style>



<div align="center">
<form name="editFrm">

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
		    <input type="hidden" name="idx" id="idx" readonly />
		    <input type="text" name="name" id="name" class="requiredInfo" required /> 
			<span class="error">성명은 필수입력 사항입니다.</span>
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
		   <img id="zipcodeSearch" src="../images/b_zipcode.gif" style="vertical-align: middle;" />
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
			<button type="button" id="btnUpdate" style="margin-left: 30%; margin-top: 10%; width: 80px; height: 40px" onClick="goEdit(event);"><span style="font-size: 15pt;">확인</span></button>
		</td>
	</tr>
	</tbody>
</table>
</form>
</div>
	
	