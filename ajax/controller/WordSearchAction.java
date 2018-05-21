package ajax.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;

public class WordSearchAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
	
		super.setViewPage("/AjaxStudy/chap5/wordSearchAjax.jsp");

	}

}
