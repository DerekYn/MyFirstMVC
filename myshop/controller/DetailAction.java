package myshop.controller;

import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import myshop.model.ProductDAO;
import myshop.model.ProductImagefileVO;
import myshop.model.ProductVO;
import util.my.MyUtil;

public class DetailAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		String pnum = req.getParameter("pnum");
		
		ProductDAO dao = new ProductDAO();
		
		ProductVO pvo = null;
		List<ProductImagefileVO> imgFileList = null;  // 복수개 이미지 파일
		
		try {
		     pvo = dao.getProductOneByPnum(pnum);
		     
		     imgFileList = dao.getProductImagefileByPnum(pnum); 
		     
		} catch(SQLException e) {
			MyUtil.invalidPath(req, this);
			return;
		}
		
		if(pvo == null) {
			// 사용자가 웹브라우저 주소창에서 존재하지 않는 pnum 값을 넣어서 장난친 경우이다.
		/*  String msg = "비정상적인 경로로 들어왔습니다.";
			String loc = "javascript:history.back();";
			
			req.setAttribute("msg", msg);
			req.setAttribute("loc", loc);
			
			this.setRedirect(false);
			this.setViewPage("/WEB-INF/msg.jsp");
		*/
		//	MyUtil.invalidPath(req, this);
		//  또는	
			super.invalidPath(req);
			
			return;
		}
		else {
			req.setAttribute("pvo", pvo);
			
			req.setAttribute("imgFileList", imgFileList); 
			
			// **** 로그인을 하지 않은 상태에서 
			// "장바구니담기" 또는 "바로주문하기"를 하면 로그인부터 해라고
			// 말이 나온다. 그러면 사용자가 로그인을 한 이후에는 
			// 특정 상품보기 페이지로 다시 돌아가야 한다.
			// 그래서 현재 특정 상품보기 페이지의 경로를 알아서 뷰단으로 넘겨주어야 한다.
			String currentURL = MyUtil.getCurrentURL(req);
			req.setAttribute("currentURL", currentURL);
			
			this.setRedirect(false);
			this.setViewPage("/WEB-INF/myshop/prodDetail.jsp"); 
		}

	}

}



