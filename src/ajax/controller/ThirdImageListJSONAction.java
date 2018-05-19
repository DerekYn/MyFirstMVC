package ajax.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import ajax.model.AjaxDAO;
import ajax.model.ImageVO;
import ajax.model.InterAjaxDAO;
import common.controller.AbstractController;
import member.model.MemberVO;

public class ThirdImageListJSONAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		InterAjaxDAO adao = new AjaxDAO();
		
		List<ImageVO> imgList = adao.getTblImages();
		
		JSONArray jsonArray = new JSONArray();
		
		if(imgList != null && imgList.size() > 0) {
			for(ImageVO ivo : imgList) {
				JSONObject jsonObj = new JSONObject();
				
				jsonObj.put("userid", ivo.getUserid());
				jsonObj.put("name", ivo.getName());
				jsonObj.put("img", ivo.getImg());
				
				jsonArray.add(jsonObj);
			}
		}
		
		String str_imagejsonArray = jsonArray.toString();
		
		req.setAttribute("str_imagejsonArray", str_imagejsonArray);
		
		super.setViewPage("/AjaxStudy/chap4/3imgInfoJSON.jsp");
		
		

	}

}
