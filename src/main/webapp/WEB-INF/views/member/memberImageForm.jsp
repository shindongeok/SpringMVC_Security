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
<%--        모달 메세지 띄우기--%>
        $(document).ready(function(){
            if(${!empty messageType}){
                $("#myMesssge").modal("show");
            }
        });

        document.addEventListener('DOMContentLoaded', function() {
            let fileInput = document.getElementById('memberProfile');
            let previewArea = document.getElementById('previewArea');
            let imagePreview = document.getElementById('imagePreview'); // 이미지 미리보기 요소

            fileInput.addEventListener('change', (event) => {
                let file = event.target.files[0]; // 사용자가 선택한 파일
                if (!file) {
                    previewArea.textContent = "파일이 선택되지 않았습니다.";
                    imagePreview.style.display = 'none'; // 이미지 미리보기 숨기기
                    return;
                }

                let reader = new FileReader();
                reader.onload = (e) => {
                    imagePreview.src = e.target.result; // 파일을 이미지로 표시
                    imagePreview.style.display = 'block'; // 이미지를 표시
                };
                reader.onerror = () => {
                    previewArea.textContent = "파일을 읽는 중 오류가 발생했습니다.";
                    imagePreview.style.display = 'none'; // 오류 발생 시 이미지를 숨기기
                };
                reader.readAsDataURL(file); // 이미지 파일 읽기
            });
        });
    </script>
</head>
<body>
<div class="container">
    <jsp:include page="../always/header.jsp" />
    <div class="panel panel-default">
        <div class="panel-body">
            <form action="${root}/memberImage?${_csrf.parameterName}=${_csrf.token}" method="post" enctype="multipart/form-data">
            <input type="hidden" id="memberID" name="memberID" value="${memberVo.memberID}" />
                <table class="table table-borderd">


                    <tr>
                        <td>사진 미리보기
                            <div class="preview" id="previewArea">
                                <img id="imagePreview" src="" alt="이미지 미리보기" style="max-width: 200px; max-height: 200px; display: none;">
                            </div>
                        </td>
                        <td colspan="2">
                            파일 명
                            <input type="file" name="memberProfile"  id="memberProfile">
                        </td>


                    </tr>
                    <tr>
                        <td colspna="2">
                            <input type="submit" class="form-control" value="사진 등록"/>
                        </td>
                    </tr>
                </table>

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