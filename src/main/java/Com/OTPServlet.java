package Com;

import java.io.IOException;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class OTPServlet
 */
@WebServlet("/OTPServlet")
public class OTPServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public OTPServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
		 String mobileNumber = request.getParameter("mobileNumber");

	        // Generate OTP
	        String otp = generateOTP();

	        // Save OTP in session for later verification
	        HttpSession session = request.getSession();
	        session.setAttribute("generatedOTP", otp);

	        // Send OTP via SMS
	        try {
	            sendSMS(mobileNumber, otp);
	            response.getWriter().write("OTP sent successfully.");
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.getWriter().write("Failed to send OTP.");
	        }
	    }

	    // Method to generate a 6-digit OTP
	    private String generateOTP() {
	        Random random = new Random();
	        int otp = 100000 + random.nextInt(900000); // Generates a number between 100000 and 999999
	        return String.valueOf(otp);
	    }

	    // Method to send SMS via Twilio
	    private void sendSMS(String mobileNumber, String otp) {
	       // Twilio.init(ACCOUNT_SID, AUTH_TOKEN);
	        //Message.creator(
	          //  new PhoneNumber(mobileNumber),   // To mobile number
	            //new PhoneNumber(TWILIO_PHONE_NUMBER), // From Twilio number
	            //"Your OTP is: " + otp            // Message content
	       // ).create();
	    
	}

}
