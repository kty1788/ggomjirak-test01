<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp"%>
<!-- board/writeForm.jsp -->
<style>
	#fileDrop {
		width: 80%;
		height: 100px;
		background-color: yellow;
		margin: 20px auto;
		border: 2px dashed blue;
	}
	.divUploaded {
		width : 150px;
		float : left;
	}

</style>
<script src="/resources/js/my-script.js"></script>
<script>
$(document).ready(function() {
	$("#fileDrop").on("dragenter dragover", function(e) {
		e.preventDefault();
	})
	
	$("#fileDrop").on("drop", function(e) {
		e.preventDefault();
		console.log(e);
		var file = e.originalEvent.dataTransfer.files[0];
		console.log(file);
		// 이미지파일(바이너리 파일)
		// <form enctype="multipart/form-data">
		//			<input typ="file"/>
		// </form>
		var formData = new FormData(); // <form>
		formData.append("file", file); // <input type="file">
									  // -> 파일을 선택한 상태
									  
		var url = "/uploadAjax";
	    // 파일을 비동기 방식으로 전송
	    $.ajax({
	    	"processData" : false,
	    	"contentType" : false, 
	    	// 위에 두개 enctype="multipart/form-data"
	    	"url" : url,
	    	"method" : "post",
	    	"data" : formData,
	    	"success" : function(receivedData) {
	    		console.log(receivedData);
// 	    		var arrStr = receivedData.split("_");
//				var fileName = arrStr[1];
	    		var fileName = receivedData.substring(receivedData.lastIndexOf("_") + 1);
	    		var cloneDiv = $("#uploadedList").prev().clone();
	    		var img = cloneDiv.find("img");
	    		if (isImage(fileName)) {
		    		img.attr("src", "http://localhost/displayImage?fileName=" + receivedData);
	    		}
	    		cloneDiv.find("span").text(fileName);
	    		cloneDiv.find(".a_times").attr("href", receivedData);
// 	    		$("#modal-275796").trigger("click");
// 	    		//2초뒤에 실행되는 함수
// 	    		setTimeout(function() {
// 	    			$("#modal-container-275796 .close").trigger("click");
// 	    		}, 2000);
    			$("#uploadedList").append(cloneDiv.show());
	    	}
	    });
	});
	
	//첨부파일 삭제 링크
	$("#uploadedList").on("click", ".a_times", function(e) {
		e.preventDefault();
		var that = $(this);
		var fileName = $(this).attr("href");
		console.log(fileName);
		var url = "/deleteFile?fileName=" + fileName;
		$.get(url, function(rData) {
			console.log(rData)
			if (rData == "success") {
				that.parent().remove();
			}
		})
	});
	
	// 폼전송
	$("#frmWrite").submit(function() {
		var div = $("#uploadedList .divUploaded");
		$(this).find("[name^=files]").remove();
		div.each(function(index) {
			var fileName = $(this).find(".a_times").attr("href");
			var html = "<input type='hidden' name='files["+index+"]' value='" + fileName+"'/>";
			$("#frmWrite").prepend(html);
		});
// 		return false;
	})
});
</script>
<div class="container-fluid">
<!-- 파일 업로드 안내 모달 -->
	<div class="row">
		<div class="col-md-12">
			 <a id="modal-275796" href="#modal-container-275796" role="button" class="btn" data-toggle="modal" style="display:none">Launch demo modal</a>
			
			<div class="modal fade" id="modal-container-275796" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
				<div class="modal-dialog" role="document">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="myModalLabel">
								Modal title
							</h5> 
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">×</span>
							</button>
						</div>
						<div class="modal-body">
							...
						</div>
						<div class="modal-footer">
							 
							<button type="button" class="btn btn-primary">
								Save changes
							</button> 
							<button type="button" class="btn btn-secondary" data-dismiss="modal">
								Close
							</button>
						</div>
					</div>
					
				</div>
				
			</div>
			
		</div>
	</div>


	<div class="row">
		<div class="col-md-12">
			<div class="jumbotron">
				<h2>
					글쓰기
				</h2>
			</div>
			<div class="row">
				<div class="col-md-12">
					<form id="frmWrite" role="form" action="/board/writeRun" method="post">
<!-- 						<input type="hidden" name="user_id" value="kim"/> -->
						<div class="form-group">
							 
							<label for="b_title">
								글제목
							</label>
							<input type="text" class="form-control" id="b_title"  name="b_title"/>
						</div>
						<div class="form-group">
							 
							<label for="b_content">
								글내용
							</label>
							<textarea class="form-control" id="b_content" name="b_content"></textarea>
						</div>
						
						<!-- 첨부파일 -->
						
						<div>
							<label>첨부할 파일을 드래그 &amp; 드롭하세요.</label>
							<div id="fileDrop"></div>
						</div>
						<!-- //첨부파일 -->
						
						<div style="display:none;" class="divUploaded">
							<img height="100" src="/resources/img/default_image.png" class="img-rounded"/><br>
							<span>default</span>
							<a href="#" class="a_times">&times;</a>
						</div>
						<div id="uploadedList">
							
						</div>
						<div style="clear:left;">
							<button type="submit" class="btn btn-primary" > 
								작성완료
							</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
<%@ include file="../include/footer.jsp"%>