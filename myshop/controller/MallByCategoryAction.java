package myshop.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import myshop.model.CategoryVO;
import myshop.model.ProductDAO;
import myshop.model.ProductVO;

public class MallByCategoryAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		// *** 카테고리 목록을 가져와서 왼쪽 로그인폼 아래에 보여주도록 한다. *** //
		super.getCategoryList(req);

		String code = req.getParameter("code");
		String cname = req.getParameter("cname");
		
		ProductDAO pdao = new ProductDAO();
		
	/*
		 GET 방식이므로 사용자가 웹브라우저 주소창에 직접입력하는 경우
		 입력한 값들이 카테고리목록(jsp_category 테이블)에 
		 존재하는 것을 입력했는지 존재하지 않는 것을 입력했는지 조사해서
		 존재하지 않는 것을 입력했다라면 사용자가 장난을 친 것이므로
		 페이지 조회결과를 javascript:history.back(); 으로
		 돌리겠다.
    */
		List<CategoryVO> categoryList = pdao.getCategoryList();
		
		boolean bool = false;
		
		if(categoryList != null) {
			for(int i=0; i<categoryList.size(); i++) {
				CategoryVO categoryVO = categoryList.get(i);
				
				if(categoryVO.getCode().equals(code)) {
					bool = true;
					break;
				}
			}// end of for-----------------------------
			
			if(!bool) {
				// jsp_category 테이블에 존재하지 않는 카테고리를 GET방식으로
				// 사용자가 직접 웹브라우저 URL에서 입력한 경우
				super.invalidPath(req);
				return;
			}
			
		}// end of if-------------------------------
		
		List<ProductVO> prodListByCategory = pdao.getProductsByCategory(code);
		
		req.setAttribute("prodListByCategory", prodListByCategory); 
		req.setAttribute("cname", cname); 
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/myshop/mallByCategory.jsp");
		
	}

}
