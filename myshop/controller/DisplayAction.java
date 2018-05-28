package myshop.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import myshop.model.InterProductDAO;
import myshop.model.ProductDAO;
import myshop.model.ProductVO;

public class DisplayAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		// *** 카테고리 목록을 가져와서 왼쪽 로그인폼 아래에 보여주도록 한다. *** //
		super.getCategoryList(req);
		
		InterProductDAO dao = new ProductDAO();
		
		// 1. HIT 상품 가져오기
		
	//	List<ProductVO> hitList = dao.selectByPspec("HIT"); 
		// 페이징 처리 안한것.
		
	//	req.setAttribute("hitList", hitList);
		// 페이징 처리 안한것.
		
		int totalHITCount = dao.totalSpecCount("HIT");
		// Ajax(XML,JSON)를 사용하여 상품목록의 페이징처리를 더보기 방식을 위한것임.
		// HIT 상품의 전체 갯수를 조회해오는 것
		
		int totalNEWCount = dao.totalSpecCount("NEW");
		// Ajax(XML,JSON)를 사용하여 상품목록의 페이징처리를 더보기 방식을 위한것임.
		// NEW 상품의 전체 갯수를 조회해오는 것
		
		req.setAttribute("totalHITCount", totalHITCount);
		req.setAttribute("totalNEWCount", totalNEWCount);
		
		super.setRedirect(false);
	//	super.setViewPage("/WEB-INF/myshop/malldisplay.jsp");
		// 페이징 처리 안한것.
		super.setViewPage("/WEB-INF/myshop/malldisplayAjax.jsp");
		// Ajax(XML,JSON)를 사용하여 상품목록의 페이징처리를 더보기 방식으로 한것임.
		
	}

}
