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

    function doubleCheck(){
        let memberID=$("#memberID").val();
        $.ajax({
            url:"${root}/memberDoubleCheck",
            type:"get",
            data:{"memberID":memberID},
            success:function(result){
                if(result==1){
                    $("#idcheck").html('사용할 수 있는 아이디이다');
                }
                else{
                    $("#idcheck").html('사용할 수 없는 아이디이다');
                }
                $("#myModal").modal("show");
            },
            error: function(request,error){
                  console.log(request.responseText);
                  console.log(error);
            }
        })
    }

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

    function goInsert(){
        let memberAge = $("#memberAge").val();
        if(memberAge==null || memberAge=="" || memberAge==0){
            alert("나이 입력해야된다");
            return false;
        }
        document.fr.submit();
    }
</script>
</head>
<body>
  <div class="container">
      <jsp:include page="../always/header.jsp" />
      <div class="panel panel-default">
          <div class="panel-body">
               <form name="fr" action="${root}/memberRegister" method="post">
                <input type="hidden" id="memberPw" name="memberPw" value=""/>
                <table class="table table-borderd">
                   <tr>
                     <td placeholder="아이디 입력해라">아이디</td>
                     <td><input type="text" class="form-control" id="memberID" name="memberID"/></td>
                      <td><button type="button" class="btn btn-primary" onclick="doubleCheck()">중복확인</button></td>
                   </tr>

                   <tr>
                      <td placeholder="비밀번호 입력해라">비밀번호</td>
                      <td><input type="password" class="form-control" name="memberPw1" id="memberPw1" onkeyup="pwCheck()"/>
                          <div id="passCheck" style="color: red"></div>
                      </td>
                   </tr>

                   <tr>
                      <td placeholder="비밀번호 확인해라">비밀번호확인</td>
                      <td><input type="password" class="form-control" name="memberPw2" id="memberPw2" onkeyup="pwCheck()"/></td>

                   </tr>

                <tr>
                    <td placeholder="이름 입력해라">이름</td>
                    <td><input type="text" class="form-control" id="memberName" name="memberName"/></td>
                </tr>

                <tr>
                   <td placeholder="나이 입력해라">나이</td>
                   <td><input type="number" class="form-control" id="memberAge" name="memberAge"/></td>
                </tr>

          <tr>
               <td placeholder="성별 입력해라">성별</td>
               <td><input type="radio" value="남자" name="memberGender"/>남자</td>
               <td><input type="radio" value="여자" name="memberGender"/>여자</td>
          </tr>

            <tr>
               <td placeholder="이메일 입력해라">이메일</td>
               <td><input type="email" class="form-control" id="memberEmail" name="memberEmail"/></td>
           </tr>

         <tr>
            <td></td>
            <td></td>
            <td  style="text-align:left;">
                <input type="button" class="btn btn-primary" value="회원등록" onclick="goInsert()"/>
            </td>
         </tr>
         </table>
         </form>
     </div>


	<div id="myModal" class="modal fade" role="dialog" >
	  <div class="modal-dialog">
	    <!-- Modal content-->
	    <div id="checkType" class="modal-content panel-info">
	      <div class="modal-header panel-heading">
	        <button type="button" class="close" data-dismiss="modal">&times;</button>
	        <h4 class="modal-title">메세지 확인</h4>
	      </div>
	      <div class="modal-body">
	        <p id="idcheck"></p>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
	      </div>
	    </div>
	  </div>
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
</body>
</html>