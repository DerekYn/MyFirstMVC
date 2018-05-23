package memo.model;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import member.model.MemberVO;

public interface InterMemoDAO {

	// *** 메모쓰기 추상 메소드 *** //
	int memoInsert(MemoVO memovo) throws SQLException;
	
	// *** 회원 1명에 대한 정보를 보여주는 추상 메소드 *** //
	MemberVO getMemberOneByUserid(String userid) throws SQLException;
	
	// *** 메모전체조회 추상 메소드 *** //
	List<HashMap<String, String>> getAllMemo() throws SQLException; 
	
	// *** 메모전체조회 추상 메소드 *** //
	List<MemoVO> getAllMemoVO() throws SQLException;
	
	// *** 메모전체갯수 조회 추상 메소드 *** //
	int getTotalCountMemo() throws SQLException;
	
	// *** 메모전체갯수 조회 추상 메소드 *** //
	int getTotalCountMemoVO() throws SQLException;
	
	// *** 페이징 처리한 데이터 조회 추상 메소드 *** //
    List<HashMap<String, String>> getAllMemo(int currentShowPageNo, int sizePerPage) throws SQLException; 
    
    // *** 페이징 처리한 데이터 조회 추상 메소드 *** //
    List<MemoVO> getAllMemoVO(int currentShowPageNo, int sizePerPage) throws SQLException; 
	
    // *** 메모를 삭제(update)하는 추상 메소드 *** //
    int deleteMemo(String str) throws SQLException;
    
    // *** 메모를 복구(update)하는 추상 메소드 *** //
    int recoveryMemo(String str) throws SQLException;
    
}
