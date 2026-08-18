<%-- 
    Document   : see_student_notice
    Created on : 10 Oct, 2018, 5:31:41 PM
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
        <title>Student Notices</title>
        <link rel="stylesheet" href="styles.css">
        <script>
            function update_details()
            {
                alert("Contact the administrator for any updations!!");
            }
        </script>
    </head>
    <body>
       <div class="divide" style="background-color: #43425D; left: 0">
            <div style="color:white;font-size: 20px; font-family: sans-serif;display: block;text-align: center;
                 margin-top: 20px; margin-bottom: 25px;">ABC Insitute</div>
            <hr> 
            <ul>
                 <li><a href="student_home.jsp">Home</a></li>
                 <li><a href="student_attendance.jsp">Check Attendance</a></li>
                 <li><a href="see_student_notice.jsp" class="active">Check Notices</a></li>
                 <li><a href="student_marks.jsp">Check Marks</a></li>
                 <li><a href="course_registration.jsp">Course Registration</a></li>
                 <li><a href="chat_student.jsp">Chat Room</a></li>
                 <li><a href="index.jsp">Sign Out</a></li>
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
                    while(rs.next())
                    {
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
                    out.println("<p style='color:red;text-align:center;'>Error: "+e.getMessage()+"</p>");
                }
            %>
        </div>    

        <!-- Student Info Right -->
        <div class="divide facutly_info_right">
            <br><br>

            <!-- Removed student image code because column does not exist -->
            <p align="center" class="facutly_info">
                <%
                    String username = (String)session.getAttribute("uname");

                    try{
                        Class.forName("com.mysql.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/student_login","root","root");

                        String qr2 = "select fname,lname,department,roll from login where username=?";
                        ps = con.prepareStatement(qr2);
                        ps.setString(1, username);

                        rs = ps.executeQuery();

                        while(rs.next()){
                            String roll = rs.getString("roll");
                            String fname = rs.getString("fname");
                            String lname = rs.getString("lname");
                            String department = rs.getString("department");
                %>
                            Roll Number : <%=roll%>
                            <br><br>
                            Name : <%=fname+" "+lname%>
                            <br><br>
                            Department : <%=department%>
                            <br><br>
                <%
                        }
                    }catch(Exception e){
                        out.println("<p style='color:red;'>Student Info Error: "+e.getMessage()+"</p>");
                    }
                %>

                <form onsubmit="update_details()">
                    <input type="submit" value="Update Details">
                </form>
            </p>
        </div>

    </body>
</html>


