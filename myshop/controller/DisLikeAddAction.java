package myshop.controller;

import java.sql.SQLIntegrityConstraintViolationException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import common.controller.AbstractController;
import myshop.model.InterProductDAO;
import myshop.model.ProductDAO;

public class DisLikeAddAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		String userid = req.getParameter("userid");
		String pnum = req.getParameter("pnum");
		
		JSONObject jsonObj = new JSONObject();
		
		if("".equals(userid))  // if(userid == null) 이 아니다.
			jsonObj.put("msg", "로그인을 하신 후 \n 싫어요를 클릭하세요.");
		else {
			InterProductDAO pdao = new ProductDAO();
			
			try {
				
				int n = pdao.insertDisLike(userid, pnum);
				
				if(n>0)
					jsonObj.put("msg", "해당제품에 \n 싫어요를 클릭하셨습니다.");
				
			} catch (SQLIntegrityConstraintViolationException e) {
				jsonObj.put("msg", "이미 싫어요를 선택한 상품입니다!!\n 두번의 싫어요는 불가능합니다.");
			}
			
		}// end of if~else------------------------------------------
		
		String str_jsonObj = jsonObj.toString();
		
		req.setAttribute("str_jsonObj", str_jsonObj);
			
		super.setViewPage("/WEB-INF/myshop/dislikeAdd.jsp");
		
		
		

	}

}
