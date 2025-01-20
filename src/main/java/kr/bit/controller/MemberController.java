package kr.bit.controller;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import kr.bit.entity.Member;
import kr.bit.entity.MemberAuth;
import kr.bit.mapper.MemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
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
import java.util.List;

@Controller
public class MemberController {

    @Autowired
    private MemberMapper memberMapper;

    //암호화를 위한 자동주입 설정
    @Autowired
    PasswordEncoder passwordEncoder;

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
                member.getMemberEmail() == null || member.getMemberEmail().equals("") ||
                member.getAuthList().size() == 0) {

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

        //패스워드 암호화 작업
        String encPw=passwordEncoder.encode(member.getMemberPw());
        member.setMemberPw(encPw);  //암호화된 비번으로 바꿔준다.



        int result = memberMapper.register(member);
        if (result == 1) {

            //MemberAut테이블에 권한 저장
            List<MemberAuth> list = member.getAuthList();
            for (MemberAuth memberAuth : list){
                if(memberAuth.getAuth() !=null){
                    //권한 설정 셋메소드로 넣어줌 객체에
                    MemberAuth memberAuthVo = new MemberAuth();
                    memberAuthVo.setMemberID(member.getMemberID());
                    memberAuthVo.setAuth(memberAuth.getAuth());
                    memberMapper.authRegister(memberAuthVo); //권한 추가하는 메소드 디비에 memberMapper.

                }
            }

            rttr.addFlashAttribute("messageType", "성공");
            rttr.addFlashAttribute("message", "회원가입에 성공했다");
            //회원가입 되면 로그인처리할거임

            Member memberVo = memberMapper.getMember(member.getMemberID());
            System.out.println(memberVo);
            session.setAttribute("memberVo", memberVo);
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


        //passwordEncoder.matches(member.getMemberPw(), memberVo.getMemberPw()) 함수로 해쉬화? 해주는 작업이 가능한다
        // 클라이언트가 입력한 값과 디비에 저장된 값 (비번) 을 해쉬화로해서 비교함.
        if (memberVo != null && passwordEncoder.matches(member.getMemberPw(), memberVo.getMemberPw())) {  // 로그인 성공했을 때
            // 비밀번호 매칭 확인
            if (passwordEncoder.matches(member.getMemberPw(), memberVo.getMemberPw())) {
                rttr.addFlashAttribute("messageType", "성공");
                rttr.addFlashAttribute("message", "로그인 되었다");
                session.setAttribute("memberVo", memberVo);
                System.out.println(memberVo);
                return "redirect:/";
            } else {
                rttr.addFlashAttribute("messageType", "실패");
                rttr.addFlashAttribute("message", "비밀번호가 일치하지 않습니다.");
                return "redirect:/memberLoginForm";
            }
        } else {
            rttr.addFlashAttribute("messageType", "실패");
            rttr.addFlashAttribute("message", "존재하지 않는 회원입니다.");
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

            //회원정보 수정후 다시 회원정보 가져와서 셋팅
            Member memberVo = memberMapper.getMember(member.getMemberID());
            session.setAttribute("memberVo", memberVo);



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