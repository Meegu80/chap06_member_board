<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.sql.*, java.util.*, com.javalab.vo.*" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

 <%
        List<BoardVO> boardList = new ArrayList<>();
        
        String JDBC_DRIVER = "oracle.jdbc.driver.OracleDriver";
        String DB_URL = "jdbc:oracle:thin:@localhost:1521:orcl";
        String DB_USER = "mboard";
        String DB_PASSWORD = "1234";
        
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            stmt = conn.createStatement();
            
            String sql = "SELECT bno, title, member_id, reg_date, hit_no FROM board ORDER BY bno desc";
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                BoardVO board = new BoardVO();
                board.setBno(rs.getInt("bno"));
                board.setTitle(rs.getString("title"));
                board.setMemberId(rs.getString("member_id"));
                board.setRegDate(rs.getDate("reg_date"));
        		board.setHitNo(rs.getInt("hit_no"));               
                boardList.add(board);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        pageContext.setAttribute("boardList", boardList);
    %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>boardList.jsp</title>
<style>
   	body, html {
        margin: 0;
        padding: 0;
    }
    .container {
        width: 100%;
    }
    .header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px;
        background-color: #f8f8f8;
        margin: 0;
    }
    nav {
        flex-grow: 1;
        text-align: center;
    }
    nav a {
        text-decoration: none;
        color: black;
        font-weight: bold;
    }
    .user-info {
        margin-right: 20px;
    }
    .user-info p {
        display: inline;
        margin-right: 10px;
    }
</style>
</head>
<body>
    <div class="container">
        <header class="header">
            <nav>
                <a href="#">게시물 목록</a>
            </nav>
            <div class="user-info">
                <c:if test="${not empty sessionScope.member}">
                    <p>${sessionScope.member.name} 님</p>
                    <a href="${contextPath}/logout.jsp">Logout</a>
                </c:if>
                <c:if test="${empty sessionScope.member}">
                    <a href="${contextPath}/loginForm.jsp">Login</a>
                </c:if>
            </div>
        </header>
        <main>
            <c:if test="${empty boardList}">
                <p>게시물이 존재하지 않습니다.</p>
            </c:if>
            
            <c:if test="${not empty boardList}">
                <table border="1">
                    <tr>
                        <th>게시물ID</th>
                        <th>제목</th>
                        <th>작성자</th>
                        <th>작성일자</th>
                        <th>조회수</th>
                    </tr>
                    <c:forEach var="board" items="${boardList}">
                        <tr>
                            <td>${board.bno}</td>
                            <td><a href="${contextPath}/boardDetail.jsp?bno=${board.bno}">${board.title}</a></td>
                            <td>${board.memberId}</td>
                            <td>${board.regDate}</td>
                            <td>${board.hitNo}</td>
                            
                        </tr>
                    </c:forEach>
                </table>
            </c:if>
            
            <a href="${contextPath}/boardInsertForm.jsp">게시물 작성</a>
        </main>
    </div>

   
</body>
</html>
