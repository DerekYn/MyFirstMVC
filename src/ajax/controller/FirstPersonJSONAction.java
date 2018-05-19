package ajax.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import common.controller.AbstractController;

public class FirstPersonJSONAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		JSONObject personObj = new JSONObject();
		
		personObj.put("name", "이순신");
		personObj.put("age", new Integer(27));
		personObj.put("height", new Double(187.2));
		personObj.put("phone", "010-9549-3188");
		personObj.put("email", "leess@gmail.com");
		personObj.put("address", "서울시 강남구 도곡동");
		
		String str_personInfo = personObj.toString();
		// JSONObject 타입의 객체 personObj 를 String 으로 변환하기 
		
		System.out.println("===> 확인용 JSON 형태의 personObj 의 값 : " + str_personInfo);
		// ===> 확인용 JSON 형태의 personObj 의 값 : {"address":"서울시 강남구 도곡동","phone":"010-9549-3188","name":"이순신","age":27,"email":"leess@gmail.com","height":187.2}

		req.setAttribute("str_personInfo", str_personInfo);
		
		super.setViewPage("/AjaxStudy/chap4/1personJSON.jsp");
		
	}

}
