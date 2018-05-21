package ajax.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import ajax.model.AjaxDAO;
import ajax.model.BookVO;
import ajax.model.InterAjaxDAO;
import common.controller.AbstractController;

public class ThirdBooksXMLAction extends AbstractController{

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		InterAjaxDAO adao = new AjaxDAO();
		
		List<BookVO> bookList = adao.getAllbooks();
		
		req.setAttribute("bookList", bookList);
		
		super.setRedirect(false);
		super.setViewPage("/AjaxStudy/chap3/3booksXML.jsp");
		
	}

}
