package myshop.model;

import java.sql.*;
import java.util.*;

import javax.naming.*;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import member.model.MemberVO;
import memo.model.MemoVO;

public class ProductDAO implements InterProductDAO {

	private DataSource ds = null;
	// 객체변수 ds 는 아파치 톰캣이 제공하는 DBCP(DB Connection Pool)이다.
	
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	/* === ProductDAO 생성자에서 해야할 일은 ===
	     아파치 톰캣이 제공하는 DBCP(DB Connection Pool) 객체인 ds 를 얻어오는 것이다.
	*/
	public ProductDAO() {
		
		try {
			Context initContext = new InitialContext();
			Context envContext  = (Context)initContext.lookup("java:/comp/env");
			ds = (DataSource)envContext.lookup("jdbc/myoracle");
		} catch(NamingException e) {
			e.printStackTrace();
		}
		
	}// end of MemoDAO() 생성자------------------
	
	
	// *** 사용한 자원을 반납하는 close() 메소드 생성하기 *** //
	public void close() {
		try {
			if(rs != null) {
			   rs.close();
			   rs = null;
			}
			
			if(pstmt != null) {
			   pstmt.close();
			   pstmt = null;
			}
			
			if(conn != null) {
			   conn.close();
			   conn = null;
			}
				
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}// end of close()-------------------


	// *** jsp_product 테이블에서 pspec 컬럼의 값(HIT, NEW, BEST) 별로 상품 목록을 가져오는 메소드 생성하기 *** // 
	@Override
	public List<ProductVO> selectByPspec(String p_spec) 
		throws SQLException {
		
		List<ProductVO> productList = null;
		
		try {
			conn = ds.getConnection();
			// DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			String sql = " select * "     
					+   "  from jsp_product "
					+   "  where pspec = ? "
					+   "  order by pnum desc ";
			
			pstmt = conn.prepareStatement(sql); 
			pstmt.setString(1, p_spec);
			
			rs = pstmt.executeQuery();
			
			int cnt = 0;
			while(rs.next()) {
				cnt++;

				if(cnt==1)
					productList = new ArrayList<ProductVO>();

				int pnum = rs.getInt("pnum");
			    String pname	= rs.getString("pname");
			    String pcategory_fk = rs.getString("pcategory_fk");
			    String pcompany = rs.getString("pcompany");
			    String pimage1 = rs.getString("pimage1");
			    String pimage2 = rs.getString("pimage2");
			    int pqty = rs.getInt("pqty");
			    int price = rs.getInt("price");
			    int saleprice = rs.getInt("saleprice");
			    String pspec = rs.getString("pspec");
			    String pcontent = rs.getString("pcontent");
			    int point = rs.getInt("point");
			    String pinputdate = rs.getString("pinputdate");
			    
			    ProductVO pvo = new ProductVO(pnum, pname, pcategory_fk, pcompany, pimage1, pimage2, pqty, price, saleprice, pspec, pcontent, point, pinputdate);  
			    
			    productList.add(pvo);
			    
			}// end of while-----------------
						
		} finally{
			close();
		}
				
		return productList;
	}// end of selectByPspec(String pspec)------------------------	


	@Override
	public ProductVO getProductOneByPnum(String str_pnum) 
		throws SQLException {
		
		ProductVO pvo = null;
		
		try {
			conn = ds.getConnection();
			// DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			String sql = " select * "     
					+   "  from jsp_product "
					+   "  where pnum = ? ";
			
			pstmt = conn.prepareStatement(sql); 
			pstmt.setString(1, str_pnum);
			
			rs = pstmt.executeQuery();
			
			boolean isExists = rs.next();
			
			if(isExists) {
				int pnum = rs.getInt("pnum");
			    String pname	= rs.getString("pname");
			    String pcategory_fk = rs.getString("pcategory_fk");
			    String pcompany = rs.getString("pcompany");
			    String pimage1 = rs.getString("pimage1");
			    String pimage2 = rs.getString("pimage2");
			    int pqty = rs.getInt("pqty");
			    int price = rs.getInt("price");
			    int saleprice = rs.getInt("saleprice");
			    String pspec = rs.getString("pspec");
			    String pcontent = rs.getString("pcontent");
			    int point = rs.getInt("point");
			    String pinputdate = rs.getString("pinputdate");
			    
			    pvo = new ProductVO(pnum, pname, pcategory_fk, pcompany, pimage1, pimage2, pqty, price, saleprice, pspec, pcontent, point, pinputdate); 	
			}
									
		} finally{
			close();
		}
		
		return pvo;
	}// end of getProductOneByPnum(String pnum)----------------


	@Override
	public int addCart(String userid, String pnum, String oqty) 
		throws SQLException {
		
		int result = 0;
		
		try {
			conn = ds.getConnection();
			// DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			/*
			   먼저 장바구니 테이블(jsp_cart)에 새로운 제품은 넣는 것인지,
			   아니면 또다시 제품을 추가로 더 구매하는 것인지 알기 위해서
			   사용자가 장바구니에 넣으려고 하는 제품번호가 장바구니 테이블에
			   이미 있는지 먼저 장바구니번호(cartno)의 값을 알아온다. 
			 */
			String sql = " select cartno "
					   + " from jsp_cart "
					   + " where status = 1 and "
					   + "       userid = ? and "
					   + "       pnum = ? ";
			
			pstmt = conn.prepareStatement(sql); 
			pstmt.setString(1, userid);
			pstmt.setString(2, pnum);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				// 이미 장바구니 테이블에 담긴 제품이라면
				// update 해준다.
				
			 	int cartno = rs.getInt("cartno");
				
				sql = " update jsp_cart set oqty = oqty + ? "
					+ " where cartno = ? ";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, Integer.parseInt(oqty));
				pstmt.setInt(2, cartno);
				
				result = pstmt.executeUpdate();
				
			}
			else {
				// 장바구니 테이블에 없는 제품이라면
				// insert 해준다.
				
				sql = " insert into jsp_cart(cartno, userid, pnum, oqty) "  
				    + " values(seq_jsp_cart_cartno.nextval, ?, to_number(?), to_number(?) ) "; 
				
				pstmt = conn.prepareStatement(sql); 
				pstmt.setString(1, userid);
				pstmt.setString(2, pnum);
				pstmt.setString(3, oqty);
				
				result = pstmt.executeUpdate();
			}
			
		} finally{
			close();
		}		
		
