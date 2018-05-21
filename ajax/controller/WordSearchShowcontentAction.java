package ajax.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import ajax.model.AjaxDAO;
import ajax.model.InterAjaxDAO;
import common.controller.AbstractController;

public class WordSearchShowcontentAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		String searchword = req.getParameter("searchword");
		
		if(!searchword.trim().isEmpty()) {
			
			InterAjaxDAO adao = new AjaxDAO();
			List<HashMap<String, String>> contentList = adao.getContentbyWordSearch(searchword);
			
			req.setAttribute("contentList", contentList);
		}

		super.setViewPage("/AjaxStudy/chap5/showwordSearchContent.jsp");

	}

}
