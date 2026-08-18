<%-- Document : faculty_attendance Created on : 17 Sep, 2018, 9:10:06 PM Author : Harsh Jain --%>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.DriverManager" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="com.db.DBConnection" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Upload Attendance</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <script>
        function courseNameSelection() {
            var x = document.getElementById("course_select");
            var course_name = x.options[x.selectedIndex].value;
            window.location.replace("total_lectures?course_name=" + course_name);
        }
        function update_details() {
            alert("Please contact the administrator to update the details!");
        }
    </script>
</head>
<body>
    <div class="divide" style="background-color: #43425D; left: 0">
        <div style="color:white;font-size: 20px; font-family: sans-serif;display: block;text-align: center; margin-top: 20px; margin-bottom: 25px;">ABC Insitute</div>
        <hr>
        <ul>
            <li><a href="faculty_home.jsp">Home</a></li>
            <li><a href="faculty_attendance.jsp" class="active">Upload Attendance</a></li>
            <li><a href="faculty_notice.jsp">Upload Notices</a></li>
            <li><a href="faculty_marks.jsp">Upload Marks</a></li>
            <li><a href="chat_faculty.jsp">Chat Room</a></li>
            <li><a href="index.jsp">Sign Out</a></li>
        </ul>
    </div>
    <div class="divide" style="left: 42%; width: 50%; height: 45%; top: 35%; right: 20%; text-align: center;">
        <% String status=request.getParameter("status"); if ("EMPTY".equals(status)) { %>
            <p style="color: red; font-weight: bold;">Error: No students are enrolled!</p>
        <% } %>
        <p>Select a course:</p>
        <select id="course_select">
            <% 
                String username=(String) session.getAttribute("uname");
                Connection con=DBConnection.getConnection("faculty_login");
                String qr="select DISTINCT course_id, course_name from courses"; 
                PreparedStatement ps=con.prepareStatement(qr); 
                ResultSet rs=ps.executeQuery(); 
                while(rs.next()) { 
            %>
                <option value="<%=rs.getString("course_name")%>"><%=rs.getString("course_id")%> - <%=rs.getString("course_name")%></option>
            <% } con.close(); %>
        </select>
        <br><br>
        <input type="submit" value="See Students Enrolled" onclick="courseNameSelection()">
    </div>
</body>
</html>
