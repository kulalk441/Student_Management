<%-- 
    Document   : enroll_faculty
    Created on : 7 Oct, 2018, 5:54:59 PM
    Author     : Harsh Jain
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Faculty Portal</title>
    <link rel="stylesheet" href="styles.css">
    <script>
        function update_details() {
            alert("Please contact the administrator to update details!");
        }
    </script>
</head>

<body>
<%
    String user = request.getParameter("username");
    if (user != null) {
        session.setAttribute("uname", user);
    }

    String username = (String) session.getAttribute("uname");
%>

<div class="divide" style="background-color: #43425D; left: 0">
    <div style="color:white;font-size: 20px; font-family: sans-serif;display: block;text-align: center;
         margin-top: 20px; margin-bottom: 25px;">ABC Insitute</div>
    <hr>
    <ul>
        <li><a href="admin_home.jsp">Home</a></li>
        <li><a href="enroll_student.jsp">Enroll Student</a></li>
        <li><a href="enroll_faculty.jsp" class="active">Enroll Faculty</a></li>
        <li><a href="notices.jsp">Notices</a></li>
        <li><a href="student_details.jsp">Student Details</a></li>
        <li><a href="faculty_details.jsp">Faculty Details</a></li>
        <li><a href="course_register.jsp">Course Registration</a></li>
        <li><a href="course_details.jsp">Course Details</a></li>
        <li><a href="index.jsp">Sign Out</a></li>
    </ul>
</div>

<div class="divide facutly_info_right">

    <br><br>

    <!-- ✅ Remove admin image section (because admin table has no image_path column) -->

    <form action="update_admin_image.jsp">
        <input type="submit" value="Update Image">
    </form>

    <br><br>

    <p align="center" class="facutly_info">
        <%
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.jdbc.Driver");

                con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/faculty_login",
                        "root",
                        "root"
                );

                String qr = "select username from admin where username=?";
                ps = con.prepareStatement(qr);
                ps.setString(1, username);
                rs = ps.executeQuery();

                if (rs.next()) {
        %>
                    Welcome Admin : <b><%= rs.getString("username") %></b>
        <%
                } else {
        %>
                    <b>Admin not found in database!</b>
        <%
                }

            } catch (Exception e) {
                out.println("<b style='color:red;'>Error: " + e.getMessage() + "</b>");
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (ps != null) ps.close(); } catch (Exception e) {}
                try { if (con != null) con.close(); } catch (Exception e) {}
            }
        %>

        <br><br>

        <form onsubmit="update_details(); return false;">
            <input type="submit" value="Update Details">
        </form>
    </p>
</div>

<div class="divide"
     style="left: 22%; width: 56%; background:#ECF0F1; top: 1%; height: 99%;right: 25%; overflow-x: auto; overflow-y: auto">

    <p align="center" style="font-family: sans-serif;font-size: 25px">
        <strong>Faculty Registration Form</strong>
    </p>

    <form action="enrollFaculty" method="post">
        <table align="center">
            <tr>
                <td>
                    <p style="font-family: sans-serif; font-size: 20px; color: darkslategrey">
                        <strong>First Name :</strong>
                    </p>
                </td>
                <td><input type="text" name="fname" required></td>
            </tr>

            <tr>
                <td>
                    <p style="font-family: sans-serif; font-size: 20px; color: darkslategrey">
                        <strong>Last Name :</strong>
                    </p>
                </td>
                <td><input type="text" name="lname" required></td>
            </tr>

            <tr>
                <td>
                    <p style="font-family: sans-serif; font-size: 20px; color: darkslategrey">
                        <strong>Username :</strong>
                    </p>
                </td>
                <td><input type="text" name="username" required></td>
            </tr>

            <tr>
                <td>
                    <p style="font-family: sans-serif; font-size: 20px; color: darkslategrey">
                        <strong>Set Password :</strong>
                    </p>
                </td>
                <td><input type="text" name="password" required></td>
            </tr>

            <tr>
                <td>
                    <p style="font-family: sans-serif; font-size: 20px; color: darkslategrey">
                        <strong>Department :</strong>
                    </p>
                </td>
                <td><input type="text" name="department" required></td>
            </tr>

            <tr>
                <td>
                    <p style="font-family: sans-serif; font-size: 20px; color: darkslategrey">
                        <strong>Age :</strong>
                    </p>
                </td>
                <td><input type="text" name="age" required></td>
            </tr>
        </table>

        <br>
        <input type="submit" value="Register Faculty">
    </form>
</div>

</body>
</html>
