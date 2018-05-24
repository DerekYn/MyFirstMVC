package myshop.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import common.controller.AbstractController;
import myshop.model.InterProductDAO;
import myshop.model.ProductDAO;

public class AllProductLikeDislikeStaticsChartAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		InterProductDAO pdao = new ProductDAO();
		
		//List<HashMap<String, String>> mapList = pdao.getTotalOrderStatics();
		List<HashMap<String, String>> mapList = pdao.getAllProductsLikeDisLikeStatics();

		JSONArray jsonArray = new JSONArray();
		
		if(mapList != null && mapList.size() > 0) {
			for(HashMap<String, String> map : mapList) {
				JSONObject jsonObj = new JSONObject();
				
				jsonObj.put("PNAME", map.get("PNAME"));
				jsonObj.put("LIKECNT", map.get("LIKECNT"));
				jsonObj.put("DISLIKECNT", map.get("DISLIKECNT"));
				
				jsonArray.add(jsonObj);	
				
			}
		}
		
		String str_jsonArray = jsonArray.toString();
		System.out.println(" str_jsonArray 확인용 : " + str_jsonArray);

		
		req.setAttribute("str_jsonArray", str_jsonArray);
		
		super.setViewPage("/WEB-INF/myshop/allProductLikeDislikeStaticsChart.jsp");
		
		}

}
