package ajax.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import member.model.InterMemberDAO;
import member.model.MemberDAO;
import member.model.MemberVO;

public class MemberListAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		String name = req.getParameter("name");
		
		InterMemberDAO mdao = new MemberDAO();
		
		List<MemberVO> memberList = mdao.getSearchMembers(name);
		
		req.setAttribute("memberList", memberList);
		
		super.setRedirect(false);
		super.setViewPage("/AjaxStudy/chap2/memberInfo.jsp");
		
	}

}
