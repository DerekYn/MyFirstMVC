package common.controller;

import java.sql.SQLException;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import member.model.MemberVO;
import myshop.model.CategoryVO;
import myshop.model.ProductDAO;

public abstract class AbstractController 
       implements Command {

	private boolean isRedirect = false;
	/*
	     view단 페이지(.jsp 페이지)로 이동시
	     redirect 방법(데이터 전달은 못하고 단순히 페이지 이동만 하는것)으로 
	         이동시키고자 한다라면
	     isRedirect 변수의 값을 true 로 해주면 된다.
	     
	     view단 페이지(.jsp 페이지)로 이동시
	     forward(dispatcher) 방법(데이터 전달을 하면서 페이지 이동을 하는것)
	         으로 이동시키고자 한다라면 
	     isRedirect 변수의 값을 false 로 해주면 된다.
	     
	         이렇게 우리끼리 약속을 세웠다. 
	 */
	
	private String viewPage;
	// view단 페이지(.jsp 페이지)의 경로명으로 사용되어지는 변수이다.

	public boolean isRedirect() {
		return isRedirect;
		// 리턴타입이 boolean 이라면 get 이 아니라 is 로 나타난다.
	}

	public void setRedirect(boolean isRedirect) {
		this.isRedirect = isRedirect;
	}

	public String getViewPage() {
		return viewPage;
	}

	public void setViewPage(String viewPage) {
		this.viewPage = viewPage;
	}
	
	// ----------- 로그인 유무 검사 ----------------- //
	public MemberVO getMemberLogin(HttpServletRequest req) { 
	/*
	    세션에 "loginuser" 가 올라와 있으면 
	    로그인한 사용자의 정보(MemberVO)를 리턴해주고,
	    세션에 "loginuser" 가 올라와 있지 않으면
	  null 을 리턴하겠다.      
	*/
		MemberVO membervo = null;
		
		HttpSession session = req.getSession();
		membervo = (MemberVO)session.getAttribute("loginuser");
		
		if(membervo == null) {
			// 로그인을 하지 않은 경우
			String msg = "먼저 로그인 하세요!!";
			String loc = "javascript:history.back();";
			
			req.setAttribute("msg", msg);
			req.setAttribute("loc", loc);
			
			setRedirect(false);
			setViewPage("/WEB-INF/msg.jsp");
		}
		
		return membervo;
		
	}// end of getMemberLogin(HttpServletRequest req)-----------
	
	
    public void invalidPath(HttpServletRequest request) {
		
		String msg = "비정상적인 경로로 들어왔습니다.";
		String loc = "javascript:history.back();";
		
		request.setAttribute("msg", msg);
		request.setAttribute("loc", loc);
		
		setRedirect(false);
		setViewPage("/WEB-INF/msg.jsp");
		
	}// end of invalidPath()-----------------
    
    
    public void alertMsg(HttpServletRequest request, String message, String location) { 
		
		String msg = message;
		String loc = location;
		
		request.setAttribute("msg", msg);
		request.setAttribute("loc", loc);
		
		setRedirect(false);
		setViewPage("/WEB-INF/msg.jsp");
		
	}// end of alertMsg(HttpServletRequest request, String message, String location)----------------- 
    
	
    public void getCategoryList(HttpServletRequest request) throws SQLException {
    	
    	// jsp_category 테이블에서
    	// 카테고리코드(code)와 카테고리명(cname)을 가져와서
    	// request 영역에 저장시킨다.
    	ProductDAO pdao = new ProductDAO();
    	List<CategoryVO> categoryList = pdao.getCategoryList(); 
    	
    	request.setAttribute("categoryList", categoryList);
    	
    }// end of getCategoryList(HttpServletRequest request)------------------------------
    
	
}
