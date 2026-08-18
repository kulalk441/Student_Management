<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Marks</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <script>
        function update_details() {
            alert("Contact the administrator for any updations!!");
        }
    </script>

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

<%
    String user = request.getParameter("username");
    if(user != null){
        session.setAttribute("uname", user);
    }

    String username = (String)session.getAttribute("uname");

    if(username == null){
        response.sendRedirect("index.jsp");
        return;
    }

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/student_login",
            "root",
            "root"
    );
%>

<!-- LEFT MENU -->
<div class="divide" style="background-color:#43425D; left:0">
    <div style="color:white;font-size:20px;text-align:center;margin:20px 0;">
        ABC Institute
    </div>
    <hr>
    <ul>
        <li><a href="student_home.jsp">Home</a></li>
        <li><a href="student_attendance.jsp">Check Attendance</a></li>
        <li><a href="see_student_notice.jsp">Check Notices</a></li>
        <li><a href="student_marks.jsp" class="active">Check Marks</a></li>
        <li><a href="course_registration.jsp">Course Registration</a></li>
        <li><a href="chat_student.jsp">Chat Room</a></li>
        <li><a href="index.jsp">Sign Out</a></li>
    </ul>
</div>

<!-- RIGHT STUDENT INFO -->
<div class="divide facutly_info_right">

<%
    String qr = "SELECT fname, lname, department, roll FROM login WHERE username=?";
    PreparedStatement ps = con.prepareStatement(qr);
    ps.setString(1, username);
    ResultSet rs = ps.executeQuery();

    if(rs.next()){
%>
        <p align="center" class="facutly_info">
            Roll Number : <%=rs.getString("roll")%><br><br>
            Name : <%=rs.getString("fname")%> <%=rs.getString("lname")%><br><br>
            Department : <%=rs.getString("department")%><br><br>
        </p>
<%
    }
    rs.close();
    ps.close();
%>

<form onsubmit="update_details(); return false;">
    <input type="submit" value="Update Details">
</form>

</div>

<!-- MARKS TABLE -->
<div class="divide" style="left:30%; width:40%; height:85%; top:15%; overflow-y:auto;">
    <table id="customers">
        <tr>
            <th>Course Name</th>
            <th>Course ID</th>
            <th>Marks</th>
        </tr>

<%
    qr = "SELECT course_name, course_id, marks FROM courses WHERE username=?";
    ps = con.prepareStatement(qr);
    ps.setString(1, username);
    rs = ps.executeQuery();

    while(rs.next()){
%>
        <tr>
            <td><%=rs.getString("course_name")%></td>
            <td><%=rs.getString("course_id")%></td>
            <td><%=rs.getInt("marks")%></td>
        </tr>
<%
    }

    rs.close();
    ps.close();
    con.close();
%>

    </table>
</div>

</body>
</html>
