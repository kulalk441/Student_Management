<%-- 
    Document   : show_faculty_details
--%>

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Faculty Details</title>
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

<!-- LEFT MENU -->
<div class="divide" style="background-color: #43425D; left: 0">
    <div style="color:white;font-size: 20px; font-family: sans-serif;display: block;text-align: center;
         margin-top: 20px; margin-bottom: 25px;">ABC Insitute</div>
    <hr>

    <ul>
        <li><a href="admin_home.jsp">Home</a></li>
        <li><a href="enroll_student.jsp">Enroll Student</a></li>
        <li><a href="enroll_faculty.jsp">Enroll Faculty</a></li>
        <li><a href="notices.jsp">Notices</a></li>
        <li><a href="student_details.jsp">Student Details</a></li>
        <li><a href="faculty_details.jsp" class="active">Faculty Details</a></li>
        <li><a href="course_register.jsp">Course Registration</a></li>
        <li><a href="course_details.jsp">Course Details</a></li>
        <li><a href="index.jsp">Sign Out</a></li>
    </ul>
</div>

<!-- RIGHT ADMIN PANEL -->
<div class="divide facutly_info_right">
    <%
        String adminUsername = (String) session.getAttribute("uname");
    %>

    <!-- ✅ Admin Image -->
    <img src="images/admin.jpeg" height="100px" width="100px"
         style="border-radius: 10px; margin-left: 85px; margin-top: 20px">

    <br><br>
    <form action="update_admin_image.jsp">
        <input type="submit" value="Update Image">
    </form>

    <br><br>
    <p align="center" class="facutly_info">
        <%
            Connection conA = null;
            PreparedStatement psA = null;
            ResultSet rsA = null;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                conA = DriverManager.getConnection("jdbc:mysql://localhost:3306/faculty_login","root","root");

                String qrA = "select fname,lname,age from admin where username=?";
                psA = conA.prepareStatement(qrA);
                psA.setString(1, adminUsername);
                rsA = psA.executeQuery();

                if(rsA.next()){
        %>
                    Name : <%=rsA.getString("fname")%> <%=rsA.getString("lname")%>
                    <br><br>
                    Age : <%=rsA.getInt("age")%>
                    <br><br>
        <%
                }
            } catch(Exception e){
                out.println("<p style='color:red;'>Admin Error: "+e.getMessage()+"</p>");
            } finally {
                try { if(rsA!=null) rsA.close(); } catch(Exception e) {}
                try { if(psA!=null) psA.close(); } catch(Exception e) {}
                try { if(conA!=null) conA.close(); } catch(Exception e) {}
            }
        %>

        <form onsubmit="return false;">
            <input type="submit" value="Update Details">
        </form>
    </p>
</div>


<!-- CENTER FACULTY DETAILS -->
<div class="divide" style="left: 22%; width: 55%; top: 3%; height: 95%; right: 20%; overflow-x: auto; overflow-y: auto">

    <%
        // ✅ get faculty_username (IMPORTANT FIX)
        String faculty_username = request.getParameter("faculty_username");

        if(faculty_username == null || faculty_username.trim().equals("") || faculty_username.equalsIgnoreCase("null")){
            faculty_username = (String) session.getAttribute("faculty_username");
        }

        // save for future update clicks
        session.setAttribute("faculty_username", faculty_username);

        if(faculty_username == null || faculty_username.trim().equals("") || faculty_username.equalsIgnoreCase("null")){
    %>
            <h3 style="text-align:center;color:red;margin-top:30px;">
                Faculty not selected!
            </h3>
    <%
        } else {

            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try{
                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/faculty_login", "root", "root");

                String qr = "select * from login where username=?";
                ps = con.prepareStatement(qr);
                ps.setString(1, faculty_username);

                rs = ps.executeQuery();

                if(rs.next()){
    %>

                <table id="customers">
                    <th colspan="4" style="text-align: center">Faculty Details</th>

                    <tr>
                        <td colspan="4" style="text-align:center;color:gray;">
                            Faculty Image Disabled
                        </td>
                    </tr>

                    <!-- ✅ First Name -->
                    <tr>
                        <td><strong>First Name</strong></td>
                        <td><%=rs.getString("fname")%></td>
                        <td>
                            <form action="update_faculty_details" method="post">
                                <input type="hidden" name="faculty_username" value="<%=faculty_username%>">
                                <input type="hidden" name="field" value="fname">
                                <input type="text" name="value" placeholder="New First Name">
                        </td>
                        <td>
                                <input type="submit" value="Update">
                            </form>
                        </td>
                    </tr>

                    <!-- ✅ Last Name -->
                    <tr>
                        <td><strong>Last Name</strong></td>
                        <td><%=rs.getString("lname")%></td>
                        <td>
                            <form action="update_faculty_details" method="post">
                                <input type="hidden" name="faculty_username" value="<%=faculty_username%>">
                                <input type="hidden" name="field" value="lname">
                                <input type="text" name="value" placeholder="New Last Name">
                        </td>
                        <td>
                                <input type="submit" value="Update">
                            </form>
                        </td>
                    </tr>

                    <!-- ✅ Username -->
                    <tr>
                        <td><strong>Username</strong></td>
                        <td><%=rs.getString("username")%></td>
                        <td>
                            <form action="update_faculty_details" method="post">
                                <input type="hidden" name="faculty_username" value="<%=faculty_username%>">
                                <input type="hidden" name="field" value="username">
                                <input type="text" name="value" placeholder="New Username">
                        </td>
                        <td>
                                <input type="submit" value="Update">
                            </form>
                        </td>
                    </tr>

                    <!-- ✅ Password -->
                    <tr>
                        <td><strong>Password</strong></td>
                        <td><%=rs.getString("password")%></td>
                        <td>
                            <form action="update_faculty_details" method="post">
                                <input type="hidden" name="faculty_username" value="<%=faculty_username%>">
                                <input type="hidden" name="field" value="password">
                                <input type="text" name="value" placeholder="New Password">
                        </td>
                        <td>
                                <input type="submit" value="Update">
                            </form>
                        </td>
                    </tr>

                    <tr>
                        <td><strong>Department</strong></td>
                        <td><%=rs.getString("department")%></td>
                        <td colspan="2">Cannot be Updated!!</td>
                    </tr>

                    <tr>
                        <td><strong>Age</strong></td>
                        <td><%=rs.getString("age")%></td>
                        <td colspan="2">Cannot be Updated!!</td>
                    </tr>

                </table>

    <%
                } else {
    %>
                <h3 style="text-align:center;color:red;margin-top:30px;">
                    Faculty not found! Username: <%=faculty_username%>
                </h3>
    <%
                }

            } catch(Exception e){
                out.println("<p style='color:red;text-align:center;'>Error: "+e.getMessage()+"</p>");
            } finally {
                try { if(rs!=null) rs.close(); } catch(Exception e) {}
                try { if(ps!=null) ps.close(); } catch(Exception e) {}
                try { if(con!=null) con.close(); } catch(Exception e) {}
            }
        }
    %>

</div>

</body>
</html>
