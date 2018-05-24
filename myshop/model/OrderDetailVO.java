package myshop.model;

public class OrderDetailVO {
	
	
	
	private int odrseqnum;      // -- 주문상세 일련번호
	private String fk_odrcode;  // 주문코드(명세서 번호)
	private int fk_pnum;		// 제품번호
	private int oqty;           //  주문량
	private int odrprice;       // "주문할 당시의 가격의 실제가격" ==> insert 시 jsp_product 테이블에서 해당제품의 saleprice 컬럼값을 읽어 넣어주어야 한다.
	private String deliverStatus;  // 배송상태( 1 : 주문만 받음. 2 : 배송시작, 3 : 배송완료)
	private String deliverDate; // 배송 완료 일자   default 는 null 로 함.
	
	private ProductVO item;		// 제품객체
	private OrderVO odrcode;	// 주문개요 객체
	
	
	public OrderDetailVO() { }
	
	public OrderDetailVO(int odrseqnum, String fk_odrcode, int fk_pnum, int oqty, int odrprice, String deliverStatus,
			String deliverDate, ProductVO item, OrderVO odrcode) {
		this.odrseqnum = odrseqnum;
		this.fk_odrcode = fk_odrcode;
		this.fk_pnum = fk_pnum;
		this.oqty = oqty;
		this.odrprice = odrprice;
		this.deliverStatus = deliverStatus;
		this.deliverDate = deliverDate;
		this.item = item;
		this.odrcode = odrcode;
	}

	public int getOdrseqnum() {
		return odrseqnum;
	}

	public void setOdrseqnum(int odrseqnum) {
		this.odrseqnum = odrseqnum;
	}

	public String getFk_odrcode() {
		return fk_odrcode;
	}

	public void setFk_odrcode(String fk_odrcode) {
		this.fk_odrcode = fk_odrcode;
	}

	public int getFk_pnum() {
		return fk_pnum;
	}

	public void setFk_pnum(int fk_pnum) {
		this.fk_pnum = fk_pnum;
	}

	public int getOqty() {
		return oqty;
	}

	public void setOqty(int oqty) {
		this.oqty = oqty;
	}

	public int getOdrprice() {
		return odrprice;
	}

	public void setOdrprice(int odrprice) {
		this.odrprice = odrprice;
	}

	public String getDeliverStatus() {
		return deliverStatus;
	}

	public void setDeliverStatus(String deliverStatus) {
		this.deliverStatus = deliverStatus;
	}

	public String getDeliverDate() {
		return deliverDate;
	}

	public void setDeliverDate(String deliverDate) {
		this.deliverDate = deliverDate;
	}

	public ProductVO getItem() {
		return item;
	}

	public void setItem(ProductVO item) {
		this.item = item;
	}

	public OrderVO getOdrcode() {
		return odrcode;
	}

	public void setOdrcode(OrderVO odrcode) {
		this.odrcode = odrcode;
	}
	
	
	

}
