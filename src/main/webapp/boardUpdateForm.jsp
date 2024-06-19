<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.sql.*, java.util.*, com.javalab.vo.*" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>boardUpdateForm.jsp</title>
<style>
    body {
        font-family: Arial, sans-serif;
    }
    form {
        width: 600px;
        margin: 0;
    }
    div {
        margin-bottom: 10px;
    }
    label {
        display: inline-block;
        width: 50px;
        vertical-align: top;
    }
    input[type="text"], textarea {
        width: calc(100% - 60px);
        padding: 5px;
        border: 1px solid #000;
        box-sizing: border-box;
    }
    textarea {
        height: 100px;
    }
</style>
</head>
<body>
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

    <c:if test="${not empty sessionScope.member}">
        <h3>게시물 수정</h3>
        <form action="${contextPath}/boardUpdateProcess.jsp" method="post">
        <input type="hidden" name="bno" value="1">
            <div>
                <label for="title">제목</label>
                <input type="text" id="title" name="title"  value="${board.title }" required>
            </div>
            <div>
                <label for="content">내용</label>
                <textarea id="content" name="content"  required>${board.content }</textarea>
            </div>
            <div>
                <input type="submit" value="저장">
                <input type="reset" value="다시쓰기">
            </div>
        </form>
    </c:if>
    <c:if test="${empty sessionScope.member}">
        <script>
            alert('회원만 게시물을 작성할 수 있습니다.');
            window.location.href = "${contextPath}/loginForm.jsp";
        </script>
    </c:if>
</body>
</html>
