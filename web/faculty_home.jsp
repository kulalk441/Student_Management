<%@page import="java.sql.*" %>
    <%@page import="com.db.DBConnection" %>
        <%@page contentType="text/html" pageEncoding="UTF-8" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Faculty Portal</title>
                <link rel="stylesheet" href="styles.css">
                <script>
                    function update_details() {
                        alert("Please contact the administrator to update the details!");
                    }
                </script>
            </head>

            <body>
                <% String user=request.getParameter("username"); if (user !=null) { session.setAttribute("uname", user);
                    } String username=(String) session.getAttribute("uname"); Connection con=null; PreparedStatement
                    ps=null; ResultSet rs=null; String fname="" , lname="" , department="" ; int age=0; try {
                    con=DBConnection.getConnection("faculty_login"); String
                    query="SELECT fname, lname, department, age FROM login WHERE username=?" ;
                    ps=con.prepareStatement(query); ps.setString(1, username); rs=ps.executeQuery(); if (rs.next()) {
                    fname=rs.getString("fname"); lname=rs.getString("lname"); department=rs.getString("department");
                    age=rs.getInt("age"); } } catch (Exception e) { out.println("<p style='color:red;'>Error: " +
                    e.getMessage() + "</p>");
                    }
                    %>

                    <div class="divide" style="background-color:#43425D; left:0">
                        <div style="color:white;font-size:20px;text-align:center;margin:20px">
                            ABC Institute
                        </div>
                        <hr>
                        <ul>
                            <li><a href="faculty_home.jsp" class="active">Home</a></li>
                            <li><a href="faculty_attendance.jsp">Upload Attendance</a></li>
                            <li><a href="faculty_notice.jsp">Upload Notices</a></li>
                            <li><a href="faculty_marks.jsp">Upload Marks</a></li>
                            <li><a href="chat_faculty.jsp">Chat Room</a></li>
                            <li><a href="index.jsp">Sign Out</a></li>
                        </ul>
                    </div>

                    <div class="divide"
                        style="left: 22%; width: 56%; background:#ECF0F1; top: 1%; height: 99%;right: 25%; overflow-x: auto; overflow-y: auto">
                        <div style="padding: 40px; font-family: sans-serif;">
                            <h1 style="color: #43425D; font-size: 32px; margin-bottom: 10px;">Welcome Back, <%= fname %>
                                    !</h1>
                            <p style="color: #666; font-size: 18px; line-height: 1.6;">
                                Manage your courses, track student attendance, and upload results efficiently.
                            </p>

                            <div
                                style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin-top: 40px;">
                                <a href="faculty_attendance.jsp" style="text-decoration: none;">
                                    <div
                                        style="background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); transition: transform 0.2s;">
                                        <h3 style="color: #4CAF50; margin-top: 0;">Attendance</h3>
                                        <p style="color: #888; margin-bottom: 0;">Mark and view student attendance.</p>
                                    </div>
                                </a>

                                <a href="faculty_marks.jsp" style="text-decoration: none;">
                                    <div
                                        style="background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); transition: transform 0.2s;">
                                        <h3 style="color: #2196F3; margin-top: 0;">Marks</h3>
                                        <p style="color: #888; margin-bottom: 0;">Upload and manage exam scores.</p>
                                    </div>
                                </a>

                                <a href="faculty_notice.jsp" style="text-decoration: none;">
                                    <div
                                        style="background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); transition: transform 0.2s;">
                                        <h3 style="color: #FF9800; margin-top: 0;">Notices</h3>
                                        <p style="color: #888; margin-bottom: 0;">Post updates for students.</p>
                                    </div>
                                </a>

                                <a href="chat_faculty.jsp" style="text-decoration: none;">
                                    <div
                                        style="background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); transition: transform 0.2s;">
                                        <h3 style="color: #9C27B0; margin-top: 0;">Chat</h3>
                                        <p style="color: #888; margin-bottom: 0;">Communicate with other faculty.</p>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="divide facutly_info_right">
                        <p class="facutly_info" align="center">
                            Name : <%= fname %>
                                <%= lname %><br><br>
                                    Department : <%= department %><br><br>
                                        Age : <%= age %><br><br>
                        </p>

                        <form onsubmit="update_details()">
                            <input type="submit" value="Update Details">
                        </form>
                    </div>

                    <% try { if(rs!=null) rs.close(); } catch(Exception e) {} try { if(ps!=null) ps.close(); }
                        catch(Exception e) {} try { if(con!=null) con.close(); } catch(Exception e) {} %>
            </body>

            </html>