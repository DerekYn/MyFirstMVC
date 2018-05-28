package myshop.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import myshop.model.InterProductDAO;
import myshop.model.ProductDAO;
import myshop.model.ProductVO;

public class DisplayXMLAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		String start = req.getParameter("start");  // 1
		String len = req.getParameter("len");      // 3
		String pspec = req.getParameter("pspec");  // "HIT"
		
		if(start == null || start.trim().isEmpty()) {
			start = "1";
		}
		
		if(len == null || len.trim().isEmpty()) {
			len = "3";
		}
		
		if(pspec == null || pspec.trim().isEmpty()) {
			pspec = "HIT";
		}
		
		System.out.println("==> 확인용 DisplayXMLAction.java  start : " + start); 
		System.out.println("==> 확인용 DisplayXMLAction.java  len : " + len);
		System.out.println("==> 확인용 DisplayXMLAction.java  pspec : " + pspec);
		
		int startRno = Integer.parseInt(start);
		// 시작행번호                1            4            7
		
		int endRno = startRno+Integer.parseInt(len)-1;
		// 끝행번호  !!공식!!  1+3-1(==3)   4+3-1(==6)   7+3-1(==9)
		
		InterProductDAO pdao = new ProductDAO();
		
		List<ProductVO> productList = pdao.getProductVOListByPspec(pspec, startRno, endRno);
		
		req.setAttribute("productList", productList);
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/myshop/malldisplayXML.jsp"); 

	}

}
