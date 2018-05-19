package common.controller;

import java.io.*;
import java.util.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebInitParam;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class FrontController
 */
@WebServlet(
		urlPatterns = { "*.do" }, 
		initParams = { 
				@WebInitParam(name = "propertyConfig", value = "C:/myjsp/MyMVC/WebContent/WEB-INF/Command.properties")
		})
public class FrontController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	HashMap<String, Object> cmdMap = new HashMap<String, Object>();
	
	/**
	 * @see Servlet#init(ServletConfig)
	 */
	public void init(ServletConfig config) 
		throws ServletException {
		// 확인용
		System.out.println("확인용 ==> FrontController 서블릿의  init(ServletConfig config) 메소드가 실행됨!! ");
		
		/*
		   웹브라우저 주소창에서 *.do 를 하면
		  FrontController 서블릿이 받는데
		   맨처음에 자동적으로 실행되어지는 메소드가   
		  init(ServletConfig config) 이다.
		  그런데 이 메소드는 WAS(톰캣서버)가 구동되어진 후
		  딱 1번만 수행되어지고, 그 이후에는 수행되지 않는다. 
		*/
		
		String props = config.getInitParameter("propertyConfig");
		// 초기화 파라미터 데이터값인 "C:/myjsp/MyMVC/WebContent/WEB-INF/Command.properties" 을 
		// 가져와서 String props 변수에 저장시켰다.
		
		// 확인용
		System.out.println("<<확인용>> 초기화 파라미터 데이터값이 저장된 파일명 props : " + props);
		// <<확인용>> 초기화 파라미터 데이터값이 저장된 파일명 props : C:/myjsp/MyMVC/WebContent/WEB-INF/Command.properties 
		
		Properties pr = new Properties();
		
		FileInputStream fis = null;
		
		try {
			fis = new FileInputStream(props);
			 
			pr.load(fis);
			/*
			   C:/myjsp/MyMVC/WebContent/WEB-INF/Command.properties 파일을 읽어다가
			   Properties 클래스의 객체인 pr 에 로드시킨다.
			     그러면 pr 은 읽어온 파일(Command.properties)의 내용에서
			   = 을 기준으로 왼쪽은 키로 보고 오른쪽은 value 로 인식한다.   
			 */
		/*	
			String str_className = pr.getProperty("/test1.do");
			                                   // "/test1.do" 이 key 이다.
			System.out.println("<<확인용>> key가 /test1.do 인 value : " + str_className);
			// <<확인용>> key가 /test1.do 인 value : test.controller.Test1Controller
			
			Class<?> cls = Class.forName(str_className);
			Object obj = cls.newInstance();
		*/
			
			Enumeration<Object> en = pr.keys();
			/*
			   pr.keys(); 은 
			   C:/myjsp/MyMVC/WebContent/WEB-INF/Command.properties 파일의 내용물에서 
			   = 을 기준으로 왼쪽에 있는 모든 key 들만 읽어오는 것이다.
			 */
			
			while(en.hasMoreElements()) {
				
				String key_urlcmd = (String)en.nextElement();
				String className = pr.getProperty(key_urlcmd);
				
				if(className != null) {
					className = className.trim();
					Class<?> cls = Class.forName(className);
					Object obj = cls.newInstance();
					
					cmdMap.put(key_urlcmd, obj);
				}
				
			}// end of while-------------------
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
	}// end of init(ServletConfig config)----------------

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
		throws ServletException, IOException {
		
		requestProcess(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
		throws ServletException, IOException {
		
		requestProcess(request, response);
	}
	
	/*
	    doGet 메소드와 doPost 메소드에서 해야할 업무처리를
	    requestProcess(request, response); 메소드로 넘겨버린다.
	       그래서 우리는  requestProcess(request, response); 메소드를 생성해야 한다.
	*/
	
	private void requestProcess(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		
	//	StringBuffer sb = request.getRequestURL();
	//	System.out.println("==> 확인용 request.getRequestURL() : " + sb.toString() );
		// ==> 확인용 request.getRequestURL() : http://localhost:9090/MyMVC/test1.do
		
		String uri = request.getRequestURI();
	//	System.out.println("==> 확인용 request.getRequestURI() : " + uri);
		// ==> 확인용 request.getRequestURI() : /MyMVC/test1.do
		
		String ctxName = request.getContextPath();
		System.out.println("==> 확인용 ctxName : " + ctxName);
		// ==> 확인용 ctxName : /MyMVC
		
		int beginIndex = ctxName.length(); // ==> 6
		
		String mapKey = uri.substring(beginIndex); 
		//  /test1.do
		
		System.out.println("==> 확인용 mapKey : " + mapKey);
		// ==> 확인용 mapKey : /test1.do
		
		AbstractController action = (AbstractController)cmdMap.get(mapKey);
		
		if(action == null) {
			System.out.println(mapKey + " URL 패턴에 매핑된 객체가 없습니다."); 
			return;
		}
		else {
		
			try {
				action.execute(request, response);
				
				String viewPage = action.getViewPage();
				System.out.println("==> 확인용 viewPage : " + viewPage); 
				
				boolean bool = action.isRedirect();
				System.out.println("==> 확인용 bool(isRedirect()) : " + bool);
				
				if(bool) { // redirect 방식으로 view단 페이지로 넘긴다.
					response.sendRedirect(viewPage);
				}
				else { // forward(dispatcher) 방식으로 view단 페이지로 넘긴다.
					RequestDispatcher dispatcher = request.getRequestDispatcher(viewPage); 
					dispatcher.forward(request, response);
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		
		}// end of if ~ else----------------------
		
		
	}
	

}



