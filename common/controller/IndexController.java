package common.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class IndexController extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) 
		throws Exception {
		
		req.setAttribute("msg", "Index 페이지 입니다.");
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/index.jsp");
	}

}
