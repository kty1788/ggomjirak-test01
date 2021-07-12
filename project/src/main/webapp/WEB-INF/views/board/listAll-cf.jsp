<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css" integrity="sha384-GJzZqFGwb1QTTN6wy59ffF1BuGJpLSa9DkKMp0DgiMDm4iYMj70gZWKYbI706tWS" crossorigin="anonymous"/>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<title>BoardList.jsp</title>
<script>
$(document).ready(function() {
	var msg = "${msg}";
	if (msg == "success") {
		alert("글 등록 완료");
	}
	
	var msgDelete = "${msgDelete}";
	if (msgDelete == "success") {
		alert("삭제완료");
	}
	
	$(".pagination > li > a").click(function(e) {
		e.preventDefault(); // 페이지 이동 막기
		var page = $(this).attr("href");
		var frmPaging = $("#frmPaging");
		frmPaging.find("[name=page]").val(page);
		frmPaging.submit();
	});
	
	$(".searchType").click(function(e) {
		e.preventDefault();
		var searchType = $(this).attr("href");
		$("#frmPaging > input[name=searchType]").val(searchType);
		$("#spanSearchType").text($(this).text());
	});
	
	// 검색버튼
	$("#btnSearch").click(function() {
		var searchType = $("#frmPaging > input[name=searchType]").val();
		if (searchType == "") {
			alert("검색 옵션을 먼저 선택해 주세요");
			return;
		}
		var keyword = $("#txtSearch").val().trim();
		if (keyword == "") {
			alert("검색어를 입력해 주세요");
			return;
		}
		
		$("#frmPaging > input[name=keyword]").val(keyword);
		$("#frmPaging > input[name=page]").val("1");
		$("#frmPaging").submit();
	});
});
</script>
</head>
<body>
<footer class = "bg-dark mt-4 p-5 text-center" style="color:#ffffff;">
	Copyright &copy; 2021 하윤지 All Rights Reserved.
</footer>
<form id="frmPaging" action="/board/listAll" method="get">
	<input type="hidden" name="page" value="${pagingDto.page }"/>
	<input type="hidden" name="perPage" value="${pagingDto.perPage }"/>
	<input type="hidden" name="searchType" value="${pagingDto.searchType }"/>
	<input type="hidden" name="keyword" value="${pagingDto.keyword }"/>
</form>

<div class="container-fluid">
<div class="form-group row justify-content-center">

			<div  style="padding-right:10px">

				<select class="form-control form-control-sm" name="searchType" id="searchType">

					<option value="title">제목</option>

					<option value="Content">본문</option>

					<option value="reg_id">작성자</option>

				</select>

			</div>

			<div style="padding-right:10px">

				<input type="text" class="form-control form-control-sm" name="keyword" id="keyword" placeholder="내용을 입력하세요">

			</div>

			<div>

				<button class="btn btn-sm btn-primary" name="btnSearch" id="btnSearch">검색</button>

			</div>

		</div>



	<div class="row">
		<div class="col-md-12">
			<div class="jumbotron">
				<h2>글목록</h2>
				<p>
					<a class="btn btn-primary btn-large" href="/board/writeForm">글쓰기</a>
				</p>
			</div>

			<!-- 검색 -->
	<div class="row">
		<div class="col-md-12">
			<div class="dropdown">
				 
				<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown">
					검색옵션
				</button>
				<span id="spanSearchType" style="color:#336699; font-weight:bold" >
				<c:choose>
					<c:when test="${pagingDto.searchType == 't' }">제목</c:when>
					<c:when test="${pagingDto.searchType == 'c' }">내용</c:when>
					<c:when test="${pagingDto.searchType == 'u' }">작성자</c:when>
					<c:when test="${pagingDto.searchType == 'tc' }">제목+내용</c:when>
					<c:when test="${pagingDto.searchType == 'tcu' }">제목+내용+작성자</c:when>
				</c:choose>
				</span>
				<div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
					 <a class="dropdown-item searchType" href="t">제목</a> 
					 <a class="dropdown-item searchType" href="c">내용</a> 
					 <a class="dropdown-item searchType" href="u">작성자</a> 
					 <a class="dropdown-item searchType" href="tc">제목+내용</a> 
					 <a class="dropdown-item searchType" href="tcu">제목+내용+작성자</a>
				</div>
				<form
                     class="d-none d-sm-inline-block form-inline mr-auto ml-md-3 my-2 my-md-0 mw-100 navbar-search">
                     <div class="input-group">
                         <input type="text" class="form-control bg-light border-0 small" placeholder="검색어 입력.."
                             aria-label="Search" aria-describedby="basic-addon2" id="txtSearch" value="${pagingDto.keyword }">
                         <div class="input-group-append">
                             <button class="btn btn-primary" type="button" id="btnSearch">
                                 <i class="fas fa-search fa-sm"></i>
                             </button>
                         </div>
                     </div>
                 </form>
			</div>
		</div>
	</div>

	<!-- // 검색 -->
			<!-- 데이터 목록 -->
			<section class="container">
				<table class="table table-striped table-sm">
						<thead>
							<tr>
								<th>글번호</th>
								<th>글제목</th>
								<th>작성자</th>
								<th>작성일</th>
								<th>조회수</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="boardVo" items="${list }">
								<tr>
									<td>${boardVo.b_no }</td>
									<td><a href="/board/content?b_no=${boardVo.b_no }">${boardVo.b_title }</a></td>
									<td>${boardVo.user_id }</td>
									<td>${boardVo.b_regdate }</td>
									<td>${boardVo.b_viewcnt }</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
			</section>
			<div class="row">
				<div class="col-md-12">
					<table class="table table-striped table-sm">
						<thead>
							<tr>
								<th>글번호</th>
								<th>글제목</th>
								<th>작성자</th>
								<th>작성일</th>
								<th>조회수</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="boardVo" items="${list }">
								<tr>
									<td>${boardVo.b_no }</td>
									<td><a href="/board/content?b_no=${boardVo.b_no }">${boardVo.b_title }</a></td>
									<td>${boardVo.user_id }</td>
									<td>${boardVo.b_regdate }</td>
									<td>${boardVo.b_viewcnt }</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	<!-- //데이터 목록 -->
		<!-- 페이징-->
		<div class="row">
		<div class="col-md-12">
			<nav>
				<ul class="pagination">
				<c:if test="${pagingDto.startPage != 1 }">
					<li class="page-item">
						<a class="page-link" href="${pagingDto.startPage - 1}">&laquo;</a>
					</li>
				</c:if>
				<c:forEach var="v" begin="${pagingDto.startPage}" end="${pagingDto.endPage}">
					<li class="page-item">
						<a class="page-link" href="${v }">${v }</a>
					</li>
				</c:forEach>
				<c:if test="${pagingDto.endPage < pagingDto.totalPage }">
					<li class="page-item">
						<a class="page-link" href="${pagingDto.endPage + 1}">&raquo;</a>
					</li>
				</c:if>
				</ul>
			</nav>
		</div>
	</div>
	<!-- //페이징-->
	
	
</div>
</body>
</html>