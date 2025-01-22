package kr.bit.entity;


import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
//User 상속받기

import java.util.Collection;
import java.util.stream.Collectors;

@Getter
@Setter
public class MemberUser extends User {

    //UserDetailsService : id기준으로 사용자 정보가져와서 사용자 유무 확인
    //사용자가 있으면 -> UserDetails로 반환 -> 인증이됐다.그럼 사용자 정보를 저장한다.

    private Member member;

    public MemberUser(String username, String password, Collection<? extends GrantedAuthority> authorities) {
       super(username, password, authorities);
    }

    public MemberUser(Member member){
        super(member.getMemberID(), member.getMemberPw(),
                member.getAuthList().stream().map(auth -> new SimpleGrantedAuthority(auth.getAuth()))
                .collect(Collectors.toList()));
        //SimpleGrantedAuthority 스프링에서 제공
        //map -> 각요소를 변환하는 역할
        // ROLE_USER -> "ROLE_USER" 이런 형식으로 바뀜

        //Auth("ROLE_USER") -> "ROLE_USER" -> SimpleGrantedAuthority("ROLE_USER") 이런식으로 변환됨.

        //사용자 권한 리스트를 -> SimpleGrantedAuthority 객체로 변환한다.
        // 시큐리티에서 권한정보를 GrantedAuthority 인터페이스로 다루기 때문에
        // 디비에 있는 권한정보를 SimpleGrantedAuthority 로 변환 해줘야함.

        this.member=member;
    }

}
