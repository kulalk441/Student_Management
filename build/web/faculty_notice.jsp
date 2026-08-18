<%-- 
    Document   : faculty_notice
    Created on : 17 Sep, 2018, 9:10:21 PM
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
        <title>Upload Notices</title>
        <link rel="stylesheet" href="styles.css">
        <script>
            function update_details()
            {
                alert("Please contact the administrator to update the details!\nYou can contact on hjain1245@gmail.com");
            }
        </script>
    </head>

    <body>
        <div class="divide" style="background-color: #43425D; left: 0">
            <div style="color:white;font-size: 20px; font-family: sans-serif;display: block;text-align: center;
                 margin-top: 20px; margin-bottom: 25px;">ABC Insitute</div>
            <hr>
            <ul>
                <li><a href="faculty_home.jsp">Home</a></li>
                <li><a href="faculty_attendance.jsp">Upload Attendance</a></li>
                <li><a href="faculty_notice.jsp" class="active">Upload Notices</a></li>
                <li><a href="faculty_marks.jsp">Upload Marks</a></li>
                <li><a href="chat_faculty.jsp">Chat Room</a></li>
                <li><a href="index.jsp">Sign Out</a></li>
            </ul>
        </div>

        <!-- Center part -->
        <div class="divide" style="left: 30%; width: 60%; height: 80%; top: 15%; right: 20%; overflow-x: auto; overflow-y: auto">
            <form action="upload_notice" enctype="multipart/form-data" method="post"
                  style="margin-top: 50px; margin-left: 50px">
                <input type="file" name="notice">
                <br><br>
                <input type="submit" value="Upload Notice">
            </form>

            <br><br><br><br><br><br><br><br><br><br>

            <form action="see_notices.jsp" style="margin-top: 90px; margin-left: 170px">
                <input type="submit" value="See Notices">
            </form>
        </div>

        <!-- Right side Faculty info -->
        <div class="divide facutly_info_right">
            <%
                String username = (String) session.getAttribute("uname");
            %>

            <br><br><br>

            <p align="center" class="facutly_info">
                <%
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection con = DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/faculty_login",
                            "root",
                            "root"
                        );

                        String qr = "select fname,lname,department,age from login where username=?";
                        PreparedStatement ps = con.prepareStatement(qr);
                        ps.setString(1, username);

                        ResultSet rs = ps.executeQuery();

                        if (rs.next()) {
                            String fname = rs.getString("fname");
                            String lname = rs.getString("lname");
                            String department = rs.getString("department");
                            int age = rs.getInt("age");
                %>

                Name : <%= fname + " " + lname %>
                <br><br>
                Department : <%= department %>
                <br><br>
                Age : <%= age %>
                <br><br>

                <%
                        } else {
                %>
                No Faculty Data Found
                <br><br>
                <%
                        }

                        con.close();
                    } catch (Exception e) {
                        out.println("Database Error: " + e.getMessage());
                    }
                %>

                <form onsubmit="update_details()">
                    <input type="submit" value="Update Details">
                </form>
            </p>
        </div>

    </body>
</html>
