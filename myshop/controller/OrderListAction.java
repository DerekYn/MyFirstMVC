package myshop.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import member.model.MemberVO;
import myshop.model.CartVO;
import myshop.model.OrderDetailVO;
import myshop.model.ProductDAO;
import util.my.MyUtil;

public class OrderListAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		super.getCategoryList(req);
		
		MemberVO loginuser = super.getMemberLogin(req);
		// 로그인 유무 검사해주는 메소드 호출 
		
		if(loginuser != null) {
			// 로그인을 했으면 장바구니 목록을 조회해주겠다.
			
			// *** 페이징 처리 하기 이전의 장바구니 목록 *** //
			ProductDAO pdao = new ProductDAO();
		//	List<CartVO> cartList = pdao.getCartList(loginuser.getUserid());
			
			// 1. 페이징 처리를 위해 페이지당 보여줄 메모갯수를 받아오기(10 or 5 or 3)
			String str_sizePerPage = req.getParameter("sizePerPage");
			
			int sizePerPage = 0;
			
			try {
				if(str_sizePerPage == null) {
				   sizePerPage = 10;
				}
				else {
					sizePerPage = Integer.parseInt(str_sizePerPage);
					
					if(sizePerPage != 10 && sizePerPage != 5 && sizePerPage != 3) {
					   sizePerPage = 10;
					}
				}
			} catch(NumberFormatException e) {
				sizePerPage = 10;
			}
			System.out.println("==> 확인용 sizePerPage : " + sizePerPage);
			
			req.setAttribute("sizePerPage", sizePerPage);
			
			// 2. 전체 페이지 갯수 알아오기
			int totalPage = 0;
			int totalCountOrder = 0;
			
			if(loginuser.getUserid().equals("admin")) {
				totalCountOrder = pdao.getTotalCountOrder();
			}
			else {
				totalCountOrder = pdao.getTotalCountOrder(loginuser.getUserid());
				// System.out.println("==> 확인용 totalCountOrder : " + totalCountOrder);
			}
			
			totalPage = (int)Math.ceil( (double)totalCountOrder/sizePerPage );
			// System.out.println("==> 확인용 totalPage : " + totalPage);
			
			String str_currentShowPageNo = req.getParameter("currentShowPageNo");
			int currentShowPageNo = 0;
			
			try {
				
				if(str_currentShowPageNo == null) {
					currentShowPageNo = 1;
				}
				else {
					currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
					
					if(currentShowPageNo < 1 || currentShowPageNo > totalPage) {
						currentShowPageNo = 1;
					}
				}
				
			} catch(NumberFormatException e) {
				currentShowPageNo = 1;
			}
			
			List<HashMap<String, String>> orderList = null;
			
			// 3. 페이징 처리한 데이터 조회 결과물 만들기
			if(loginuser.getUserid().equals("admin")) {
				orderList = pdao.getAllOrder(currentShowPageNo, sizePerPage);
			}
			else {
				orderList = pdao.getAllOrder(loginuser.getUserid(), currentShowPageNo, sizePerPage); 
			}
			
			req.setAttribute("orderList", orderList);
			
			// **** 메소드로 pageBar 호출하기 **** //
			String url = "orderList.do";
			int blocksize = 10;
			
			String pageBar = MyUtil.getPageBar(url, currentShowPageNo, sizePerPage, totalPage, blocksize);
			
			req.setAttribute("pageBar", pageBar);
			
			super.setRedirect(false);
			super.setViewPage("WEB-INF/myshop/orderList.jsp");
		
		}
	}

}
