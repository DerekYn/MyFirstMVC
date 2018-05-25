package myshop.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import member.model.MemberVO;
import myshop.model.InterProductDAO;
import myshop.model.ProductDAO;

public class DeliverStartAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
	 	String method = req.getMethod();
	 	
	 	if(!"post".equalsIgnoreCase(method)) {
	 		super.invalidPath(req);
	 		return;
	 	}
	 	
	 	MemberVO loginuser = super.getMemberLogin(req);
	 	
	 	if(loginuser != null && !"admin".equals(loginuser.getUserid()) ) {
	 		super.alertMsg(req, "관리자만 가능합니다.", "javascript:history.back();");
	 		return;
	 	}
	 	
	 	String[] odrcodeArr = req.getParameterValues("odrcode");
	 	String[] pnumArr = req.getParameterValues("deliverStartPnum");
	 	
	 	if(odrcodeArr == null || pnumArr == null) {
	 		super.alertMsg(req, "배송시작할 제품을 하나 이상 선택하셔야 합니다.", "javascript:history.back();"); 
	 		return;
	 	}
	 	
	 	InterProductDAO pdao = new ProductDAO();
	 	
	 	StringBuilder sb = new StringBuilder();
	 	
	 	// 's20180502-112','s20180502-115'
	 	
	 	for(int i=0; i<odrcodeArr.length; i++) {
	 		sb.append("\'"+odrcodeArr[i]);
	 		sb.append(pnumArr[i]+"\',");
	 	}
	 	
	 	String odrcodePnum = sb.toString();
	 	
	 	odrcodePnum = odrcodePnum.substring(0, odrcodePnum.length()-1);
	 	// 맨뒤의 콤마(,)제거하기 
	 	
	 	int n = pdao.updateDeliverStart(odrcodePnum, odrcodeArr.length);
	 	
	 	if(n == 1) {
	 		super.alertMsg(req, "선택하신 제품들은 배송시작으로 변경되었습니다.", "orderList.do"); 
	 	}
	 	else {
	 		super.alertMsg(req, "선택하신 제품들은 배송시작으로 변경이 실패했습니다.", "javascript:history.back();");  
	 	}
	 	

	}

}
