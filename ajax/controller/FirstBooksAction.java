package ajax.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;

public class FirstBooksAction extends AbstractController{

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		
		
		
		
		super.setRedirect(false);
		super.setViewPage("/AjaxStudy/chap3/1booksAjax.jsp");
		
	}

}
