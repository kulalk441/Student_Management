<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Faculty Portal</title>
    <link rel="stylesheet" href="styles.css">
</head>

<body>
<%
    String user = request.getParameter("username");
    if (user != null) {
        session.setAttribute("uname", user);
    }
    String username = (String) session.getAttribute("uname");

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String qr = null;
%>

<div class="divide" style="background-color: #43425D; left: 0">
    <div style="color:white;font-size: 20px; font-family: sans-serif;display: block;text-align: center;
         margin-top: 20px; margin-bottom: 25px;">ABC Insitute</div>
    <hr>
    <ul>
        <li><a href="admin_home.jsp">Home</a></li>
        <li><a href="enroll_student.jsp" class="active">Enroll Student</a></li>
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
    <br><br>
    <p align="center" class="facutly_info">
    <%
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/faculty_login", "root", "root");

            // NOTE: admin table has only username,password (in your SQL file)
            // so we will just display admin username
    %>
            Welcome Admin : <b><%= username %></b>
            <br><br>
    <%
            con.close();
        } catch (Exception e) {
            out.println("<span style='color:red'>Error: " + e.getMessage() + "</span>");
        }
    %>
    </p>
</div>

<!-- CENTER STUDENT REGISTRATION FORM -->
<div class="divide" style="left: 22%; width: 56%; background:#ECF0F1; top: 1%; height: 99%;
     right: 25%; overflow-x: hidden; overflow-y: auto">

    <p align="center" style="font-family: sans-serif;font-size: 25px;top: 0%">
        <strong>Student Registration Form</strong>
    </p>

    <form action="enrollStudent" method="post">
        <table align="center">
            <tr>
                <td>
                    <p style="font-family: sans-serif; font-size: 20px; color: darkslategrey">
                        <strong>First Name :</strong>
                    </p>
                </td>
                <td><input type="text" name="fname"></td>
            </tr>

            <tr>
                <td>
                    <p style="font-family: sans-serif; font-size: 20px; color: darkslategrey">
                        <strong>Last Name :</strong>
                    </p>
                </td>
                <td><input type="text" name="lname"></td>
            </tr>

            <tr>
                <td>
                    <p style="font-family: sans-serif; font-size: 20px; color: darkslategrey">
                        <strong>Username :</strong>
                    </p>
                </td>
                <td><input type="text" name="username"></td>
            </tr>

            <tr>
                <td>
                    <p style="font-family: sans-serif; font-size: 20px; color: darkslategrey">
                        <strong>Set Password :</strong>
                    </p>
                </td>
                <td><input type="text" name="password"></td>
            </tr>

            <tr>
                <td>
                    <p style="font-family: sans-serif; font-size: 20px; color: darkslategrey">
                        <strong>Department :</strong>
                    </p>
                </td>
                <td><input type="text" name="department" autocomplete="on"></td>
            </tr>

            <tr>
                <td>
                    <p style="font-family: sans-serif; font-size: 20px; color: darkslategrey">
                        <strong>Roll Number :</strong>
                    </p>
                </td>
                <td><input type="text" name="roll"></td>
            </tr>
        </table>

        <br>
        <input type="submit" value="Register Student">
    </form>

</div>

</body>
</html>
