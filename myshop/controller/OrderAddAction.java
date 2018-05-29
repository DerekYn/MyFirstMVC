package myshop.controller;

import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import member.controller.GoogleMail;
import member.model.InterMemberDAO;
import member.model.MemberDAO;
import member.model.MemberVO;
import myshop.model.ProductDAO;
import myshop.model.ProductVO;

public class OrderAddAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
			
		if(loginuser == null) {
			
			String returnPage = req.getParameter("currentURL");
			session.setAttribute("returnPage", returnPage);
			
			super.alertMsg(req, "주문하기 전 로그인을 해주세요.", "javascript:history.back();");
			
			return;		// 종료 ~~
		}
			
		String method = req.getMethod();
				
		if(!"post".equalsIgnoreCase(method)) {
			super.invalidPath(req);
			
			return;	   // 종료 ~~
		}
		
		
		// *** 이 아래의 코딩은 로그인 되어진 상태에서 post 방식으로 넘어온 경우 *** //
		
		String[] pnumArr = req.getParameterValues("pnum");			 // 제품 번호
		String[] oqtyArr = req.getParameterValues("oqty");			 // 주문량
		String[] salepriceArr = req.getParameterValues("saleprice"); // 주문할 그때 당시의 판매단가
		String[] cartnoArr = req.getParameterValues("cartno"); 		 // 장바구니 번호
		
		/*if(cartnoArr != null) {
			for(int i=0; i<pnumArr.length; i++) {
				System.out.println("1. 제품번호 : " + pnumArr[i]);
				System.out.println("2. 주문량 : " + oqtyArr[i]);
				System.out.println("3. 판매단가 : " + salepriceArr[i]);
				System.out.println("4. 장바구니 번호 : " + cartnoArr[i]);
			}
		}
		else {
			for(int i=0; i<pnumArr.length; i++) {
				System.out.println("1. 제품번호 : " + pnumArr[i]);
				System.out.println("2. 주문량 : " + oqtyArr[i]);
				System.out.println("3. 판매단가 : " + salepriceArr[i]);
			}
		}*/
		
		String str_sumtotalprice = req.getParameter("sumtotalprice"); // 주문 총액
		String str_sumtotalpoint = req.getParameter("sumtotalpoint"); // 주문 총 포인트
		
		/*System.out.println("주문총액 : " + str_sumtotalprice);
		System.out.println("주문총포인트 : " + str_sumtotalpoint);*/
		
		int usercoin = loginuser.getCoin();
		// 10000
		
		int sumtotalprice = Integer.parseInt(str_sumtotalprice);
		// 13000
		
		int sumtotalpoint = Integer.parseInt(str_sumtotalpoint);
		
		if(usercoin < sumtotalprice) {
			int minusmoney = sumtotalprice - usercoin;
			
			// 숫자로 되어진 데이터를 세자리 마다 콤마(,)를 찍어주는 객체 생성
			DecimalFormat df = new DecimalFormat("#,###");
			df.format(minusmoney);
			
			super.alertMsg(req, minusmoney + " 만큼의 코인이 부족합니다", "javascript:history.back();");
			return;    // 종료 ~~~
		}
		
		
		// *** 이 아래의 코딩은 보유 코인량으로 충분히 주문이 가능하므로 정상적으로 주문을 받도록 처리하는 것 *** //
		
		ProductDAO pdao = new ProductDAO();
		
		// === 주문량의 갯수가 제품의 잔고량보다 크면 주문을 받지 않도록 한다. === //
		List<ProductVO> lackProductList = new ArrayList<ProductVO>();

		for(int i=0; i<oqtyArr.length; i++) {
			ProductVO pvo = pdao.getProductOneByPnum(pnumArr[i]);
			int pqty = pvo.getPqty();
			// 해당 제품의 잔고량
			
			if(pqty < Integer.parseInt(oqtyArr[i])) {
				// 특정 제품의 잔고량이 주문량 보다 적다면,
				lackProductList.add(pdao.getProductOneByPnum(pnumArr[i]));
			}
			
		}// end of for()--------------------------------------------------------
		
		if(lackProductList.size() > 0) {
			// 잔고량을 초과한 주문제품이 있는 경우라면
			
			StringBuffer sbPname = new StringBuffer();	// 복수 스레드 지원
			StringBuffer sbPqty = new StringBuffer();
			
			for(int i=0; i<lackProductList.size(); i++) {
				sbPname.append(lackProductList.get(i).getPname());
				sbPqty.append(lackProductList.get(i).getPqty());
				
				if(i < lackProductList.size()-1) {
					sbPname.append(", ");
					sbPqty.append(", ");
				}
			}
			
			String msg = "잔고량이 부족합니다!!. 제품명 " + sbPname.toString() + " 의 잔고량은 각각 " + sbPqty.toString() + " 개 입니다.";
			String loc = "javacript:history.back();";
			
			super.alertMsg(req, msg, loc);
			
		}
		
		// 이아래 부터 주문량의 갯수가 제품의 잔고량보다 같거나 적으므로 주문을 받도록 하는 것이다. //
		/*
		 	=== *** Transaction 처리하기 *** ===
		 	1. 주문개요 테이블(jsp_order)에 입력(insert)
		 	2. 주문상세 테이블(jsp_order_detail)에 입력(insert)
		 	3. 구매하는 사용자의 coin 컬럼의 값을 구매한 가격만큼 감하고,
		 	   point 컬럼의 값은 구매한 포인트만큼 증가하며(update),
		 	4. 주문한 제품의 잔고량은 주문량 만큼 감해야 하고(update),
		 	5. 장바구니에서 주문을 한 것이라면 장바구니 비우기(status 컬럼을 0으로 변경하는 update)
		 	      를 해주는 DAO에서 만든 메소드 호출하기
		 */
		
		String odrcode = getOrdercode();
		// 주문코드(명세서) 따오기
		// 주문코드 형식 : s + 날짜 _ sequence ==> s20180430-1
		
		int n = pdao.add_Order_OrderDetail(odrcode,                 // 주문코드(명세서)
											 loginuser.getUserid(),   // 사용자 ID
											 sumtotalprice,			  // 주문 총 액
											 sumtotalpoint,			  // 주문 총 포인트
											 pnumArr,    			  // 제품번호 배열
											 oqtyArr,				  // 주문량 배열
											 salepriceArr,			  // 주문할 당시의 해당 제품의 판매단가
											 cartnoArr 	     		  // 장바구니 번호 배열
						                     );
		
		/*
		 	== 위에서 리턴되어지는 n의 값은 0 또는 1 인데 1 값이 리턴되어지면
		 		jsp_member 테이블에서 해당 userid 의 행에는 코인액이 주문총액만큼 감해졌고,
		 		포인트는 주문 총 포인트 만큼 더해져서 변경이 되어진 상태이다.
		 		그러므로 세션에 저장된 기존의 loginuser의 값을 jsp_member 테이블에서 
		 		갱신된 user로 새로이 갱신하여 웹페이지 상에 감소된 코인액, 증가된 포인트를 보여준다.
		 */
		if(n == 1) {
			InterMemberDAO memberdao = new MemberDAO();
			
			loginuser = memberdao.getMemberOneByIdx(String.valueOf(loginuser.getIdx()));
			
			session.setAttribute("loginuser", loginuser);
			
		// **** 주문이 완료되었다라는 email 보내기 시작 **** //
			GoogleMail mail = new GoogleMail();
			
			int length = pnumArr.length;
						
			StringBuilder sb = new StringBuilder();
			
			for(int i=0; i<length; i++) {
				sb.append("\'" + pnumArr[i] + "\',");
				// jsp_product 테이블에서 select 시
				// where 절에 in() 속에 들어가므로 홑따음표(')가 필요한 경우
				// 위와 같이 직접 넣어주어야 한다.
			}
			
			String pnumes = sb.toString().trim();
			
			pnumes = pnumes.substring(0, pnumes.length()-1);
			// 맨 뒤에 콤마(,)를 제거하기 위함.
			
			// System.out.println("===> 확인용(punmes) : " + pnumes);
			
			List<ProductVO> getOrderFinishProductList = pdao.getOrderFinishProductList(pnumes);
			// 제품번호들에 해당하는 제품 목록을 얻어오는 것.
		
			sb.setLength(0);
			// StringBuilder sb 초기화하기
			
			sb.append("주문코드 번호 : <span style='color: blue; font-weight: bold;'>" + odrcode + "</span><br/><br/>");
			sb.append("<주문상품><br/>");
			
			for(int i=0; i<getOrderFinishProductList.size(); i++) {
				sb.append( getOrderFinishProductList.get(i).getPname() + "\t" + oqtyArr[i] + " 개&nbsp;&nbsp;" );
				sb.append("<img src='http://localhost:9090/MyMVC/images/"+getOrderFinishProductList.get(i).getPimage1()+"' />");
				sb.append("<img src='https://encrypted-tbn0.gstatic.com/shopping?q=tbn:ANd9GcQMB73c6Q3LffWlOPzjP03GpmBH1-KOQxy2LixDZaELBJU9Dps&usqp=CAY' />");
				sb.append("<br/>");
			}// end of for()---------------------------------------------------------------------------------
			
			sb.append("<br/> 이용해 주셔서 감사합니다.");
			
			String emailContents = sb.toString();
			
			mail.sendmail_OrderFinish(loginuser.getEmail(), emailContents);
			
		// **** 주문이 완료되었다라는 email 보내기 끝 **** //
			String msg = "주문이 정상적으로 처리되었습니다.";
			String loc = "orderList.do";
				
			super.alertMsg(req, msg, loc);
		}
		else {
			String msg = "주문이 실패되었습니다.";
			String loc = "javascript:history.back();";
				
			super.alertMsg(req, msg, loc);
		}
		
	}// end of execute(HttpServletRequest req, HttpServletResponse res)
	
	
	private String getOrdercode() {
	
		/* ----- 주문코드 생성하기 ----- */
		// 주문코드(명세서번호) 형식 : s + 날짜 + sequence ==> s20180430-1
		
		Date now = new Date();
		SimpleDateFormat smdatefm = new SimpleDateFormat("yyyyMMdd");
		String today = smdatefm.format(now);
		
		ProductDAO pdao = new ProductDAO();
		int seq_jsp_order = 0;
		try {
			seq_jsp_order = pdao.getSeq_jsp_order();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		// pdao.getSeq_jsp_order() 시퀀스 seq_jsp_order 값을 따오는 것
		
		return "s" + today + "-" + seq_jsp_order;
		
	}// end of getOrdercode()---------------------------------------

}
