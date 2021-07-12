<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>do_e.jsp</h1>
	<h2>${productVo }</h2>
	<h2>${productVo2 }</h2>
	<table>
		<thead>
			<tr>
				<th>이름</th>
				<th>가격</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>${productVo.name }</td>
				<td>${productVo.price }</td>
			</tr>
			<tr>
				<td>${productVo2.name }</td>
				<td>${productVo2.price }</td>
			</tr>
		</tbody>
	</table>
</body>
</html>