<%@ page contentType="text/html;charset=UTF-8" language="java"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<script type="text/javascript">
    $(document).ready(function(){
        loadList();
    });

    function loadList(){
        $.ajax({
            url: "board/all",
            type: "get",
            dataType: "json",
            success: make,
            error: function(){
                alert("error");
            }
        });
    }
    function make(data){
        let listHtml="<table class='table table-bordered'>";
        listHtml+="<tr>";
        listHtml+="<td>번호</td>";
        listHtml+="<td>제목</td>";
        listHtml+="<td>작성자</td>";
        listHtml+="<td>작성일</td>";
        listHtml+="<td>조회수</td>";
        listHtml+="</tr>";

        $.each(data, function(index,obj){
                    listHtml+="<tr>";
                    listHtml+="<td>"+obj.idx+"</td>";
                    listHtml+="<td id='t"+obj.idx+"'><a href='javascript:goContent("+obj.idx+")'>"+obj.title+"</a></td>";
                    listHtml+="<td>"+obj.writer+"</td>";
                    listHtml+="<td>"+obj.indate.split(' ')[0]+"</td>";
                    listHtml+="<td id='cnt"+obj.idx+"'>"+obj.count+"</td>";
                    listHtml+="</tr>";

                    listHtml+="<tr id='c"+obj.idx+"' style='display:none'>";
                    listHtml+="<td>내용</td>";
                    listHtml+="<td colspan='4'>";
                    listHtml+="<textarea id='ta"+obj.idx+"' readonly rows='7' class='form-control'>"+obj.content+"</textarea>";


                    // 로그인 한 사람과 글쓴이가 같을때 수정 삭제 가능하게
                    // 세션에 넣은 ${memberVo.memberID} 와 글쓴이 obj.memberID 같을때
                    if("${memberVo.memberID}" == obj.memberID){


                    listHtml+="<br/>";
                    listHtml+="<span id='ub"+obj.idx+"'><button class='btn btn-success btn-sm' onclick='goUpdateForm("+obj.idx+")'>수정화면</button></span>&nbsp;";
                    listHtml+="<button class='btn btn-warning btn-sm' onclick='goDelete("+obj.idx+")'>삭제</button>";

                    }
                    else{
                        listHtml+="<br/>";
                        listHtml+="<span id='ub"+obj.idx+"'><button disabled class='btn btn-success btn-sm' onclick='goUpdateForm("+obj.idx+")'>수정화면</button></span>&nbsp;";
                        listHtml+="<button  disabled class='btn btn-warning btn-sm' onclick='goDelete("+obj.idx+")'>삭제</button>";

                    }

                    listHtml+="</td>";
                    listHtml+="</tr>";

                } );


                if(${!empty memberVo}) {
                    listHtml += "<tr>";
                    listHtml += "<td>";
                    listHtml += "</td>";
                    listHtml += "<td>";
                    listHtml += "</td>";
                    listHtml += "<td>";
                    listHtml += "</td>";
                    listHtml += "<td>";
                    listHtml += "</td>";
                    listHtml += "<td colspan='5' >";
                    listHtml += "<button class='btn btn-primary btn-sm' onclick='goForm()'>글쓰기</button>";
                    listHtml += "</td>";
                    listHtml += "</tr>";
                }
                    listHtml += "</table>";
                    $("#view").html(listHtml);

                    $("#view").css("display", "block");
                    $("#wfrom").css("display", "none");

             }

             function goList(){
               $("#view").css("display","block");
               $("#wfrom").css("display","none");
             }

             function goForm(){
                 $("#view").css("display","none");
                 $("#wfrom").css("display","block");
             }

             function goInsert(){
                let fData=$("#frm").serialize();
                $.ajax({
                     url: "board/new",
                     type: "post",
                     data: fData,
                     success: loadList,
                     error: function(request,error){
                         console.log(request.responseText);
                         console.log(error);
                     }
                });
             }

             function goContent(idx){
                if($("#c"+idx).css("display")=="none"){

                    $.ajax({
                        url:"board/"+idx,
                        type:"get",
                        data:{"idx":idx},
                        dataType:"json",
                        success:function(data){
                            $("#ta"+idx).val(data.content);
                        },
                        error: function(request,error){
                         console.log(request.responseText);
                         console.log(error);
                     }
                    });

                     $("#c"+idx).css("display","table-row");
                     $("#ta"+idx).css("readonly",true);
                }
                else{  //내용이 보였다 제목 다시 클릭할때 (닫을때)-> 조회수 증가
                    $("#c"+idx).css("display","none");

                    $.ajax({
                        url:"board/cnt/"+idx,
                        type:"put",
                        data:{"idx":idx},
                        dataType:"json",
                        success:function(data){
                            $("#cnt"+idx).text(data.count);
                        },
                         error: function(request,error){
                            console.log(request.responseText);
                            console.log(error);
                         }
                    });
                }
             }

             function goDelete(idx){
                $.ajax({
                    url:"board/"+idx,
                    type: "delete",
                    data: {"idx":idx},//내가 삭제한 글번호
                    success: loadList,
                    error: function(request,error){
                         console.log(request.responseText);
                         console.log(error);
                   }
                });
             }

             function goUpdateForm(idx){
                $("#ta" + idx).attr("readonly", false); //수정가능하게끔 폼을 만듬

                let title=$("#t"+idx).text();

                let newInput="<input type='text' id='nt"+idx+"' class='form-control' value='"+title+"'/>";
                $("#t"+idx).html(newInput);

                let newButton="<button class='btn btn-warning btn-sm' onclick='goUpdate("+idx+")'>수정</button>";
                $("#ub"+idx).html(newButton); //수정화면버튼 클릭하면 수정화면 버튼을 수정버튼으로 바꿈

             }

             function goUpdate(idx){
                 let title=$("#nt"+idx).val();
                 let content=$("#ta"+idx).val();
                  $.ajax({
                        url:"board/update",
                        type:"put",
                        contentType:'application/json;charset=utf-8',
                        data:JSON.stringify({"idx":idx,"title":title,"content":content}),
                        success:loadList,
                        error: function (request,error){
                               alert(request.responseText);
                               alert(error);
                         }
                  })
             }
</script>
</head>
<body>
   <div class="container">
       <jsp:include page="../always/header.jsp" />
        <h2>Spring Legacy</h2>
        <div class="panel panel-default">
            <div class="panel-heading">BOARD</div>
            <div class="panel-body" id="view">Panel Content</div>
            <div class="panel-body" id="wfrom" style="display: none">
             <form id="frm">
                    <input type="hidden" name="memberID" value="${memberVo.memberID}">
              <table class="table">
                 <tr>
                   <td>제목</td>
                   <td><input type="text" id="title" name="title" class="form-control"/></td>
                 </tr>
                 <tr>
                   <td>내용</td>
                   <td><textarea rows="7" class="form-control" id="content" name="content"></textarea> </td>
                 </tr>
                 <tr>
                   <td>작성자</td>
                   <td><input type="text" id="writer" name="writer" value="${memberVo.memberName}" readonly="readonly" class="form-control"/></td>
                 </tr>
                 <tr>
                   <td colspan="2" align="center">
                       <button type="button" class="btn btn-success btn-sm" onclick="goInsert()">등록</button>
                       <button type="reset" class="btn btn-warning btn-sm" id="fclear">취소</button>
                       <button type="button" class="btn btn-info btn-sm" onclick="goList()">리스트</button>
                   </td>
                 </tr>
              </table>
             </form>
            </div>
            <div class="panel-footer">비트캠프</div>
        </div>
   </div>
</body>
</html>