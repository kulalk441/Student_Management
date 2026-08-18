import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/update_attendance")
public class update_attendance extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String studentUsername = request.getParameter("student_username");
        String courseName = request.getParameter("course_name");

        if (studentUsername == null || courseName == null ||
                studentUsername.trim().equals("") || courseName.trim().equals("")) {

            response.getWriter().println("Error: student_username or course_name missing!");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");

            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/student_login",
                    "root",
                    "root"
            );

            String qr = "UPDATE courses SET attended = attended + 1 WHERE username=? AND course_name=?";
            ps = con.prepareStatement(qr);
            ps.setString(1, studentUsername);
            ps.setString(2, courseName);

            int updated = ps.executeUpdate();

            if (updated > 0) {
                // ✅ redirect back to same course page
                response.sendRedirect("upload_attendance.jsp?course_name=" + courseName);
            } else {
                response.getWriter().println("Error: Student not found in this course!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}
