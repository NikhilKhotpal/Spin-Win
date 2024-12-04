<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="main.css">
    <link rel="shortcut icon" href="images/sp.jfif">
    <title>Spin & Win</title>
    
    <style>
        /* Include any additional styles you may need */
        body {
            margin: 0px;
            display: flex;
            height: 100vh;
            font-size:18px;
            font-family: 'Comic Sans MS', cursive, sans-serif; /* Fun font for children */
            background: linear-gradient(to right, #87CEEB, #FFD700)
        }

        /* Sidebar styles */
        nav#sidebar {
            width: 250px;
            background: deepskyblue;
            padding: 10px 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            color: #fff;
        }

        nav#sidebar img.logo-circle {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 10px;
            border: 2px solid #FFFFFF;
        }

        nav#sidebar .user {
            margin-top: 20px;
            color:black;
        }

        nav#sidebar .user label {
            display: block;
        }

        nav#sidebar ul {
            list-style: none;
            padding: 0;
            width: 100%;
        }

        nav#sidebar ul li {
            width: 88%;
            padding: 15px;
            text-align: center;
            cursor: pointer;
            transition: background 0.3s;
        }

        nav#sidebar ul li:hover {
            background: rgba(255, 255, 255, 0.2);
        }

        nav#sidebar ul li.active {
            background: white;
            color: deepskyblue;
        }

        nav#sidebar ul li a {
            color: inherit;
            text-decoration: none;
        }

        .container {
            flex: 1;
            padding: 20px;
        }

        .info-boxes {
            display: flex;
            justify-content: space-around;
            margin-top: 20px;
        }

        .bonus-box, .withdraw-box {
            border: 1px solid #ccc;
            padding: 25px;
            border-radius: 5px;
            width: 45%;
            text-align: center;
            margin:15px;
        }
        .bonus-box:hover, .withdraw-box:hover{
        	border-radius:20px;
        }

        .spin-button, .spin-more-button, .withdraw-button {
            background: deepskyblue;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-align: center;
            cursor: pointer;
            width: 120px;
            margin: 10px auto;
        }
    </style>
    <!-- Include SweetAlert CSS and JS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
</head>
<body>
<%
	response.setHeader("cache-Control","no-cache, no-store, must-revalidate");
%>
    <nav id="sidebar">
    
        <img src="<%= session.getAttribute("image") != null ? "uploads/" + session.getAttribute("image") : "images/default.jpg" %>" alt="Profile Picture" class="logo-circle">
        <div class="user">
            <label class="uname">UserName :-
                <% 
                    String fname = (String) session.getAttribute("fname");
                    if (fname != null) {
                        out.print(fname); // Display the value
                    } else {
                        out.print("Name not available"); // Fallback message if session is null
                    } 
                %>
            </label><br>
            <label class="unumber">Contact No :-<% 
                    String contact = (String) session.getAttribute("contact");
                    if (contact != null) {
                        out.print(contact); // Display the contact number
                    } else {
                        out.print("Not available"); // Fallback message if contact number is null
                    } 
                %></label>
        </div>
        
        <ul class="group">
            <li class="active"><a href="Dashboard.jsp"><i class="material-icons"></i>Home</a></li>
            <li><a href="Wallet.jsp"><i class="material-icons"></i>Wallet</a></li>
            <li><a href="#link3"><i class="material-icons"></i>Privacy Policy</a></li>
            <li><a href="#link4"><i class="material-icons"></i>Terms & Condition</a></li>
            <li><a href="Profile.jsp"><i class="material-icons"></i>Profile Update</a></li>
            <li><a href="Logout.jsp" id="logoutButton"><i class="material-icons"></i>LogOut</a></li>
        </ul>
    </nav>
    
    <div id="toolbar" class="container">
        <div class="spin-button">Start Spin</div>
        <div id="message-box" class="message-box"></div>
        <br>
        <div class="wheel-container">
            <canvas id="wheel" width="300" height="300"></canvas>
        </div>
        
        
        <div class="info-boxes">
            <div class="bonus-box">
                <h3>Your Amount</h3>
                <p>Rs. <span id="bonusAmount">
                    <%
                        Integer bonusAmount = (Integer) session.getAttribute("bonusAmount");
                        out.print(bonusAmount != null ? bonusAmount : 0);
                    %>
                </span></p>
            </div>
            <div class="withdraw-box">
                <h3>Withdraw</h3>
                <p>Rs. <span id="withdrawAmount"><%
                        Integer withdrawAmount = (Integer) session.getAttribute("withdrawAmount");
                        out.print(withdrawAmount != null ? withdrawAmount : 0);
                    %></span></p>
                    <button id="wallet-button">Go to Wallet</button>
            </div>
        </div>
    </div>

	
    <script src="main1.js"></script>
    <script>
        // Optional: Add any JavaScript functionality needed for the sidebar
        const sidebarLinks = document.querySelectorAll('nav#sidebar ul li');
        sidebarLinks.forEach(link => {
            link.addEventListener('click', function() {
                sidebarLinks.forEach(l => l.classList.remove('active'));
                this.classList.add('active');
            });
        });

        // Reference to the new buttons
       // const spinMoreButton = document.querySelector('.spin-more-button');
        //const withdrawButton = document.querySelector('.withdraw-button');

        // Event listener for "Withdraw" button
       // withdrawButton.addEventListener("click", function() {
         //   let withdrawAmount = 0; // This should be replaced with actual withdraw amount logic
           // alert(`You have withdrawn Rs. ${withdrawAmount}`);
            //withdrawAmount = 0; // Reset the withdrawable amount after withdrawal
            //withdrawDisplay.textContent = withdrawAmount; // Update the displayed amount
        //});
    </script>
<script>
// Add event listener to the logout button
document.getElementById("logoutButton").addEventListener("click", function(event) {
    event.preventDefault(); // Prevent the default action of the link
    Swal.fire({
        title: 'Are you sure?',
        text: "Once You Logout your data is not visible",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, log me out!'
    }).then((result) => {
        if (result.isConfirmed) {
            // Redirect to a logout servlet or JSP that handles session invalidation
            window.location.href = 'Logout.jsp'; // Create this servlet
        }
    });
});
</script>

    <%
    String seslogingin = (String) session.getAttribute("seslogingin");
        // Display success message
        if (seslogingin != null) {
    %>
    <script>
        Swal.fire({
            title: "Login Successfull!",
            text: "Welcome, <% 
                    String fname1 = (String) session.getAttribute("fname");
                    if (fname != null) {
                        out.print(fname1); // Display the value
                    } else {
                        out.print("Name not available"); // Fallback message if session is null
                    } 
                %>! You Get a 50₹ Bonus",
            icon: "success",
            confirmButtonText: "Start The Game!"
        });
    </script>
    <%
            session.setAttribute("seslogingin", null); // Clear session attribute after showing the message
        }
        
        // Display failure message if exists
        String loginFailed = (String) session.getAttribute("loginfailed");
        if (loginFailed != null) {
    %>
    <script>
        Swal.fire({
            title: "Failed",
            text: "<%= loginFailed %>",
            icon: "error",
            confirmButtonText: "Click!"
        });
    </script>
    <%
            session.setAttribute("loginfailed", null); // Clear session attribute after showing the message
        }
    %>
    <!-- let bonusAmount = parseInt(document.getElementById('bonusAmount').textContent);
     -->
</body>
</html>
