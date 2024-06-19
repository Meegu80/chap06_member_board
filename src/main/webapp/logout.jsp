<%@page import="oracle.net.aso.l"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
			<head>
					<meta charset="UTF-8">
					<title> logout.jsp </title>
			</head>
			<body>
                   	        <h3>   </h3>
                   	        <%
                   	        // request 객체에서 세션 객체 얻기
                   	        HttpSession ses = request.getSession();
                   	        
                   	        // 세션에서 member라는 이름으로 저장된 객체 삭제
                   	        ses.removeAttribute("member");
                   	        // 세션 전체를 무효화
                   	        ses.invalidate();
                   	        
                   	        String contextPath = request.getContextPath();
                   	        response.sendRedirect(contextPath + "/loginForm.jsp");
                   	        	
                   	        %>
                   	        
                   	        
			</body>
</html>