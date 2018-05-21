package ajax.model;

public class BookVO {
	
	private String subject;
	private String title;
	private String author;
	private String registerday;
	

	
	public BookVO() { }
	
	public BookVO(String subject, String title, String author, String registerday) {
		this.subject = subject;
		this.title = title;
		this.author = author;
		this.registerday = registerday;
	}

	
	
	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public String getRegisterday() {
		return registerday;
	}

	public void setRegisterday(String registerday) {
		this.registerday = registerday;
	}
	
	
}
