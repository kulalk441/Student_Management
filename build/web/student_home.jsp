<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Home</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <link rel="stylesheet" href="js/jQuery-plugin-progressbar.css">
    <script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
    <script src="js/jQuery-plugin-progressbar.js"></script>

    <script>
        function update_details() {
            alert("Contact the administrator for any updations!!");
        }
    </script>
</head>

<body>

<%
    // SESSION HANDLING
    String user = request.getParameter("username");
    if (user != null) {
        session.setAttribute("uname", user);
    }
    String username = (String) session.getAttribute("uname");

    // DB VARIABLES
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String qr = null;

    int totalClasses = 0;
    int attendedClasses = 0;

    int percent = 0; // ✅ final percentage
%>

<div class="divide" style="background-color:#43425D; left:0">
    <div style="color:white;font-size:20px;text-align:center;margin:20px">
        ABC Institute
    </div>
    <hr>
    <ul>
        <li><a href="student_home.jsp" class="active">Home</a></li>
        <li><a href="student_attendance.jsp">Check Attendance</a></li>
        <li><a href="see_student_notice.jsp">Check Notices</a></li>
        <li><a href="student_marks.jsp">Check Marks</a></li>
        <li><a href="course_registration.jsp">Course Registration</a></li>
        <li><a href="chat_student.jsp">Chat Room</a></li>
        <li><a href="index.jsp">Sign Out</a></li>
    </ul>
</div>

<div class="divide facutly_info_right">

<%
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/student_login",
        "root",
        "root"
    );

    // STUDENT DETAILS
    qr = "select fname,lname,department,roll from login where username=?";
    ps = con.prepareStatement(qr);
    ps.setString(1, username);
    rs = ps.executeQuery();

    while (rs.next()) {
%>

    <p align="center" class="facutly_info">
        Roll Number : <%= rs.getString("roll") %><br><br>
        Name : <%= rs.getString("fname") %> <%= rs.getString("lname") %><br><br>
        Department : <%= rs.getString("department") %><br><br>
    </p>

<%
    }
    rs.close();
    ps.close();

    // ✅ ATTENDANCE DETAILS (Sum all courses)
    qr = "select attended,total from courses where username=?";
    ps = con.prepareStatement(qr);
    ps.setString(1, username);
    rs = ps.executeQuery();

    while (rs.next()) {
        attendedClasses += rs.getInt("attended");
        totalClasses += rs.getInt("total");
    }

    // ✅ FIX % CALCULATION (Double division + rounding)
    if (totalClasses > 0) {
        percent = (int) Math.round((attendedClasses * 100.0) / totalClasses);
    } else {
        percent = 0;
    }
%>

<form onsubmit="update_details()">
    <input type="submit" value="Update Details">
</form>

</div>

<div class="divide" style="left:30%; width:40%; height:85%; top:8%; overflow:auto">

<%
    // ✅ Show message based on percentage
    if (totalClasses == 0) {
%>
        <marquee>
            <p style="font-size:20px;color:#ff3300">
                <strong>Please Register for a Course!!!</strong>
            </p>
        </marquee>

        <div class="progress-bar position"
             data-percent="0"
             data-color="#ccc,red"
             style="left:30%">
        </div>

<%
    } else if (percent < 75) {
%>
        <marquee>
            <p style="font-size:20px;color:#ff3300">
                <strong>Not Eligible to give your examinations!!!!</strong>
            </p>
        </marquee>

        <div class="progress-bar position"
             data-percent="<%= percent %>"
             data-color="#ccc,red"
             style="left:30%">
        </div>

<%
    } else {
%>
        <marquee>
            <p style="font-size:20px;color:#00cc00">
                <strong>Eligible to give Examinations!!!</strong>
            </p>
        </marquee>

        <div class="progress-bar position"
             data-percent="<%= percent %>"
             data-color="#ccc,green"
             style="left:30%">
        </div>
<%
    }

    // CLOSE CONNECTION
    if (rs != null) rs.close();
    if (ps != null) ps.close();
    if (con != null) con.close();
%>

<script>
    $(".progress-bar").loading();
</script>

</div>

</body>
</html>
