package test.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;

public class Test4Controller extends AbstractController  {
	
	// 생성되었나 안되었나를 확인하기 위한 생성자
	public Test4Controller() {
		System.out.println("==> test.controller.Test4Controller 클래스의 객체가 생성되었습니다.");
	}

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

		req.setAttribute("result", "Test4Controller 에서 넘겨준 값은 <span style='color: purple;'> \"하얼빈의 구국영웅\"</span> 입니다. ");
		req.setAttribute("name", "안중근");
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/test/test4.jsp");
		/*
		 	확장자가 .java 인 파일과 .xml 인 파일에서
		 	view 단 페이지의 경로를 나타낼때 맨 앞의  / 는 context 명/(/MyMVC) 이다. 
		 	즉, "/test/test1.jsp" 는 실제 "/MyMVC/test/test1.jsp" 이다.
		 */
		
	}

}
