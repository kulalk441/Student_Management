<%-- 
    Document   : chat_student
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
        <title>Chat Room</title>

        <link rel="stylesheet" type="text/css" href="styles.css">

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
            function facultySelection() {
                var x = document.getElementById("faculty_select");
                var facultyName = x.options[x.selectedIndex].text;
                window.location.replace("new_student_message.jsp?faculty_name=" + facultyName);
            }

            function update_details() {
                alert("Contact the administrator for any updations!!");
            }
        </script>

    </head>

    <body>

        <%
            // Session
            String user = request.getParameter("username");
            if(user != null){
                session.setAttribute("uname", user);
            }

            String username = (String) session.getAttribute("uname");
            if(username == null){
                response.sendRedirect("index.jsp");
                return;
            }

            String fname = "";
            String lname = "";
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

        <!-- RIGHT STUDENT INFO -->
        <div class="divide facutly_info_right">

            <!-- ✅ STATIC DEFAULT IMAGE (NO DB) -->
            <img src="images/admin.jpeg" height="100px" width="100px"
                 style="border-radius: 10px; margin-left: 85px; margin-top: 20px">

            <br><br>

            <form onsubmit="update_details(); return false;">
                <input type="submit" value="Update Image">
            </form>

            <br><br>

            <p align="center" class="facutly_info">
                <%
                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    String qr = null;

                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/student_login","root","root");

                        qr = "select fname,lname,department,roll from login where username=?";
                        ps = con.prepareStatement(qr);
                        ps.setString(1, username);
                        rs = ps.executeQuery();

                        if(rs.next()){
                            String roll = rs.getString("roll");
                            fname = rs.getString("fname");
                            lname = rs.getString("lname");
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
                    } catch(Exception e){
                        out.println("<p style='color:red;text-align:center;'>Error: "+e.getMessage()+"</p>");
                    } finally {
                        try{ if(rs!=null) rs.close(); }catch(Exception e){}
                        try{ if(ps!=null) ps.close(); }catch(Exception e){}
                        try{ if(con!=null) con.close(); }catch(Exception e){}
                    }
                %>

                <form onsubmit="update_details(); return false;">
                    <input type="submit" value="Update Details">
                </form>
            </p>

        </div>

        <!-- CENTER CHAT AREA -->
        <div class="divide" style="left: 25%; width: 50%; height: 85%; top: 8%; right: 25%; overflow-x: auto; overflow-y: auto">

            <div style="height: 50px; position: absolute;">
                <select id="faculty_select" style="margin-left: 265px">
                    <%
                        Connection con2 = null;
                        PreparedStatement ps2 = null;
                        ResultSet rs2 = null;

                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            con2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/faculty_login","root","root");

                            String qr2 = "select fname,lname from login";
                            ps2 = con2.prepareStatement(qr2);
                            rs2 = ps2.executeQuery();

                            while(rs2.next()){
                    %>
                                <option><%=rs2.getString("fname")+" "+rs2.getString("lname")%></option>
                    <%
                            }
                        } catch(Exception e){
                            out.println("<option>Error loading faculty</option>");
                        } finally {
                            try{ if(rs2!=null) rs2.close(); }catch(Exception e){}
                            try{ if(ps2!=null) ps2.close(); }catch(Exception e){}
                            try{ if(con2!=null) con2.close(); }catch(Exception e){}
                        }
                    %>
                </select>

                <br><br>
                <input type="submit" value="Send Message" onclick="facultySelection()" style="margin-left:230px">
                <br><br><br>
            </div>

            <!-- SENT MESSAGES -->
            <div style="margin-top:90px; width: 50%; position: absolute">
                <table id="customers" style="width:250px">
                    <th colspan="2">Message Sent</th>
                    <tr>
                        <th>Faculty</th>
                        <th>Message</th>
                    </tr>

                    <%
                        Connection con3 = null;
                        PreparedStatement ps3 = null;
                        ResultSet rs3 = null;

                        try{
                            Class.forName("com.mysql.jdbc.Driver");
                            con3 = DriverManager.getConnection("jdbc:mysql://localhost:3306/faculty_login","root","root");

                            String qr3 = "select fid, msg from messages where sid=?";
                            ps3 = con3.prepareStatement(qr3);
                            ps3.setString(1, username);
                            rs3 = ps3.executeQuery();

                            while(rs3.next()){
                    %>
                            <tr>
                                <td><%=rs3.getString("fid")%></td>
                                <td><%=rs3.getString("msg")%></td>
                            </tr>
                    <%
                            }
                        } catch(Exception e){
                            out.println("<tr><td colspan='2' style='color:red;'>Error: "+e.getMessage()+"</td></tr>");
                        } finally {
                            try{ if(rs3!=null) rs3.close(); }catch(Exception e){}
                            try{ if(ps3!=null) ps3.close(); }catch(Exception e){}
                            try{ if(con3!=null) con3.close(); }catch(Exception e){}
                        }
                    %>

                </table>
            </div>

            <!-- RECEIVED MESSAGES -->
            <div style="margin-left:300px; margin-top: 90px; width: 50%">
                <table id="customers" style="width: 250px">
                    <th colspan="3">Message Received</th>
                    <tr>
                        <th>Faculty</th>
                        <th>Message</th>
                        <th>Reply</th>
                    </tr>

                    <%
                        Connection con4 = null;
                        PreparedStatement ps4 = null;
                        ResultSet rs4 = null;

                        try{
                            Class.forName("com.mysql.jdbc.Driver");
                            con4 = DriverManager.getConnection("jdbc:mysql://localhost:3306/faculty_login","root","root");

                            String studentFullName = fname + " " + lname;

                            String qr4 = "select fid, msg from messagef where sid=?";
                            ps4 = con4.prepareStatement(qr4);
                            ps4.setString(1, studentFullName);
                            rs4 = ps4.executeQuery();

                            while(rs4.next()){
                                String fid = rs4.getString("fid");
                                String msg = rs4.getString("msg");
                    %>
                            <tr>
                                <td><%=fid%></td>
                                <td><%=msg%></td>
                                <td>
                                    <form action="new_student_message.jsp">
                                        <input type="hidden" value="<%=fid%>" name="fac_name">
                                        <input type="submit" value="Reply">
                                    </form>
                                </td>
                            </tr>
                    <%
                            }
                        } catch(Exception e){
                            out.println("<tr><td colspan='3' style='color:red;'>Error: "+e.getMessage()+"</td></tr>");
                        } finally {
                            try{ if(rs4!=null) rs4.close(); }catch(Exception e){}
                            try{ if(ps4!=null) ps4.close(); }catch(Exception e){}
                            try{ if(con4!=null) con4.close(); }catch(Exception e){}
                        }
                    %>

                </table>
            </div>

        </div>

    </body>
</html>
