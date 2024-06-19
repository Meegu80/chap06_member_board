<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.sql.*, com.javalab.vo.*" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%
   // message body 파라미터 인코딩
   request.setCharacterEncoding("utf-8");

   // 게시물 작성폼에서 파라미터 전달
    String title = request.getParameter("title");      // 제목
    String content = request.getParameter("content");   // 내용
    
    

    // 세션에서 로그인 사용자 아이디 갖고오기
    HttpSession ses = request.getSession();
    MemberVO memberVO = (MemberVO) ses.getAttribute("member");
    String memberId = memberVO.getMemberId();          // 사용자Id
    
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
        
        String sql = "insert into board(bno, title, content, member_id, reg_date, hit_no) " ;
        sql += " values(seq_board.nextval, ?, ?, ?, sysdate, 0)";
        
        pstmt = conn.prepareStatement(sql);   // PreparedStatement 객체 얻기(쿼리문 전달)
        pstmt.setString(1, title);      // 첫번째 ? 표에 파라미터 세팅
        pstmt.setString(2, content);   // 두번째 ? 표에 파라미터 세팅
        pstmt.setString(3, memberId);   
             
        int row = pstmt.executeUpdate();   // 쿼리문 실행해서 결과 전달 받기
        
        if (row > 0) {   // 정상저장
         System.out.println("게시물 저장 성공");
         String contextPath = request.getContextPath();
         response.sendRedirect(contextPath + "/boardList.jsp");
        } else{
          out.println("<script>");
          out.println("alert('게시물 등록에 실패했습니다.');");
          out.println("history.back();");
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

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>boardInsertProcess.jsp</title>
</head>
<body>
   
