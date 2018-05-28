package myshop.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import common.controller.AbstractController;
import myshop.model.InterProductDAO;
import myshop.model.ProductDAO;
import myshop.model.ProductVO;
import util.my.MyUtil;

public class DisplayJSONAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		String start = req.getParameter("start");  // 1
		String len = req.getParameter("len");      // 3
		String pspec = req.getParameter("pspec");  // "NEW"
		
		if(start == null || start.trim().isEmpty()) {
			start = "1";
		}
		
		if(len == null || len.trim().isEmpty()) {
			len = "3";
		}
		
		if(pspec == null || pspec.trim().isEmpty()) {
			pspec = "NEW";
		}
		
		System.out.println("==> 확인용 DisplayJSONAction.java  start : " + start); 
		System.out.println("==> 확인용 DisplayJSONAction.java  len : " + len);
		System.out.println("==> 확인용 DisplayJSONAction.java  pspec : " + pspec);
		
		int startRno = Integer.parseInt(start);
		// 시작행번호                1            4            7
		
		int endRno = startRno+Integer.parseInt(len)-1;
		// 끝행번호  !!공식!!  1+3-1(==3)   4+3-1(==6)   7+3-1(==9)
		
		InterProductDAO pdao = new ProductDAO();
		
		List<ProductVO> productList = pdao.getProductVOListByPspec(pspec, startRno, endRno);
		
		JSONArray jsonArray = new JSONArray();
		
		if(productList != null && productList.size() > 0) {
		
			for(ProductVO pvo : productList) {
				JSONObject jsonObj = new JSONObject();
				
				jsonObj.put("pnum", pvo.getPnum());
				jsonObj.put("pname", pvo.getPname());
				jsonObj.put("pcategory_fk", pvo.getPcategory_fk());
				jsonObj.put("pcompany", pvo.getPcompany());
				jsonObj.put("pimage1", pvo.getPimage1());
				jsonObj.put("pimage2", pvo.getPimage2());
				jsonObj.put("pqty", pvo.getPqty());
				jsonObj.put("price", MyUtil.getMoney(pvo.getPrice()) );
				jsonObj.put("saleprice", MyUtil.getMoney(pvo.getSaleprice()) );
				jsonObj.put("pspec", pvo.getPspec());
				jsonObj.put("pcontent", pvo.getPcontent() );
				jsonObj.put("point", MyUtil.getMoney(pvo.getPoint()) );
				jsonObj.put("pinputdate", pvo.getPinputdate() );
				jsonObj.put("percent", pvo.getPercent() );
				
				jsonArray.add(jsonObj);
				
			} // end of for---------------------
		}
		
		String str_jsonArray = jsonArray.toString();
		
		req.setAttribute("str_jsonArray", str_jsonArray);
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/myshop/malldisplayJSON.jsp"); 		

	}

}
