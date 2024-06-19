<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.sql.*, com.javalab.vo.*" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%
    String memberId = request.getParameter("memberId");
    String password = request.getParameter("password");
    
    String JDBC_DRIVER = "oracle.jdbc.driver.OracleDriver";
    String DB_URL = "jdbc:oracle:thin:@localhost:1521:orcl";
    String DB_USER = "mboard";
    String DB_PASSWORD = "1234";
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    boolean loginSuccess = false;
    MemberVO member = null;
    
    try {
        Class.forName(JDBC_DRIVER);
        conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        
        String sql = "SELECT member_id, name, email FROM member WHERE member_id = ? AND password = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, memberId);
        pstmt.setString(2, password);
        
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            loginSuccess = true;
            
            member = new MemberVO();
            member.setMemberId(rs.getString("member_id"));
            member.setName(rs.getString("name"));
            member.setEmail(rs.getString("email"));
            
            // 세션에 사용자 저장
            HttpSession ses = request.getSession();
            ses.setAttribute("member", member);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    String contextPath = request.getContextPath();
    
    if (loginSuccess) {
        response.sendRedirect(contextPath + "/index.jsp");
    } else {
        // out : JSP 페이지에 출력하는 객체로 기본적으로 제공 (PrintWriter)
        out.println("<script>");
        out.println("alert('아이디와 비밀번호를 확인하세요.');");
        out.println("history.back();");
        out.println("</script>");
    }
%>
