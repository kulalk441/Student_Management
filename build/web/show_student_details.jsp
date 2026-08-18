<%-- 
    Document   : show_student_details
    Created on : 7 Oct, 2018, 6:35:34 PM
    Author     : Harsh Jain
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
   <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Faculty Portal</title>
        <link rel="stylesheet" href="styles.css">
        <style>
            #customers 
            {
                font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
                border-collapse: collapse;
                width: 100%;
            }
            #customers td, #customers th {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: center;
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
                  <li><a href="notices.jsp">Notices</a></li>
                  <li><a href="student_details.jsp" class="active">Student Details</a></li>
                  <li><a href="faculty_details.jsp">Faculty Details</a></li>
                  <li><a href="course_register.jsp">Course Registration</a></li>
                  <li><a href="course_details.jsp">Course Details</a></li>
                  <li><a href="index.jsp">Sign Out</a></li>
            </ul> 
        </div>

        <!-- RIGHT ADMIN PANEL -->
        <div class="divide facutly_info_right">
            <%
                String username = (String)session.getAttribute("uname");

                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                String adminImg = "admin.jpeg"; // fallback image

                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/faculty_login","root","root");

                    String sqlImg = "SELECT image_path FROM admin WHERE username=?";
                    ps = con.prepareStatement(sqlImg);
                    ps.setString(1, username);

                    rs = ps.executeQuery();

                    if(rs.next()){
                        String dbImg = rs.getString("image_path");
                        if(dbImg != null && !dbImg.trim().equals("")){
                            adminImg = dbImg.trim();
                        }
                    }

                } catch(Exception e){
                    adminImg = "admin.jpeg";
                }
            %>

            <img src="images/<%=adminImg%>" height="100px" width="100px"
                 style="border-radius: 10px; margin-left: 85px; margin-top: 20px">

            <br><br>
            <form action="update_admin_image.jsp">
                <input type="submit" value="Update Image">
            </form>

            <br><br>
            <p align="center" class="facutly_info">
                 <%
                    try {
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/faculty_login","root","root");

                        String qr = "select fname,lname,age from admin where username=?";
                        ps = con.prepareStatement(qr);
                        ps.setString(1, username);
                        rs = ps.executeQuery();

                        while(rs.next()) {
                            String fname = rs.getString("fname");
                            String lname = rs.getString("lname");
                            int age = rs.getInt("age");
                 %>

                    Name : <%=fname+" "+lname%>
                    <br><br>
                    Age : <%=age%>
                    <br><br>

                 <%
                        }
                    } catch(Exception e) {
                        out.println("<p style='color:red;'>Admin Details Error: "+e.getMessage()+"</p>");
                    }
                 %>

                <form onsubmit="return false;">
                    <input type="submit" value="Update Details">
                </form>
            </p>
        </div>

        <!-- CENTER STUDENT DETAILS -->
        <div class="divide" style="left: 22%; width: 55%; top: 3%; height: 95%; right: 20%; overflow-x: auto; overflow-y: auto">
            <%
                String student_username = request.getParameter("student_username");
                session.setAttribute("student_username", student_username);

                try {
                    Class.forName("com.mysql.jdbc.Driver");

                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/student_login", "root", "root");
                    String qr2 = "select * from login where username=?";
                    ps = con.prepareStatement(qr2);
                    ps.setString(1, student_username);
                    rs = ps.executeQuery();

                    if(rs.next()) {
            %>
                    <table id="customers">
                        <th colspan="4" style="text-align: center">Student Details</th>

                        <!-- ✅ Student Image Removed -->
                        <tr>
                            <td><strong>First Name</strong></td>
                            <td><%=rs.getString("fname")%></td>
                            <form action="update_student_fname">
                                <td><input type="text" name="fname"></td>
                                <td><input type="submit" value="Update"></td>
                            </form>
                        </tr>

                        <tr>
                            <% session.setAttribute("student_username", rs.getString("username")); %>
                            <td><strong>Last Name</strong></td>
                            <form action="update_student_lname">
                                <td><%=rs.getString("lname")%></td>
                                <td><input type="text" name="lname"></td>
                                <td><input type="submit" value="Update"></td>
                            </form>
                        </tr>

                        <tr>
                            <td><strong>Username</strong></td>
                            <td><%=rs.getString("username")%></td>
                            <form action="update_student_uname">
                                <td><input type="text" name="username"></td>
                                <td><input type="submit" value="Update"></td>
                            </form>
                        </tr>

                        <tr>
                            <td><strong>Password</strong></td>
                            <td><%=rs.getString("password")%></td>
                            <form action="update_student_password">
                                <td><input type="text" name="password"></td>
                                <td><input type="submit" value="Update"></td>
                            </form>
                        </tr>

                        <tr>
                            <td><strong>Department</strong></td>
                            <td><%=rs.getString("department")%></td>
                            <td colspan="2">Cannot be updated!!</td>
                        </tr>

                        <tr>
                            <td><strong>Roll Number</strong></td>
                            <td><%=rs.getString("roll")%></td>
                            <td colspan="2">Cannot be Updated!!</td>
                        </tr>

                    </table>
            <%
                    } else {
            %>
                    <h3 style="text-align:center;color:red;margin-top:30px;">
                        Student not found!
                    </h3>
            <%
                    }

                } catch(Exception e) {
                    out.println("<p style='color:red;text-align:center;'>Error: "+e.getMessage()+"</p>");
                }
            %>
        </div>

    </body>
</html>
