<%-- 
    Document   : course_registration.jsp
    Student Course Registration Page (FIXED)
--%>

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Course Registration</title>
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

    <script>
        function update_details() {
            alert("Contact the administrator for any updations!!");
        }
    </script>
</head>

<body>

<%
    // ✅ session handling
    String user = request.getParameter("username");
    if(user != null && !user.trim().equals("")){
        session.setAttribute("uname", user);
    }

    String uname = (String)session.getAttribute("uname");

    if(uname == null){
        response.sendRedirect("index.jsp");
        return;
    }

    Connection conFaculty = null;
    Connection conStudent = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>

<!-- LEFT MENU -->
<div class="divide" style="background-color: #43425D; left: 0">
    <div style="color:white;font-size: 20px; font-family: sans-serif;display: block;text-align: center;
         margin-top: 20px; margin-bottom: 25px;">ABC Institute</div>
    <hr>
    <ul>
        <li><a href="student_home.jsp">Home</a></li>
        <li><a href="student_attendance.jsp">Check Attendance</a></li>
        <li><a href="see_student_notice.jsp">Check Notices</a></li>
        <li><a href="student_marks.jsp">Check Marks</a></li>

        <!-- ✅ IMPORTANT FIX -->
        <li><a href="course_registration.jsp" class="active">Course Registration</a></li>

        <li><a href="chat_student.jsp">Chat Room</a></li>
        <li><a href="index.jsp">Sign Out</a></li>
    </ul>
</div>

<!-- CENTER SECTION -->
<div class="divide" style="left: 27%; width: 50%; height: 80%; top: 10%; right: 20%; overflow-x: hidden; overflow-y: auto">

    <h2 style="text-align:center; margin-top:20px;">Available Courses</h2>

    <div style="overflow-x: auto; overflow-y: auto; height: 50%; width: 90%; margin: auto;">
        <table id="customers" style="width: 100%;">
            <tr>
                <th>Course ID</th>
                <th>Course Name</th>
            </tr>

            <%
                try{
                    Class.forName("com.mysql.cj.jdbc.Driver");

                    // ✅ available courses are stored in faculty_login.courses
                    conFaculty = DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/faculty_login",
                            "root",
                            "root"
                    );

                    String qr = "SELECT course_id, course_name FROM courses";
                    ps = conFaculty.prepareStatement(qr);
                    rs = ps.executeQuery();

                    while(rs.next()){
            %>
            <tr>
                <td><%=rs.getString("course_id")%></td>
                <td><%=rs.getString("course_name")%></td>
            </tr>
            <%
                    }
                }catch(Exception e){
                    out.println("<tr><td colspan='2' style='color:red;text-align:center;'>Error: "+e.getMessage()+"</td></tr>");
                }finally{
                    try{ if(rs!=null) rs.close(); }catch(Exception e){}
                    try{ if(ps!=null) ps.close(); }catch(Exception e){}
                    try{ if(conFaculty!=null) conFaculty.close(); }catch(Exception e){}
                }
            %>
        </table>
    </div>

    <!-- ✅ REGISTER FORM -->
    <div style="margin-top: 40px; text-align:center;">
        <h3>Register a Course</h3>

        <form action="register_course" method="post">
            <input type="text" name="course_id" placeholder="Enter Course ID (example: cs1234)" required>
            <br><br>
            <input type="submit" value="Register the Course">
        </form>

        <%
            String msg = request.getParameter("msg");
            if(msg != null){
        %>
            <p style="color:green;"><%=msg%></p>
        <%
            }

            String err = request.getParameter("err");
            if(err != null){
        %>
            <p style="color:red;"><%=err%></p>
        <%
            }
        %>
    </div>

</div>

<!-- RIGHT STUDENT INFO -->
<div class="divide facutly_info_right">

    <br><br>
    <form action="update_student_image.jsp">
        <input type="submit" value="Update Image">
    </form>

    <br><br>
    <p align="center" class="facutly_info">
        <%
            try{
                Class.forName("com.mysql.cj.jdbc.Driver");
                conStudent = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/student_login",
                        "root",
                        "root"
                );

                String qr2 = "SELECT roll, fname, lname, department FROM login WHERE username=?";
                ps = conStudent.prepareStatement(qr2);
                ps.setString(1, uname);
                rs = ps.executeQuery();

                if(rs.next()){
                    String roll = rs.getString("roll");
                    String fname = rs.getString("fname");
                    String lname = rs.getString("lname");
                    String department = rs.getString("department");
        %>

        Roll Number : <%=roll%>
        <br><br>
        Name : <%=fname%> <%=lname%>
        <br><br>
        Department : <%=department%>

        <%
                }else{
        %>
            <span style="color:red;">Student details not found!</span>
        <%
                }

            }catch(Exception e){
                out.println("<span style='color:red;'>Error: "+e.getMessage()+"</span>");
            }finally{
                try{ if(rs!=null) rs.close(); }catch(Exception e){}
                try{ if(ps!=null) ps.close(); }catch(Exception e){}
                try{ if(conStudent!=null) conStudent.close(); }catch(Exception e){}
            }
        %>

        <br><br>
        <form onsubmit="update_details(); return false;">
            <input type="submit" value="Update Details">
        </form>
    </p>

</div>

</body>
</html>
