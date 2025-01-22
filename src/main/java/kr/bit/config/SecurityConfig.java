package kr.bit.config;

import kr.bit.security.MemberUserDetailsService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.csrf.CsrfFilter;
import org.springframework.web.filter.CharacterEncodingFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    //보안 관련 커스텀을 할 수 있다.
    //인증, 보안필터 설정 가능해짐

    @Bean
    public UserDetailsService userDetailsService(){
        return new MemberUserDetailsService();
    }   //db에서 사용자 정보 가져와 유무파악


    @Override   //시큐리티 인증 설정하는 객체
    protected  void configure(AuthenticationManagerBuilder auth) throws Exception{
        auth.userDetailsService(userDetailsService())
                .passwordEncoder(passwordEncoder());    //비밀번호 암호화하여 인증 수행
    }

    @Override
    public void configure(HttpSecurity http) throws Exception {

        //요청에 대한 보안 설정
        CharacterEncodingFilter filter = new CharacterEncodingFilter();
        //한글 인코딩
        filter.setEncoding("UTF-8");
        filter.setForceEncoding(true);
        http.addFilterBefore(filter, CsrfFilter.class);
        //csrf보안 처리 전에 실행되도록



        //요청에 따른 권한 확인한 후 서비스하는 코드
        http
                .authorizeRequests()
                .antMatchers("/")   //메인페이지 누구나 확인가능 설정
                .permitAll()    // /(기본경로)는 다 접근 가능
                .and()
                    .formLogin()    //기본 로그인 폼 활성화(스프링에서 제공해주는 폼이 기본으로 나온다)
                    .loginPage("/memberLoginForm")
                    .loginProcessingUrl("/memberLogin") //로그인처리를 어디서 할것이냐. 로그인 처리 페이지!
                                        // 시큐리티에서 가로채가기때문에 컨트롤러에 없어도 상관없다.(이름만있다)
                                        //로그인 url
                    .permitAll()    //로그인 페이지는 누구나 접근 가능하다.
                    .and()
                        .logout()
                        .invalidateHttpSession(true)    //로그아웃 후 세션 제거
                        .logoutSuccessUrl("/")  //로그아웃 후 /로 리다이렉트
                        .and()  //login?error
                            .exceptionHandling().accessDeniedPage("/denied");   //오류페이지로 이동.
                            // 필요하다면 추가 가능 !!



    }

    //패스워드 인코딩 객체 -> 패스워드 암호화
    @Bean
    public PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }



}
