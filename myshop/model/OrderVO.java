package myshop.model;

public class OrderVO {
	
	private String odrcode;       // 주문코드(명세서번호)  주문코드 형식 : s + 날짜 + sequence
								  // ==> s20180430-1, s20180430-2, s20180430-3
	private String fk_userid;     // 사용자 ID
	private int odrtotalPrice;    // 주문 총액
	private int odrtotalPoint;    // 주문 총포인트
	private String odrdate;		  // 주문일자
	
	
	public OrderVO() { }
	
	public OrderVO(String odrcode, String fk_userid, int odrtotalPrice, int odrtotalPoint, String odrdate) {
		this.odrcode = odrcode;
		this.fk_userid = fk_userid;
		this.odrtotalPrice = odrtotalPrice;
		this.odrtotalPoint = odrtotalPoint;
		this.odrdate = odrdate;
	}

	public String getOdrcode() {
		return odrcode;
	}

	public void setOdrcode(String odrcode) {
		this.odrcode = odrcode;
	}

	public String getFk_userid() {
		return fk_userid;
	}

	public void setFk_userid(String fk_userid) {
		this.fk_userid = fk_userid;
	}

	public int getOdrtotalPrice() {
		return odrtotalPrice;
	}

	public void setOdrtotalPrice(int odrtotalPrice) {
		this.odrtotalPrice = odrtotalPrice;
	}

	public int getOdrtotalPoint() {
		return odrtotalPoint;
	}

	public void setOdrtotalPoint(int odrtotalPoint) {
		this.odrtotalPoint = odrtotalPoint;
	}

	public String getOdrdate() {
		return odrdate;
	}

	public void setOdrdate(String odrdate) {
		this.odrdate = odrdate;
	}
	

}
