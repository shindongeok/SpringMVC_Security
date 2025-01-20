<%@ page contentType="text/html;charset=UTF-8" language="java"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet"
          href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

    <script>
        $(document).ready(function(){
            if(${!empty messageType}){
                $("#myMesssge").modal("show");
            }
        });




        function pwCheck(){
            let memberPw1 = $("#memberPw1").val();
            let memberPw2 = $("#memberPw2").val();


            if(memberPw1 != memberPw2){
                $("#passCheck").html("비밀번호가 일치하지 않습니다");
            }
            else{
                $("#passCheck").html("");
                $("#memberPw").val(memberPw1); //비번일치하면 hidden에 비번 넣을거임

            }
        }

        function goUpdate(){
            let memberAge = $("#memberAge").val();
            if(memberAge==null || memberAge=="" || memberAge==0){
                alert("나이 입력해야된다");
                return false;
            }
            document.fr.submit();   //서버로 전송
        }

    </script>

</head>
<body>
<div class="container">
    <jsp:include page="../always/header.jsp" />
    <div class="panel panel-default">
        <div class="panel-body">
            <form name="fr" action="${root}/memberUpdate" method="post">
                <input type="hidden" id="memberID" name="memberID" value="${memberVo.memberID}" />
                <input type="hidden" id="memberPw" name="memberPw" />
                <table class="table table-borderd">
                    <tr>
                        <td placeholder="아이디">아이디</td>
                        <td>${memberVo.memberID}</td>

                    </tr>

                    <tr>
                        <td placeholder="비밀번호 입력해라">비밀번호</td>
                        <td><input type="password" class="form-control" name="memberPw1" id="memberPw1" onkeyup="pwCheck()"/></td>
                    </tr>

                    <tr>
                        <td placeholder="비밀번호 확인해라">비밀번호확인</td>
                        <td><input type="password" class="form-control" name="memberPw2" id="memberPw2" onkeyup="pwCheck()"/></td>

                    </tr>

                    <tr>
                        <td placeholder="이름 입력해라">이름</td>
                        <td><input type="text" class="form-control" id="memberName" name="memberName" value="${memberVo.memberName}"/></td>
                    </tr>

                    <tr>
                        <td placeholder="나이 입력해라">나이</td>
                        <td><input type="number" class="form-control" id="memberAge" name="memberAge" value="${memberVo.memberAge}" /></td>
                    </tr>

                    <tr>
                        <td placeholder="성별 입력해라">성별</td>
                        <td><input type="radio" value="남자" name="memberGender"/>남자</td>
                        <td><input type="radio" value="여자" name="memberGender"/>여자</td>
                    </tr>

                    <tr>
                        <td placeholder="이메일 입력해라">이메일</td>
                        <td><input type="email" class="form-control" id="memberEmail" name="memberEmail" value="${memberVo.memberEmail}"/></td>
                    </tr>

                    <tr>
                        <td></td>
                        <td></td>
                        <td colspan="3" style="text-align:left;">
                            <span id="passCheck" style="color: red"></span>
                            <input type="button" class="btn btn-primary" value="회원수정" onclick="goUpdate()"/>
                        </td>
                    </tr>
                </table>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </form>
        </div>




        <div id="myMesssge" class="modal fade" role="dialog" >
            <div class="modal-dialog">
                <!-- Modal content-->
                <div id="checkType2" class="modal-content panel-info">
                    <div class="modal-header panel-heading">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">${messageType}</h4>
                    </div>
                    <div class="modal-body">
                        <p>${message}</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>