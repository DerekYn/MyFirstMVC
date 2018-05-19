package ajax.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import common.controller.AbstractController;
import member.model.InterMemberDAO;
import member.model.MemberDAO;
import member.model.MemberVO;

public class ThirdMemberListJSONAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		String name = req.getParameter("name");
		
		InterMemberDAO mdao = new MemberDAO();
		
		List<MemberVO> memberList = mdao.getSearchMembers(name);
		
		JSONArray jsonArray = new JSONArray();
		
		if(memberList != null && memberList.size() > 0) {
			for(MemberVO mvo : memberList) {
				JSONObject jsonObj = new JSONObject();
				
				jsonObj.put("name", mvo.getName());
				jsonObj.put("email", mvo.getEmail());
				jsonObj.put("addr1", mvo.getAddr1());
				jsonObj.put("addr2", mvo.getAddr2());
				
				jsonArray.add(jsonObj);
			}
		}
		
		String str_memberjsonArray = jsonArray.toString();
		
		req.setAttribute("str_memberjsonArray", str_memberjsonArray);
		
		super.setRedirect(false);
		super.setViewPage("/AjaxStudy/chap4/3memberInfoJSON.jsp");
		
	}

}
