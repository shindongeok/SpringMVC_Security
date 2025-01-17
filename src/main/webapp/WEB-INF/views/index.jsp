<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="root" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Sample Page</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
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
        <jsp:include page="always/header.jsp" />
        <c:if test="${!empty memberVo}">
            <%--memberVo.memberProfile값이     공백이면--%>
            <c:if test="${memberVo.memberProfile eq ''}">
                <img src="${root}/resources/image/cat.jpg" style="width: 50px; height: 50px;"/>
            </c:if>
            <%----%>
            <c:if test="${memberVo.memberProfile ne ''}">
                <img src="${root}/resources/upload/${memberVo.memberProfile}"/>
            </c:if>
            ${memberVo.memberName} 님 환영합니다.
        </c:if>
        <div class="panel panel-default">
            <div>
                <img src="${root}/resources/image/apple-inc.jpg" style="width:100%;"/>
            </div>
            <div class="panel-body">
                <!-- Navigation Tabs -->
                <ul class="nav nav-tabs">
                    <li class="active"><a data-toggle="tab" href="#tab1">Tab 1</a></li>
                    <!--<li><a data-toggle="tab" href="#tab2">Tab 2</a></li>-->
                </ul>

                <!-- Tab Content -->
                <div class="tab-content">
                    <div id="tab1" class="tab-pane fade in active">
                        <h3>Tab 1</h3>
                        <p>This is the content of Tab 1.</p>
                    </div>
                    <div id="tab2" class="tab-pane fade">
                        <h3>Tab 2</h3>
                        <p>This is the content of Tab 2.</p>
                    </div>
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


</body>
</html>
