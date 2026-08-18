import com.db.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = { "/register_course" })
public class register_course extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {

            String course_id = request.getParameter("course_id");
            String uname = (String) request.getSession().getAttribute("uname");

            if (uname == null || uname.trim().equals("")) {
                response.sendRedirect("index.jsp");
                return;
            }

            if (course_id == null || course_id.trim().equals("")) {
                response.sendRedirect("course_register.jsp?msg=invalid");
                return;
            }

            String course_name = "";
            int roll = 0;
            int total = 30;

            // ✅ Step 1: Get course_name from faculty_login DB
            Connection conFaculty = DBConnection.getConnection("faculty_login");
            String qr1 = "SELECT course_name FROM courses WHERE course_id=?";
            PreparedStatement ps1 = conFaculty.prepareStatement(qr1);
            ps1.setString(1, course_id);
            ResultSet rs1 = ps1.executeQuery();

            if (rs1.next()) {
                course_name = rs1.getString("course_name");
            } else {
                response.sendRedirect("course_register.jsp?msg=courseNotFound");
                return;
            }

            rs1.close();
            ps1.close();
            conFaculty.close();

            // ✅ Step 2: Get student roll number from student_login DB
            Connection conStudent = DBConnection.getConnection("student_login");

            String qrRoll = "SELECT roll FROM login WHERE username=?";
            PreparedStatement psRoll = conStudent.prepareStatement(qrRoll);
            psRoll.setString(1, uname);
            ResultSet rsRoll = psRoll.executeQuery();

            if (rsRoll.next()) {
                roll = rsRoll.getInt("roll");
            } else {
                response.sendRedirect("course_register.jsp?msg=studentNotFound");
                return;
            }

            rsRoll.close();
            psRoll.close();

            // ✅ Step 3: CHECK DUPLICATE COURSE REGISTRATION
            String qrCheck = "SELECT id FROM courses WHERE username=? AND course_id=?";
            PreparedStatement psCheck = conStudent.prepareStatement(qrCheck);
            psCheck.setString(1, uname);
            psCheck.setString(2, course_id);
            ResultSet rsCheck = psCheck.executeQuery();

            if (rsCheck.next()) {
                // already registered
                response.sendRedirect("course_register.jsp?msg=alreadyRegistered");
                return;
            }

            rsCheck.close();
            psCheck.close();

            // ✅ Step 4: Insert new course registration
            String qrInsert = "INSERT INTO courses(username,course_id,course_name,roll,total,attended,marks) VALUES(?,?,?,?,?,?,?)";
            PreparedStatement psInsert = conStudent.prepareStatement(qrInsert);

            psInsert.setString(1, uname);
            psInsert.setString(2, course_id);
            psInsert.setString(3, course_name);
            psInsert.setInt(4, roll);
            psInsert.setInt(5, total);
            psInsert.setInt(6, 0); // attended default
            psInsert.setInt(7, 0); // marks default

            psInsert.executeUpdate();

            psInsert.close();
            conStudent.close();

            // ✅ Redirect to attendance page or success message
            response.sendRedirect("student_attendance.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
