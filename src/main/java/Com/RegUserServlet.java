package Com;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 * Servlet implementation class RegUser
 */
@WebServlet("/RegUser")
@MultipartConfig(maxFileSize = 16177215) // Limit image upload size to 16MB
public class RegUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
		HttpSession session = request.getSession();
        String fname = request.getParameter("fname");
        String phone = request.getParameter("phone");

        // Input validation
        if (fname == null || fname.trim().isEmpty() || phone == null || phone.trim().isEmpty() || !isValidMobileNumber(phone)) {
            response.getWriter().write("Invalid input. Please check your details.");
            return;
        }

        // Image upload handling
        Part imagePart = request.getPart("image");
        String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir(); // Create directory if not exists
        }
        String filePath = uploadPath + File.separator + fileName;

        // Save the image file to the server
        try (FileOutputStream fos = new FileOutputStream(filePath);
             InputStream inputStream = imagePart.getInputStream()) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                fos.write(buffer, 0, bytesRead);
            }
        }

        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/spin", "root", "");

            // Check if the user already exists in 'reguser' table
            String checkUserSql = "SELECT * FROM reguser WHERE phone = ? AND fname = ?";
            stmt = con.prepareStatement(checkUserSql);
            stmt.setString(1, phone);
            stmt.setString(2, fname);
            rs = stmt.executeQuery();

            int regId = -1;
            if (rs.next()) {
                regId = rs.getInt("id");
            } else {
                // Insert new user into 'reguser' table with image file path
                String insertSql = "INSERT INTO reguser (fname, phone, image) VALUES (?, ?, ?)";
                stmt = con.prepareStatement(insertSql);
                stmt.setString(1, fname);
                stmt.setString(2, phone);
                stmt.setString(3, "uploads/" + fileName); // Store image path
                stmt.executeUpdate();

                // Retrieve the newly inserted user's ID
                String getNewUserSql = "SELECT LAST_INSERT_ID() AS last_id";
                stmt = con.prepareStatement(getNewUserSql);
                ResultSet newUserRs = stmt.executeQuery();
                if (newUserRs.next()) {
                    regId = newUserRs.getInt("last_id");
                }
                newUserRs.close();
            }

            // Set session attributes for the logged-in user
            session.setAttribute("seslogingin", "success");
            session.setAttribute("fname", fname);
            session.setAttribute("contact", phone);
            session.setAttribute("image", fileName);

            // Fetch or initialize bonus and spin details from 'users1' table
            String getUserAmountsSql = "SELECT spins_count, bonus_amount, withdraw_amount FROM users1 WHERE reg_id = ?";
            stmt = con.prepareStatement(getUserAmountsSql);
            stmt.setInt(1, regId);
            rs = stmt.executeQuery();

            int spinsCount = 0;
            int bonusAmount = 50; // Default bonus for new users
            int withdrawAmount = 0;

            if (rs.next()) {
                spinsCount = rs.getInt("spins_count");
                bonusAmount = rs.getInt("bonus_amount");
                withdrawAmount = rs.getInt("withdraw_amount");
            } else {
                // Insert default values for new users in 'users1' table
                String insertUserAmounts = "INSERT INTO users1 (reg_id, bonus_amount, withdraw_amount, spins_count) VALUES (?, ?, ?, ?)";
                stmt = con.prepareStatement(insertUserAmounts);
                stmt.setInt(1, regId);
                stmt.setInt(2, bonusAmount);
                stmt.setInt(3, withdrawAmount); // Initial withdraw amount
                stmt.setInt(4, spinsCount);
                stmt.executeUpdate();
            }

            // Deduct Rs. 25 for every spin
            if (spinsCount >= 1) {
	            int deduction = (spinsCount / 2) * 25;
	            bonusAmount = Math.max(0, bonusAmount - deduction);
	            spinsCount = spinsCount % 2; // Reset spin count after deduction
	            spinsCount++; 
	        } else if (spinsCount == 2) {
	            // If the user only has one spin, we do not perform any deduction here.
	            spinsCount++;
	        } else {
	            // For new users or users with zero spins
	            spinsCount++; // Increment spins count for the new spin
	        }

            // Update the user's bonus amount and spins count in 'users1' table
            String sql = "UPDATE users1 SET bonus_amount = ?, spins_count = ? WHERE reg_id = ?";
            PreparedStatement updateStmt = con.prepareStatement(sql);
            updateStmt.setInt(1, bonusAmount);
            updateStmt.setInt(2, spinsCount);
            updateStmt.setInt(3, regId);

            int rowsUpdated = updateStmt.executeUpdate();
            if (rowsUpdated > 0) {
                // Update session attributes with the bonus amount and withdrawal amount
                session.setAttribute("bonusAmount", bonusAmount);
                session.setAttribute("withdrawAmount", withdrawAmount);
            } else {
                response.getWriter().write("Error updating amounts: No rows affected.");
                return;
            }

            // Redirect the user to the dashboard after successful update
            response.sendRedirect("Dashboard.jsp");

        } catch (Exception ex) {
            ex.printStackTrace();
            response.getWriter().write("An error occurred: " + ex.getMessage());
        } finally {
            // Close all resources to prevent memory leaks
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    // Helper method to validate the phone number format
    private boolean isValidMobileNumber(String phone) {
        String regex = "^[0-9]{10}$";
        return phone.matches(regex);
    }
}

	    
   

  
