package myshop.controller;

import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import common.controller.AbstractController;
import myshop.model.InterProductDAO;
import myshop.model.ProductDAO;
import myshop.model.ProductVO;

public class ProductRegisterEndAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		// **** 첨부파일 바아서 WAS 컴퓨터 디스크에 올려주기 **** //
		
		// 1. WAS 컴퓨터 디스크의 어느 경로에 파일을 올려줄지 결정해야 한다.
		HttpSession session = req.getSession();
		ServletContext svlCtx = session.getServletContext();
		String upDir = svlCtx.getRealPath("/images");
		// 웹 상에서 /images 에 해당하는 실제 물리적인 디스크경로를 알아오는 것이다.
		
		System.out.println("===> 확인용 : 첨부파일이 올라갈 upDir 절대 경로명 => " + upDir);
		// ===> 확인용 : 첨부파일이 올라갈 upDir 절대 경로명 => C:\myjsp\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\MyMVC\images
		
		
		MultipartRequest mtrequest = null;
		// 일반 HttpServletRequest request 객체로서는
		// 첨부파일을 받을 수가 없다.
		// 그래서 MultipartRequest mtrequest 객체를 사용하면
		// 폼 상의 모든 값(예 : <input type="text" "password" "number" ... 등등 뿐 아니라,
		//                 <input type="file" 도 받을 수 있다.)
		// 을 받아서 처리해 준다.
		
		// 2. 파일을 받아서 올려주기
		// ==> MultipartRequest mtrequest 객체의 생성자만
		//     호출해주면 알아서 첨부파일을 올려준다.
		
		try {
		
			mtrequest = new MultipartRequest(req, upDir, 10*1024*1024, "UTF-8", new DefaultFileRenamePolicy());
			
			/*
			 	MultipartRequest 의 객체가 생성됨과 동시에 파일 업로드가 이루어 진다.
			 	
			 	MultipartRequest(HttpServletRequest request,
			 					 String saveDirectory,	 -- 파일이 저장될 경로
			 					 int maxPostsize,  -- 업로드할 파일 1개의 최대크기(byte)
			 					 String encoding,  --   
			 					 FileRenamePolicy policy  -- 중복된 파일명이 올라갈 경우 파일명 다음에  자동으로 숫자가 붙어서 올라간다.
			 					 );
			 					 
			 	파일을 저장할 디렉토리를 지정할 수 있으며, 
			 	업로드 제한 용량을 설정할 수 있다.
			 	이때 업로드 제한 용량을 넘어서 업로드를 시도하면 IOException 이 발생된다.
			 	또한 국제화 지원을 위한 인코딩 방식을 지정할 수 있으며,
			 	중복 파일 처리 인터페이스를 사용할 수 있다.
			 	
			 	이때 업로드 파일의 최대크기를 초과하는 경우라면IOException 이 발생된다.
			 	
			 */
			
			System.out.println("===> 확인용 : 파일업로드 성공!!");
			
		} catch(IOException e) {
			super.alertMsg(req, "파일업로드 실패 --> 용량 10MB 이하로 재업로드 하세요.", "javascript:history.back();");
			return;
		}
		
		// **** 파일 업로드가 성공했으니 그 다음으로 상품정보(상품명, 정가, 제품설명.. )를
		// 		jsp_product 테이블에 insert 해주어야 한다.
		
		
		InterProductDAO pdao = new ProductDAO();
		
		// *** 새로운 제품 등록시 HTMl form 에서 입력한 값들을 얻어오기 *** //
		String pcategory_fk = mtrequest.getParameter("pcategory_fk");
		String pname = mtrequest.getParameter("pname");
		String pcompany = mtrequest.getParameter("pcompany");

		String pimage1 = mtrequest.getFilesystemName("pimage1"); 
		String pimage2 = mtrequest.getFilesystemName("pimage2");
		// 업로드되어진 시스템의 파일 이름을 얻어 올때는 
		// cos.jar 라이브러리에서 제공하는 MultipartRequest 객체의  getFilesystemName("form에서의 첨부파일 name명") 메소드를 사용 한다. 
		// 이때 업로드 된 파일이 없는 경우에는 null을 반환한다.
	/*
		   <<참고>> 
		   ※ MultipartRequest 메소드

		--------------------------------------------------
		  반환타입                         설명
		--------------------------------------------------
		 Enumeration       getFileNames()
		
				                     업로드 된 파일들에 대한 이름을 Enumeration객체에 String형태로 담아 반환한다. 
				                     이때의 파일 이름이란 클라이언트 사용자에 의해서 선택된 파일의 이름이 아니라, 
				                     개발자가 form의 file타임에 name속성으로 설정한 이름을 말한다. 
				                     만약 업로드 된 파일이 없는 경우엔 비어있는 Enumeration객체를 반환한다.
		
		 
		 String            getContentType(String name)
		
				                     업로드 된 파일의 컨텐트 타입을 얻어올 수 있다. 
				                     이 정보는 브라우저로부터 제공받는 정보이다. 
				                     이때 업로드 된 파일이 없는 경우에는 null을 반환한다.
		
		
		 File              getFile(String name)
		
				                     업로드 된 파일의 File객체를 얻는다. 
				                     우리는 이 객체로부터 파일사이즈 등의 정보를 얻어낼 수 있다. 
				                     이때 업로드 된 파일이 없는 경우에는 null을 반환한다.
		
		
		 String            getFilesystemName(String name)
		
				                     시스템의 파일 이름을 반환한다. 
				                     이때 업로드 된 파일이 없는 경우에는 null을 반환한다.
		
		
		 String            getOriginalFimeName(String name)
		
				                     중복 파일 처리 인터페이스에 의해 변환되기 이전의 파일 이름을 반환한다. 
				                     이때업로드 된 파일이 없는 경우에는 null을 반환한다.
		
		
		 String            getParameter(String name)
		
				                     지정한 파라미터의 값을 반환한다. 
				                     이때 전송된 값이 없을 경우에는 null을 반환한다.
		
		
		 Enumeration       getParameternames()
		
				                     폼을 통해 전송된 파라미터들의 이름을 Enumeration객체에 String 형태로 담아 반환한다. 
				                     전송된 파라미터가 없을 경우엔 비어있는 Enumeration객체를 반환한다
		
		
		 String[]          getparameterValues(String name)
		
				                     동일한 파라미터 이름으로 전송된 값들을 String배열로 반환한다. 
				                     이때 전송된파라미터가 없을 경우엔 null을 반환하게 된다. 
				                     동일한 파라미터가 단 하나만 존재하는 경우에는 하나의 요소를 지닌 배열을 반환하게 된다.    
	*/

		String pqty = mtrequest.getParameter("pqty");
		String price = mtrequest.getParameter("price");
		String saleprice = mtrequest.getParameter("saleprice");
		String pspec = mtrequest.getParameter("pspec");
		String pcontent = mtrequest.getParameter("pcontent").replaceAll("\r\n", "<br/>");
		String point = mtrequest.getParameter("point");

		
		int pnum = pdao.getPnumOfProduct();
		// jsp_product 테이블에 신규제품으로 insert 되어질
		// 제품번호 시퀀스 seq_jsp_product_pnum.nextval 을
		// 따와서 변수에 넣어준다.
		
		ProductVO pvo = new ProductVO();
		pvo.setPnum(pnum);
		pvo.setPname(pname);
		pvo.setPcategory_fk(pcategory_fk);
		pvo.setPcompany(pcompany);
		pvo.setPimage1(pimage1);
		pvo.setPimage2(pimage2);
		pvo.setPqty(Integer.parseInt(pqty));
		pvo.setPrice(Integer.parseInt(price));
		pvo.setSaleprice(Integer.parseInt(saleprice));
		pvo.setPspec(pspec);
		pvo.setPcontent(pcontent);
		pvo.setPoint(Integer.parseInt(point));
		
		int n = pdao.productInsert(pvo);
		
		String str_attachCount = mtrequest.getParameter("attachCount");
		
		if(!"".equals(str_attachCount)) {
			
			int attachCount = Integer.parseInt(str_attachCount);	// 추가 이미지 파일 갯수.
			
			for(int i=0; i<attachCount; i++) {
				
				String attachFilename = mtrequest.getFilesystemName("attach" + i);	// 넘겨준 파일에서의 값과 동일하게.
				
				pdao.product_imagefile_Insert(pnum, attachFilename);
								
			}// end of for()------------------------------------------
			
			String msg = (n>0)?"제품등록 성공!!":"제품등록 실패!!";
			String loc = (n>0)?"../malldisplay.do":"javascript:history.back();";
			
			super.alertMsg(req, msg, loc);
	
			
		}

		
	}

}
