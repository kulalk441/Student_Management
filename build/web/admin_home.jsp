<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Portal</title>
    <link rel="stylesheet" href="styles.css">

    <style>
        #customers {
            font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }
        #customers td, #customers th {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        #customers tr:nth-child(even) { background-color: #f2f2f2; }
        #customers tr:hover { background-color: #ddd; }
        #customers th {
            padding-top: 12px;
            padding-bottom: 12px;
            background-color: #4CAF50;
            color: white;
        }
    </style>
</head>

<body>

<%
    // session username
    String user = request.getParameter("username");
    if (user != null) {
        session.setAttribute("uname", user);
    }
    String username = (String) session.getAttribute("uname");

    // DB variables
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>

<div class="divide" style="background-color:#43425D; left:0">
    <div style="color:white;font-size:20px;font-family:sans-serif;text-align:center;margin-top:20px;margin-bottom:25px;">
        ABC Institute
    </div>
    <hr>
    <ul>
        <li><a href="admin_home.jsp" class="active">Home</a></li>
        <li><a href="enroll_student.jsp">Enroll Student</a></li>
        <li><a href="enroll_faculty.jsp">Enroll Faculty</a></li>
        <li><a href="notices.jsp">Notices</a></li>
        <li><a href="student_details.jsp">Student Details</a></li>
        <li><a href="faculty_details.jsp">Faculty Details</a></li>
        <li><a href="course_register.jsp">Course Registration</a></li>
        <li><a href="course_details.jsp">Course Details</a></li>
        <li><a href="index.jsp">Sign Out</a></li>
    </ul>
</div>

<!-- RIGHT SIDE ADMIN INFO -->
<div class="divide facutly_info_right">
<%
    try {
        Class.forName("com.mysql.jdbc.Driver");

        // admin info from faculty_login.admin
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/faculty_login",
            "root",
            "root"
        );

        ps = con.prepareStatement("SELECT username,password FROM admin WHERE username=?");
        ps.setString(1, username);
        rs = ps.executeQuery();

        if (rs.next()) {
%>
        <p align="center" class="facutly_info">
            Welcome Admin : <b><%= username %></b>
        </p>
<%
        } else {
%>
        <p align="center" class="facutly_info" style="color:red">
            Admin not found in database!
        </p>
<%
        }

        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        out.println("<p style='color:red;text-align:center;'>Error: " + e.getMessage() + "</p>");
    }
%>
</div>

<!-- CENTER TABLES -->
<div class="divide" style="left:25%; width:60%; height:85%; top:8%; overflow:auto">

    <!-- STUDENT LIST -->
    <div style="width:48%; float:left;">
        <table id="customers">
            <tr><th colspan="2">Student Details</th></tr>
            <tr>
                <th>Username</th>
                <th>Name</th>
            </tr>

<%
    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/student_login",
            "root",
            "root"
        );

        ps = con.prepareStatement("SELECT username,fname,lname FROM login");
        rs = ps.executeQuery();

        while (rs.next()) {
%>
            <tr>
                <td><%= rs.getString("username") %></td>
                <td><%= rs.getString("fname") %> <%= rs.getString("lname") %></td>
            </tr>
<%
        }

        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
%>
            <tr>
                <td colspan="2" style="color:red;">Error loading students</td>
            </tr>
<%
    }
%>
        </table>
    </div>

    <!-- FACULTY LIST -->
    <div style="width:48%; float:right;">
        <table id="customers">
            <tr><th colspan="2">Faculty Details</th></tr>
            <tr>
                <th>Username</th>
                <th>Name</th>
            </tr>

<%
    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/faculty_login",
            "root",
            "root"
        );

        ps = con.prepareStatement("SELECT username,fname,lname FROM login");
        rs = ps.executeQuery();

        while (rs.next()) {
%>
            <tr>
                <td><%= rs.getString("username") %></td>
                <td><%= rs.getString("fname") %> <%= rs.getString("lname") %></td>
            </tr>
<%
        }

        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
%>
            <tr>
                <td colspan="2" style="color:red;">Error loading faculty</td>
            </tr>
<%
    }
%>
        </table>
    </div>

</div>

</body>
</html>
