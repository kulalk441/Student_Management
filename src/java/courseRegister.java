/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import com.db.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.db.DBConnection;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Harsh Jain
 */
@WebServlet(urlPatterns = { "/courseRegister" })
public class courseRegister extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String course_name = request.getParameter("course_name");
            String course_id = request.getParameter("course_id");
            String faculty_username = request.getParameter("faculty_username");

            Connection con = DBConnection.getConnection("faculty_login");
            PreparedStatement ps = null;
            ResultSet rs = null;

            // 1. Check if Course ID already exists
            String qrId = "select course_id from courses where course_id=?";
            ps = con.prepareStatement(qrId);
            ps.setString(1, course_id);
            rs = ps.executeQuery();
            if (rs.next()) {
                response.sendRedirect("course_register.jsp?status=CID");
                return;
            }

            // 2. Check if Course Name already exists
            String qrName = "select course_name from courses where course_name=?";
            ps = con.prepareStatement(qrName);
            ps.setString(1, course_name);
            rs = ps.executeQuery();
            if (rs.next()) {
                response.sendRedirect("course_register.jsp?status=CNAME");
                return;
            }

            // 3. Verify if Faculty Username exists in the login table
            String qrUser = "select username from login where username=?";
            ps = con.prepareStatement(qrUser);
            ps.setString(1, faculty_username);
            rs = ps.executeQuery();

            if (rs.next()) {
                // Faculty found, proceed with registration
                String qrInsert = "insert into courses(username,course_id,course_name) values(?,?,?)";
                ps = con.prepareStatement(qrInsert);
                ps.setString(1, faculty_username);
                ps.setString(2, course_id);
                ps.setString(3, course_name);
                ps.executeUpdate();
                response.sendRedirect("course_register.jsp");
            } else {
                // Faculty not found
                response.sendRedirect("course_register.jsp?status=UNAME");
            }

        } catch (SQLException ex) {
            Logger.getLogger(courseRegister.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
