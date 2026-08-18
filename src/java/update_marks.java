import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/update_marks")
public class update_marks extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String studentUsername = request.getParameter("student_username");
        String courseName = request.getParameter("course_name");
        String marksStr = request.getParameter("marks");

        if (studentUsername == null || courseName == null || marksStr == null ||
                studentUsername.trim().equals("") || courseName.trim().equals("") || marksStr.trim().equals("")) {

            response.getWriter().println("Error: Missing values!");
            return;
        }

        int marks;
        try {
            marks = Integer.parseInt(marksStr);
        } catch (Exception e) {
            response.getWriter().println("Error: Marks must be number!");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/student_login",
                    "root",
                    "root"
            );

            String qr = "UPDATE courses SET marks=? WHERE username=? AND course_name=?";
            ps = con.prepareStatement(qr);
            ps.setInt(1, marks);
            ps.setString(2, studentUsername);
            ps.setString(3, courseName);

            int updated = ps.executeUpdate();

            if (updated > 0) {
                response.sendRedirect("upload_marks.jsp?course_name=" + courseName);
            } else {
                response.getWriter().println("Student not found in this course!");
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
