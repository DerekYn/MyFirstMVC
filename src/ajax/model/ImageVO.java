package ajax.model;

public class ImageVO {

	private String userid;
	private String name;
	private String img;
	
	
	
	public ImageVO() {}
	
	public ImageVO(String userid, String name, String img) {
		this.userid = userid;
		this.name = name;
		this.img = img;
	}

	
	
	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getImg() {
		return img;
	}

	public void setImg(String img) {
		this.img = img;
	}
	
}
