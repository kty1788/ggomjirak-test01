<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../include/header.jsp"%>

<script>
$(function() {
	var msg = "${msg}";
	if (msg == "success") {
		alert("메일 전송 완료");
	}
});
</script>

<div class="container-fluid">
	<div class="row">
		<div class="col-md-12">
			<form role="form" action="/email/sendMail" method="post">
				<div class="form-group">

					<label for="to"> 받는 사람 이메일 </label> 
					<input name="to"
						type="email" class="form-control" id="to"  />
				</div>
				<div class="form-group">

					<label for="subject"> 제목 </label> 
					<input name="subject"
						type="text" class="form-control" id="subject" />
				</div>
				<div class="form-group">

					<label for="content"> 내용 </label> 
					<textarea name="content" id="content"
						class="form-control"></textarea>
				</div>
				
				<button type="submit" class="btn btn-primary">보내기</button>
			</form>
		</div>
	</div>
</div>

<%@ include file="../include/footer.jsp"%>