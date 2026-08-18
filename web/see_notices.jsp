<%-- 
    Document   : see_notices
    Created on : 5 Oct, 2018, 9:32:11 PM
    Author     : Harsh Jain
--%>

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
   <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>See Notices</title>
        <link rel="stylesheet" href="styles.css">
        <script>
            function update_details()
            {
                 alert("Please contact the administrator to update the details!");
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
                <li><a href="faculty_settings.jsp">Settings</a></li>
            </ul> 
        </div>

        <!-- Notices Center -->
        <div class="divide" style="left: 27%; width: 50%; height: 80%; top: 10%; right: 20%; overflow-x: hidden; overflow-y: auto">

            <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/faculty_login","root","root");

                    String qr = "select image_path from notices";
                    ps = con.prepareStatement(qr);
                    rs = ps.executeQuery();

                    boolean found = false;

                    while(rs.next()){
                        found = true;
            %>
                        <img src="images/<%=rs.getString("image_path")%>" height="600px" width="600px">
                        <hr>
            <%
                    }

                    if(!found){
            %>
                        <p style="text-align:center; font-size:18px; color:gray; margin-top:30px;">
                            No notices uploaded yet.
                        </p>
            <%
                    }

                } catch(Exception e){
                    out.println("<p style='color:red;text-align:center;'>Error: " + e.getMessage() + "</p>");
                } finally {
                    try { if(rs != null) rs.close(); } catch(Exception e) {}
                    try { if(ps != null) ps.close(); } catch(Exception e) {}
                    try { if(con != null) con.close(); } catch(Exception e) {}
                }
            %>

        </div>

        <!-- Faculty Info Right -->
        <div class="divide facutly_info_right">
            <br><br>

            <p align="center" class="facutly_info">
            <%
                String username = (String)session.getAttribute("uname");

                Connection con2 = null;
                PreparedStatement ps2 = null;
                ResultSet rs2 = null;

                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    con2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/faculty_login","root","root");

                    String qr2 = "select fname,lname,department,age from login where username=?";
                    ps2 = con2.prepareStatement(qr2);
                    ps2.setString(1, username);
                    rs2 = ps2.executeQuery();

                    while(rs2.next()){
                        String fname = rs2.getString("fname");
                        String lname = rs2.getString("lname");
                        String department = rs2.getString("department");
                        String age = rs2.getString("age");
            %>
                        Name : <%=fname+" "+lname%>
                        <br><br>
                        Department : <%=department%>
                        <br><br>
                        Age : <%=age%>
                        <br><br>
            <%
                    }

                } catch(Exception e){
                    out.println("<p style='color:red;text-align:center;'>Error: " + e.getMessage() + "</p>");
                } finally {
                    try { if(rs2 != null) rs2.close(); } catch(Exception e) {}
                    try { if(ps2 != null) ps2.close(); } catch(Exception e) {}
                    try { if(con2 != null) con2.close(); } catch(Exception e) {}
                }
            %>

                <form onsubmit="update_details()">
                    <input type="submit" value="Update Details">
                </form>

            </p>
        </div>

    </body>
</html>
