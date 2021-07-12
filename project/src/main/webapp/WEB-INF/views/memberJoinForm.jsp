<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="include/header.jsp" %>
<script>
$(document).ready(function() {
	var isCheckDupId = false;
	var checkId = "";
	// 회원가입 폼전송
	$("#frmJoin").submit(function() {
		if($("#user_pw").val() != $("#user_pw2").val()) {
			alert("비밀번호가 일치하지 않습니다.");
			$("#user_pw").focus();
		}
		
		if (isCheckDupId == false) {
			alert("아이디 중복 체크를 해주세요");
			$("#btnCheckDupId").focus();
			return false;
		}
	});
	//아이디 중복 확인버튼
	$("#btnCheckDupId").click(function() {
		var url = "/checkDupId";
		var user_id = $("#user_id").val();
		var sendData = {
				"user_id" : user_id
		};
		$.get(url, sendData, function(rData) {
			console.log(rData);
			if(rData == "true") {
				$("#checkDupIdResult").text("사용중인 아이디").css("color", "red");
			} else {
				$("#checkDupIdResult").text("사용 가능한 아이디").css("color", "blue");
				isCheckDupId = true;
				checkId = user_id;
			}
		});
		
	});
});
</script>
<div class="container-fluid">
	<div class="row">
		<div class="col-md-12">
			<div class="jumbotron">
				<h2>
					회원 가입
				</h2>
				<p>
					<a class="btn btn-primary btn-large" href="/loginForm">로그인</a>
				</p>
			</div>
			<form role="form" id="frmJoin" action="/memberJoinRun" method="post" enctype="multipart/form-data">
				<div class="form-group">
					<label for="user_id">
						아이디
					</label>
					<input type="text" class="form-control" id="user_id" name="user_id" required/>
					<br/>
					<button type="button" class="btn btn-sm btn-danger" id="btnCheckDupId">아이디 중복 확인</button>
					<span id="checkDupIdResult"></span>
				</div>
				<div class="form-group">
					<label for="user_pw">
						비밀번호
					</label>
					<input type="password" class="form-control" id="user_pw" name="user_pw" required/>
				</div>
				<div class="form-group">
					<label for="user_pw2">
						비밀번호 확인
					</label>
					<input type="password" class="form-control" id="user_pw2" required/>
				</div>
				<div class="form-group">
					<label for="user_name">
						이름
					</label>
					<input type="text" class="form-control" id="user_name" name="user_name"/>
				</div>
				<div class="form-group">
					<label for="user_pw">
						이메일
					</label>
					<input type="email" class="form-control" id="user_email" name="user_email"/>
				</div>
				<div class="form-group">
					<label for="file">
						사진
					</label>
					<input type="file" class="form-control-file" id="file" name="file" />
				</div>
				<button type="submit" class="btn btn-primary">
					가입완료
				</button>
			</form>
		</div>
	</div>
</div>
<%@ include file="include/footer.jsp" %>