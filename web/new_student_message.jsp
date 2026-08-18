<%-- 
    Document   : new_student_message
    Created on : 24 Oct, 2018, 8:26:31 PM
    Author     : Harsh Jain
--%>

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Student - Send Message</title>
    <link rel="stylesheet" type="text/css" href="styles.css">

    <script>
        function update_details() {
            alert("Contact the administrator for any updations!!");
        }
    </script>
</head>

<body>

<%
    // Get username from URL only first time
    String user = request.getParameter("username");
    if (user != null) {
        session.setAttribute("uname", user);
    }

    String username = (String) session.getAttribute("uname");
    if (username == null) {
        response.sendRedirect("index.jsp");
        return;
    }
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
        <li><a href="course_registration.jsp">Course Registration</a></li>
        <li><a href="chat_student.jsp" class="active">Chat Room</a></li>
        <li><a href="index.jsp">Sign Out</a></li>
    </ul>
</div>

<!-- RIGHT SIDE STUDENT INFO (NO IMAGEPATH ✅) -->
<div class="divide facutly_info_right">

    <!-- ✅ Default static image (you can remove this line if you want) -->
    <img src="images/admin.jpeg" height="100px" width="100px"
         style="border-radius: 10px; margin-left: 85px; margin-top: 20px">

    <br><br>

    <!-- ✅ Remove update image feature because DB has no image -->
    <form onsubmit="update_details(); return false;">
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
                        "jdbc:mysql://localhost:3306/student_login",
                        "root",
                        "root"
                );

                String qr = "SELECT fname,lname,department,roll FROM login WHERE username=?";
                ps = con.prepareStatement(qr);
                ps.setString(1, username);
                rs = ps.executeQuery();

                if (rs.next()) {
                    String roll = rs.getString("roll");
                    String fname = rs.getString("fname");
                    String lname = rs.getString("lname");
                    String department = rs.getString("department");
        %>
                    Roll Number : <%= roll %>
                    <br><br>
                    Name : <%= fname + " " + lname %>
                    <br><br>
                    Department : <%= department %>
                    <br><br>
        <%
                }
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (ps != null) ps.close(); } catch (Exception e) {}
                try { if (con != null) con.close(); } catch (Exception e) {}
            }
        %>

        <form onsubmit="update_details(); return false;">
            <input type="submit" value="Update Details">
        </form>
    </p>
</div>

<!-- MESSAGE FORM -->
<div class="divide" style="left: 30%; width: 40%; height: 85%; top: 8%; right: 25%; overflow-x: hidden; overflow-y: auto">

    <%
        String faculty_name = request.getParameter("faculty_name");
        if (faculty_name == null) {
            faculty_name = request.getParameter("fac_name");
        }

        if (faculty_name == null) {
            faculty_name = "Unknown Faculty";
        }
    %>

    <h2 style="text-align:center;">Send Message</h2>
    <p style="text-align:center;">To Faculty: <b><%= faculty_name %></b></p>

    <form action="s_to_f" method="post">
        <input type="hidden" value="<%= faculty_name %>" name="faculty_name">
        <input type="hidden" value="<%= username %>" name="student_name">

        <textarea placeholder="Enter the message" spellcheck="true"
                  name="message"
                  required
                  style="width: 400px; height: 300px; margin-left: 55px"></textarea>

        <br><br>

        <div style="text-align:center;">
            <input type="submit" value="Send Message">
        </div>
    </form>

</div>

</body>
</html>
