<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Upload Marks</title>
    <link rel="stylesheet" href="styles.css">
</head>

<body>

<div class="divide" style="background-color:#43425D; left:0">
    <div style="color:white;font-size:20px;text-align:center;margin:20px 0;">
        ABC Institute
    </div>
    <hr>
    <ul>
        <li><a href="faculty_home.jsp">Home</a></li>
        <li><a href="faculty_attendance.jsp">Upload Attendance</a></li>
        <li><a href="faculty_notice.jsp">Upload Notices</a></li>
        <li><a href="faculty_marks.jsp" class="active">Upload Marks</a></li>
        <li><a href="chat_faculty.jsp">Chat Room</a></li>
        <li><a href="index.jsp">Sign Out</a></li>
    </ul>
</div>

<div style="margin-left:30%; margin-top:12%;">

    <h2 style="text-align:center;">Select a course:</h2>

    <form action="upload_marks.jsp" method="get" style="text-align:center;">
        <select name="course_name" required style="width:200px;">
            <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/student_login",
                        "root",
                        "root"
                    );

                    String qr = "SELECT DISTINCT course_name FROM courses";
                    ps = con.prepareStatement(qr);
                    rs = ps.executeQuery();

                    while(rs.next()){
            %>
                        <option value="<%=rs.getString("course_name")%>">
                            <%=rs.getString("course_name")%>
                        </option>
            <%
                    }

                } catch(Exception e){
                    out.println("<option>Error: "+e.getMessage()+"</option>");
                } finally {
                    try{ if(rs!=null) rs.close(); }catch(Exception e){}
                    try{ if(ps!=null) ps.close(); }catch(Exception e){}
                    try{ if(con!=null) con.close(); }catch(Exception e){}
                }
            %>
        </select>

        <br><br>
        <input type="submit" value="See Students Enrolled" style="padding:10px 25px;">
    </form>

</div>

</body>
</html>
