<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Logout</title>
<!-- Prevent caching -->
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies
%>
<!-- Disable back button script -->
<script type="text/javascript">
    window.history.pushState(null, "", window.location.href);  // Push current state to history
    window.onpopstate = function () {
        // If the user presses the back button, this will prevent them from going back
        window.history.pushState(null, "", window.location.href);
    };
</script>
</head>
<body>
<%
    // Before redirecting to the registration page
    String message = "Login Again To get your data!";
    String encodedMessage = java.net.URLEncoder.encode(message, "UTF-8"); // Encode the message to pass it via URL
    response.sendRedirect("UserRegister.jsp?message=" + encodedMessage);
%>

</body>
</html>
