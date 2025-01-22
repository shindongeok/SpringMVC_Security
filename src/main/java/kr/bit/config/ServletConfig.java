package kr.bit.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

import javax.swing.*;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = {"kr.bit.controller"})
public class ServletConfig implements WebMvcConfigurer {

    //CSS, JavaScript, 이미지, 폰트 등과 같은 정적 파일들을 클라이언트가 요청했을 때 제공할 수 있도록 처리
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/resources/**").addResourceLocations("/resources/");
    }

    //Spring MVC에서 뷰(View)를 처리하는 방법을 설정
    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        //InternalResourceViewResolver는 JSP 같은 내부 리소스를 뷰로 사용하도록 설정하는 ViewResolver 구현체
        InternalResourceViewResolver bean=new InternalResourceViewResolver();
        //이 설정은 JSP 파일이 위치한 폴더 경로를 지정
        bean.setPrefix("/WEB-INF/views/");
        //.jsp 확장자가 붙은 파일을 처리하도록 설정
        bean.setSuffix(".jsp");
        //Spring MVC의 뷰 리졸버 목록에 등록
        registry.viewResolver(bean);
    }

}
