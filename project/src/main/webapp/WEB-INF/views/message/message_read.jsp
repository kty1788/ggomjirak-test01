<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<div class="container-fluid">
	<div class="row">
		<div class="col-md-12">
			<table class="table">
				<tbody>
					<tr>
						<th>#</th>
						<td>${messageVo.msg_no }</td>
					</tr>
					<tr>
						<th>쪽지내용</th>
						<td>${messageVo.msg_content}</td>
					</tr>
					<tr>
						<th>보낸사람</th>
						<td>${messageVo.msg_sender}</td>
					</tr>
					<tr>
						<th>보낸날짜</th>
						<td>${messageVo.msg_senddate}</td>
					</tr>
					<tr>
						<th>읽은날짜</th>
						<td>${messageVo.msg_opendate}</td>
					</tr>
				</tbody>
			</table>
			<a href="/message/deleteMessage?msg_no=${messageVo.msg_no}" class="btn btn-sm btn-danger">삭제</a>
			<a href="#replyModal" class="btn btn-sm btn-warning" data-toggle="modal">답장</a>
			<a href="/message/messageListReceive" class="btn btn-sm btn-primary">목록</a>
		</div>
	</div>
</div>

		<div class="modal fade" id="replyModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
				<div class="modal-dialog" role="document">
				<form action="/message/replyMessage" method="post">
					<input type="hidden" name="msg_receiver" value="${messageVo.msg_sender}"/>
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="myModalLabel">
								답장보내기
							</h5> 
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">×</span>
							</button>
						</div>
						<div class="modal-body">
							<input type="text" class="form-control" id="msg_content" name="msg_content"/>
						</div>
						<div class="modal-footer">
							 
							<button type="submit" class="btn btn-primary" id="btnReply">
								보내기
							</button> 
							<button type="button" class="btn btn-secondary" data-dismiss="modal">
								닫기
							</button>
						</div>
					</div>
					</form>
				</div>
				
			</div>
<%@ include file="../include/footer.jsp" %>