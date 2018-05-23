package memo.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import memo.model.MemoDAO;
import util.my.MyUtil;

public class MemoListAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		MemoDAO memodao = new MemoDAO();

	//  *** 페이지 처리 하기 이전	의 데이터 조회 결과물 만들기 *** 
	//	List<HashMap<String, String>> memoList = memodao.getAllMemo();
	//	req.setAttribute("memoList", memoList);
		
		// 1. 페이징 처리를 위해 페이지당 보여줄 메모갯수를 받아오기(10 or 5 or 3)
		String str_sizePerPage = req.getParameter("sizePerPage");
		
		int sizePerPage = 0;
		
		try {
			if(str_sizePerPage == null) {
			   sizePerPage = 10;
			}
			else {
				sizePerPage = Integer.parseInt(str_sizePerPage);
				
				if(sizePerPage != 10 && sizePerPage != 5 && sizePerPage != 3) {
				   sizePerPage = 10;
				}
			}
		} catch(NumberFormatException e) {
			sizePerPage = 10;
		}
		
		req.setAttribute("sizePerPage", sizePerPage);
		
		// 2. 전체 페이지 갯수 알아오기
		int totalPage = 0;
		int totalCountMemo = memodao.getTotalCountMemo();
	//	System.out.println("==> 확인용 totalCountMemo : " + totalCountMemo);
		
		totalPage = (int)Math.ceil( (double)totalCountMemo/sizePerPage );
	//	System.out.println("==> 확인용 totalPage : " + totalPage);
		
		String str_currentShowPageNo = req.getParameter("currentShowPageNo");
		int currentShowPageNo = 0;
		
		try {
			
			if(str_currentShowPageNo == null) {
				currentShowPageNo = 1;
			}
			else {
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
				
				if(currentShowPageNo < 1 || currentShowPageNo > totalPage) {
					currentShowPageNo = 1;
				}
			}
			
		} catch(NumberFormatException e) {
			currentShowPageNo = 1;
		}
		
		// 3. 페이징 처리한 데이터 조회 결과물 만들기
        List<HashMap<String, String>> memoList = memodao.getAllMemo(currentShowPageNo, sizePerPage); 
		
		req.setAttribute("memoList", memoList);
		
		
		// 4. 페이지바 만들기
/*		int blocksize = 10;
		int pageNo = 1;
		int loop = 1;
		
		pageNo = ((currentShowPageNo - 1) / blocksize) * blocksize + 1;
		// 공식임.
		
		//     currentShowPageNo      pageNo
		//    -------------------------------
		//           1                  1
		//           2                  1
		//          ..                 ..
		//          10                  1
		//          
		//          11                 11
		//          12                 11
		//          ..                 ..
		//          20                 11
		//          
		//          21                 21                 
		//          22                 21 
		//          ..                 ..
		//          30                 21 
		 
		String pageBar = "";
		
		if(pageNo == 1) {
			pageBar += "";
		}
		else {
			pageBar += "&nbsp;<a href=\"memoList.do?currentShowPageNo="+(pageNo-1)+"&sizePerPage="+sizePerPage+"\">[이전]</a>";
		}
		
		while( !(loop > blocksize || pageNo > totalPage) ) {
			
			if(pageNo == currentShowPageNo) {
				pageBar += "&nbsp;<span style=\"color: red; font-size: 13pt; font-weight: bold; text-decoration: underline;\">"+pageNo+"</span>&nbsp;";
			}
			else {
				pageBar += "&nbsp;<a href=\"memoList.do?currentShowPageNo="+pageNo+"&sizePerPage="+sizePerPage+"\">"+pageNo+"</a>&nbsp;";
			}
			
			pageNo++;
			loop++;
		}// end of while-------------------------
		
		if(pageNo > totalPage) {
			pageBar += "";
		}
		else {
			pageBar += "&nbsp;<a href=\"memoList.do?currentShowPageNo="+pageNo+"&sizePerPage="+sizePerPage+"\">[다음]</a>";
		}

*/
		// **** 메소드로 pageBar 호출하기 **** //
		String url = "memoList.do";
		int blocksize = 10;
		
		String pageBar = MyUtil.getPageBar(url, currentShowPageNo, sizePerPage, totalPage, blocksize);
		
		req.setAttribute("pageBar", pageBar);
		
		super.setRedirect(false);
	//	super.setViewPage("/WEB-INF/memo/memoList.jsp");
		super.setViewPage("/WEB-INF/memo/memoListJSTL.jsp"); 
		
	}

}
