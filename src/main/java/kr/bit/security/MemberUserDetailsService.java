package kr.bit.security;

import kr.bit.entity.Member;
import kr.bit.entity.MemberUser;
import kr.bit.mapper.MemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

public class MemberUserDetailsService implements UserDetailsService {

    @Autowired
    private MemberMapper memberMapper;

    @Override   //시큐리티에서 아이디 기준으로 비번이 맞는지 체크해줌
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException{
        //아이디를 기준으로 사용자의 정보 반환.
        Member member = memberMapper.login(username);
        //이 회원정보들을 User객체가 UserDetails에 담는다.
        //UserDetailsService(사용자 정보가져옴 - 사용자 유무확인) -> UserDetails
        // -> implements -> User -> extends -> MemberUser

        if(member != null){
            //값이 있다면..
            return new MemberUser(member);
            //리턴을 이런식으로 받아도 상관없다.(같은 형이다)
            //Member, MemberAuth에 저장해놓은 값을 MemberUser에 정보를 담을거임


        }
        else{
            throw new UsernameNotFoundException(username + "존재하지 않는다.");
        }


    }
}
