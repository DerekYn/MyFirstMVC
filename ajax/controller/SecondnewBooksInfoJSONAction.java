package ajax.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import ajax.model.AjaxDAO;
import ajax.model.BookVO;
import ajax.model.InterAjaxDAO;
import common.controller.AbstractController;

public class SecondnewBooksInfoJSONAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		InterAjaxDAO adao = new AjaxDAO();
		
		List<BookVO> bookList = adao.getNewbooks();
		
		JSONArray jsonArray = new JSONArray();
		
		if(bookList != null && bookList.size() > 0) {
			for(BookVO bookvo : bookList) {
				JSONObject jsonObj = new JSONObject();
				// JSONObject 는 JSON형태(키:값) 의 데이터를 관리해주는 클래스이다.
				
				jsonObj.put("subject", bookvo.getSubject());
				jsonObj.put("title", bookvo.getTitle());
				jsonObj.put("author", bookvo.getAuthor());
				jsonObj.put("registerday", bookvo.getRegisterday());
				
				jsonArray.add(jsonObj);
			}
		}
		
		String str_jsonArray = jsonArray.toString();
		System.out.println(">>>> str_jsonArray 확인용 : " + str_jsonArray);
		// >>>> str_jsonArray 확인용 : [{"registerday":"2018-05-08","subject":"소설","author":"황석영","title":"해질무렵"},{"registerday":"2018-05-08","subject":"소설","author":"앤디위어","title":"마션"},{"registerday":"2018-05-08","subject":"소설","author":"생텍쥐페리","title":"어린왕자"},
		// {"registerday":"2018-05-08","subject":"소설","author":"박범신","title":"당신"},{"registerday":"2018-05-08","subject":"소설","author":"이문열","title":"삼국지"},{"registerday":"2018-05-08","subject":"프로그래밍","author":"이순신","title":"ORACLE"},
		// {"registerday":"2018-05-08","subject":"프로그래밍","author":"안중근","title":"자바"},{"registerday":"2018-05-08","subject":"프로그래밍","author":"똘똘이","title":"JSP Servlet"},{"registerday":"2018-05-08","subject":"프로그래밍","author":"윤봉길","title":"스프링"}]

		// 데이터가 없으면 걍 [] 이렇게 나옴.
		
		req.setAttribute("str_jsonArray", str_jsonArray);
		
		super.setViewPage("/AjaxStudy/chap4/2booksInfoJSON.jsp");

	}

}
