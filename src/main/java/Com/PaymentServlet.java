package Com;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
// Import statements for Paytm classes
//import com.paytm.pg.sdk.PaytmUtils;
//import com.paytm.pg.sdk.PaytmOrder;
//import com.paytm.pg.sdk.PaytmChecksum;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public PaymentServlet() {
        super();
        
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set up Paytm parameters
    	String mid = request.getParameter("MID");
        String orderId = request.getParameter("ORDERID");

        // Initialize a TreeMap for Paytm parameters
        TreeMap<String, String> params = new TreeMap<>();
        params.put("MID", mid);
        params.put("ORDERID", orderId);

        try {
            // Generate checksum
            //String paytmchecksum = PaytmChecksum.generateSignature(params, "YOUR_MERCHANT_KEY");
         //  boolean verifySignature = PaytmChecksum.verifySignature(params, "YOUR_MERCHANT_KEY", );

            // Send the response back
            response.setContentType("application/json");
            //response.getWriter().write("{\"checksum\":\"" +  + "\", \"isValid\":\"" + verifySignature + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating checksum.");
        }
    }
}
