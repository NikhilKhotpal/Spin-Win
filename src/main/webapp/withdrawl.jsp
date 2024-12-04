<%@page import="java.io.PrintWriter"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
String jdbcUrl = "jdbc:mysql://localhost:3306/spin";
String dbUser = "root";
String dbPassword = "";

int amountToWithdraw = Integer.parseInt(request.getParameter("withdraw_amount"));
Integer userId = (Integer) request.getSession().getAttribute("userId"); // Assuming userId is stored in session

try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword)) {
    String sql = "UPDATE users1 SET withdraw_amount = withdraw_amount - ? WHERE id = ?";
    PreparedStatement pstmt = conn.prepareStatement(sql);
    pstmt.setDouble(1, amountToWithdraw);
    pstmt.setInt(2, userId);
    
    int rowsAffected = pstmt.executeUpdate();
    response.setContentType("application/json");
    PrintWriter t = response.getWriter();

    if (rowsAffected > 0) {
        out.print("{\"success\": true}");
    } else {
        out.print("{\"success\": false, \"message\": \"Withdrawal failed.\"}");
    }
} catch (Exception e) {
    e.printStackTrace();
    response.setContentType("application/json");
    PrintWriter t = response.getWriter();
    out.print("{\"success\": false, \"message\": \"An error occurred while processing your request.\"}");
}

%>
</body>
</html>