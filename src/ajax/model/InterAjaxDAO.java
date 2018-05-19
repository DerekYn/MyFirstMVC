package ajax.model;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

public interface InterAjaxDAO  {
	
	// *** tbl_images 테이블의 모든 행을 조회하는 추상 메소드 *** //
	List<ImageVO> getTblImages() throws SQLException;
	
	// *** tbl_ajaxnews 테이블에 입력된 데이터 중 오늘 날짜에 해당하는 행만 추출(select)하는 추상메소드 *** //
	List<TodayNewsVO> getNewsTitleList() throws SQLException;
	
	// *** tbl_books 테이블에 있는 모든 정보를 조회하는 추상 메소드 *** //
	List<BookVO> getAllbooks() throws SQLException;
	
	// *** tbl_books 테이블에 있는 최근 1주간의 정보를 조회하는 추상 메소드 *** //
	List<BookVO> getNewbooks() throws SQLException;

	// *** jsp_wordsearchtest 테이블에 있는 정보 중 검색되어진 title 컬럼값만 조회해주는 추상 메소드 *** //
	List<String> getSearchWordAutoCompletely(String searchword) throws SQLException;
	
	// *** jsp_wordsearchtest 테이블에 있는 정보중 검색되어진 title에 의해 content를 조회해주는 추상 메소드 *** //
	List<HashMap<String, String>> getContentbyWordSearch(String searchword) throws SQLException;

	
}
