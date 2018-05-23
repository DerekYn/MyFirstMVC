package memo.model;

import member.model.MemberVO;

public class MemoVO {

  private int	 idx;        // 글번호(시퀀스로 입력)
  private String userid;     // 회원아이디
  private String name;       // 작성자이름
  private String msg;        // 메모내용
  private String writedate;  // 작성일자
  private String cip;        // 클라이언트 IP 주소
  private int status;        // 글삭제유무
  
  private MemberVO member;   // 글쓴이의 모든 정보 

  public MemoVO() { }
  // 기본생성자가 있어야만 자바규격서에 따른 자바빈으로 사용될 수 있다.
  
  public MemoVO(int idx, String userid, String name, String msg, String writedate, String cip, int status) {
		this.idx = idx;
		this.userid = userid;
		this.name = name;
		this.msg = msg;
		this.writedate = writedate;
		this.cip = cip;
		this.status = status;
	}
  
   public MemoVO(int idx, String userid, String name, String msg, String writedate, String cip, int status
		        ,MemberVO member) {
		this.idx = idx;
		this.userid = userid;
		this.name = name;
		this.msg = msg;
		this.writedate = writedate;
		this.cip = cip;
		this.status = status;
		this.member = member;
	}

    public MemberVO getMember() {
		return member;
	}
	
	public void setMember(MemberVO member) {
		this.member = member;
	}
   
	public int getIdx() {
		return idx;
	}
	
	public void setIdx(int idx) {
		this.idx = idx;
	}
	
	public String getUserid() {
		return userid;
	}
	
	public void setUserid(String userid) {
		this.userid = userid;
	}
	
	public String getIrum() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getMsg() {
		return msg;
	}
	
	public void setMsg(String msg) {
		this.msg = msg;
	}
	
	public String getWritedate() {
		return writedate;
	}
	
	public void setWritedate(String writedate) {
		this.writedate = writedate;
	}
	
	public String getCip() {
		return cip;
	}
	
	public void setCip(String cip) {
		this.cip = cip;
	}
	
	public int getStatus() {
		return status;
	}
	
	public void setStatus(int status) {
		this.status = status;
	}
  
}
