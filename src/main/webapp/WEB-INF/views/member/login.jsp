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
</script>

</head>
<body>
    <div class="container">
          <jsp:include page="../always/header.jsp" />
          <div class="panel panel-default">
              <div class="panel-body">
                   <form action="${root}/memberLogin" method="post">
                        <table class="table table-borderd">
                           <tr>
                             <td placeholder="아이디 입력해라">아이디</td>
                             <td><input type="text" class="form-control" id="memberID" name="memberID"/></td>
                           </tr>

                           <tr>
                              <td placeholder="비밀번호 입력해라">비밀번호</td>
                              <td><input type="password" class="form-control" name="memberPw" id="memberPw" /></td>
                           </tr>
                            <tr>
                                <td colspna="2">
                                    <input type="submit" class="form-control" value="로그인"/>
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