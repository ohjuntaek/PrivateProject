<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%
//Manage manage = Manage.getInstance();

String j = (String)request.getAttribute("content");
out.print(j);
out.print("1test2test3test4");
%>
<script>
console.log(<%=j%>);
</script>


</body>
</html>