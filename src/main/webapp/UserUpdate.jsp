<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Profile Update Result</title>
</head>
<body>
<%
    // Get the submitted form data
    String updatedName = request.getParameter("fname");
    String updatedPhone = request.getParameter("phone");
    String userIdStr = request.getParameter("userID"); // Get userID as a String first
    int userId = 0;

    // Check if userIdStr is not null and is a valid integer
    if (userIdStr != null && !userIdStr.isEmpty()) {
        try {
            userId = Integer.parseInt(userIdStr); // Try parsing it
        } catch (NumberFormatException e) {
            out.println("Invalid user ID format.");
            return; // Stop further processing if userID is invalid
        }
    } else {
        out.println("User ID is missing.");
        return; // Stop processing if userID is missing
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // Establish the database connection
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/spin", "root", "");

        // SQL query to update the user profile
        String sql = "UPDATE reguser SET fname = ?, phone = ? WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, updatedName);
        pstmt.setString(2, updatedPhone);
        pstmt.setInt(3, userId);

        int rowsUpdated = pstmt.executeUpdate();
        if (rowsUpdated > 0) {
            // Update the session attributes with the new values
            session.setAttribute("fname", updatedName);
            session.setAttribute("contact", updatedPhone);

            // Redirect to the dashboard or the same page
            response.sendRedirect("Dashboard.jsp?success=true");
        } else {
            response.sendRedirect("Profile.jsp?error=true");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("Profile.jsp?error=true");
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
</body>
</html>
