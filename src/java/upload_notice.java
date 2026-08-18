import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/upload_notice")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class upload_notice extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1) Get uploaded file
            Part filePart = request.getPart("notice");

            if (filePart == null || filePart.getSize() == 0) {
                response.getWriter().println("Please select a notice image!");
                return;
            }

            // 2) Get original filename
            String fileName = Paths.get(filePart.getSubmittedFileName())
                    .getFileName().toString();

            // 3) Remove spaces (IMPORTANT)
            fileName = fileName.replaceAll("\\s+", "_");

            // 4) Folder where image will be stored
            String uploadPath = getServletContext().getRealPath("") 
                    + File.separator + "images" 
                    + File.separator + "notices";

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // 5) Save uploaded file
            String fullPath = uploadPath + File.separator + fileName;
            filePart.write(fullPath);

            // ✅✅✅ IMPORTANT: use SAME DB for all (faculty/admin/student)
            Class.forName("com.mysql.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/faculty_login",   // ✅ your notices table is here
                    "root",
                    "root"
            );

            // 6) Insert filename into DB
            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO notices(image_path) VALUES(?)"
            );
            ps.setString(1, fileName);
            ps.executeUpdate();

            con.close();

            // 7) Redirect back
            response.sendRedirect("faculty_notice.jsp?msg=uploaded");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Upload Error: " + e.getMessage());
        }
    }
}
