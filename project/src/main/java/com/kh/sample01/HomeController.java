package com.kh.sample01;

import java.io.FileInputStream;
import java.text.DateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.sample01.service.BoardService;
import com.kh.sample01.service.LikeService;
import com.kh.sample01.service.MemberService;
import com.kh.sample01.service.MessageService;
import com.kh.sample01.util.MyFileUploadUtil;
import com.kh.sample01.vo.MemberVo;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	@Inject
	private MemberService memberService;
	@Inject
	private MessageService messageService;
	@Inject
	private LikeService likeService;	
	@Inject
	private BoardService boardService;	
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		
		return "redirect:/board/listAll";
	}
	
	@RequestMapping(value="/uploadAjax", method=RequestMethod.POST, produces="application/text;charset=utf-8")
	@ResponseBody
	public String uploadAjax(MultipartFile file) throws Exception {
		System.out.println("file:" + file);
		String originalFilename = file.getOriginalFilename();
		System.out.println("orginalFilename:" + originalFilename);
		String filePath = MyFileUploadUtil.uploadFile("//192.168.0.204/upload", originalFilename, file.getBytes());
		return filePath;
	}
	
	//썸네일 이미지 요청
	@RequestMapping(value="/displayImage", method=RequestMethod.GET)
	@ResponseBody
	public byte[] displayImage(String fileName) throws Exception {
		FileInputStream fis = new FileInputStream(fileName);
		byte[] bytes = IOUtils.toByteArray(fis);
		fis.close();
		return bytes;
	}
	
	//첨부파일 삭제
	@RequestMapping(value="/deleteFile", method=RequestMethod.GET)
	@ResponseBody
	public String deleteFile(String fileName) throws Exception {
		MyFileUploadUtil.deleteFile(fileName);
		return "success";
	}
	
	//로그인 폼
	@RequestMapping(value="/loginForm", method=RequestMethod.GET)
	public String loginForm() throws Exception {
		return "loginForm";
	}
	
	//로그인실행
	@RequestMapping(value="/loginRun", method=RequestMethod.POST)
	public String loginRun(String user_id, String user_pw, RedirectAttributes rttr, HttpSession session) throws Exception{
		MemberVo memberVo = memberService.login(user_id, user_pw);
		String msg = null;
		String page = null;
		if (memberVo != null) {
			msg = "success";
			page = "redirect:/board/listAll";
			int notReadCount = messageService.notReadCount(user_id);
			memberVo.setNotReadCount(notReadCount);
			session.setAttribute("loginVo", memberVo);
			String requestPath = (String) session.getAttribute("requestPath");
			session.removeAttribute("requestPath");
			if(requestPath != null) {
				page = "redirect:" + requestPath;
			}
 		} else {
 			msg = "fail";
 			page = "redirect:/loginForm";
 		}
		rttr.addFlashAttribute("msg", msg);
		return page;
	}
	
	// 회원 가입 폼
	@RequestMapping(value="/memberJoinForm", method=RequestMethod.GET)
	public String memberJoinForm() throws Exception {
		return "memberJoinForm";
	}
	
	@RequestMapping(value="/checkDupId", method=RequestMethod.GET)
	@ResponseBody
	public String checkDupId(String user_id) throws Exception {
		boolean result = memberService.checkDupId(user_id);
		return String.valueOf(result);
	}
	
	@RequestMapping(value="/memberJoinRun", method=RequestMethod.POST)
	public String memberJoinRun(MemberVo memberVo, MultipartFile file, RedirectAttributes rttr) throws Exception {
		String orgFileName = file.getOriginalFilename();
		System.out.println("orgFileName: " + orgFileName);
		String filePath = MyFileUploadUtil.uploadFile("D:/user_pic", orgFileName, file.getBytes());
		memberVo.setUser_pic(filePath);
		System.out.println("memberVo: " + memberVo);
		memberService.insertMember(memberVo);
		rttr.addFlashAttribute("msg", "success");
		return "redirect:/loginForm";
	}
	
	// 로그아웃
	@RequestMapping(value="/logout", method=RequestMethod.GET)
	public String logout(HttpSession session) throws Exception {
		session.invalidate(); //현재세션 무효화
							 // removeAttribute() 모두
		return "redirect:/loginForm";
	}
	
	@ResponseBody
	@RequestMapping(value="/clickLike", method=RequestMethod.GET)
	public Map<String, Object> clickLike(int b_no, HttpSession session) throws Exception {
		MemberVo memberVo = (MemberVo) session.getAttribute("loginVo");
		int heart = likeService.clickLike(b_no, memberVo.getUser_id());
		int likeCount = boardService.getLikeCount(b_no);
		// heart -> 0 해당사용자가 하트 안누름 heart -> 1 해당사용자가 하트 눌렀음
		 logger.info("request: /clickLike");
		logger.debug("request: /clickLike heart", heart);
		
		Map<String, Object> likeMap = new HashMap<>();
		likeMap.put("heart", heart);
		likeMap.put("likeCount", likeCount);
		return likeMap;
//	        int resultLike = 1;
//	        int likecheck = 1;
//	        Map<String,Integer> map = new HashMap<>();
//	        Map<String,Object> likecntMap = new HashMap<>();
//	        Map<String,Object> resultMap = new HashMap<>();
//           	map = likeService.likeCheck(likeMap);
//           	if (map == null) {
//           		return "map is null";
//           	} else {
//           		return "map is not null";
//           	}
//            if(map == null) {
//                //처음 좋아요 누른것 likecheck=1, 좋아요 빨간색이 되야됨
//                service.insertLikeBtn(commandMap); //좋아요 테이블 인서트
//                service.updateLikeCntPlus(commandMap); //bbs 테이블 업데이트 +1
//                resultCode = 1;
//            }
//            else if(Integer.parseInt(map.get("likecheck").toString()) == 0) {
//                //좋아요 처음은 아니고 취소했다가 다시 눌렀을때 likecheck=1, 좋아요 빨간색 되야됨
//                commandMap.put("likecheck",likecheck);
//                service.updateLikeCheck(commandMap); //좋아요 테이블 업데이트
//                service.updateLikeCntPlus(commandMap); // bbs테이블 +1
//                resultCode = 1;
//            }
//            else {
//                //좋아요 취소한거 likecheck=0, 빈하트 되야됨
//                likecheck = 0;
//                commandMap.put("likecheck", likecheck);
//                service.updateLikeCheck(commandMap);
//                service.updateLikeCntMinus(commandMap);
//                resultCode = 0;
//            }
//            resultMap = service.getLikeCnt(commandMap); 
//            // 해당 게시글 테이블의 likecnt칼럼  update가 끝난후 likecnt값 가져옴
//            resultMap.put("likecheck", likecheck);
//            logger.debug(e.getMessage());
//            resultCode = -1;
//        
//        resultMap.put("resultCode", resultCode);
        //resultCode가 1이면 빨간하트 0이면 빈하트
//        return resultMap;
	}
}
