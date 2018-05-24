package myshop.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import member.model.MemberVO;
import myshop.model.ProductDAO;

public class CartEditAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		String method = req.getMethod();
		
		if(!"post".equalsIgnoreCase(method)) {
			// POST 방식이 아니라면
			super.invalidPath(req);
			return;
		}
		else {
			// POST 방식이라면
			MemberVO loginuser = super.getMemberLogin(req);
			
			if(loginuser == null) {
				// 로그인을 안했으면 
				return;
			}
			else {
				// 로그인을 한 경우
				String oqty = req.getParameter("oqty");
				String cartno = req.getParameter("cartno");
				String goBackURL = req.getParameter("goBackURL");
				
				ProductDAO pdao = new ProductDAO();
				
				int n = pdao.editCart(oqty, cartno);
				
				String msg = (n>0)?"장바구니에 제품수량 변경 성공!!":"장바구니에 제품수량 변경 실패!!";
				String loc = (n>0)?goBackURL:"javascript:history.back();";
				
				super.alertMsg(req, msg, loc);
			}
			
		}// end of if~else---------------------

	}

}
