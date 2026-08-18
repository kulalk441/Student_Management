<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Upload Attendance</title>
    <link rel="stylesheet" href="styles.css">
</head>

<body>

<div class="divide" style="background-color: #43425D; left: 0">
    <div style="color:white;font-size: 20px; font-family: sans-serif;display: block;text-align: center;
         margin-top: 20px; margin-bottom: 25px;">ABC Institute</div>
    <hr>
    <ul>
        <li><a href="faculty_home.jsp">Home</a></li>
        <li><a href="faculty_attendance.jsp" class="active">Upload Attendance</a></li>
        <li><a href="faculty_notice.jsp">Upload Notices</a></li>
        <li><a href="faculty_marks.jsp">Upload Marks</a></li>
        <li><a href="chat_faculty.jsp">Chat Room</a></li>
        <li><a href="index.jsp">Sign Out</a></li>
    </ul>
</div>

<%
    String course_name = request.getParameter("course_name");
    if(course_name == null){
        course_name = (String)session.getAttribute("course_name");
    } else {
        session.setAttribute("course_name", course_name);
    }
%>

<div class="divide" style="left: 22%; width: 70%; top: 5%; height: 90%; overflow-y:auto; background:#ECF0F1;">

    <h2 style="text-align:center;">Attendance - <%=course_name%></h2>

    <%
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/student_login", "root", "root");

            String qr = "SELECT courses.roll, courses.username, login.fname, login.lname, courses.attended, courses.total " +
                        "FROM courses INNER JOIN login ON login.username=courses.username " +
                        "WHERE courses.course_name=?";
            ps = con.prepareStatement(qr);
            ps.setString(1, course_name);

            rs = ps.executeQuery();
    %>

    <table border="1" style="width:95%; margin:auto; text-align:center; background:white;">
        <tr style="background:#4CAF50; color:white;">
            <th>Roll</th>
            <th>Username</th>
            <th>Name</th>
            <th>Attended</th>
            <th>Total</th>
            <th>Action</th>
        </tr>

        <%
            boolean found = false;
            while(rs.next()){
                found = true;
        %>
        <tr>
            <td><%=rs.getInt("roll")%></td>
            <td><%=rs.getString("username")%></td>
            <td><%=rs.getString("fname")%> <%=rs.getString("lname")%></td>
            <td><%=rs.getInt("attended")%></td>
            <td><%=rs.getInt("total")%></td>
            <td>
                <!-- ✅ Present button -->
                <form action="update_attendance" method="post">
                    <input type="hidden" name="student_username" value="<%=rs.getString("username")%>">
                    <input type="hidden" name="course_name" value="<%=course_name%>">
                    <input type="submit" value="Present">
                </form>
            </td>
        </tr>
        <%
            }

            if(!found){
        %>
        <tr>
            <td colspan="6" style="color:red;">No students enrolled in this course!</td>
        </tr>
        <%
            }
        %>

    </table>

    <%
        } catch(Exception e){
            out.println("<h3 style='color:red;text-align:center;'>Error: "+e.getMessage()+"</h3>");
        } finally {
            try { if(rs!=null) rs.close(); } catch(Exception e){}
            try { if(ps!=null) ps.close(); } catch(Exception e){}
            try { if(con!=null) con.close(); } catch(Exception e){}
        }
    %>

</div>

</body>
</html>
