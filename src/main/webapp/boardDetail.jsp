<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.sql.*, java.util.*, com.javalab.vo.*" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%
   // 게시물 번호(웹에서는 파라미터가 모두 문자열이므로 int 변환)
   int bno = Integer.parseInt(request.getParameter("bno"));

    // 데이터베이스 드라이버 로딩 문자열 
    String JDBC_DRIVER = "oracle.jdbc.driver.OracleDriver";
    // 데이터베이스 연결 문자열
    String DB_URL = "jdbc:oracle:thin:@localhost:1521:orcl";
    String DB_USER = "mboard";
    String DB_PASSWORD = "1234";
    
    Connection conn = null;   // 커넥션 객체
    PreparedStatement pstmt = null;   // 쿼리문 생성 및 실행 객체
    ResultSet rs = null;   // 쿼리 실행 결과 반환 객체
    
    BoardVO board = null;
    
    try {
        Class.forName(JDBC_DRIVER);   // jdbc 드라이버 로딩
        conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD); // 커넥션 객체 획득

        //조회수 증가 쿼리
        String updateHitSql = 
        	      "UPDATE board SET hit_no = hit_no + 1 WHERE bno = ?";
        	        pstmt = conn.prepareStatement(updateHitSql);
        	        pstmt.setInt(1, bno);
        	        pstmt.executeUpdate();
        	        pstmt.close();
		
        String sql = "select bno, title, content, member_id, reg_date, hit_no from board where bno=? " ;        
        pstmt = conn.prepareStatement(sql);   // PreparedStatement 객체 얻기(쿼리문 전달)
        pstmt.setInt(1, bno);
        rs = pstmt.executeQuery(); // 게시물 1건 반환
        
      if(rs.next()){
         board = new BoardVO();
         board.setBno(rs.getInt("bno"));
         board.setTitle(rs.getString("title"));
         board.setContent(rs.getString("content"));      // 게시물 내용
         board.setMemberId(rs.getString("member_id"));
         board.setRegDate(rs.getDate("reg_date"));
         board.setHitNo(rs.getInt("hit_no"));
         
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
    
    // 게시물목록을 현재 페이지 객체에 저장
    pageContext.setAttribute("board", board);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>boardList.jsp</title>
</head>
   <body>
   <table border="1">
      <tr>
         <th>게시물번호</th>
         <td>${board.bno }</td>
      </tr>
      <tr>   
         <th>제목</th>
         <td>${board.title }</td>
      </tr>
      <tr>   
         <th>내용</th>
         <td>${board.content }</td>
      </tr>
      <tr>      
         <th>작성자</th>
         <td>${board.memberId }</td>
      </tr>
      <tr>      
         <th>작성일자</th>
         <td>${board.regDate }</td>
      </tr>
      <tr>      
         <th>조회수</th>
         <td>${board.hitNo }</td>
      </tr>
   </table>
   <br>
   <a href="${contextPath }/boardList.jsp">목록</a>
   <a href="${contextPath }/boardUpdateForm.jsp?bno=${board.bno}">수정</a>
   <a href="${contextPath }/boardDelete.jsp?bno=${board.bno}">삭제</a>
   
   
</body>
</html>   
