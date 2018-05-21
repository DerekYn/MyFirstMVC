package ajax.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import ajax.model.AjaxDAO;
import ajax.model.InterAjaxDAO;
import common.controller.AbstractController;

public class WordSearchJSONAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		String searchword = req.getParameter("searchword");
		
		JSONArray jsonArray = new JSONArray();
		
		if(!searchword.trim().isEmpty()) {
			
			InterAjaxDAO adao = new AjaxDAO();
			List<String> titleList = adao.getSearchWordAutoCompletely(searchword);
			
			if(titleList != null && titleList.size() > 0) {
				for(String resultstr : titleList) {
					JSONObject jsonObj = new JSONObject();
					jsonObj.put("resultstr", resultstr);
					
					jsonArray.add(jsonObj);					
				}
			}
		}
		
		String str_jsonArray = jsonArray.toString();
		System.out.println("str_jsonArray 확인용 => " + str_jsonArray);
		// str_jsonArray 확인용 => [{"resultstr":"AJAX"},{"resultstr":"ajax 프로그래밍"},
		//                       {"resultstr":"Java 프로그래밍"},{"resultstr":"Java Programming"}]

		
		req.setAttribute("str_jsonArray", str_jsonArray);
		
		super.setViewPage("/AjaxStudy/chap5/wordSearchJSON.jsp");
	}

}
