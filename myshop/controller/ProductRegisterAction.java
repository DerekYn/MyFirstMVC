package myshop.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;

public class ProductRegisterAction extends AbstractController{

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		super.getCategoryList(req);
			
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/myshop/productRegister.jsp");
			
	}

}
