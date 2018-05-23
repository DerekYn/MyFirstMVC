package memo.model;

import java.sql.*;
import java.util.*;

import javax.naming.*;
import javax.sql.DataSource;

import member.model.MemberVO;

/*
 ==> 아파치 톰캣이 제공하는 DBCP(DB Connection Pool)를 이용하여
     MemoDAO 클래스를 생성한다.  
 */

public class MemoDAO implements InterMemoDAO {

	private DataSource ds = null;
	// 객체변수 ds 는 아파치 톰캣이 제공하는 DBCP(DB Connection Pool)이다.
	
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	/* === MemoDAO 생성자에서 해야할 일은 ===
	     아파치 톰캣이 제공하는 DBCP(DB Connection Pool) 객체인 ds 를 얻어오는 것이다.
	*/
	public MemoDAO() {
		
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


	// *** 메모쓰기 메소드 생성하기 *** //
	@Override
	public int memoInsert(MemoVO memovo) 
		throws SQLException {
		
		int result = 0;
		
		try {	
			MemberVO membervo = getMemberOneByUserid(memovo.getUserid());
			System.out.println("==> 확인용 membervo : " + membervo);
			
			if(membervo == null) {
				return result;
			}
			
			conn = ds.getConnection();
			// DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			String sql = " insert into jsp_memo(idx, userid, name, msg, writedate, cip, status) "   
					   + " values(jsp_memo_idx.nextval, ?, ?, ?, default, ?, default) "; 
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, memovo.getUserid());
			pstmt.setString(2, membervo.getName());
			pstmt.setString(3, memovo.getMsg());
			pstmt.setString(4, memovo.getCip());
			
			result = pstmt.executeUpdate();
			
		} finally {
			close();
		}
		
		return result;
	}// end of memoInsert(MemoVO memovo)-------------
	

	// *** 회원 1명에 대한 정보를 보여주는 메소드 생성하기 *** //
	@Override
	public MemberVO getMemberOneByUserid(String userid) 
		throws SQLException {
		
		MemberVO mvo = null;
		
		try {
			 conn = ds.getConnection();
			 // DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			 String sql = " select idx, userid, name, pwd, email, hp1, hp2, hp3, post1, post2, addr1, addr2 "
		               +	"      , to_char(registerday, 'yyyy-mm-dd') as registerday "
				 	   +	"      , status "
		               +	" from jsp_member "
					   +    " where userid = ? ";
			
			 pstmt = conn.prepareStatement(sql);
			 pstmt.setString(1, userid);
			
			 rs = pstmt.executeQuery();
			
			 boolean isExists = rs.next();
			
			 if(isExists) {
				int idx = rs.getInt("idx");
				userid = rs.getString("userid");
				String name = rs.getString("name");
				String pwd = rs.getString("pwd");
				String email = rs.getString("email");
				String hp1 = rs.getString("hp1");
				String hp2 = rs.getString("hp2");
				String hp3 = rs.getString("hp3");
				String post1 = rs.getString("post1");
				String post2 = rs.getString("post2");
				String addr1 = rs.getString("addr1");
				String addr2 = rs.getString("addr2");
				String registerday = rs.getString("registerday");
				int status = rs.getInt("status");
				
				mvo = new MemberVO(idx, userid, name, pwd, email, hp1, hp2, hp3, post1, post2, addr1, addr2, registerday, status);	
			}
			
		} finally {
			close();
		}
		
		return mvo;
	}// end of getMemberOneByUserid(String userid)-------------	


