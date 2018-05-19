package ajax.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import common.controller.AbstractController;

public class FirstPersonJSONArrayAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		JSONObject personObj1 = new JSONObject();
		
		personObj1.put("name", "이순신");
		personObj1.put("age", new Integer(27));
		personObj1.put("height", new Double(187.2));
		personObj1.put("phone", "010-9549-3188");
		personObj1.put("email", "leess@gmail.com");
		personObj1.put("address", "서울시 강남구 도곡동");
		
		
		JSONObject personObj2 = new JSONObject();
		
		personObj2.put("name", "엄정화");
		personObj2.put("age", new Integer(25));
		personObj2.put("height", new Double(167.7));
		personObj2.put("phone", "010-4986-9318");
		personObj2.put("email", "eom@gmail.com");
		personObj2.put("address", "서울시 종로구 명동");
		
		JSONObject personObj3 = new JSONObject();
		
		personObj3.put("name", "안중근");
		personObj3.put("age", new Integer(33));
		personObj3.put("height", new Double(175.7));
		personObj3.put("phone", "010-9943-3181");
		personObj3.put("email", "ahnjg@gmail.com");
		personObj3.put("address", "부산특별시 남구");
		
		
		JSONArray jsonArray = new JSONArray();
		jsonArray.add(personObj1);
		jsonArray.add(personObj2);
		jsonArray.add(personObj3);
		
		String str_jsonArray = jsonArray.toString();
		// JSONObject 타입의 객체 personObj 를 String 으로 변환하기 
		
		System.out.println("===> 확인용 JSON 형태의 str_jsonArray 의 값 : " + str_jsonArray);
		/*===> 확인용 JSON 형태의 str_jsonArray 의 값 : [{"address":"서울시 강남구 도곡동","phone":"010-9549-3188","name":"이순신","age":27,"email":"leess@gmail.com","height":187.2},
		대괄호 []는 배열 {}는 객체                                       {"address":"서울시 종로구 명동","phone":"010-4986-9318","name":"엄정화","age":25,"email":"eom@gmail.com","height":167.7},
		                                       {"address":"부산특별시 남구","phone":"010-9943-3181","name":"안중근","age":33,"email":"ahnjg@gmail.com","height":175.7}]*/

		req.setAttribute("str_jsonArray", str_jsonArray);
		
		super.setViewPage("/AjaxStudy/chap4/1personArrayInfoJSON.jsp");

	}

}
