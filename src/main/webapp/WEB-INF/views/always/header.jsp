<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="security" uri="http://www.springframework.org/security/tags"%>
<c:set var="root" value="${pageContext.request.contextPath}"/>
<%--실행중인 웹앱의 contextPath의 값--%>
<c:set var="memVo" value="${SPRING_SECURITY_CONTEXT.authentication.principal}"/>
<%-- 스프링시큐리티에서 현재 인증된 객체를 가져오는 표현식(UserDetails) --%>
<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities}"/>
<script>
    console.log("${memVo}");
    console.log("${memVo.member.memberName}");

    // ajax로 넘길때
    let csrfName="${_csrf.headerName}";
    let csrfToken="${_csrf.token}";
    // 시큐리티에서 로그아웃은 get방식이 안됨
    function logout(){

        $.ajax({
            // 스프링 시큐리티에서 로그아웃,로그인을 지원하기 때문에 url매핑을 컨트롤러에서 안해도 자동으로 가능하다.
            url: "${root}/logout",
            type: "post",
            beforeSend: function (xhr){ //csrf토큰을 http헤더에 추가해서 보낸다.
                xhr.setRequestHeader(csrfName,csrfToken)
            },
            success: function (){
                location.href="${root}/";
            },
            error: function(request,error){
                console.log(request.responseText);
                console.log(error);
            }

        });
    }
</script>
<%--<meta charset="UTF-8">--%>
<nav class="navbar navbar-default">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">

            </button>
            <a class="navbar-brand" href="${root}">스프링</a>
        </div>
        <div class="collapse navbar-collapse" id="myNavbar">
            <ul class="nav navbar-nav">
                <li><a href="boardMain">게시판</a></li>
            </ul>

            <!-- 익명일때 -->
            <security:authorize access="isAnonymous()">
                <ul class="nav navbar-nav navbar-right">
                    <li class="dropdown">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#">접속<span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="${root}/memberLoginForm"><span class="glyphicon glyphicon-log-in"></span>로그인</a></li>
                            <li><a href="${root}/memberJoin"><span class="glyphicon glyphicon-user"></span>회원가입</a></li>
                        </ul>
                    </li>
                </ul>
            </security:authorize>

            <security:authorize access="isAuthenticated()">
                <ul class="nav navbar-nav navbar-right">
                    <li class="dropdown">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                            <c:if test="${!empty memVo}">
                                    <%--memberVo.memberProfile값이     공백이면--%>
                                    <c:if test="${memVo.member.memberProfile eq ''}">
                                            <img src="${root}/resources/image/cat.jpg" style="width: 30px; height: 30px;"/>
                                    </c:if>
                                    <%----%>
                                    <c:if test="${memVo.member.memberProfile ne ''}">
                                        <img src="${root}/resources/upload/${memVo.member.memberProfile}" style="width: 30px; height: 30px;"/>
                                    </c:if>
                            </c:if>

                                <security:authorize access="hasRole('ROLE_USER')">
                                    일반회원,
                                </security:authorize>

                                <security:authorize access="hasRole('ROLE_VIP')">
                                    VIP,
                                </security:authorize>

                                <security:authorize access="hasRole('ROLE_ADMIN')">
                                    관리자,
                                </security:authorize>
                                    ${memVo.member.memberName} 님 환영합니다.
                            <span class="caret"></span>
                        </a>

                        <ul class="dropdown-menu">
                            <c:if test="${!empty memVo}">
                                <li><a href="${root}/memberUpdateForm"><span class="glyphicon glyphicon-user"></span>정보수정</a></li>
                                <li><a href="${root}/memberImageForm"><span class="glyphicon glyphicon-paperclip"></span>사진등록</a></li>
                                <li><a href="javascript:logout()"><span class="glyphicon glyphicon-log-out"></span>로그아웃</a></li>
                            </c:if>
                        </ul>
                    </li>
                </ul>
            </security:authorize>
        </div>
    </div>
</nav>