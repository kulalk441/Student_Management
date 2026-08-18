<%-- 
    Document   : notices
    Created on : 13 Oct, 2018, 6:18:02 PM
    Author     : Harsh Jain
--%>

<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Upload Notices</title>
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
        }
        #customers tr:nth-child(even){background-color: #f2f2f2;}
        #customers tr:hover {background-color: #ddd;}
        #customers th {
            padding-top: 12px;
            padding-bottom: 12px;
            text-align: left;
            background-color: #4CAF50;
            color: white;
        }
    </style>
</head>

<body>
    <div class="divide" style="background-color: #43425D; left: 0">
        <div style="color:white;font-size: 20px; font-family: sans-serif;display: block;text-align: center;
             margin-top: 20px; margin-bottom: 25px;">ABC Insitute</div>
        <hr> 

        <ul>
            <li><a href="admin_home.jsp">Home</a></li>
            <li><a href="enroll_student.jsp">Enroll Student</a></li>
            <li><a href="enroll_faculty.jsp">Enroll Faculty</a></li>
            <li><a href="notices.jsp" class="active">Notices</a></li>
            <li><a href="student_details.jsp">Student Details</a></li>
            <li><a href="faculty_details.jsp">Faculty Details</a></li>
            <li><a href="course_register.jsp">Course Registration</a></li>
            <li><a href="course_details.jsp">Course Details</a></li>
            <li><a href="index.jsp">Sign Out</a></li>
        </ul>
    </div>

    <!-- ✅ Right side admin info -->
    <div class="divide facutly_info_right">
        <%
            String username = (String) session.getAttribute("uname");

            // if session not found, go back to login
            if(username == null){
                response.sendRedirect("index.jsp");
                return;
            }

            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/faculty_login","root","root");

                // ✅ admin table has only username,password
                // your SQL file does not have image_path, fname, lname, age in admin table
        %>

        <br><br>
        <p align="center" class="facutly_info">
            Welcome Admin : <b><%= username %></b>
        </p>

        <%
            } catch(Exception e){
                out.println("<p style='color:red;text-align:center'>Database Error: "+e.getMessage()+"</p>");
            }
        %>
    </div>

    <!-- ✅ Notice list -->
    <div class="divide" style="left: 22%; width: 56%; height: 96%; top: 3%; right: 20%; overflow-x: auto; overflow-y: auto">
        <table id="customers" style="width: 700px">
            <th colspan="2" style="text-align: center">Notice</th>

            <%
                try {
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/faculty_login","root","root");
                    String qr = "select image_path from notices";
                    ps = con.prepareStatement(qr);
                    rs = ps.executeQuery();

                    boolean found = false;

                    while(rs.next()){
                        found = true;
            %>

            <form action="delete_notice" method="post">
                <tr>
                    <td>
                        <img src="images/<%=rs.getString("image_path")%>" height="600px" width="500px">
                    </td>
                    <td>
                        <input type="hidden" name="imagepath" value="<%=rs.getString("image_path")%>">
                        <input type="submit" value="Delete">
                    </td>
                </tr>
            </form>

            <%
                    }

                    if(!found){
            %>
                <tr>
                    <td colspan="2" style="text-align:center;color:gray;">
                        No notices uploaded yet.
                    </td>
                </tr>
            <%
                    }

                } catch(Exception e){
                    out.println("<tr><td colspan='2' style='color:red;text-align:center'>Error: "+e.getMessage()+"</td></tr>");
                }
            %>

        </table>
    </div>

</body>
</html>