	// *** 메모전체조회 메소드 생성하기 *** //
	@Override
	public List<HashMap<String, String>> getAllMemo() 
		throws SQLException {
		
		List<HashMap<String, String>> memoList = null;
		
		try {
			 conn = ds.getConnection();
			 // DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			 String sql = " select A.idx, A.msg "
		               +  "      , to_char(A.writedate, 'yyyy-mm-dd hh24:mi:ss') AS WRITEDATE "
				 	   +  "      , A.cip, B.name "
				 	   +  "      , case B.gender when '1' then '남' else '여' end AS GENDER "
				 	   +  "      , extract(year from sysdate) - to_number(substr(birthday, 1, 4)) + 1 AS AGE "
				 	   +  "      , B.email "
		               +  "	from jsp_memo A join jsp_member B "
					   +  " on A.userid = B.userid "
					   +  " where A.status = 1 "
					   +  " order by A.idx desc ";
			 
			 pstmt = conn.prepareStatement(sql);
			 
			 rs = pstmt.executeQuery();
			
			 int cnt = 0;
			 while(rs.next()) {
				 cnt++;
				 
				 if(cnt==1)
					 memoList = new ArrayList<HashMap<String, String>>(); 
				 
				 String idx = rs.getString("IDX");
				 String msg = rs.getString("MSG");
				 String writedate = rs.getString("WRITEDATE");
				 String cip = rs.getString("CIP");
				 String name = rs.getString("NAME");
				 String gender = rs.getString("GENDER");
				 String age = rs.getString("AGE");
				 String email = rs.getString("EMAIL");
				 
				 HashMap<String, String> map = new HashMap<String, String>();
				 
				 map.put("idx", idx);
				 map.put("msg", msg);
				 map.put("writedate", writedate);
				 map.put("cip", cip);
				 map.put("name", name);
				 map.put("gender", gender);
				 map.put("age", age);
				 map.put("email", email);
				 
				 memoList.add(map);
				 
			 }// end of while-----------------------
			
		} finally {
			close();
		}
		
		return memoList;
	}// end of getAllMemo()-------------------


	// *** 메모전체조회 메소드 생성하기 *** //
	@Override
	public List<MemoVO> getAllMemoVO() 
		throws SQLException {

		List<MemoVO> memoList = null;
		
		try {
			 conn = ds.getConnection();
			 // DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			 String sql = " select A.idx, A.msg "
		               +  "      , to_char(A.writedate, 'yyyy-mm-dd hh24:mi:ss') AS WRITEDATE "
				 	   +  "      , A.cip, B.name, B.gender, B.birthday, B.email, A.status "
		               +  "	from jsp_memo A join jsp_member B "
					   +  " on A.userid = B.userid "
				//	   +  " where A.status = 1 "
					   +  " order by A.idx desc ";
			 
			 pstmt = conn.prepareStatement(sql);
			 
			 rs = pstmt.executeQuery();
			
			 int cnt = 0;
			 while(rs.next()) {
				 cnt++;
				 
				 if(cnt==1)
					 memoList = new ArrayList<MemoVO>(); 
				 
				 int idx = rs.getInt("IDX");
				 String msg = rs.getString("MSG");
				 String writedate = rs.getString("WRITEDATE");
				 String cip = rs.getString("CIP");
				 String name = rs.getString("NAME");
				 String gender = rs.getString("GENDER"); // "1" or "2"
				 String birthday = rs.getString("BIRTHDAY");
				 String email = rs.getString("EMAIL");
				 int status = rs.getInt("STATUS");
				 
				 MemoVO memovo = new MemoVO();
				 
				 memovo.setIdx(idx);
				 memovo.setMsg(msg);
				 memovo.setWritedate(writedate);
				 memovo.setCip(cip);
				 memovo.setName(name);
				 memovo.setStatus(status);
				 
				 MemberVO member = new MemberVO();
				 member.setEmail(email);
				 member.setGender(gender); // "1" or "2"
				 member.setBirthday(birthday);
				 
				 memovo.setMember(member);
				 
				 memoList.add(memovo);
				 
			 }// end of while-----------------------
			
		} finally {
			close();
		}
		
		return memoList;		

	}// end of List<MemoVO> getAllMemoVO()-----------


