<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp"%>
<!-- board/content.jsp -->
<style>
	.red-class {color:red}
</style>
<script src="/resources/js/my-script.js"></script>
<script>
$(document).ready(function() {
	var msg = "${msg}";
	if (msg == "success") {
		alert("수정 완료");
	}
	
	
	$("#btnModify").click(function() {
		$("#btnModifyFinish").show(1000);
		$("[name^=b_]").prop("readonly", false);
	});
	
	$("#btnDelete").click(function() {
		if (confirm("삭제하시겠습니까?")) {
			location.href = "/board/deleteRun?b_no=${boardVo.b_no}"
		}
	});
	
	//목록 버튼
	$("#btnList").click(function() {
		location.href = "/board/listAll?page=${pagingDto.page}&perPage=${pagingDto.perPage}&searchType=${pagingDto.searchType}&keyword=${pagingDto.keyword}";
	});
	
	// 댓글 목록 버튼
	$("#btnCommentList").click(function() {
		// 비동기 요청 , $.ajax, $.get, $.post, $.getJSON
		var url = "/comment/getCommentList/${boardVo.b_no}";
// 		var sendData = {
// 				"b_no" : "${boardVo.b_no}"
// 		}
		$.get(url, function(receivedData) {
// 			console.log(receivedData);
			var cloneTr;
			$("#commentTable > tbody > tr:gt(0)").remove();
			$.each(receivedData, function() {
				var cloneTr = $("#commentTable > tbody > tr:first").clone();
				var td = cloneTr.find("td");
				td.eq(0).text(this.c_no);
				td.eq(1).text(this.c_content);
				td.eq(2).text(this.user_id);
				td.eq(3).text(changeDateString(this.c_regdate));
				td.eq(5).find("button").attr("data-cno", this.c_no);
				
				$("#commentTable > tbody").append(cloneTr);
				cloneTr.show("slow");
			})
		});
	})
	
	//댓글 입력 버튼
	$("#btnCommentInsert").click(function() {
		var c_content = $("#c_content").val();
		var b_no = parseInt("${boardVo.b_no}");
// 		var user_id = "hong";
		var url = "/comment/insertComment";
		var sendData = {
				"c_content" : c_content,
				"b_no" 	    : b_no,
		}
		$.ajax({
			"url" : url,
			"headers" : {
				"Content-Type" : "application/json"
			},
			"method" : "post",
			"dataType" : "text",
			"data" : JSON.stringify(sendData),// JSON.stringify() : json데이터를 문자열로 변환
			"success" : function(receivedData) {
				console.log(receivedData);
				// 처리가 잘 되었다면, 댓글 목록 버튼을 클릭시켜서 목록을 새로 얻음
				if(receivedData == "success") {
					$("#btnCommentList").trigger("click");
				}
			}
		});
	});
	
	// 댓글 수정 버튼
	// 비동기방식 등으로 추가된 엘리먼트(html소스에)에 대해서 이벤트 처리는 처음 로딩된 상태에서 존재하는 엘리먼트에 설정한다. (비동기방식으로 추가된건 html소스에 없기때문)
	// 아래거 반응 없음
	//$(".commentDelete").click(function() {
		//console.log("수정")
// 	});
	//on은 동적메소드
	$("#commentTable").on("click", ".commentModify", function() {
// 		console.log("수정");
		//모달창 보이기
		var c_no = $(this).parent().parent().find("td").eq(0).text();
		var c_content = $(this).parent().parent().find("td").eq(1).text();
		console.log(c_content);
		$(".modal-body > .c_content").val(c_content);
		$("#btnModalOk").attr("data-cno", c_no);
		$("#modal-370105").trigger("click");
	});
	
	// 모달 수정 완료 버튼
	$("#btnModalOk").click(function() {
		var c_no = $(this).attr("data-cno");
		var c_content = $(".modal-body > .c_content").val();
		var url = "/comment/updateComment";
		var sendData = {
				"c_no" : c_no,
				"c_content" : c_content
		}
		console.log(sendData);
		$.ajax({
			"url" : url,
			"headers" : {
				"Content-Type" : "application/json"
			},
			"method" : "post",
			"dataType" : "text",
			"data" : JSON.stringify(sendData),// JSON.stringify() : json데이터를 문자열로 변환
			"success" : function(receivedData) {
				console.log(receivedData);
				if(receivedData == "success") {
					$("#btnModalClose").trigger("click");
					$("#btnCommentList").trigger("click");
				}
			}
		});
	})
	
	// 댓글 삭제 버트
	$("#commentTable").on("click", ".commentDelete", function() {
		var c_no = $(this).attr("data-cno");
		var url = "/comment/deleteComment/" + c_no + "/${boardVo.b_no}";
		if (confirm("댓글을 삭제하시겠어요?")) {
			$.get(url, function(receivedData) {
				console.log(receivedData);
				if (receivedData == "success") {
					$("#btnCommentList").trigger("click");
				}
			});
		}
	});
	
	//좋아요 부분
	$("#likeSpan").click(function() {
		
		var url = "/clickLike?b_no=" + ${boardVo.b_no };
		$.get(url, function(rData) {
			console.log(rData);
			if (rData.heart == "1") {
				$("#likeSpan").addClass("red-class");
				$("#likeCount").text(rData.likeCount);
			} else if (rData.heart == "0") {
				$("#likeSpan").removeClass("red-class");
				$("#likeCount").text(rData.likeCount);
			}
		})
	});
	
});
</script>
<!-- 모달창 -->
	<div class="row">
		<div class="col-md-12">
			 <a style="display:none" id="modal-370105" href="#modal-container-370105" role="button" class="btn" data-toggle="modal">Launch demo modal</a>
			
			<div class="modal fade" id="modal-container-370105" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
				<div class="modal-dialog" role="document">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="myModalLabel">
								댓글 수정
							</h5> 
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">×</span>
							</button>
						</div>
						<div class="modal-body">
							<input type="text" class="form-control c_content"/>
						</div>
						<div class="modal-footer">
							 
							<button type="button" class="btn btn-primary" id="btnModalOk">
								수정완료
							</button> 
							<button type="button" class="btn btn-secondary" data-dismiss="modal" id="btnModalClose">
								닫기
							</button>
						</div>
					</div>
					
				</div>
				
			</div>
			
		</div>
	</div>
