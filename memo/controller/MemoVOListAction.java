package memo.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import memo.model.MemoDAO;
import memo.model.MemoVO;
import util.my.MyUtil;

public class MemoVOListAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) 
		throws Exception {
		
		MemoDAO memodao = new MemoDAO();
		
	//  *** 페이지 처리 하기 이전	의 데이터 조회 결과물 만들기 ***
	//	List<MemoVO> memoList = memodao.getAllMemoVO();
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
		int totalCountMemo = memodao.getTotalCountMemoVO();
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
        List<MemoVO> memoList = memodao.getAllMemoVO(currentShowPageNo, sizePerPage); 
		
		req.setAttribute("memoList", memoList);
		
		// **** 메소드로 pageBar 호출하기 **** //
		String url = "memoVOList.do";
		int blocksize = 10;
		
		String pageBar = MyUtil.getPageBar(url, currentShowPageNo, sizePerPage, totalPage, blocksize);
		
		req.setAttribute("pageBar", pageBar);
				
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/memo/memoListJSTLVO.jsp");		
		
	}
	

}