	// *** 메모전체갯수 조회 메소드 생성하기 *** //
	@Override
	public int getTotalCountMemo() 
		throws SQLException {

		int cnt = 0;
		
		try {
			 conn = ds.getConnection();
			 // DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			 String sql = " select count(*) AS CNT "
		               +  "	from jsp_memo "
					   +  " where status = 1 ";
			 
			 pstmt = conn.prepareStatement(sql);
			 
			 rs = pstmt.executeQuery();
			 
			 rs.next();
			 
			 cnt = rs.getInt("CNT");
			 
		} finally {
			close();
		}
		
		return cnt;
	}// end of getTotalCountMemo()----------------------

	
	// *** 메모전체갯수 조회 메소드 생성하기 *** //
	@Override
	public int getTotalCountMemoVO() 
		throws SQLException {

		int cnt = 0;
		
		try {
			 conn = ds.getConnection();
			 // DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			 String sql = " select count(*) AS CNT "
		               +  "	from jsp_memo ";
				  //   +  " where status = 1 ";
			 
			 pstmt = conn.prepareStatement(sql);
			 
			 rs = pstmt.executeQuery();
			 
			 rs.next();
			 
			 cnt = rs.getInt("CNT");
			 
		} finally {
			close();
		}
		
		return cnt;
	}// end of getTotalCountMemoVO()----------------------
	

	// *** 페이징 처리한 데이터 조회 메소드 생성하기 *** //
	@Override
	public List<HashMap<String, String>> getAllMemo(int currentShowPageNo, int sizePerPage) 
		throws SQLException {
		
		List<HashMap<String, String>> memoList = null;
		
		try {
			 conn = ds.getConnection();
			 // DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			 String sql = " select idx, msg, writedate, cip, name, gender, age, email " 
		               +  " from "
				 	   +  " ( "
				 	   +  "  select rownum as RNO "
				 	   +  "       , idx, msg, writedate, cip, name, gender, age, email "
				 	   +  "  from "
				 	   +  "  (  "
		               +  "	   select A.idx, A.msg "
		               +  "         , to_char(A.writedate, 'yyyy-mm-dd hh24:mi:ss') AS WRITEDATE "
		               +  "         , A.cip, B.name "
		               +  "         , case B.gender when '1' then '남' else '여' end AS GENDER "
		               +  "         , extract(year from sysdate) - to_number(substr(birthday, 1, 4)) + 1 AS AGE "
		               +  "         , B.email "
					   +  "    from jsp_memo A join jsp_member B "
					   +  "    on A.userid = B.userid "
					   +  "    where A.status = 1 "
					   +  "    order by A.idx desc "
					   +  "  ) V "
					   +  " ) T "
					   +  " where T.RNO between ? and ? ";
			 
			 pstmt = conn.prepareStatement(sql);
			 pstmt.setInt(1, (currentShowPageNo*sizePerPage)-(sizePerPage-1) ); // 공식
			 pstmt.setInt(2, (currentShowPageNo*sizePerPage) ); // 공식
			 
			 rs = pstmt.executeQuery();
			
			 int cnt = 0;
			 while(rs.next()) {
				 cnt++;
				 
				 if(cnt==1)
					 memoList = new ArrayList<HashMap<String, String>>(); 
				 
				 String idx = rs.getString("IDX");
				 String msg = rs.getString("MSG");
				 String writedate = rs.getString("WRITEDATE");
				 String cip = rs.getString("CIP");
				 String name = rs.getString("NAME");
				 String gender = rs.getString("GENDER");
				 String age = rs.getString("AGE");
				 String email = rs.getString("EMAIL");
				 
				 HashMap<String, String> map = new HashMap<String, String>();
				 
				 map.put("idx", idx);
				 map.put("msg", msg);
				 map.put("writedate", writedate);
				 map.put("cip", cip);
				 map.put("name", name);
				 map.put("gender", gender);
				 map.put("age", age);
				 map.put("email", email);
				 
				 memoList.add(map);
				 
			 }// end of while-----------------------
			
		} finally {
			close();
		}		
		
		return memoList;
	}// end of getAllMemo(int currentShowPageNo, int sizePerPage)-------------
	

