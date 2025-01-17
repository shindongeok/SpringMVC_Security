package kr.bit.mapper;

import kr.bit.entity.Member;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberMapper {
    public Member memberDoubleCheck(String memberID);
    public int register(Member member); //가입이 성공되면 1, 실패 0
    public Member login(Member member);
    public int update(Member member);
    public void memberImage(Member memberProfile);

//    프로필업데이트
    public void proUpdate(Member member);
}
