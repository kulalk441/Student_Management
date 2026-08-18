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
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import com.db.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Harsh Jain
 */
@WebServlet(urlPatterns = { "/update_faculty_details" })
public class update_faculty_details extends HttpServlet {

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
            String field = request.getParameter("field");
            String value = request.getParameter("value");
            String faculty_username = request.getParameter("faculty_username");

            // Case 1: Partial update from show_faculty_details.jsp (Admin)
            if (field != null && faculty_username != null) {
                Connection con = DBConnection.getConnection("faculty_login");
                String qr = "";

                // Allow only specific fields to be updated for security
                if (field.equals("fname") || field.equals("lname") || field.equals("username")
                        || field.equals("password")) {
                    qr = "update login set " + field + "=? where username=?";
                    java.sql.PreparedStatement ps = con.prepareStatement(qr);
                    ps.setString(1, value);
                    ps.setString(2, faculty_username);
                    ps.executeUpdate();

                    // If username itself was updated, redirect with the NEW username
                    String redirectUser = field.equals("username") ? value : faculty_username;
                    response.sendRedirect("show_faculty_details.jsp?faculty_username=" + redirectUser);
                    return;
                }
            }

            // Case 2: Bulk update from update_faculty_details.jsp (Faculty self-service)
            String fname = request.getParameter("firstname");
            String lname = request.getParameter("lastname");
            String pass = request.getParameter("password");
            String sessionUser = (String) request.getSession().getAttribute("uname");

            if (fname != null && sessionUser != null) {
                Connection con = DBConnection.getConnection("faculty_login");
                String qr = "update login set fname=?, lname=?, password=? where username=?";
                java.sql.PreparedStatement ps = con.prepareStatement(qr);
                ps.setString(1, fname);
                ps.setString(2, lname);
                ps.setString(3, pass);
                ps.setString(4, sessionUser);
                ps.executeUpdate();
                response.sendRedirect("faculty_home.jsp");
                return;
            }

            // Fallback: if nothing matched, just go back
            response.sendRedirect("admin_home.jsp");

        } catch (java.sql.SQLException ex) {
            Logger.getLogger(update_faculty_details.class.getName()).log(Level.SEVERE, null, ex);
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
