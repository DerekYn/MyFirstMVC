package myshop.model;

public class ProductImagefileVO {

	private int imgfileno;      // 시퀀스로 입력받음
	private int fk_pnum;        // 제품번호(foreign key)
	private String imgfilename; // 제품이미지파일명
	
	public ProductImagefileVO() { }
	
	public ProductImagefileVO(int imgfileno, int fk_pnum, String imgfilename) {
		this.imgfileno = imgfileno;
		this.fk_pnum = fk_pnum;
		this.imgfilename = imgfilename;
	}

	public int getImgfileno() {
		return imgfileno;
	}

	public void setImgfileno(int imgfileno) {
		this.imgfileno = imgfileno;
	}

	public int getFk_pnum() {
		return fk_pnum;
	}

	public void setFk_pnum(int fk_pnum) {
		this.fk_pnum = fk_pnum;
	}

	public String getImgfilename() {
		return imgfilename;
	}

	public void setImgfilename(String imgfilename) {
		this.imgfilename = imgfilename;
	}
	
	
}
