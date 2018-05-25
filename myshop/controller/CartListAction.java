package myshop.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import member.model.MemberVO;
import myshop.model.CartVO;
import myshop.model.ProductDAO;
import util.my.MyUtil;

public class CartListAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		// *** 카테고리 목록을 가져와서 왼쪽 로그인폼 아래에 보여주도록 한다. *** //
		super.getCategoryList(req);
		
		MemberVO loginuser = super.getMemberLogin(req);
		// 로그인 유무 검사해주는 메소드 호출 
		
		if(loginuser != null) {
			// 로그인을 했으면 주문내역 목록을 조회해주겠다.
			
			// *** 페이징 처리 하기 이전의 주문내역 목록 *** //
			ProductDAO pdao = new ProductDAO();
					
			// *** 페이징 처리하기 *** //
			String str_currentShowPageNo = req.getParameter("currentShowPageNo");
			int currentShowPageNo = 0;
			
			if(str_currentShowPageNo == null) {
				currentShowPageNo = 1;
			}
			else {
				try {
					currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
					
					if(currentShowPageNo < 1) {
					   currentShowPageNo = 1;
					}
					
				} catch(NumberFormatException e) {
					currentShowPageNo = 1;
				}
			}// end of if~else------------------------------	
			
			int sizePerPage = 3;
			int blockSize = 2;
			
			List<CartVO> cartList = pdao.getCartList(loginuser.getUserid(), currentShowPageNo, sizePerPage); 
			
			// *** 페이지바 만들기 *** //
			int totalCountCart = pdao.getTotalCartCount(loginuser.getUserid()); 
			int totalPage = (int)Math.ceil( (double)totalCountCart/sizePerPage );
			
			String pageBar = MyUtil.getPageBar("cartList.do", currentShowPageNo, sizePerPage, totalPage, blockSize);
			
			req.setAttribute("cartList", cartList);
			req.setAttribute("pageBar", pageBar);
			
			// *** 장바구니 수량수정 또는 삭제후 돌아갈 페이지를 위해 현재 URL 경로를 넘겨줌 *** //
			String currentURL = MyUtil.getCurrentURL(req);
			req.setAttribute("currentURL", currentURL);
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/myshop/cartList.jsp");
			
		}
		

	}

}




