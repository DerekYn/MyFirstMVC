package ajax.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import ajax.model.AjaxDAO;
import ajax.model.ImageVO;
import ajax.model.InterAjaxDAO;
import common.controller.AbstractController;

public class ImageListAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		InterAjaxDAO adao = new AjaxDAO();
		
		List<ImageVO> imgList = adao.getTblImages();
		
		req.setAttribute("imgList", imgList);
		
		super.setViewPage("/AjaxStudy/chap2/imgInfo.jsp");
		
	}

}
