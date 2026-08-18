<%-- 
    Document   : chat_faculty
    Created on : 24 Oct, 2018, 10:02:32 PM
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
        #customers {
            font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }
        #customers td, #customers th {
            border: 1px solid #ddd;
            padding: 8px;
        }
        #customers tr:nth-child(even){background-color: #f2f2f2;}
        #customers tr:hover {background-color: #ddd;}
        #customers th {
            padding-top: 12px;
            padding-bottom: 12px;
            text-align: center;
            background-color: #4CAF50;
            color: white;
        }
    </style>

    <script>
        function studentSelection() {
            var x = document.getElementById("student_select");
            var student_name = x.options[x.selectedIndex].text;
            window.location.replace("new_faculty_message.jsp?student_name=" + student_name);
        }

        function update_details() {
            alert("Please contact the administrator to update the details!\nYou can contact on hjain1245@gmail.com");
        }
    </script>
</head>

<body>

<%
    String user = request.getParameter("username");
    if (user != null) {
        session.setAttribute("uname", user);
    }

    String username = (String) session.getAttribute("uname");
    if (username == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String qr = "";

    String fname = "";
    String lname = "";
%>

<!-- LEFT MENU -->
<div class="divide" style="background-color: #43425D; left: 0">
    <div style="color:white;font-size: 20px; font-family: sans-serif;display: block;text-align: center;
         margin-top: 20px; margin-bottom: 25px;">ABC Insitute</div>
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

<!-- RIGHT SIDE FACULTY INFO -->
<div class="divide facutly_info_right">

    <!-- ✅ Static Image (No DB needed) -->
    <img src="images/admin.jpeg" height="100px" width="100px"
         style="border-radius: 10px; margin-left: 85px; margin-top: 20px">

    <br><br>

    <!-- ✅ If you don't want this button also, you can remove it -->
    <form action="update_faculty_image.jsp">
        <input type="submit" value="Update Image">
    </form>

    <br><br>

    <p align="center" class="facutly_info">
    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/faculty_login",
                    "root",
                    "root"
            );

            qr = "select fname,lname,department,age from login where username=?";
            ps = con.prepareStatement(qr);
            ps.setString(1, username);
            rs = ps.executeQuery();

            if (rs.next()) {
                fname = rs.getString("fname");
                lname = rs.getString("lname");
                String department = rs.getString("department");
                String age = rs.getString("age");
    %>

        Name : <%= fname + " " + lname %>
        <br><br>
        Department : <%= department %>
        <br><br>
        Age : <%= age %>
        <br><br>

    <%
            }
        } catch(Exception e) {
            out.println("<p style='color:red;text-align:center;'>Error: " + e.getMessage() + "</p>");
        }
    %>

    <form onsubmit="update_details(); return false;">
        <input type="submit" value="Update Details">
    </form>
    </p>

</div>

<!-- CENTER CHAT AREA -->
<div class="divide" style="left: 25%; width: 50%; height: 85%; top: 8%; right: 25%; overflow-x: hidden; overflow-y: auto">

    <div style="height: 50px; position: absolute;">

        <select id="student_select" style="margin-left: 265px">
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/student_login",
                        "root",
                        "root"
                );

                qr = "select fname,lname from login";
                ps = con.prepareStatement(qr);
                rs = ps.executeQuery();
                while (rs.next()) {
        %>
            <option><%= rs.getString("fname") + " " + rs.getString("lname") %></option>
        <%
                }
            } catch(Exception e) {
                out.println("<option>Error Loading Students</option>");
            }
        %>
        </select>

        <br><br>

        <input type="submit" value="Send Message" onclick="studentSelection()" style="margin-left:230px">

        <br><br><br>
    </div>

    <!-- MESSAGE SENT -->
    <div style="margin-top:90px; width: 50%; position: absolute">
        <table id="customers" style="width:250px">
            <th colspan="2">Message Sent</th>
            <tr>
                <th>Student Name</th>
                <th>Message Sent</th>
            </tr>

            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/faculty_login",
                            "root",
                            "root"
                    );

                    qr = "select sid from messagef where fid=? group by sid";
                    ps = con.prepareStatement(qr);
                    ps.setString(1, username);
                    rs = ps.executeQuery();

                    while(rs.next()) {
                        String name = rs.getString("sid");

                        String qr1 = "select msg from messagef where sid=? and fid=?";
                        PreparedStatement ps1 = con.prepareStatement(qr1);
                        ps1.setString(1, name);
                        ps1.setString(2, username);
                        ResultSet rs1 = ps1.executeQuery();

                        while(rs1.next()) {
                            String message = rs1.getString("msg");
            %>
            <tr>
                <td><%= name %></td>
                <td><%= message %></td>
            </tr>
            <%
                        }
                    }
                } catch(Exception e) {
            %>
            <tr>
                <td colspan="2" style="color:red; text-align:center;">
                    Error: <%= e.getMessage() %>
                </td>
            </tr>
            <%
                }
            %>
        </table>
    </div>

    <!-- MESSAGE RECEIVED -->
    <div style="margin-left:300px; margin-top: 90px; width: 50%">
        <table id="customers" style="width: 250px">
            <th colspan="3">Message Received</th>
            <tr>
                <th>Student Name</th>
                <th>Message Received</th>
                <th>Reply</th>
            </tr>

            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/faculty_login",
                            "root",
                            "root"
                    );

                    // ✅ In your old code: fid saved as "fname lname"
                    String facultyFullName = fname + " " + lname;

                    qr = "select sid from messages where fid=? group by sid";
                    ps = con.prepareStatement(qr);
                    ps.setString(1, facultyFullName);
                    rs = ps.executeQuery();

                    while(rs.next()) {
                        String name = rs.getString("sid");

                        String qr1 = "select msg from messages where fid=? and sid=?";
                        PreparedStatement ps1 = con.prepareStatement(qr1);
                        ps1.setString(1, facultyFullName);
                        ps1.setString(2, name);
                        ResultSet rs1 = ps1.executeQuery();

                        while(rs1.next()) {
                            String message = rs1.getString("msg");

                            // Get student full name
                            String studentFullName = name;
                            Connection c = DriverManager.getConnection(
                                    "jdbc:mysql://localhost:3306/student_login",
                                    "root",
                                    "root"
                            );
                            String qr2 = "select fname,lname from login where username=?";
                            PreparedStatement ps2 = c.prepareStatement(qr2);
                            ps2.setString(1, name);
                            ResultSet r = ps2.executeQuery();
                            if(r.next()){
                                studentFullName = r.getString("fname") + " " + r.getString("lname");
                            }
            %>
            <tr>
                <td><%= studentFullName %></td>
                <td><%= message %></td>
                <td>
                    <form action="new_faculty_message.jsp">
                        <input type="hidden" value="<%= studentFullName %>" name="fac_name">
                        <input type="submit" value="Reply">
                    </form>
                </td>
            </tr>
            <%
                        }
                    }

                } catch(Exception e) {
            %>
            <tr>
                <td colspan="3" style="color:red; text-align:center;">
                    Error: <%= e.getMessage() %>
                </td>
            </tr>
            <%
                }
            %>
        </table>
    </div>

</div>

</body>
</html>
