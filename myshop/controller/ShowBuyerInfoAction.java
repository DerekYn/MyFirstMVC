package myshop.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import member.model.MemberDAO;
import member.model.MemberVO;

public class ShowBuyerInfoAction extends AbstractController{

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
	
		MemberVO loginuser = super.getMemberLogin(req);
		// 로그인 유무 검사해주는 메소드 호출 
		
		if(loginuser != null && !"admin".equals(loginuser.getUserid()) ) { 
			super.alertMsg(req, "관리자로 로그인해야 합니다.", "javascript:history.back();");
			return;
		}		
	 	String userid = req.getParameter("userid");
	 	
 		MemberDAO memberDao = new MemberDAO();
 		MemberVO mvo = memberDao.getMemberOneByUserid(userid);
 		
 		req.setAttribute("mvo", mvo);
 		req.setAttribute("userid", userid);
 		
 		super.setRedirect(false);
 		super.setViewPage("/WEB-INF/myshop/buyerInfo.jsp");
 		
	 }
		
}