	// *** 페이징 처리한 데이터 조회 메소드 생성하기 *** //
	@Override
	public List<MemoVO> getAllMemoVO(int currentShowPageNo, int sizePerPage) 
		throws SQLException {

		List<MemoVO> memoList = null;
		
		try {
			 conn = ds.getConnection();
			 // DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			 String sql = " select idx, msg, writedate, cip, name, gender, birthday, email, status " 
		               +  " from "
				 	   +  " ( "
				 	   +  "  select rownum as RNO "
				 	   +  "       , idx, msg, writedate, cip, name, gender, birthday, email, status "
				 	   +  "  from "
				 	   +  "  (  "
		               +  "	   select A.idx, A.msg "
		               +  "         , to_char(A.writedate, 'yyyy-mm-dd hh24:mi:ss') AS WRITEDATE "
		               +  "         , A.cip, B.name, B.gender, B.birthday, B.email, A.status "
					   +  "    from jsp_memo A join jsp_member B "
					   +  "    on A.userid = B.userid "
					// +  "    where A.status = 1 "
					   +  "    order by A.idx desc "
					   +  "  ) V "
					   +  " ) T "
					   +  " where T.RNO between ? and ? ";
			 
			 pstmt = conn.prepareStatement(sql);
			 pstmt.setInt(1, (currentShowPageNo*sizePerPage)-(sizePerPage-1) ); // 공식
			 pstmt.setInt(2, (currentShowPageNo*sizePerPage) ); // 공식
			 
			 rs = pstmt.executeQuery();
			
			 int cnt = 0;
			 while(rs.next()) {
				 cnt++;
				 
				 if(cnt==1)
					 memoList = new ArrayList<MemoVO>(); 
				 
				 int idx = rs.getInt("IDX");
				 String msg = rs.getString("MSG");
				 String writedate = rs.getString("WRITEDATE");
				 String cip = rs.getString("CIP");
				 String name = rs.getString("NAME");
				 String gender = rs.getString("GENDER"); // "1" or "2"
				 String birthday = rs.getString("BIRTHDAY");
				 String email = rs.getString("EMAIL");
				 int status = rs.getInt("STATUS");
				 
				 MemoVO memovo = new MemoVO();
				 
				 memovo.setIdx(idx);
				 memovo.setMsg(msg);
				 memovo.setWritedate(writedate);
				 memovo.setCip(cip);
				 memovo.setName(name);
				 memovo.setStatus(status);
				 
				 MemberVO member = new MemberVO();
				 member.setEmail(email);
				 member.setGender(gender); // "1" or "2"
				 member.setBirthday(birthday);
				 
				 memovo.setMember(member);
				 
				 memoList.add(memovo);
				 
			 }// end of while-----------------------
			
		} finally {
			close();
		}
		
		return memoList;		

	}// end of List<MemoVO> getAllMemoVO(int currentShowPageNo, int sizePerPage)-----------	


	// *** 메모를 삭제(update)하는 메소드 생성하기 *** //
	@Override
	public int deleteMemo(String str) 
		throws SQLException {
		
		int result = 0;
		
		try {	
			conn = ds.getConnection();
			// DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			String sql = " update jsp_memo set status = 0 "
					   + " where idx in (" + str +")"; 
			
			pstmt = conn.prepareStatement(sql);
			
			result = pstmt.executeUpdate();
			
		} finally {
			close();
		}		
		
		return result;
	}// end of deleteMemo(String str)-----------------


	// *** 메모를 복구(update)하는 메소드 생성하기 *** //
	@Override
	public int recoveryMemo(String str) 
		throws SQLException {
		
		int result = 0;
		
		try {	
			conn = ds.getConnection();
			// DBCP객체 ds를 통해 context.xml에서 이미 설정된 Connection 객체를 빌려오는 것이다.
			
			String sql = " update jsp_memo set status = 1 "
					   + " where idx in (" + str +")"; 
			
			pstmt = conn.prepareStatement(sql);
			
			result = pstmt.executeUpdate();
			
		} finally {
			close();
		}		
		
		return result;
	}// end of recoveryMemo(String str)---------------

	
	
	
}





