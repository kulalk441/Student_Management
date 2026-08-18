<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Upload Marks</title>
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
            background-color: #4CAF50;
            color: white;
        }
    </style>
</head>

<body>

<div class="divide" style="background-color:#43425D; left:0">
    <div style="color:white;font-size:20px;text-align:center;margin:20px 0;">
        ABC Institute
    </div>
    <hr>
    <ul>
        <li><a href="faculty_home.jsp">Home</a></li>
        <li><a href="faculty_attendance.jsp">Upload Attendance</a></li>
        <li><a href="faculty_notice.jsp">Upload Notices</a></li>
        <li><a href="faculty_marks.jsp" class="active">Upload Marks</a></li>
        <li><a href="chat_faculty.jsp">Chat Room</a></li>
        <li><a href="index.jsp">Sign Out</a></li>
    </ul>
</div>

<div class="divide" style="left: 26%; width: 70%; top: 5%; height: 90%; overflow:auto;">

<%
    String course_name = request.getParameter("course_name");
    if(course_name == null || course_name.trim().equals("")){
        course_name = (String)session.getAttribute("course_name");
    } else {
        session.setAttribute("course_name", course_name);
    }

    if(course_name == null || course_name.trim().equals("")){
%>
        <h2 style="color:red;text-align:center;margin-top:40px;">Course not selected!</h2>
<%
    } else {

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/student_login",
                    "root",
                    "root"
            );

            String qr = "SELECT c.roll, c.username, l.fname, l.lname, c.marks " +
                        "FROM courses c, login l " +
                        "WHERE l.username=c.username AND c.course_name=?";

            ps = con.prepareStatement(qr);
            ps.setString(1, course_name);
            rs = ps.executeQuery();
%>

            <h2 style="text-align:center;">Students Enrolled - <%=course_name%></h2>

            <table id="customers">
                <tr>
                    <th>Roll</th>
                    <th>Username</th>
                    <th>Name</th>
                    <th>Marks</th>
                    <th>Update Marks</th>
                </tr>

<%
            while(rs.next()){
                String suser = rs.getString("username");
%>
                <tr>
                    <td><%=rs.getString("roll")%></td>
                    <td><%=suser%></td>
                    <td><%=rs.getString("fname")%> <%=rs.getString("lname")%></td>
                    <td><%=rs.getInt("marks")%></td>

                    <td>
                        <form action="update_marks" method="post">
                            <input type="hidden" name="student_username" value="<%=suser%>">
                            <input type="hidden" name="course_name" value="<%=course_name%>">
                            <input type="number" name="marks" min="0" max="100" required style="width:80px;">
                            <input type="submit" value="Update">
                        </form>
                    </td>
                </tr>
<%
            }
%>
            </table>

<%
        } catch(Exception e){
            out.println("<p style='color:red;text-align:center;'>Error: "+e.getMessage()+"</p>");
        } finally {
            try{ if(rs!=null) rs.close(); } catch(Exception e){}
            try{ if(ps!=null) ps.close(); } catch(Exception e){}
            try{ if(con!=null) con.close(); } catch(Exception e){}
        }
    }
%>

</div>

</body>
</html>
