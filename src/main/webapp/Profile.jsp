<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Update Profile</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            font-family: 'Arial', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .profile-form-container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            width: 400px;
            text-align: center;
        }

        h1 {
            margin-bottom: 20px;
            font-size: 24px;
            color: #333;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 10px;
            color: #333;
            text-align: left;
        }

        input[type="text"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
            background-color: #f9f9f9;
            transition: border-color 0.3s;
        }

        input[type="text"]:focus {
            border-color: deepskyblue;
            outline: none;
        }

        input[type="submit"] {
            width: 100%;
            background-color: deepskyblue;
            color: white;
            border: none;
            padding: 12px;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        input[type="submit"]:hover {
            background-color: dodgerblue;
        }
    </style>
</head>
<body>
<%
Integer id = (Integer) session.getAttribute("id");
String fname = (String) session.getAttribute("fname");
String phone = (String) session.getAttribute("contact");
%>

<div class="profile-form-container">
    <h1>Update Profile</h1>
    <form action="updateservlet" method="post">
        <!-- Hidden input for ID -->
        <input type="text" name="id" value="<%=id %>">
        <%System.out.println("id"+id); %>
        <label for="fname">UserName</label>
        <input type="text" id="fname" name="fname" value="<%=fname %>">

        <label for="phone">Phone</label>
        <input type="text" id="phone" name="phone" value="<%=phone %>">

        <input type="submit" value="Update">
    </form>
</div>

</body>
</html>