<!-- //모달창 -->
<div class="container-fluid">
	<div class="row">
		<div class="col-md-12">
			<div class="jumbotron">
				<h2>글 내용보기</h2>
			</div>
			<div class="row">
				<div class="col-md-12">
					<form role="form" action="/board/modifyRun" method="post">
<!-- 						<input type="hidden" name="user_id" value="hong" /> -->
							<input type="hidden" name="b_no" value="${boardVo.b_no }" />
						<div class="form-group">

							<label for="b_title"> 글제목 </label> <input type="text"
								class="form-control" id="b_title" name="b_title"
								value="${boardVo.b_title }" readonly />
						</div>
						<div class="form-group">

							<label for="b_content"> 글내용 </label>
							<textarea class="form-control" id="b_content" name="b_content"
								readonly>${boardVo.b_content }</textarea>
						</div>
						<button type="button" class="btn btn-primary" id="btnModify">수정</button>
						<button type="submit" class="btn btn-success"
							style="display: none" id="btnModifyFinish">수정완료</button>
						<button type="button" class="btn btn-danger" id="btnDelete">삭제</button>
						<button type="button" class="btn btn-warning" id="btnList">목록</button>
<!-- 						<button type="button" class="btn btn-outline-secondary"> -->
<!--               			  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" style="color:gray" fill="currentColor" class="bi bi-heart-fill" viewBox="0 0 16 16"> -->
<!--   						  <path fill-rule="evenodd" d="M8 1.314C12.438-3.248 23.534 4.735 8 15-7.534 4.736 3.562-3.248 8 1.314z"></path> -->
<!-- 						  </svg><span style="color:gray">(10)</span> -->
<!--               			</button> -->
						<span style="margin-left:50px" id="likeSpan" class= "${isLike == 'true' ? 'red-class' : ''}">
						<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-heart-fill" viewBox="0 0 16 16">
  						<path fill-rule="evenodd" d="M8 1.314C12.438-3.248 23.534 4.735 8 15-7.534 4.736 3.562-3.248 8 1.314z"/>
						</svg>(<span id="likeCount">${boardVo.like_count }</span>)
						</span>
					</form>
				</div>
			</div>

			<div class="row">
				<div class="col-md-12">
					<hr />
					<button type="button" class="btn btn-info" id="btnCommentList">댓글목록</button>
					<hr />
				</div>
			</div>
			<div class="row">
				<div class="col-md-2"></div>
				<div class="col-md-8">
					<input type="text" class="form-control" placeholder="댓글을 입력하세요..."
						id="c_content" />
				</div>
				<div class="col-md-2">
					<button type="button" class="btn btn-primary" id="btnCommentInsert">입력</button>
				</div>
			</div>
			<div class="row">
				<div class="col-md-12">
					<table class="table" id="commentTable">
						<tbody>
							<tr style="display: none;">
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td><button type="button" class="btn btn-sm btn-warning commentModify" >수정</button></td>
								<td><button type="button" class="btn btn-sm btn-danger commentDelete">삭제</button></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
<%@ include file="../include/footer.jsp"%>