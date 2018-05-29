package myshop.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import common.controller.AbstractController;
import member.model.MemberVO;
import myshop.model.InterProductDAO;
import myshop.model.ProductDAO;

public class MyOrderStaticsChartAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
	
		MemberVO loginuser = super.getMemberLogin(req);
		
		InterProductDAO pdao = new ProductDAO();
		
		List<HashMap<String, String>> mapList = pdao.getMyOrderStatics(loginuser.getUserid());
		
		JSONArray jsonArray = new JSONArray();
		
		if(mapList != null && mapList.size() > 0) {
			for(HashMap<String, String> map : mapList) {
				JSONObject jsonObj = new JSONObject();
				// JSONObject 는 JSON 형태(키 : 값)의 데이터를 관리해주는 클래스이다.
				
				jsonObj.put("CNAME", map.get("CNAME"));
				jsonObj.put("TOTALFIXEDORDERPRICE", map.get("TOTALFIXEDORDERPRICE"));
				jsonObj.put("PERCENT", map.get("PERCENT"));
				
				jsonArray.add(jsonObj);
			}
		}
		
		String str_jsonArray = jsonArray.toJSONString();
		System.out.println(" str_jsonArray 확인용 : " + str_jsonArray);
		// str_jsonArray 확인용 : [{"PERCENT":"91.3","TOTALFIXEDORDERPRICE":"22013000","CNAME":"전자제품"},
		//                       {"PERCENT":"7.8","TOTALFIXEDORDERPRICE":"1882000","CNAME":"도서"},
		//                       {"PERCENT":".9","TOTALFIXEDORDERPRICE":"216000","CNAME":"의류"}]

		
		req.setAttribute("str_jsonArray", str_jsonArray);
		
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/myshop/MyOrderStaticsChart.jsp");
		
		
		
		
	}

}
