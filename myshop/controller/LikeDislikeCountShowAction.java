package myshop.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import common.controller.AbstractController;
import myshop.model.InterProductDAO;
import myshop.model.ProductDAO;

public class LikeDislikeCountShowAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		String pnum = req.getParameter("pnum");
		
		InterProductDAO pdao = new ProductDAO();
		
		HashMap<String, String> map = pdao.getLikeDislikeCount(pnum);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("likecnt", map.get("likecnt"));
		jsonObj.put("dislikecnt", map.get("dislikecnt"));
		
		String str_jsonObj = jsonObj.toString();
		
		req.setAttribute("str_jsonObj", str_jsonObj);
		
		super.setViewPage("/WEB-INF/myshop/likeDislikeCountShow.jsp");
	
	}

}
