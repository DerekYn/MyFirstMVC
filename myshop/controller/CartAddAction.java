package myshop.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import member.model.MemberVO;
import myshop.model.ProductDAO;
import util.my.MyUtil;

public class CartAddAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		String method = req.getMethod();
		
		if(!"post".equalsIgnoreCase(method)) {
		// GET 방식이라면
			
		//	MyUtil.invalidPath(req, this);
		//  또는
			super.invalidPath(req);
			
			return;
		}
		else {
		// POST 방식이라면
			
			MemberVO loginuser = super.getMemberLogin(req); 
		 	// 로그인 유무 검사하기 
			// ==> 로그인을 안한 경우이라면 alert 발생되어지고
			//     loginuser 에는 null 리턴되어진다.
			
            if(loginuser == null) {
			// 로그인을 하지 않은 상태에서 장바구니 담기를 시도한 경우
            	String currentURL = req.getParameter("currentURL");
            	
            	HttpSession session = req.getSession();
            	session.setAttribute("returnPage", currentURL);
            	
            	return;
            }
            
            // *** 정상적으로 로그인을 해서 장바구니에 특정제품을 담는 경우 *** //
            String pnum = req.getParameter("pnum");
    		String oqty = req.getParameter("oqty"); 
    		
    		ProductDAO pdao = new ProductDAO();
    		int n = pdao.addCart(loginuser.getUserid(), pnum, oqty); 
    		
            if(n==1) {
            	super.alertMsg(req, "장바구니 담기 성공!!", "cartList.do");
            }
            else {
            	super.alertMsg(req, "장바구니 담기 실패!!", "javascript:history.back();"); 
            }
            
		}// end of if~else-------------------------
		
		

	}

}
