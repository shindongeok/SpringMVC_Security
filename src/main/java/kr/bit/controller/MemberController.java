package kr.bit.controller;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import kr.bit.entity.Member;
import kr.bit.mapper.MemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;

@Controller
public class MemberController {

    @Autowired
    private MemberMapper memberMapper;

    @RequestMapping("/memberJoin")
    public String memberJoin() {
        return "member/join";
    }

    @RequestMapping("/memberDoubleCheck")
    public @ResponseBody int memberDoubleCheck(@RequestParam("memberID") String memberID) {
        Member member = memberMapper.memberDoubleCheck(memberID);
        if (member != null || memberID.equals("")) {
            return 0;
        }
        return 1;
    }

    @RequestMapping("/memberRegister")
    public String memberRegister(Member member, String memberPw1, String memberPw2,
                                 RedirectAttributes rttr, HttpSession session) {

        if (member.getMemberID() == null || member.getMemberID().equals("") ||
                memberPw1 == null || memberPw1.equals("") ||
                memberPw2 == null || memberPw2.equals("") ||
                member.getMemberName() == null || member.getMemberName().equals("") ||
                member.getMemberAge() == 0 ||
                member.getMemberGender() == null || member.getMemberGender().equals("") ||
                member.getMemberEmail() == null || member.getMemberEmail().equals("")) {

            rttr.addFlashAttribute("messageType", "실패");
            rttr.addFlashAttribute("message", "모든 내용을 입력해야한다");

            return "redirect:/memberJoin";
        }

        if (!memberPw1.equals(memberPw2)) {
            rttr.addFlashAttribute("messageType", "실패");
            rttr.addFlashAttribute("message", "비밀번호가 다르다");
            return "redirect:/memberJoin";
        }

        member.setMemberProfile("");
        int result = memberMapper.register(member);
        if (result == 1) {
            rttr.addFlashAttribute("messageType", "성공");
            rttr.addFlashAttribute("message", "회원가입에 성공했다");
            //회원가입 되면 로그인처리할거임
            session.setAttribute("memberVo", member);
            return "redirect:/";
        } else {
            rttr.addFlashAttribute("messageType", "실패");
            rttr.addFlashAttribute("message", "이미 존재하는 회원이다");
            return "redirect:/";
        }
    }

    @RequestMapping("/memberLogout")
    public String memberLogout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    @RequestMapping("/memberLoginForm")
    public String memberLoginForm() {
        return "member/login";
    }

    @RequestMapping("/memberLogin")
    public String memberLogin(Member member, RedirectAttributes rttr, HttpSession session) {
        if (member.getMemberID() == null || member.getMemberID().equals("") ||
                member.getMemberPw() == null || member.getMemberPw().equals("")) {

            rttr.addFlashAttribute("messageType", "실패");
            rttr.addFlashAttribute("message", "모든 내용을 입력해야한다");

            return "redirect:/memberLoginForm";
        }

        Member memberVo = memberMapper.login(member);

        if (memberVo != null) {  //로그인 성공했을때
            rttr.addFlashAttribute("messageType", "성공");
            rttr.addFlashAttribute("message", "로그인 되었다");
            session.setAttribute("memberVo", memberVo);
            return "redirect:/";
        } else {
            rttr.addFlashAttribute("messageType", "실패");
            rttr.addFlashAttribute("message", "다시 로그인해라");
            return "redirect:/memberLoginForm";
        }
    }

    @RequestMapping("/memberUpdateForm")
    public String memberUpdateForm(){
        return "member/memberUpdateForm";
    }

    @PostMapping("/memberUpdate")
    public String memberUpdate(Member member, String memberPw1, String memberPw2,
                               RedirectAttributes rttr, HttpSession session) {

        if (member.getMemberID() == null || member.getMemberID().equals("") ||
                memberPw1 == null || memberPw1.equals("") ||
                memberPw2 == null || memberPw2.equals("") ||
                member.getMemberName() == null || member.getMemberName().equals("") ||
                member.getMemberAge() == 0 ||
                member.getMemberGender() == null || member.getMemberGender().equals("") ||
                member.getMemberEmail() == null || member.getMemberEmail().equals("")) {

            rttr.addFlashAttribute("messageType", "실패");
            rttr.addFlashAttribute("message", "모든 내용을 입력해야한다");

            return "redirect:/memberUpdateForm";
        }

        if (!memberPw1.equals(memberPw2)) {
            rttr.addFlashAttribute("messageType", "실패");
            rttr.addFlashAttribute("message", "비밀번호가 다르다");
            return "redirect:/memberUpdateForm";
        }

        //회원수정
        int result=memberMapper.update(member);
        if(result == 1){
            rttr.addFlashAttribute("messageType", "성공");
            rttr.addFlashAttribute("message", "수정이 되었습니다.");

            session.setAttribute("memberVo", member);

            return "redirect:/";
        }
        else {
            rttr.addFlashAttribute("messageType", "실패");
            rttr.addFlashAttribute("message", "회원정보 수정 실패!");
        }

        return "redirect:/memberUpdateForm";
    }

    @RequestMapping("memberImageForm")
    public String memberImageForm(){
        return "member/memberImageForm";
    }

    @PostMapping("/memberImage")
    public String memberImage(RedirectAttributes rttr, HttpServletRequest request, HttpSession session) throws IOException {

        //MultipartRequest -> 업로드된 파일 처리하는 객체
        MultipartRequest multipartRequest = null;
        int fileMaxSize = 40 * 1024 * 1024;   //업로드할 파일 최대크기

        String savePath = request.getRealPath("resources/upload");    //파일이 저장될 경로 설정


        //new DefaultFileRenamePolicy() -> 동일한 파일명이 있으면 바꿔주겠다.
        multipartRequest = new MultipartRequest(request, savePath, fileMaxSize, "UTF-8", new DefaultFileRenamePolicy());

        String memeberID = multipartRequest.getParameter("memberID");
        String newProfile = "";


        File file = multipartRequest.getFile("memberProfile");
        if (file != null) {   //업로드 되어 있는 상태라면
            String str = file.getName().substring(file.getName().lastIndexOf(".") + 1);
            str = str.toUpperCase();  //JPG

            if (str.equals("PNG") || str.equals("JPG")) {
                String oldProfile = memberMapper.getMember(memeberID).getMemberProfile();
                File oldFile = new File(savePath + "/" + oldProfile);

                if (oldFile.exists()) {
                    oldFile.delete();   //기존 이미지가 있따면 해당 이미지 파일을 삭제한다.
                }
                newProfile = file.getName();    //업로드 된 새 파일명을 newProfile에 저장함
            } else {
                if (file.exists()) {
                    file.delete();
                }
                rttr.addFlashAttribute("messageType", "실패");
                rttr.addFlashAttribute("message", "업로드할 수 없습니다.");


                return "redirect:/memberImageForm";
            }
        }

        //새로운 사진 테이블에 저장
        Member memberVo = new Member();
        memberVo.setMemberID(memeberID);
        memberVo.setMemberProfile(newProfile);

        memberMapper.memberProfile(memberVo);
        Member member = memberMapper.getMember(memeberID);

        session.setAttribute("memberVo", member);

        rttr.addFlashAttribute("messageType", "성공");
        rttr.addFlashAttribute("message", "업로드 성공");

        return "redirect:/";
    }






}