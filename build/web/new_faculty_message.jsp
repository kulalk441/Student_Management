<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Faculty Message</title>
    <link rel="stylesheet" href="styles.css">

    <script>
        function update_details() {
            alert("Please contact the administrator to update the details!");
        }
    </script>
</head>

<body>

<%
    // ✅ SESSION HANDLING
    String user = request.getParameter("username");
    if (user != null) {
        session.setAttribute("uname", user);
    }

    String username = (String) session.getAttribute("uname");
    if (username == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // ✅ Student name coming from Reply button
    String student_name = request.getParameter("student_name");
    if (student_name == null) {
        student_name = request.getParameter("fac_name");
    }

    // ✅ Fetch faculty details
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String fname = "";
    String lname = "";
    String department = "";
    int age = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/faculty_login",
                "root",
                "root"
        );

        String qr = "SELECT fname,lname,department,age FROM login WHERE username=?";
        ps = con.prepareStatement(qr);
        ps.setString(1, username);
        rs = ps.executeQuery();

        if (rs.next()) {
            fname = rs.getString("fname");
            lname = rs.getString("lname");
            department = rs.getString("department");
            age = rs.getInt("age");
        }

    } catch (Exception e) {
        out.println("<p style='color:red;text-align:center;'>Error: " + e.getMessage() + "</p>");
    }
%>

<!-- LEFT MENU -->
<div class="divide" style="background-color: #43425D; left: 0">
    <div style="color:white;font-size: 20px; font-family: sans-serif;display: block;text-align: center;
         margin-top: 20px; margin-bottom: 25px;">ABC Institute</div>
    <hr>
    <ul>
        <li><a href="faculty_home.jsp">Home</a></li>
        <li><a href="faculty_attendance.jsp">Upload Attendance</a></li>
        <li><a href="faculty_notice.jsp">Upload Notices</a></li>
        <li><a href="faculty_marks.jsp">Upload Marks</a></li>
        <li><a href="chat_faculty.jsp" class="active">Chat Room</a></li>
        <li><a href="index.jsp">Sign Out</a></li>
    </ul>
</div>

<!-- RIGHT FACULTY INFO -->
<div class="divide facutly_info_right">

    <!-- ✅ Static image (no DB column needed) -->
    <img src="images/admin.jpeg" height="100px" width="100px"
         style="border-radius: 10px; margin-left: 85px; margin-top: 20px">

    <br><br>

    <form onsubmit="update_details(); return false;">
        <input type="submit" value="Update Details">
    </form>

    <br><br>

    <p align="center" class="facutly_info">
        Name : <%= fname + " " + lname %>
        <br><br>
        Department : <%= department %>
        <br><br>
        Age : <%= age %>
        <br><br>
    </p>

</div>

<!-- CENTER MESSAGE AREA -->
<div class="divide" style="left: 30%; width: 40%; height: 85%; top: 8%; right: 25%; overflow-x: hidden; overflow-y: auto">

    <h2 style="text-align:center;">Send Message to Student</h2>

    <%
        if (student_name == null || student_name.trim().equals("")) {
    %>
        <p style="color:red;text-align:center;">Student name not selected!</p>
    <%
        } else {
    %>

    <form action="f_to_s" method="post">
        <input type="hidden" name="student_name" value="<%= student_name %>">
        <input type="hidden" name="faculty_name" value="<%= username %>">

        <p style="text-align:center;">
            <b>Sending to:</b> <%= student_name %>
        </p>

        <textarea name="message" placeholder="Enter the message"
                  style="width: 400px; height: 250px; margin-left: 55px;"></textarea>

        <br><br>

        <div style="text-align:center;">
            <input type="submit" value="Send Message">
        </div>
    </form>

    <%
        }
    %>

</div>

</body>
</html>
