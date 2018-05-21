package ajax.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import ajax.model.AjaxDAO;
import ajax.model.InterAjaxDAO;
import ajax.model.TodayNewsVO;
import common.controller.AbstractController;

public class NewsTitleAction extends AbstractController{

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		InterAjaxDAO adao = new AjaxDAO();
		
		List<TodayNewsVO> newsTitleList = adao.getNewsTitleList();
		
		req.setAttribute("newsTitleList", newsTitleList);
		
		super.setViewPage("/AjaxStudy/chap2/newsTitle.jsp");
		
	}

}
