package ajax.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;

public class FirstPersonArrayAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		super.setViewPage("/AjaxStudy/chap4/1personArrayInfoAjax.jsp");

	}

}