		return result;
	}// end of addCart(String userid, String pnum, String oqty)---------------


	// *** jsp_cart 테이블(장바구니 테이블)을 조회해주는 메소드 생성하기 *** //
	@Override
	public List<CartVO> getCartList(String userid) 
		throws SQLException {
		
		List<CartVO> cartList = null;
		
		try {
			conn = ds.getConnection();
			// DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			String sql = "SELECT B.cartno, " 
					+"  B.userid, " 
					+"  B.pnum, " 
					+"  A.pname, " 
					+"  A.pcategory_fk, " 
					+"  A.pimage1, " 
					+"  A.price, " 
					+"  A.saleprice, " 
					+"  B.oqty, " 
					+"  A.point, " 
					+"  B.status " 
					+"FROM jsp_product A " 
					+"JOIN jsp_cart B " 
					+"ON A.pnum      = B.pnum " 
					+"WHERE B.userid = ? " 
					+"AND B.status   = 1 " 
					+"ORDER BY B.cartno DESC";
			
			pstmt = conn.prepareStatement(sql); 
			pstmt.setString(1, userid);
			
			rs = pstmt.executeQuery();
			
			int cnt = 0;
			while(rs.next()) {
				cnt++;

				if(cnt==1)
					cartList = new ArrayList<CartVO>();

				int cartno = rs.getInt("cartno");
			    userid = rs.getString("userid");
			    int pnum = rs.getInt("pnum");
			    String pname = rs.getString("pname");
			    String pcategory_fk = rs.getString("pcategory_fk");
			    String pimage1 = rs.getString("pimage1");
			    int price = rs.getInt("price");
			    int saleprice = rs.getInt("saleprice");
			    int oqty = rs.getInt("oqty");
			    int point = rs.getInt("point");
			    int status = rs.getInt("status");
			    
			    ProductVO item = new ProductVO();
			    item.setPnum(pnum);
			    item.setPname(pname);
			    item.setPcategory_fk(pcategory_fk);
			    item.setPimage1(pimage1);
			    item.setPrice(price);
			    item.setSaleprice(saleprice);
			    item.setPoint(point);
			    
			    // **** !!!!!!!! 중요함 !!!!!!!!! **** //
			    item.setTotalPriceTotalPoint(oqty);
			    // **** !!!!!!!! 중요함 !!!!!!!!! **** //
			    
			    CartVO cvo = new CartVO();
			    cvo.setCartno(cartno);
			    cvo.setUserid(userid);
			    cvo.setPnum(pnum);
			    cvo.setOqty(oqty);
			    cvo.setStatus(status);
			    cvo.setItem(item);
			    
			    cartList.add(cvo);
			    
			}// end of while-----------------
						
		} finally{
			close();
		}
		
		return cartList;
	}// end of getCartList(String userid)------------------------


	// *** jsp_cart 테이블(장바구니 테이블)에 수량 변경해주는 메소드 생성하기 *** //
	@Override
	public int editCart(String oqty, String cartno) 
		throws SQLException {
		
		int result = 0;
		
		try {
			conn = ds.getConnection();
			// DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			String sql = "";
			
			if( Integer.parseInt(oqty) == 0 ) {
				sql = " update jsp_cart set status = 0 "
					+ " where cartno = to_number(?) ";
				
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setString(1, cartno);
				result = pstmt.executeUpdate();	
			}
			else {
				sql = " update jsp_cart set oqty = to_number(?) "
					+ " where cartno = to_number(?) ";
					
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setString(1, oqty);
				pstmt.setString(2, cartno);
				result = pstmt.executeUpdate();
			}
						
		} finally{
			close();
		}
		
		return result;
	}// end of editCart(String oqty, String cartno)------------- 


	// *** jsp_cart 테이블(장바구니 테이블) 페이징 처리해서 데이터를 가져오는  메소드 생성하기 *** //
	@Override
	public List<CartVO> getCartList(String userid, int currentShowPageNo, int sizePerPage) 
		throws SQLException {

		List<CartVO> cartList = null;
		
		try {
			conn = ds.getConnection();
			// DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			String sql = " select cartno, userid, pnum, "
					+ "           pname, pcategory_fk, pimage1,  "
					+ "           price, saleprice, oqty, point, status "
					+ "    from  "
					+ "    ( "
					+ "      select rownum as RNO, "
					+ "             cartno, userid, pnum, "
					+ "             pname, pcategory_fk, pimage1,  "
					+ "             price, saleprice, oqty, point, status "
					+ "      from  "
					+ "      ( "
					+ "        select B.cartno, B.userid, B.pnum, "
					+ "               A.pname, A.pcategory_fk, A.pimage1,  "
					+ "               A.price, A.saleprice, B.oqty, A.point, B.status "
					+ "        from jsp_product A join jsp_cart B "
					+ "        on A.pnum = B.pnum "
					+ "        where B.userid = ? and "
					+ "              B.status = 1 "
					+ "        order by B.cartno desc "
					+ "      ) V  "
					+ "    ) T  "
					+ " where T.rno between ? and ? ";
			
			pstmt = conn.prepareStatement(sql); 
			pstmt.setString(1, userid);
			pstmt.setInt(2, (currentShowPageNo*sizePerPage)-(sizePerPage-1) ); // 공식
			pstmt.setInt(3, (currentShowPageNo*sizePerPage) ); // 공식
			
			rs = pstmt.executeQuery();
			
			int cnt = 0;
			while(rs.next()) {
				cnt++;

				if(cnt==1)
					cartList = new ArrayList<CartVO>();

				int cartno = rs.getInt("cartno");
			    userid = rs.getString("userid");
			    int pnum = rs.getInt("pnum");
			    String pname = rs.getString("pname");
			    String pcategory_fk = rs.getString("pcategory_fk");
			    String pimage1 = rs.getString("pimage1");
			    int price = rs.getInt("price");
			    int saleprice = rs.getInt("saleprice");
			    int oqty = rs.getInt("oqty");
			    int point = rs.getInt("point");
			    int status = rs.getInt("status");
			    
			    ProductVO item = new ProductVO();
			    item.setPnum(pnum);
			    item.setPname(pname);
			    item.setPcategory_fk(pcategory_fk);
			    item.setPimage1(pimage1);
			    item.setPrice(price);
			    item.setSaleprice(saleprice);
			    item.setPoint(point);
			    
			    // **** !!!!!!!! 중요함 !!!!!!!!! **** //
			    item.setTotalPriceTotalPoint(oqty);
			    // **** !!!!!!!! 중요함 !!!!!!!!! **** //
			    
			    CartVO cvo = new CartVO();
			    cvo.setCartno(cartno);
			    cvo.setUserid(userid);
			    cvo.setPnum(pnum);
			    cvo.setOqty(oqty);
			    cvo.setStatus(status);
			    cvo.setItem(item);
			    
			    cartList.add(cvo);
			    
			}// end of while-----------------
						
		} finally{
			close();
		}
		
		return cartList;		
		
	}// end of getCartList(String userid, int currentShowPageNo, int sizePerPage)------------------ 
	
	
	// *** userid 별 장바구니 전체갯수 조회 메소드 생성하기 *** //
	@Override
	public int getTotalCartCount(String userid) 
		throws SQLException {

		int cnt = 0;
		
		try {
			 conn = ds.getConnection();
			 // DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			 String sql = " select count(*) AS CNT "
		               +  "	from jsp_cart "
					   +  " where status = 1 and "
					   +  "       userid = ? ";
			 
			 pstmt = conn.prepareStatement(sql);
			 pstmt.setString(1, userid);
			 
			 rs = pstmt.executeQuery();
			 
			 rs.next();
			 
			 cnt = rs.getInt("CNT");
			 
		} finally {
			close();
		}
		
		return cnt;
	}// end of getTotalCartCount(String userid) ----------------------	


	// *** 장바구니에서 특정 제품 삭제하기전 
	//     해당 장바구니 번호의 소유주(userid)가 누구인지를 알려주는 메소드 생성하기 *** //   
	@Override
	public String getUseridByCartno(String cartno) 
		throws SQLException {
	
		String userid = null;
		
		try {
			 conn = ds.getConnection();
			 // DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			 String sql = " select userid "
		               +  "	from jsp_cart "
					   +  " where status = 1 and "
					   +  "       cartno = to_number(?) ";
			 
			 pstmt = conn.prepareStatement(sql);
			 pstmt.setString(1, cartno);
			 
			 rs = pstmt.executeQuery();
			 
			 rs.next();
			 
			 userid = rs.getString("userid");
			 
		} finally {
			close();
		}
		
		return userid;
	}// end of getUseridByCartno(String cartno)-----------------


	// *** 장바구니에서 특정 제품 삭제하는 메소드 생성하기 *** // 
	@Override
	public int deleteCartno(String cartno) 
		throws SQLException {
		
		int result = 0;
		
		try {
			 conn = ds.getConnection();
			 // DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			 String sql = " update jsp_cart set status = 0 "
		               +  " where cartno = to_number(?) "; 
			 
			 pstmt = conn.prepareStatement(sql);
			 pstmt.setString(1, cartno);
			 
			 result = pstmt.executeUpdate();
			 
		} finally {
			close();
		}
		
		return result;
	}// end of deleteCartno(String cartno)--------------------


	// *** jsp_product_imagefile 테이블에서 복수개 이미지 파일을 출력해주는 메소드 생성하기 *** //
	@Override
	public List<ProductImagefileVO> getProductImagefileByPnum(String pnum) 
		throws SQLException {
		
		List<ProductImagefileVO> imgFileList = null;
		
		try {
			conn = ds.getConnection();
			// DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			String sql = " select imgfileno, fk_pnum, imgfilename "
					   + " from jsp_product_imagefile "
					   + " where fk_pnum = to_number(?) "
					   + " order by imgfileno desc ";
			
			pstmt = conn.prepareStatement(sql); 
			pstmt.setString(1, pnum);
			
			rs = pstmt.executeQuery();
			
			int cnt = 0;
			while(rs.next()) {
				cnt++;

				if(cnt==1)
					imgFileList = new ArrayList<ProductImagefileVO>();

				int imgfileno = rs.getInt("imgfileno");
			    int fk_pnum = rs.getInt("fk_pnum");
			    String imgfilename = rs.getString("imgfilename");
			    
			    ProductImagefileVO imgfilevo = new ProductImagefileVO(imgfileno, fk_pnum, imgfilename); 
			    
			    imgFileList.add(imgfilevo);
			    
			}// end of while-----------------
						
		} finally{
			close();
		}		
		
		return imgFileList;
	}// end of getProductImagefileByPnum(String pnum)---------------


	// *** jsp_category 테이블에서 카테고리코드(code)와 카테고리명(cname)을 가져오는 메소드 생성하기 *** //
	@Override
	public List<CategoryVO> getCategoryList() 
		throws SQLException {
		
		List<CategoryVO> categoryList = null;
		
		try {
			conn = ds.getConnection();
			// DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			String sql = " select cnum, code, cname "
					   + " from jsp_category "
					   + " order by cnum ";
			
			pstmt = conn.prepareStatement(sql); 
						
			rs = pstmt.executeQuery();
			
			int cnt = 0;
			while(rs.next()) {
				cnt++;

				if(cnt==1)
					categoryList = new ArrayList<CategoryVO>();

				int cnum = rs.getInt("cnum");
			    String code = rs.getString("code");
			    String cname = rs.getString("cname");
			    
			    CategoryVO categoryvo = new CategoryVO(cnum, code, cname); 
			    
			    categoryList.add(categoryvo);
			    
			}// end of while-----------------
						
		} finally{
			close();
		}		
		
		return categoryList;
		
	}// end of getCategoryList()-------------------


	// *** jsp_product 테이블에서 카테고리코드(pcategory_fk)별로 제품목록을 조회해주는 메소드 생성하기 *** //
	@Override
	public List<ProductVO> getProductsByCategory(String code) 
		throws SQLException {

		List<ProductVO> productList = null;
		
		try {
			conn = ds.getConnection();
			// DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			String sql = " select * "     
					+   "  from jsp_product "
					+   "  where pcategory_fk = ? "
					+   "  order by pnum desc ";
			
			pstmt = conn.prepareStatement(sql); 
			pstmt.setString(1, code);
			
			rs = pstmt.executeQuery();
			
			int cnt = 0;
			while(rs.next()) {
				cnt++;

				if(cnt==1)
					productList = new ArrayList<ProductVO>();

				int pnum = rs.getInt("pnum");
			    String pname	= rs.getString("pname");
			    String pcategory_fk = rs.getString("pcategory_fk");
			    String pcompany = rs.getString("pcompany");
			    String pimage1 = rs.getString("pimage1");
			    String pimage2 = rs.getString("pimage2");
			    int pqty = rs.getInt("pqty");
			    int price = rs.getInt("price");
			    int saleprice = rs.getInt("saleprice");
			    String pspec = rs.getString("pspec");
			    String pcontent = rs.getString("pcontent");
			    int point = rs.getInt("point");
			    String pinputdate = rs.getString("pinputdate");
			    
			    ProductVO pvo = new ProductVO(pnum, pname, pcategory_fk, pcompany, pimage1, pimage2, pqty, price, saleprice, pspec, pcontent, point, pinputdate);  
			    
			    productList.add(pvo);
			    
			}// end of while-----------------
						
		} finally{
			close();
		}
				
		return productList;
	}// end of getProductsByCategory(String code)----------------  


	// *** 주문코드(명세서 번호) 시퀀스 값 따오는 메소드 생성하기 *** //
		@Override
		public int getSeq_jsp_order() throws SQLException {
			
			int result = 0;
			
			try {
				conn = ds.getConnection();
			    // 객체 ds 를 통해 아파치톰캣이 제공하는 DBCP(DB Connection pool)에서 생성된 커넥션을 빌려온다.
				
				String sql = "select seq_jsp_order.nextval AS seq "
						   + " from dual ";
				
				pstmt = conn.prepareStatement(sql);
				
				rs = pstmt.executeQuery();
				
				rs.next();
				
				result = rs.getInt("seq");
				
			} finally {
				close();
			}
					
			return result;
			
		}// end of getSeq_jsp_order()-------------------------------
	
	
	// *** 주문하기 매소드 만들기 *** //
	   @Override
	   public int add_Order_OrderDetail(String odrcode, String userid, int sumtotalprice, int sumtotalpoint,
	         String[] pnumArr, String[] oqtyArr, String[] salepriceArr, String[] cartnoArr) throws SQLException {
	      
	      int result = 0;
	      
	      int n1 = 0, n2 = 0, n3 = 0, n4 = 0, n5 = 0;
	      
	      try {
	         conn = ds.getConnection();
	         // DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
	         //  ==== *** Transaction 처리하기 *** ====
	         /*
	                        오토커밋 해제 --> 모든 DML문이 성공되었을 경우에만 commit;하고,
	                        하나라도 실패하면 모두 rollback 시키기 위함이다.
	          */
	         conn.setAutoCommit(false);
	         // 1. 주문개요 테이블(jsp_order)에 입력(insert)
	         String sql = " insert into jsp_order(odrcode, fk_userid, odrtotalPrice, odrtotalPoint, odrdate) "
	                  + " values(?, ?, ?, ?, default) ";
	         
	         pstmt = conn.prepareStatement(sql);
	         
	         pstmt.setString(1, odrcode);
	         pstmt.setString(2, userid);
	         pstmt.setInt(3, sumtotalprice);
	         pstmt.setInt(4, sumtotalpoint);
	         
	         n1 = pstmt.executeUpdate();
	         
	         if(n1 != 1) {
				conn.rollback();
				return 0;
			 }
	         
	         if(n1 == 1) {
	        	// 2. 주문상세 테이블(jsp_order_detail)에 입력(insert)
	        	for(int i=0; i<pnumArr.length; i++) {
	        		
	        		sql = " insert into jsp_order_detail(odrseqnum, fk_odrcode, fk_pnum, oqty, odrprice, deliverStatus, deliverDate) "
	        		    + " values(seq_jsp_order_detail.nextval, ?, to_number(?), to_number(?), to_number(?), default, default) ";
	        		
	        		pstmt = conn.prepareStatement(sql);
	        		pstmt.setString(1, odrcode);
	        		pstmt.setString(2, pnumArr[i]);
	        		pstmt.setString(3, oqtyArr[i]);
	        		pstmt.setString(4, salepriceArr[i]);
	        		
	        		n2 = pstmt.executeUpdate();
	        		
	        		if(n2 != 1) {
	        			conn.rollback();
	        			return 0;
	        		}
	        		       		
	        	}// end of for()------------------------------------
	        	
	        }// end of if(n1 == 1)------------------------------------
	         
	        if(n2 == 1) {
	        	/*3. 구매하는 사용자의 coin 컬럼의 값을 구매한 가격만큼 감하고,
	            point 컬럼의 값은 구매한 포인트만큼 증가하며(update),*/
	        	
	        	sql = " update jsp_member set coin = coin - ? "
	        	    + "                     , point = point + ? "
	        	    + " where userid = ? ";
	        	
	        	pstmt = conn.prepareStatement(sql);
	        	pstmt.setInt(1, sumtotalprice);
	        	pstmt.setInt(2, sumtotalpoint);
	        	pstmt.setString(3, userid);
	        	
	        	n3 = pstmt.executeUpdate();
	        	
	        	if(n3 != 1) {
        			conn.rollback();
        			return 0;
	        	}
	        	       	
     		}// end of if(n2 == 1)----------------------------------------
	        
	        if(n3 == 1) {
	        	// 4. 주문한 제품의 잔고량은 주문량 만큼 감해야 하고(update),
	        	for(int i=0; i<pnumArr.length; i++) {
	        		
	        		sql = " update jsp_product set pqty = pqty - to_number(?) "
	        			+ " where pnum = to_number(?) ";
	        		
	        		pstmt = conn.prepareStatement(sql);
	        		pstmt.setString(1, oqtyArr[i]);
	        		pstmt.setString(2, pnumArr[i]);
		        	
		        	n4 = pstmt.executeUpdate();
		        	
		        	if(n4 != 1) {
	        			conn.rollback();
	        			return 0;
		        	}
	        	}// end of for()----------------------------------------
	        	
	        }// end of if(n3 == 1)----------------------------------------------
	        
	      // *** 장바구니에 있던 것을 주문한 경우라면 장바구니 비우기를 하도록 한다. *** //
	      if(cartnoArr != null && n4 == 1) {
	    	  
	    	  for(int i=0; i<cartnoArr.length; i++) {
	    		  
	    		  sql = " update jsp_cart set status = 0 "
	    			  + " where cartno = to_number(?) ";
	    		  
	    		  pstmt = conn.prepareStatement(sql);
	    		  pstmt.setString(1, cartnoArr[i]);
	    		  
	    		  n5 = pstmt.executeUpdate();
	    		  
	    		  if(n5 != 1) {
	    			  conn.rollback();
	    			  return 0;
	    		  }
	    		  
	    	  }// end of for()-----------------------------
	    	  
	      }// end of if(cartnoArr != null && n4 == 1)--------------------------------------------
	      
	      // *** 바로 주문하기인 경우의 commit; 하기 *** //
	      if(cartnoArr == null && n1+n2+n3+n4 == 4) {
	    	  conn.commit();
	    	  return 1;
	      }
	            
	      // *** 장바구니인 경우의 commit; 하기 *** //
	      else if(cartnoArr != null && n1+n2+n3+n4+n5 == 5) {
	    	  conn.commit();
	    	  return 1;
	      }
	      else {
	    	  conn.rollback();
	    	  return 0;
	      }
	         
	      } finally {
	         close();
	      }
	      
	   }// end of add_Order_OrderDetail(String odrcode, String userid, int sumtotalprice, int sumtotalpoint, String[] pnumArr, String[] oqtyArr, String[] salepriceArr, String[] cartnoArr)


	   
	// *** 제품번호들에 해당하는 제품목록을 조회해오는 추상 메소드 *** //
	@Override
	public List<ProductVO> getOrderFinishProductList(String pnumes) throws SQLException {
		
		List<ProductVO> productList = null;
		
		try {
			conn = ds.getConnection();
			// DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			String sql = " select * "     
					+   "  from jsp_product "
					+   "  where pnum in (" + pnumes + ") ";
			
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			int cnt = 0;
			while(rs.next()) {
				cnt++;

				if(cnt==1)
					productList = new ArrayList<ProductVO>();

				int pnum = rs.getInt("pnum");
			    String pname	= rs.getString("pname");
			    String pcategory_fk = rs.getString("pcategory_fk");
			    String pcompany = rs.getString("pcompany");
			    String pimage1 = rs.getString("pimage1");
			    String pimage2 = rs.getString("pimage2");
			    int pqty = rs.getInt("pqty");
			    int price = rs.getInt("price");
			    int saleprice = rs.getInt("saleprice");
			    String pspec = rs.getString("pspec");
			    String pcontent = rs.getString("pcontent");
			    int point = rs.getInt("point");
			    String pinputdate = rs.getString("pinputdate");
			    
			    ProductVO pvo = new ProductVO(pnum, pname, pcategory_fk, pcompany, pimage1, pimage2, pqty, price, saleprice, pspec, pcontent, point, pinputdate);  
			    
			    productList.add(pvo);
			    
			}// end of while-----------------
						
		} finally{
			close();
		}
				
		return productList;
		
	}// end of getOrderFinishProductList(String pnumes)--------------------------------------


	
    // *** userid 별 주문내역 전체갯수 조회 추상메소드  *** //
	@Override
	public int getTotalCountOrder(String userid) throws SQLException {
		
		int cnt = 0;
		
		try {
			 conn = ds.getConnection();
			 // DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			 String sql = " select count(*) AS CNT "
		               +  "	from jsp_order "
					   +  " where fk_userid = ? and odrdate > add_months(sysdate, - 12)";
			 
			 pstmt = conn.prepareStatement(sql);
			 pstmt.setString(1, userid);
			 
			 rs = pstmt.executeQuery();
			 
			 rs.next();
			 
			 cnt = rs.getInt("CNT");
			 
		} finally {
			close();
		}
		
		return cnt;
		
	}// end of getTotalCountOrder(String userid)---------------------------------------

	
	// *** 모든회원 주문내역 전체갯수 조회 추상메소드  *** //
	@Override
	public int getTotalCountOrder() throws SQLException {
		
		int cnt = 0;
		
		try {
			 conn = ds.getConnection();
			 // DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			 String sql = " select count(*) AS CNT "
		               +  "	from jsp_order "
					   +  " where odrdate > add_months(sysdate, - 12)";
			 
			 pstmt = conn.prepareStatement(sql);
			 
			 rs = pstmt.executeQuery();
			 
			 rs.next();
			 
			 cnt = rs.getInt("CNT");
			 
		} finally {
			close();
		}
		
		return cnt;
	}// end of getTotalCountOrder()----------------------------------

	
    // *** 페이징 처리한 데이터 조회 추상 메소드 *** //
	@Override
	public List<HashMap<String, String>> getAllOrder(String userid, int currentShowPageNo, int sizePerPage) throws SQLException {
		
		List<HashMap<String, String>> orderList = null;
		
		try {
			 conn = ds.getConnection();
			 // DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			 String sql = " select pname, pimage1, price, odrprice, point, pnum, oqty, "
			 		    + " case deliverstatus when 1 then '주문완료' " 
			 		    + "                    when 2 then '배송시작' " 
			 		    + "                    when 3 then '배송완료' "
			 		    + "                    end as deliverstatus, "
			 		    + " fk_userid, odrtotalprice, fk_odrcode, to_char(odrdate, 'yyyy-mm-dd') AS odrdate " 
			 			+ " from "
					 	+ "  ("  
					 	+ "    select rownum AS RNO, pname, pimage1, price, odrprice, point, pnum, oqty, deliverstatus, fk_userid, odrtotalprice, fk_odrcode, odrdate "  
					 	+ "    From jsp_product A left JOIN jsp_order_detail B "  
					 	+ "    ON A.pnum = B.fk_pnum "
					 	+ "    left JOIN jsp_order C " 
					 	+ "    ON fk_odrcode = C.odrcode "
					 	+ "    where fk_userid = ? and odrdate > add_months(sysdate, - 12) "
					 	+ "  )V "
					 	+ " where V.RNO between ? and ? ";
			 
			 pstmt = conn.prepareStatement(sql);
			 pstmt.setString(1, userid);
			 pstmt.setInt(2, (currentShowPageNo*sizePerPage)-(sizePerPage-1) ); // 공식
			 pstmt.setInt(3, (currentShowPageNo*sizePerPage) ); // 공식
			 
			 rs = pstmt.executeQuery();
			
			 int cnt = 0;
			 while(rs.next()) {
				 cnt++;
				 
				 if(cnt==1)
					 orderList = new ArrayList<HashMap<String, String>>();
				 
				 String fk_odrcode = rs.getString("fk_odrcode");
				 String odrdate = rs.getString("odrdate");
				 String pimage1 = rs.getString("pimage1");
				 String pnum = rs.getString("pnum");
				 String pname = rs.getString("pname");
				 String price = rs.getString("price");
				 String odrprice = rs.getString("odrprice");
				 String point = rs.getString("point");
				 String oqty = rs.getString("oqty");
				 String deliverstatus = rs.getString("deliverstatus");
				 
				 
				 
				 HashMap<String, String> map = new HashMap<String, String>();

				 map.put("fk_odrcode", fk_odrcode);
				 map.put("odrdate", odrdate);
				 map.put("pimage1", pimage1);
				 map.put("pnum", pnum);
				 map.put("pname", pname);
				 map.put("price", price);
				 map.put("odrprice", odrprice);
				 map.put("point", point);
				 map.put("oqty", oqty);
				 map.put("deliverstatus", deliverstatus);				 
				 
				 orderList.add(map);
				 
			 }// end of while-----------------------
			
		} finally {
			close();
		}
		
		return orderList;		
		
	}// end of getAllOrder(int currentShowPageNo, int sizePerPage)-----------------

	
    // *** 페이징 처리한 모든 회원 주문 데이터 조회 추상 메소드 *** //
	@Override
	public List<HashMap<String, String>> getAllOrder(int currentShowPageNo, int sizePerPage) throws SQLException {
		
		List<HashMap<String, String>> orderList = null;
		
		try {
			 conn = ds.getConnection();
			 // DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			 String sql = " select pname, pimage1, price, odrprice, point, pnum, oqty, "
			 		    + " case deliverstatus when 1 then '주문완료' " 
			 		    + "                    when 2 then '배송시작' " 
			 		    + "                    when 3 then '배송완료' "
			 		    + "                    end as deliverstatus, "
			 		    + " fk_userid, odrtotalprice, fk_odrcode, to_char(odrdate, 'yyyy-mm-dd') AS odrdate " 
			 			+ " from "
					 	+ "  ("  
					 	+ "    select rownum AS RNO, pname, pimage1, price, odrprice, point, pnum, oqty, deliverstatus, fk_userid, odrtotalprice, fk_odrcode, odrdate "  
					 	+ "    From jsp_product A left JOIN jsp_order_detail B "  
					 	+ "    ON A.pnum = B.fk_pnum "
					 	+ "    left JOIN jsp_order C " 
					 	+ "    ON fk_odrcode = C.odrcode "
					 	+ "    where odrdate > add_months(sysdate, - 12) "
					 	+ "  )V "
					 	+ " where V.RNO between ? and ? ";
			 
			 pstmt = conn.prepareStatement(sql);
			 pstmt.setInt(1, (currentShowPageNo*sizePerPage)-(sizePerPage-1) ); // 공식
			 pstmt.setInt(2, (currentShowPageNo*sizePerPage) ); // 공식
			 
			 rs = pstmt.executeQuery();
			
			 int cnt = 0;
			 while(rs.next()) {
				 cnt++;
				 
				 if(cnt==1)
					 orderList = new ArrayList<HashMap<String, String>>();
				 
				 String fk_userid = rs.getString("fk_userid");
				 String fk_odrcode = rs.getString("fk_odrcode");
				 String odrdate = rs.getString("odrdate");
				 String pimage1 = rs.getString("pimage1");
				 String pnum = rs.getString("pnum");
				 String pname = rs.getString("pname");
				 String price = rs.getString("price");
				 String odrprice = rs.getString("odrprice");
				 String point = rs.getString("point");
				 String oqty = rs.getString("oqty");
				 String deliverstatus = rs.getString("deliverstatus");
				 
				 
				 
				 HashMap<String, String> map = new HashMap<String, String>();

				 
				 map.put("fk_userid", fk_userid);
				 map.put("fk_odrcode", fk_odrcode);
				 map.put("odrdate", odrdate);
				 map.put("pimage1", pimage1);
				 map.put("pnum", pnum);
				 map.put("pname", pname);
				 map.put("price", price);
				 map.put("odrprice", odrprice);
				 map.put("point", point);
				 map.put("oqty", oqty);
				 map.put("deliverstatus", deliverstatus);		
				 				 
				 orderList.add(map);
				 
			 }// end of while-----------------------
			
		} finally {
			close();
		}
		
		return orderList;
		
	}// end of getAllOrder(int currentShowPageNo, int sizePerPage)------------------------------------


    // *** 배송 시작으로 해주는 추상 메소드 *** //
	@Override
	public int updateDeliverStart(String odrcodePnum, int length)  throws SQLException {
		
		int result = 0;
		
		try {
			 conn = ds.getConnection();
			 // DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			 conn.setAutoCommit(false); // 수동커밋
			 
			 String sql = " UPDATE jsp_order_detail SET DELIVERSTATUS = 2 " 
					     +" WHERE FK_ODRCODE || FK_PNUM IN("+odrcodePnum+")"; 
			 
			 pstmt = conn.prepareStatement(sql);
			 			 
			 int n = pstmt.executeUpdate();
			 
			 if(n == length) {
				 conn.commit();
				 result = 1;
			 } 
			 else {
				 conn.rollback();
				 result = 0;
			 }
				
		} finally {
			close();
		}
		
		return result;
		
	}// end of  int updateDeliverStart(String odrcodePnum, int length)-------------


    // *** 배송 시작으로 해주는 추상 메소드 *** //
	@Override
	public int updateDeliverEnd(String odrcodePnum, int length) throws SQLException {
		
		int result = 0;
		
		try {
			 conn = ds.getConnection();
			 // DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			 conn.setAutoCommit(false); // 수동커밋
			 
			 String sql = " UPDATE jsp_order_detail SET DELIVERSTATUS = 3 " 
					     +" WHERE FK_ODRCODE || FK_PNUM IN("+odrcodePnum+")"; 
			 
			 pstmt = conn.prepareStatement(sql);
			 			 
			 int n = pstmt.executeUpdate();
			 
			 if(n == length) {
				 conn.commit();
				 result = 1;
			 } 
			 else {
				 conn.rollback();
				 result = 0;
			 }
				
		} finally {
			close();
		}		
		
		return result;
		
	}// end of updateDeliverEnd(String odrcodePnum, int length)-----------------


	
 	// *** jsp_product 테이블에 신규제품으로 insert 되어질 제품번호 시퀀스 seq_jsp_product_pnum.nextval 을 따오는 추상 메소드 *** //
	@Override
	public int getPnumOfProduct() throws SQLException {
		
		int result = 0;
		
		try {
			conn = ds.getConnection();
		    // 객체 ds 를 통해 아파치톰캣이 제공하는 DBCP(DB Connection pool)에서 생성된 커넥션을 빌려온다.
			
			String sql = "select seq_jsp_product_pnum.nextval AS seq "
					   + " from dual ";
			
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			rs.next();
			
			result = rs.getInt("seq");
			
		} finally {
			close();
		}
				
		return result;
		
	}// end of getPnumOfProduct()--------------------------------------


	
 	// *** 제품등록(신규상품등록)을 해주는 추상 메소드 *** //
	@Override
	public int productInsert(ProductVO pvo) throws SQLException {
		
		int result = 0;
		
		try {
			
			conn = ds.getConnection();
		    // 객체 ds 를 통해 아파치톰캣이 제공하는 DBCP(DB Connection pool)에서 생성된 커넥션을 빌려온다.
			
			String sql = " insert into jsp_product(pnum, pname, pcategory_fk, pcompany, "  
					   + "                        pimage1, pimage2, pqty, price, saleprice, "  
					   + "                        pspec, pcontent, point, pinputdate) "
					   + " values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, default) ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, pvo.getPnum());
			pstmt.setString(2, pvo.getPname());
			pstmt.setString(3, pvo.getPcategory_fk());
			pstmt.setString(4, pvo.getPcompany());
			pstmt.setString(5, pvo.getPimage1());
			pstmt.setString(6, pvo.getPimage2());
			pstmt.setInt(7, pvo.getPqty());
			pstmt.setInt(8, pvo.getPrice());
			pstmt.setInt(9, pvo.getSaleprice());
			pstmt.setString(10, pvo.getPspec());
			pstmt.setString(11, pvo.getPcontent());
			pstmt.setInt(12, pvo.getPoint());
			
			result = pstmt.executeUpdate();
			
			
		} finally {
			close();
		}
				
		return result;
		
	}// end of productInsert(ProductVO pvo)----------------------------


	
 	// *** 제품등록(신규상품등록)시 추가이미지 파일정보를 jsp_product_imagefile 테이블에 insert 추상 메소드 *** //
	@Override
	public void product_imagefile_Insert(int pnum, String attachFilename) throws SQLException {
		
		try {
			
			conn = ds.getConnection();
		    // 객체 ds 를 통해 아파치톰캣이 제공하는 DBCP(DB Connection pool)에서 생성된 커넥션을 빌려온다.
			
			String sql = " insert into jsp_product_imagefile(imgfileno, fk_pnum, imgfilename) "
					   + " values(seq_imgfileno.nextval, ?, ?) ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, pnum);
			pstmt.setString(2, attachFilename);
		
			
			pstmt.executeUpdate();
			
			
		} finally {
			close();
		}
		
	}// end of product_imagefile_Insert()------------------------------------


	
	
 	// *** 로그인한 사용자의 구매통계 현황을 조회해주는 추상 메소드 *** //
	@Override
	public List<HashMap<String, String>> getMyOrderStatics(String userid) throws SQLException {
		
		List<HashMap<String, String>> mapList = null;
		
		try {
			
			conn = ds.getConnection();
		    // 객체 ds 를 통해 아파치톰캣이 제공하는 DBCP(DB Connection pool)에서 생성된 커넥션을 빌려온다.
			
			String sql = "SELECT V.CNAME, " 
					+"  SUM(FIXEDORDERPRICE) AS TOTALFIXEDORDERPRICE, " 
					+"  ROUND( SUM(FIXEDORDERPRICE) / " 
					+"  (SELECT SUM(B.oqty * B.odrprice) " 
					+"  FROM jsp_order A " 
					+"  JOIN jsp_order_detail B " 
					+"  ON A.odrcode = B.fk_odrcode " 
					+"  JOIN jsp_product C " 
					+"  ON B.fk_pnum = C.pnum " 
					+"  JOIN jsp_category D " 
					+"  ON C.pcategory_fk = D.code " 
					+"  WHERE A.fk_userid = ? " 
					+"  ) * 100, 1 ) AS PERCENT " 
					+"FROM " 
					+"  (SELECT D.cname, " 
					+"    B.oqty * B.odrprice AS FIXEDORDERPRICE " 
					+"  FROM jsp_order A " 
					+"  JOIN jsp_order_detail B " 
					+"  ON A.odrcode = B.fk_odrcode " 
					+"  JOIN jsp_product C " 
					+"  ON B.fk_pnum = C.pnum " 
					+"  JOIN jsp_category D " 
					+"  ON C.pcategory_fk = D.code " 
					+"  WHERE A.fk_userid = ? " 
					+"  ) V " 
					+"GROUP BY V.CNAME "
					+"ORDER BY PERCENT DESC ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, userid);
			pstmt.setString(2, userid);
		
			rs = pstmt.executeQuery();
			
			int cnt = 0;
			while(rs.next()) {
				cnt++;
				if(cnt == 1) 
					mapList = new ArrayList<HashMap<String, String>>();
				
				String CNAME = rs.getString("CNAME");
				String TOTALFIXEDORDERPRICE = rs.getString("TOTALFIXEDORDERPRICE");
				String PERCENT = rs.getString("PERCENT");
				
				HashMap<String, String> map = new HashMap<String, String>();
				
				map.put("CNAME", CNAME);
				map.put("TOTALFIXEDORDERPRICE", TOTALFIXEDORDERPRICE);
				map.put("PERCENT", PERCENT);
				 
				mapList.add(map);
			}
			
		} finally {
			close();
		}
		
		return mapList;
		
	}// end of List<HashMap<String, String>> getMyOrderStatics(String userid)-------------------


	
 	// *** 제품 카테고리별 월별 판매 통계 현황을 조회해주는 추상 메소드 *** //
	@Override
	public List<HashMap<String, String>> getTotalOrderStatics() throws SQLException {

		List<HashMap<String, String>> mapList = null;
		
		try {
			
			conn = ds.getConnection();
		    // 객체 ds 를 통해 아파치톰캣이 제공하는 DBCP(DB Connection pool)에서 생성된 커넥션을 빌려온다.
			
			String sql = "SELECT D.cname AS CNAME, " 
					+"  SUM(DECODE(TO_CHAR(A.odrdate, 'mm'), '01', B.oqty, 0) ) AS JAN, " 
					+"  SUM(DECODE(TO_CHAR(A.odrdate, 'mm'), '02', B.oqty, 0) ) AS FEB, " 
					+"  SUM(DECODE(TO_CHAR(A.odrdate, 'mm'), '03', B.oqty, 0) ) AS MAR, " 
					+"  SUM(DECODE(TO_CHAR(A.odrdate, 'mm'), '04', B.oqty, 0) ) AS APR, " 
					+"  SUM(DECODE(TO_CHAR(A.odrdate, 'mm'), '05', B.oqty, 0) ) AS MAY, " 
					+"  SUM(DECODE(TO_CHAR(A.odrdate, 'mm'), '06', B.oqty, 0) ) AS JUN, " 
					+"  SUM(DECODE(TO_CHAR(A.odrdate, 'mm'), '07', B.oqty, 0) ) AS JUL, " 
					+"  SUM(DECODE(TO_CHAR(A.odrdate, 'mm'), '08', B.oqty, 0) ) AS AUG, " 
					+"  SUM(DECODE(TO_CHAR(A.odrdate, 'mm'), '09', B.oqty, 0) ) AS SEP, " 
					+"  SUM(DECODE(TO_CHAR(A.odrdate, 'mm'), '10', B.oqty, 0) ) AS OCT, " 
					+"  SUM(DECODE(TO_CHAR(A.odrdate, 'mm'), '11', B.oqty, 0) ) AS NOV, " 
					+"  SUM(DECODE(TO_CHAR(A.odrdate, 'mm'), '21', B.oqty, 0) ) AS DEC " 
					+"FROM jsp_order A " 
					+"JOIN jsp_order_detail B " 
					+"ON A.odrcode = B.fk_odrcode " 
					+"JOIN jsp_product C " 
					+"ON B.fk_pnum = C.pnum " 
					+"JOIN jsp_category D " 
					+"ON C.pcategory_fk                = D.code " 
					+"WHERE TO_CHAR(A.odrdate, 'yyyy') = TO_CHAR(sysdate, 'yyyy') " 
					+"GROUP BY D.cname";
			
			pstmt = conn.prepareStatement(sql);
					
			rs = pstmt.executeQuery();
			
			int cnt = 0;
			while(rs.next()) {
				cnt++;
				if(cnt == 1) 
					mapList = new ArrayList<HashMap<String, String>>();
				
				String CNAME = rs.getString("CNAME");
				String JAN = rs.getString("JAN");
				String FEB = rs.getString("FEB");
				String MAR = rs.getString("MAR");
				String APR = rs.getString("APR");
				String MAY = rs.getString("MAY");
				String JUN = rs.getString("JUN");
				String JUL = rs.getString("JUL");
				String AUG = rs.getString("AUG");
				String SEP = rs.getString("SEP");
				String OCT = rs.getString("OCT");
				String NOV = rs.getString("NOV");
				String DEC = rs.getString("DEC");
				
				
				HashMap<String, String> map = new HashMap<String, String>();
				
				map.put("CNAME", CNAME);
				map.put("JAN", JAN);
				map.put("FEB", FEB);
				map.put("MAR", MAR);
				map.put("APR", APR);
				map.put("MAY", MAY);
				map.put("JUN", JUN);
				map.put("JUL", JUL);
				map.put("AUG", AUG);
				map.put("SEP", SEP);
				map.put("OCT", OCT);
				map.put("NOV", NOV);
				map.put("DEC", DEC);
				 
				mapList.add(map);
			}
			
		} finally {
			close();
		}
		
		return mapList;
		
	}// end of List<HashMap<String, String>> getTotalOrderStatics()-----------------------


	// *** jsp_like 테이블에 insert 를 해주는 추상 메소드 *** //
	@Override
	public int insertLike(String userid, String pnum) throws SQLException {
		
		int n = 0;
		
		try {
			conn = ds.getConnection();
			
			String sql = " delete from jsp_dislike "
					   + " where userid = ? and pnum = ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			pstmt.setString(2, pnum);
			pstmt.executeUpdate();
			
			sql = " insert into jsp_like(userid, pnum) "
			    + " values(?, ?) ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			pstmt.setString(2, pnum);
			n = pstmt.executeUpdate();
			
		} finally {
			close();
		}
		
		return n;
		
	}// end of insertLike(String userid, int pnum)----------------------


	// *** jsp_dislike 테이블에 insert 를 해주는 추상 메소드 *** //
	@Override
	public int insertDisLike(String userid, String pnum) throws SQLException {

		int n = 0;
		
		try {
			conn = ds.getConnection();
			
			String sql = " delete from jsp_like "
					   + " where userid = ? and pnum = ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			pstmt.setString(2, pnum);
			pstmt.executeUpdate();
			
			sql = " insert into jsp_dislike(userid, pnum) "
			    + " values(?, ?) ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			pstmt.setString(2, pnum);
			n = pstmt.executeUpdate();
	
		} finally {
			close();
		}

		return n;
		
	}// end of insertDisLike(String userid, int pnum)----------------------


	
	// *** jsp_like, jsp_dislike 테이블에서 특정 제품의 count(*)를 조회하는 추상 메소드 *** //
	@Override
	public HashMap<String, String> getLikeDislikeCount(String pnum) throws SQLException {
		
		HashMap<String, String> map = null;
		
		try {
			
			conn = ds.getConnection();
		    // 객체 ds 를 통해 아파치톰캣이 제공하는 DBCP(DB Connection pool)에서 생성된 커넥션을 빌려온다.
			
			String sql = "SELECT " 
					   + "  ( SELECT COUNT(*) FROM jsp_like WHERE pnum = ? " 
					   + "  ) AS LIKECNT, " 
					   + "  ( SELECT COUNT(*) FROM jsp_dislike WHERE pnum = ? " 
					   + "  ) AS DISLIKECNT " 
					   + "FROM dual";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, pnum);
			pstmt.setString(2, pnum);
					
			rs = pstmt.executeQuery();
			
			rs.next();
				
			String likecnt = rs.getString("LIKECNT");
			String dislikecnt = rs.getString("DISLIKECNT");
						
			map = new HashMap<String, String>();
			
			map.put("likecnt", likecnt);
			map.put("dislikecnt", dislikecnt);
				 			
		} finally {
			close();
		}
		
		return map;
		
	}// end of getLikeDislikeCount(String pnum)----------------------------------------


	// *** 모든 제품에 대한 좋아요와 싫어요를 차트로 보여주는 추상 메소드 *** //
	@Override
	public List<HashMap<String, String>> getAllProductsLikeDisLikeStatics() throws SQLException {
		
		List<HashMap<String, String>> mapList = null;
		
		try {
			
			conn = ds.getConnection();
		    // 객체 ds 를 통해 아파치톰캣이 제공하는 DBCP(DB Connection pool)에서 생성된 커넥션을 빌려온다.
			
			String sql = "SELECT A.pname AS PNAME, " 
					+"  SUM( " 
					+"  CASE NVL(B.userid, '0') " 
					+"    WHEN '0' " 
					+"    THEN 0 " 
					+"    ELSE 1 " 
					+"  END) AS LIKECNT, " 
					+"  SUM( " 
					+"  CASE NVL(C.userid, '0') " 
					+"    WHEN '0' " 
					+"    THEN 0 " 
					+"    ELSE 1 " 
					+"  END) AS DISLIKECNT " 
					+"FROM jsp_product A " 
					+"LEFT OUTER JOIN jsp_like B " 
					+"ON A.pnum = B.pnum " 
					+"LEFT OUTER JOIN jsp_dislike C " 
					+"ON A.pnum = C.pnum " 
					+"GROUP BY A.pname";
			
			pstmt = conn.prepareStatement(sql);
					
			rs = pstmt.executeQuery();
			
			int cnt = 0;
			while(rs.next()) {
				cnt++;
				if(cnt == 1) 
					mapList = new ArrayList<HashMap<String, String>>();
				
				String PNAME = rs.getString("PNAME");
				String LIKECNT = rs.getString("LIKECNT");
				String DISLIKECNT = rs.getString("DISLIKECNT");

				HashMap<String, String> map = new HashMap<String, String>();
				
				map.put("PNAME", PNAME);
				map.put("LIKECNT", LIKECNT);
				map.put("DISLIKECNT", DISLIKECNT);
				 
				mapList.add(map);
			}
			
		} finally {
			close();
		}
		
		return mapList;
		
	}// end of getAllProductsLikeDisLikeStatics()-----------------------------------------------


	// Ajax(XML, JSON)로 페이징 처리를 위한 작업 //
	// *** jsp_product 테이블에서 HIT 상품의 갯수를 조회해오는 추상 메소드 *** //
	@Override
	public int totalSpecCount(String pspec) throws SQLException {

		int n = 0;
		
		try {
			
			conn = ds.getConnection();
		    // 객체 ds 를 통해 아파치톰캣이 제공하는 DBCP(DB Connection pool)에서 생성된 커넥션을 빌려온다.
			
			String sql = " select count(*) AS CNT "
					   + " from jsp_product "
					   + " where pspec = ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, pspec);
					
			rs = pstmt.executeQuery();
			
			rs.next();
			
			n = rs.getInt("CNT");
			
		} finally {
			close();
		}
		

		return n;
		
	}// end of totalSpecCount(String pspec)


	
	// *** jsp_product 테이블에서 pspec(HIT, NEW, BEST) 에 해당하는 데이터중 3개 행만 조회해오는  추상 메소드 *** //
	@Override
	public List<ProductVO> getProductVOListByPspec(String pspec, int startRno, int endRno) throws SQLException {

		List<ProductVO> productList = null;
		
		try {
			
			conn = ds.getConnection();
		    // 객체 ds 를 통해 아파치톰캣이 제공하는 DBCP(DB Connection pool)에서 생성된 커넥션을 빌려온다.
			
			String sql = " select * "
					   + " from "
					   + " ( "
					   + "   select row_number() over(order by pnum DESC) AS rno, "
					   + "          pnum, pname, pcategory_fk, pcompany, "
					   + "          pimage1, pimage2, pqty, price, saleprice, "
					   + "          pspec, pcontent, point, pinputdate "
					   + "   from jsp_product "
					   + "   where pspec = ? "
					   + " ) V "
					   + " where rno between ? and ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, pspec);
			pstmt.setInt(2, startRno);
			pstmt.setInt(3, endRno);
					
			rs = pstmt.executeQuery();
			
			int cnt = 0;
			while(rs.next()) {
				
				cnt++;
				if(cnt==1)
					productList = new ArrayList<ProductVO>();
				
				int pnum = rs.getInt("pnum");
			    String pname	= rs.getString("pname");
			    String pcategory_fk = rs.getString("pcategory_fk");
			    String pcompany = rs.getString("pcompany");
			    String pimage1 = rs.getString("pimage1");
			    String pimage2 = rs.getString("pimage2");
			    int pqty = rs.getInt("pqty");
			    int price = rs.getInt("price");
			    int saleprice = rs.getInt("saleprice");
			    pspec = rs.getString("pspec");
			    String pcontent = rs.getString("pcontent");
			    int point = rs.getInt("point");
			    String pinputdate = rs.getString("pinputdate");	
			    
			    ProductVO pvo = new ProductVO(pnum, pname, pcategory_fk, pcompany, pimage1, pimage2, pqty, price, saleprice, pspec, pcontent, point, pinputdate);  
			    
			    productList.add(pvo);
			}
			
		} finally {
			close();
		}
				
		return productList;
		
	}// end of getProductVOListByPspec(String pspec, String startRno, String endRno)--------------------------
	

	// *** jsp_storemap 테이블의 모든 정보(위,경도)를 조회해주는 메소드 생성하기 *** //
	@Override
	public List<StoremapVO> getStoreMap() throws SQLException {
		List<StoremapVO> storemapList = null;
		
		try{
			conn = ds.getConnection();
			// DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			String sql = " select storeno, storeName, latitude, longitude, zindex, tel, addr, transport "
					   + " from jsp_storemap "
					   + " order by storeno ";
			
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			int cnt = 0;
			while(rs.next()) {
				cnt++;
				
				if(cnt==1)
					storemapList = new ArrayList<StoremapVO>();
				
				int storeno = rs.getInt("storeno");
				String storeName = rs.getString("storeName");
				double latitude = rs.getDouble("latitude");
				double longitude = rs.getDouble("longitude");
				int zindex = rs.getInt("zindex");
				String tel = rs.getString("tel");
				String addr = rs.getString("addr");
				String transport = rs.getString("transport");
								
				StoremapVO mapvo = new StoremapVO(storeno, storeName, latitude, longitude, zindex, tel, addr, transport);
				
				storemapList.add(mapvo);
				
			}// end of while---------------------
			
		 } finally{
			close();
		 }
		
		return storemapList;
		
	}// end of List<StoremapVO> getStoreMap()---------------------


	// *** 매장 상세 정보보기 메소드 생성하기 *** //
	@Override
	public List<HashMap<String, String>> getStoreDetail(String storeno) 
		throws SQLException {
		
		List<HashMap<String, String>> mapList = null;
		
		try{
			conn = ds.getConnection();
			// DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			String sql = " select storeno, storeName, tel, addr, transport "
					   + " from jsp_storemap  "
					   + " where storeno = ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, storeno);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				mapList = new ArrayList<HashMap<String, String>>();
				
				storeno = rs.getString("storeno");
				String storeName = rs.getString("storeName");
				String tel = rs.getString("tel");
				String addr = rs.getString("addr");
				String transport = rs.getString("transport");
								
				HashMap<String, String> map = new HashMap<String, String>();
				
				map.put("storeno", storeno);
				map.put("storeName", storeName);
				map.put("tel", tel);
				map.put("addr", addr);
				map.put("transport", transport);
				
				mapList.add(map);
				
			}// end of if---------------------
			
			sql =  " select img " 
                + " from jsp_storedetailImg "
                + " where fk_storeno = ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, storeno);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
					
				String img = rs.getString("img");
												
				HashMap<String, String> map = new HashMap<String, String>();
				
				map.put("img", img);
								
				mapList.add(map);
				
			}// end of while---------------------
			
		 } finally{
			close();
		 }
		
		return mapList;
		
	}// end of List<HashMap<String, String>> getStoreDetail()--------------------

	
}



