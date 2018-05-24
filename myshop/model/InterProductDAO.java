package myshop.model;

import java.sql.SQLException;
import java.util.*;

public interface InterProductDAO {

	// *** jsp_product 테이블에서 pspec 컬럼의 값(HIT, NEW, BEST) 별로 상품 목록을 가져오는 추상 메소드 *** // 
	List<ProductVO> selectByPspec(String pspec) throws SQLException; 
	
	// *** jsp_product 테이블에서 제품1개 정보만 출력해주는 추상 메소드 *** //
	ProductVO getProductOneByPnum(String pnum) throws SQLException;

	// *** jsp_product_imagefile 테이블에서 복수개 이미지 파일을 출력해주는 추상 메소드 *** //
	List<ProductImagefileVO> getProductImagefileByPnum(String pnum) throws SQLException; 
	
	// *** jsp_cart 테이블(장바구니 테이블)에 물건을 입력해주는 추상 메소드 *** // 
	int addCart(String userid, String pnum, String oqty) throws SQLException;
	
	// *** jsp_cart 테이블(장바구니 테이블)을 조회해주는 추상 메소드 *** //
	List<CartVO> getCartList(String userid) throws SQLException;
	
	// *** jsp_cart 테이블(장바구니 테이블)에 수량 변경해주는 추상 메소드 *** //
	int editCart(String oqty, String cartno) throws SQLException;
	
	// *** jsp_cart 테이블(장바구니 테이블) 페이징 처리해서 데이터를 가져오는  추상 메소드 *** //
	List<CartVO> getCartList(String userid, int currentShowPageNo, int sizePerPage) throws SQLException; 
	
	// *** userid 별 장바구니 전체갯수 조회 추상메소드  *** //
	int getTotalCartCount(String userid) throws SQLException; 
	
	// *** 장바구니에서 특정 제품 삭제하기전 
	//     해당 장바구니 번호의 소유주(userid)가 누구인지를 알려주는 추상 메소드 *** //   
	String getUseridByCartno(String cartno) throws SQLException;
	
	// *** 장바구니에서 특정 제품 삭제하는 추상 메소드 *** // 
	int deleteCartno(String cartno) throws SQLException;
	
	// *** jsp_category 테이블에서 카테고리코드(code)와 카테고리명(cname)을 가져오는 추상 메소드 *** //
	List<CategoryVO> getCategoryList() throws SQLException; 

	// *** jsp_product 테이블에서 카테고리코드(pcategory_fk)별로 제품목록을 조회해주는 추상 메소드 *** //
	List<ProductVO> getProductsByCategory(String code) throws SQLException;
	
 	// *** 주문코드(명세서 번호) 시퀀스 값 따오는 추상 메소드 *** //
 	int getSeq_jsp_order() throws SQLException;
 	
 	// *** 주문하기 추상 매소드 *** //
    /*
     ==== *** Transaction 처리하기 *** ====
     1. 주문개요 테이블(jsp_order)에 입력(insert)
     2. 주문상세 테이블(jsp_order_detail)에 입력(insert) 
     3. 구매하는 사용자의 coin 컬럼의 값을 구매한 가격만큼 감하고,
        point 컬럼의 값은 구매한 포인트만큼 증가하며(update),
     4. 주문한 제품의 잔고량은 주문량 만큼 감해야 하고(update),
     5. 장바구니에서 주문을 한 것이라면 장바구니 비우기(status 컬럼을 0 으로 변경하는 update) 
               를 해주는 DAO에서 만든 메소드 호출하기        
     */
    int add_Order_OrderDetail(String odrcode, String userid, int sumtotalprice, int sumtotalpoint, String[] pnumArr, String[] oqtyArr, String[] salepriceArr, String[] cartnoArr) throws SQLException;
	
    
    // *** 제품번호들에 해당하는 제품목록을 조회해오는 추상 메소드 *** //
    List<ProductVO> getOrderFinishProductList(String pnumes) throws SQLException;
    
    // *** userid 별 주문내역 전체갯수 조회 추상메소드  *** //
    int getTotalCountOrder(String userid) throws SQLException;
    
    // *** 모든회원 주문내역 전체갯수 조회 추상메소드  *** //
    int getTotalCountOrder() throws SQLException;
    
    // *** 페이징 처리한 회원별 주문 데이터 조회 추상 메소드 *** //
    List<HashMap<String, String>> getAllOrder(String userid, int currentShowPageNo, int sizePerPage) throws SQLException;
    
    // *** 페이징 처리한 모든 회원 주문 데이터 조회 추상 메소드 *** //
    List<HashMap<String, String>> getAllOrder(int currentShowPageNo, int sizePerPage) throws SQLException;
    
    // *** 배송시작으로 해주는 추상 메소드 *** //
 	int updateDeliverStart(String odrcodePnum, int length) throws SQLException;
 	
 	// *** 배송완료로 해주는 추상 메소드 *** //
 	int updateDeliverEnd(String odrcodePnum, int length) throws SQLException;
    
 	// *** jsp_product 테이블에 신규제품으로 insert 되어질 제품번호 시퀀스 seq_jsp_product_pnum.nextval 을 따오는 추상 메소드 *** //
 	int getPnumOfProduct() throws SQLException;
 	
 	
 	// *** 제품등록(신규상품등록)을 해주는 추상 메소드 *** //
 	int productInsert(ProductVO pvo) throws SQLException;
 	
 	// *** 제품등록(신규상품등록)시 추가이미지 파일정보를 jsp_product_imagefile 테이블에 insert 추상 메소드 *** //
 	void product_imagefile_Insert(int pnum, String attachFilename) throws SQLException;
 	
 	// *** 로그인한 사용자의 구매통계 현황을 조회해주는 추상 메소드 *** //
 	List<HashMap<String, String>> getMyOrderStatics(String userid) throws SQLException;
 	
 	// *** 제품 카테고리별 월별 판매 통계 현황을 조회해주는 추상 메소드 *** //
	List<HashMap<String, String>> getTotalOrderStatics() throws SQLException;

	// *** jsp_like 테이블에 insert 를 해주는 추상 메소드 *** //
	int insertLike(String userid, String pnum) throws SQLException;
	
	// *** jsp_dislike 테이블에 insert 를 해주는 추상 메소드 *** //
	int insertDisLike(String userid, String pnum) throws SQLException;
	
	// *** jsp_like, jsp_dislike 테이블에서 특정 제품의 count(*)를 조회하는 추상 메소드 *** //
	HashMap<String, String> getLikeDislikeCount(String pnum) throws SQLException;
	
	// *** 모든 제품에 대한 좋아요와 싫어요를 차트로 보여주는 추상 메소드 *** //
	List<HashMap<String, String>> getAllProductsLikeDisLikeStatics() throws SQLException;

	// *** jsp_product 테이블에서 HIT 상품의 갯수를 조회해오는 추상 메소드 *** //
	int totalSpecCount(String pspec) throws SQLException;
	
	// *** jsp_product 테이블에서 pspec(HIT, NEW, BEST) 에 해당하는 데이터중 3개 행만 조회해오는  추상 메소드 *** //
	List<ProductVO> getProductVOListByPspec(String pspec, int startRno, int endRno) throws SQLException;
	
	// *** jsp_storemap 테이블의 모든 정보(위,경도)를 조회해주는 추상 메소드 *** //
	List<StoremapVO> getStoreMap() throws SQLException;
		
	// *** 매장 상세 정보보기 추상메소드 *** //
	List<HashMap<String,String>> getStoreDetail(String storeno) throws SQLException;

}



