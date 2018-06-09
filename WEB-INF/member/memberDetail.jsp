<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="../header.jsp" />

<script type="text/javascript">
	
	function goMemberList(goBackURL){
		
		location.href = "javascript:history.back()";
		
	}

</script>


<table class="outline">
	<thead>
		<tr>
	   		<th class="th">회원번호</th>
	   		<th class="th">회원명</th>
			<th class="th">아이디</th>
			<th class="th">이메일</th>
			<th class="th">휴대폰</th>
			<th class="th">주소</th>
			<th class="th">가입일자</th>
		</tr>
	</thead>
	
	<tbody>
		<tr>
			<td class="td">${vo.idx}</td>
	   		<td class="td">${vo.name}</td>
			<td class="td">${vo.userid}</td>
			<td class="td">${vo.email}</td>
			<td class="td">${vo.allHp}</td>
			<td class="td">${vo.allAddr} (${vo.allPost})  </td>
			<td class="td">${vo.registerday} </td> 
		</tr>
	</tbody>
</table>
<button onClick="goMemberList();">돌아가기</button>

<jsp:include page="../footer.jsp" />