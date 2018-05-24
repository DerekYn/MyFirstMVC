package myshop.model;

public class CartVO {

	private int cartno;     // 장바구니번호
	private String userid;  // 사용자ID
	private int pnum;       // 제품번호
	private int oqty;       // 주문량
	private int status;     // 삭제유무
	
	private ProductVO item; // 제품정보객체

	public CartVO() { } // 기본생성자  -- 그래야만 자바빈규격서에 따른 자바빈을 사용할 수 있다.
	
	public CartVO(int cartno, String userid, int pnum, int oqty, int status, ProductVO item) {
		this.cartno = cartno;
		this.userid = userid;
		this.pnum = pnum;
		this.oqty = oqty;
		this.status = status;
		this.item = item;
	}

	public int getCartno() {
		return cartno;
	}

	public void setCartno(int cartno) {
		this.cartno = cartno;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public int getPnum() {
		return pnum;
	}

	public void setPnum(int pnum) {
		this.pnum = pnum;
	}

	public int getOqty() {
		return oqty;
	}

	public void setOqty(int oqty) {
		this.oqty = oqty;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public ProductVO getItem() {
		return item;
	}

	public void setItem(ProductVO item) {
		this.item = item;
	}
	
}
