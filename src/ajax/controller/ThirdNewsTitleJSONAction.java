package ajax.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import ajax.model.AjaxDAO;
import ajax.model.InterAjaxDAO;
import ajax.model.TodayNewsVO;
import common.controller.AbstractController;
import member.model.MemberVO;

public class ThirdNewsTitleJSONAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {


		InterAjaxDAO adao = new AjaxDAO();
		int a = 0;
		
		List<TodayNewsVO> newsTitleList = adao.getNewsTitleList();
		
		JSONArray jsonArray = new JSONArray();
		
		if(newsTitleList != null && newsTitleList.size() > 0) {
			for(TodayNewsVO TNVO : newsTitleList) {
				JSONObject jsonObj = new JSONObject();
			
				jsonObj.put("seqtitleno", TNVO.getSeqtitleno());
				jsonObj.put("title", TNVO.getTitle());
				jsonObj.put("registerday", TNVO.getRegisterday());
								
				jsonArray.add(jsonObj);
			}
		}
		
		String str_newsjsonArray = jsonArray.toString();
		
		req.setAttribute("str_newsjsonArray", str_newsjsonArray);
		
		super.setViewPage("/AjaxStudy/chap4/3newsTitleJSON.jsp");

	}

}
