package Com;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@javax.servlet.annotation.WebServlet("/updateservlet")  // Correct annotation for servlet mapping
public class updateservlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public updateservlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get parameters from the request
        String id = request.getParameter("id");
        String fname = request.getParameter("fname");
        String phone = request.getParameter("phone");

        // Response content type
        response.setContentType("text/plain");
        
        Connection con = null;
        PreparedStatement pst = null;

        try {
            // Load MySQL driver
            Class.forName("com.mysql.jdbc.Driver");  // Use com.mysql.cj.jdbc.Driver for MySQL 8+
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/spin", "root", "");

            // Use prepared statement to prevent SQL injection
            String updateSql = "UPDATE reguser SET phone = ?, fname = ? WHERE id = ?";
            pst = con.prepareStatement(updateSql);
            pst.setString(1, phone);    // Set phone value
            pst.setString(2, fname);    // Set fname value
            pst.setString(3, id);       // Set id value

            int rowsUpdated = pst.executeUpdate();

            if (rowsUpdated > 0) {
                response.getWriter().write("Updated Successfully");
            } else {
                response.getWriter().write("No records were updated. Check if the ID is correct.");
            }
        } catch (Exception ex) {
            // Log the error and send an error message to the client
            ex.printStackTrace();
            response.getWriter().write("Error: " + ex.getMessage());
        } finally {
            // Close resources to avoid memory leaks
            try {
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    // Optional: doGet method to handle GET requests
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }
}
