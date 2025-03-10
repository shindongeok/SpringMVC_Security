package kr.bit.mapper;

import kr.bit.entity.Member;
import kr.bit.entity.MemberAuth;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberMapper {
    public Member memberDoubleCheck(String memberID);
    public int register(Member member); //가입이 성공되면 1, 실패 0

    // 로그인
    public Member login(String username);
    public int update(Member member);


    // 프로필업데이트
    public Member getMember(String memberID);
    public void memberProfile(Member member);

    // 권한 부여한 필드객체를 디비에 넣는 인터페이스
    public void authRegister(MemberAuth memberAuth);

    //권한 삭제
    public void authDalate(String memberID);
}
