<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.sql.*, com.javalab.vo.*" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%
   // 게시물 작성폼에서 파라미터 전달
   int bno = Integer.parseInt(request.getParameter("bno"));   // 게시물번호
    
    // 데이터베이스 드라이버 로딩 문자열 
    String JDBC_DRIVER = "oracle.jdbc.driver.OracleDriver";
    // 데이터베이스 연결 문자열
    String DB_URL = "jdbc:oracle:thin:@localhost:1521:orcl";
    String DB_USER = "mboard";
    String DB_PASSWORD = "1234";
    
    Connection conn = null;   // 커넥션 객체
    PreparedStatement pstmt = null;   // 쿼리문 생성 및 실행 객체
    ResultSet rs = null;   // 쿼리 실행 결과 반환 객체
    
    try {
        Class.forName(JDBC_DRIVER);   // jdbc 드라이버 로딩
        conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD); // 커넥션 객체 획득
        
        String sql = "delete board where bno=?" ;   // ? 동적파라미터
        
        pstmt = conn.prepareStatement(sql);   // PreparedStatement 객체 얻기(쿼리문 전달)
        pstmt.setInt(1, bno);         // bno   
        
        int row = pstmt.executeUpdate();   // 쿼리문 실행 영향 받은 행수 반환
        
        if (row > 0) {   // 정상 삭제
         System.out.println("게시물 삭제 성공");
         String contextPath = request.getContextPath();
         response.sendRedirect(contextPath + "/boardList.jsp");
        } else{
          out.println("<script>");
          out.println("alert('게시물 삭제에 실패했습니다.');");
          out.println("history.back();");   // 다시 게시물 상세페이지로 이동
          out.println("</script>");
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
%>
