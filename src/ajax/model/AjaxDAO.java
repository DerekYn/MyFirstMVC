package ajax.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/*
==> 아파치 톰캣이 제공하는 DBCP(DB Connection Pool)를 이용하여
    AjaxDAO 클래스를 생성한다.  
*/

public class AjaxDAO implements InterAjaxDAO {
	
	private DataSource ds = null;
	// 객체변수 ds 는 아파치 톰캣이 제공하는 DBCP(DB Connection Pool)이다.
	
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	/* === MemberDAO 생성자에서 해야할 일은 ===
	     아파치 톰캣이 제공하는 DBCP(DB Connection Pool) 객체인 ds 를 얻어오는 것이다.
	*/
	
	public AjaxDAO() {
		
		try {
			Context initContext = new InitialContext();
			Context envContext  = (Context)initContext.lookup("java:/comp/env");
			ds = (DataSource)envContext.lookup("jdbc/myoracle");
		} catch(NamingException e) {
			e.printStackTrace();
		}
		
	}// end of AjaxDAO() 생성자------------------
	
	
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


	
	// *** tbl_images 테이블의 모든 행을 조회하는 추상 메소드 *** //
	@Override
	public List<ImageVO> getTblImages() throws SQLException {
		
		List<ImageVO> imgList = null;
		
		try {
			conn = ds.getConnection();
			
			String sql = " select userid, name, img "
					   + " from tbl_images ";
			
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			int cnt = 0;
			while(rs.next()) {
				
				cnt++;
				if(cnt==1) 
					imgList = new ArrayList<ImageVO>();
				
				String userid = rs.getString("userid");
				String name = rs.getString("name");
				String img = rs.getString("img");
				
				ImageVO imgvo = new ImageVO();
				imgvo.setUserid(userid);
				imgvo.setName(name);
				imgvo.setImg(img);
				
				imgList.add(imgvo);
				
			}// end of while()-----------------------------------
			
		} finally {
			close();
		}
		
		return imgList;
		
	}// List<ImageVO> getTblImages()--------------------------------------------

	
	// *** tbl_ajaxnews 테이블에 입력된 데이터 중 오늘 날짜에 해당하는 행만 추출(select)하는 추상메소드 *** //
	@Override
	public List<TodayNewsVO> getNewsTitleList() throws SQLException {
		
		List<TodayNewsVO> todayNewsList = null;
		
		try {
			conn = ds.getConnection();
			
			String sql = " select seqtitleno, " 
					   + "        case when length(title) > 22 then substr(title, 1, 20)||'..' " 
					   + "             else title end as title, " 
					   + "        to_char(registerday, 'yyyy-mm-dd') as registerday "
					   + " from tbl_ajaxnews "
					   + " where to_char(registerday, 'yyyy-mm-dd') = to_char(sysdate, 'yyyy-mm-dd') ";
			
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			int cnt = 0;
			while(rs.next()) {
				
				cnt++;
				if(cnt==1) 
					todayNewsList = new ArrayList<TodayNewsVO>();
				
				int seqtitleno = rs.getInt("seqtitleno");
				String title = rs.getString("title");
				String registerday = rs.getString("registerday");
				
				TodayNewsVO todaynewsvo = new TodayNewsVO();
				todaynewsvo.setSeqtitleno(seqtitleno);
				todaynewsvo.setTitle(title);
				todaynewsvo.setRegisterday(registerday);
				
				todayNewsList.add(todaynewsvo);
				
			}// end of while()-----------------------------------
			
		} finally {
			close();
		}
		
		return todayNewsList;
		
	}// end of getNewsTitleList()---------------------------------


	
	// *** tbl_books 테이블에 있는 모든 정보를 조회하는 추상 메소드 *** //
	@Override
	public List<BookVO> getAllbooks() throws SQLException {
		
		List<BookVO> bookList = null;
		
		try {
			conn = ds.getConnection();
			
			String sql = " select subject, title, author, to_char(registerday, 'yyyy-mm-dd') as registerday "
					   + " from tbl_books "
					// + " where to_date( to_char(sysdate, 'yyyy-mm-dd'), 'yyyy-mm-dd') - to_date( to_char(registerday, 'yyyy-mm-dd'), 'yyyy-mm-dd') <= 7 "
					   + " order by subject asc, registerday desc ";
			
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			int cnt = 0;
			while(rs.next()) {
				
				cnt++;
				if(cnt==1) 
					bookList = new ArrayList<BookVO>();
				
				String subject = rs.getString("subject");
				String title = rs.getString("title");
				String author = rs.getString("author");
				String registerday = rs.getString("registerday");
				
				BookVO bookvo = new BookVO();
				bookvo.setSubject(subject);
				bookvo.setTitle(title);
				bookvo.setAuthor(author);
				bookvo.setRegisterday(registerday);
				
				bookList.add(bookvo);
				
			}// end of while()-----------------------------------
			
		} finally {
			close();
		}
		
		return bookList;
		
	}// end of getAllbooks()-------------------------------------------------


	
	// *** tbl_books 테이블에 있는 최근 1주간의 정보를 조회하는 추상 메소드 *** //
	@Override
	public List<BookVO> getNewbooks() throws SQLException {
		
		List<BookVO> bookList = null;
		
		try {
			conn = ds.getConnection();
			
			String sql = " select subject, title, author, to_char(registerday, 'yyyy-mm-dd') as registerday "
					   + " from tbl_books "
					   + " where to_date( to_char(sysdate, 'yyyy-mm-dd'), 'yyyy-mm-dd') - to_date( to_char(registerday, 'yyyy-mm-dd'), 'yyyy-mm-dd') <= 7 "
					   + " order by subject asc, registerday desc ";
			
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			int cnt = 0;
			while(rs.next()) {
				
				cnt++;
				if(cnt==1) 
					bookList = new ArrayList<BookVO>();
				
				String subject = rs.getString("subject");
				String title = rs.getString("title");
				String author = rs.getString("author");
				String registerday = rs.getString("registerday");
				
				BookVO bookvo = new BookVO();
				bookvo.setSubject(subject);
				bookvo.setTitle(title);
				bookvo.setAuthor(author);
				bookvo.setRegisterday(registerday);
				
				bookList.add(bookvo);
				
			}// end of while()-----------------------------------
			
		} finally {
			close();
		}
		
		return bookList;
	
	}// end of getNewbooks()-------------------------------------------------------


	
	// *** jsp_wordsearchtest 테이블에 있는 정보 중 검색되어진 title 컬럼값만 조회해주는 추상 메소드 *** //
	@Override
	public List<String> getSearchWordAutoCompletely(String searchword) throws SQLException {
		
		List<String> strList = null;
		
		try {
			conn = ds.getConnection();
			
			String sql = " select case when length(title) > 20 then substr(title,1,20) else title end AS TITLE"
					   + " from jsp_wordsearchtest "
					   + " where lower(title) like '%' || lower(?) || '%' ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, searchword);
			rs = pstmt.executeQuery();
			
			int cnt = 0;
			while(rs.next()) {
				
				cnt++;
				if(cnt==1) 
					strList = new ArrayList<String>();
				
				String title = rs.getString("TITLE");
				
				strList.add(title);
						
			}// end of while()-----------------------------------
			
		} finally {
			close();
		}
		
		return strList;
		
	}// end of getSearchWordAutoCompletely(String searchword)----------------------------


	
	// *** jsp_wordsearchtest 테이블에 있는 정보중 검색되어진 title에 의해 content를 조회해주는 추상 메소드 *** //
	@Override
	public List<HashMap<String, String>> getContentbyWordSearch(String searchword) throws SQLException {
		
		List<HashMap<String, String>> mapList = null;
		
		try {
			conn = ds.getConnection();
			
			String sql = " select seq, title, content "
					   + " from jsp_wordsearchtest "
					   + " where lower(title) like '%' || lower(?) || '%' ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, searchword);
			rs = pstmt.executeQuery();
			
			int cnt = 0;
			while(rs.next()) {
				
				cnt++;
				if(cnt == 1) 				
					mapList = new ArrayList<HashMap<String, String>>();
				
				String seq = rs.getString("seq");
				String title = rs.getString("title");
				String content = rs.getString("content");
				
				HashMap<String, String> map = new HashMap<String, String>();
				
				map.put("seq", seq);
				map.put("title", title);
				map.put("content", content);
				
				mapList.add(map);
				
			}
			
		} finally {
			close();
		}
		
		return mapList;
		
	} // getContentbyWordSearch(String searchword)---------------------------------------------

}


















