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

public class TotalOrderStaticsChartAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		InterProductDAO pdao = new ProductDAO();
		
		List<HashMap<String, String>> mapList = pdao.getTotalOrderStatics();

		JSONArray jsonArray = new JSONArray();
		
		if(mapList != null && mapList.size() > 0) {
			for(HashMap<String, String> map : mapList) {
				JSONObject jsonObj = new JSONObject();
				
				jsonObj.put("CNAME", map.get("CNAME"));
				jsonObj.put("JAN", map.get("JAN"));
				jsonObj.put("FEB", map.get("FEB"));
				jsonObj.put("MAR", map.get("MAR"));
				jsonObj.put("APR", map.get("APR"));
				jsonObj.put("MAY", map.get("MAY"));
				jsonObj.put("JUN", map.get("JUN"));
				jsonObj.put("JUL", map.get("JUL"));
				jsonObj.put("AUG", map.get("AUG"));
				jsonObj.put("SEP", map.get("SEP"));
				jsonObj.put("OCT", map.get("OCT"));
				jsonObj.put("NOV", map.get("NOV"));
				jsonObj.put("DEC", map.get("DEC"));
				
				jsonArray.add(jsonObj);				
				
			}
		}
		
		String str_jsonArray = jsonArray.toString();
		System.out.println(" str_jsonArray 확인용 : " + str_jsonArray);
		//  str_jsonArray 확인용 : [{"JUL":"0","OCT":"0","FEB":"0","JUN":"0","APR":"2","DEC":"0","MAY":"28","AUG":"0","NOV":"0","JAN":"0","CNAME":"의류","MAR":"0","SEP":"0"},
		//                        {"JUL":"0","OCT":"0","FEB":"0","JUN":"0","APR":"25","DEC":"0","MAY":"8","AUG":"0","NOV":"0","JAN":"0","CNAME":"전자제품","MAR":"0","SEP":"0"},
		//                        {"JUL":"0","OCT":"0","FEB":"0","JUN":"0","APR":"4","DEC":"0","MAY":"18","AUG":"0","NOV":"0","JAN":"0","CNAME":"도서","MAR":"0","SEP":"0"}]


		
		req.setAttribute("str_jsonArray", str_jsonArray);
		
		super.setViewPage("/WEB-INF/myshop/totalOrderStaticsChart.jsp");
		
		}

}
