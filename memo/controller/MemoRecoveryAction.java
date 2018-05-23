package memo.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import memo.model.MemoDAO;

public class MemoRecoveryAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		String[] delChkboxArr = req.getParameterValues("delChkbox"); 
	/*  req.getParameterValues("delChkbox"); 은 
	       타입이 checkbox 인데 체크가 되어진 것만 받아온다. 
	*/
		StringBuilder sb = new StringBuilder();
		
		for(int i=0; i<delChkboxArr.length; i++) {
			sb.append(delChkboxArr[i]+",");
		}// end of for---------------------
		
		String str = sb.toString();
		str = str.substring(0, str.length()-1);
		
	//	System.out.println("===> 확인용 str : " + str);
		// ===> 확인용 str : 108,105,103,100,99
		
		MemoDAO memodao = new MemoDAO();
		
		int n = memodao.recoveryMemo(str);
		
		String msg = (n == delChkboxArr.length)?"선택한 메모내용 모두 복구 성공!!":"선택한 메모내용 모두 복구 실패!!"; 
		String loc = "memoVOList.do";
		
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/msg.jsp");
		
	}

}
