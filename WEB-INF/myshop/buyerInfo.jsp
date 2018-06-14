<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css" />

<style>
	table#tblMemberRegister {
	     width: 90%;
	     border: hidden; /* 선을 숨기는 것 */
	     margin: 10px;
	}
	
	table#tblMemberRegister #th {
   		height: 40px;
   		text-align: center;
   		background-color: silver;
   		font-size: 14pt;
    }
	
	table#tblMemberRegister td {
   		height: 50px;
    }
	
</style>

<script type="text/javascript" src="<%= request.getContextPath() %>/js/jquery-3.3.1.min.js"></script>

<div align="center">

<c:if test="${empty mvo}">		
	<span style="color: red; font-weight: bold;">[${str_idx}]</span>번 회원정보는 존재하지 않습니다.
	<br/><br/>
	[<a href="javascript:self.close();">닫기</a>]
	<%-- javascript:self.close() 이 팝업창을 닫게 하는 것이다. --%>
</c:if>

<c:if test="${not empty mvo }">
	<form name="registerFrm">
	    <input type="hidden" name="idx" value="${mvo.idx}">
	    <input type="hidden" name="goBackURL" value="${goBackURL}">
	     
		<table id="tblMemberRegister">
			<tr>
				<th colspan="2" id="th">::: 구매자 ${mvo.userid}&nbsp;님의 정보  :::</th>
			</tr>
			<tr>
				<td style="width: 25%; font-weight: bold;">성명&nbsp;</td>
				<td style="width: 75%; text-align: left;">
				    <input type="text" name="name" id="name" value="${mvo.name}" class="requiredInfo" required />
				</td>
			</tr>
			
			<tr>
				<td style="width: 25%; font-weight: bold;">이메일&nbsp;</td>
				<td style="width: 75%; text-align: left;">
				    <input type="text" name="email" id="email" value="${mvo.email}" class="requiredInfo" placeholder="123@abc.com" required />
				</td>
			</tr>
			<tr>
				<td style="width: 25%; font-weight: bold;">연락처</td>
				<td style="width: 75%; text-align: left;">
					<input type="text" name="hp2" id="hp2" value="${mvo.hp1}" size="4" maxlength="4" />&nbsp;-&nbsp;
				    <input type="text" name="hp2" id="hp2" value="${mvo.hp2}" size="4" maxlength="4" />&nbsp;-&nbsp;
				    <input type="text" name="hp3" id="hp3" value="${mvo.hp3}" size="4" maxlength="4" />
				</td>
			</tr>
			<tr>
				<td style="width: 25%; font-weight: bold;">우편번호</td>
				<td style="width: 75%; text-align: left;">
				   <input type="text" name="post1" id="post1" value="${mvo.post1}" size="4" maxlength="3" />-
				   <input type="text" name="post2" id="post2" value="${mvo.post2}" size="4" maxlength="3" />&nbsp;&nbsp;
				</td>
			</tr>
			<tr>
				<td style="width: 25%; font-weight: bold;">주소</td>
				<td style="width: 75%; text-align: left;">
				   <input type="text" name="addr1" value="${mvo.addr1}" size="50" maxlength="100" /><br style="line-height: 200%"/>
				   <input type="text" name="addr2" value="${mvo.addr2}" size="50" maxlength="100" /><br/><br/>
				</td>
			</tr>
			<tr>
				<td style="width: 75%; text-align: right;">
					<br/>[<a href="javascript:self.close();">닫기</a>]
				</td>
			</tr>
		</table>
	</form>

</c:if>

</div>

