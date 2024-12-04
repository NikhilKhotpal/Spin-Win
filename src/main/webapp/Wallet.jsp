<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Spin & Win</title>
    <link rel="shortcut icon" href="images/sp.jfif">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            display: flex;
            flex-wrap: wrap;
            font-size:18px;
            font-family: 'Comic Sans MS', cursive, sans-serif;
             height: 100vh;
        }
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
            text-align:center;
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
        
        .main-content {
            width: 100%;
            padding: 20px;
            box-sizing: border-box;
            background-color: #f0f0f0;
        }
        .header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            flex-wrap: wrap;
            
        }
        .header div {
            width: 48%;
            background: linear-gradient(to right, #00bfff, #1e90ff);
            color: white;
            text-align: center;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 10px;
            margin-left: 24%;
        }
        .buttons {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .buttons button {
            width: 48%;
            padding: 15px;
            margin-left:26%;
            background-color: black;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            margin-bottom: 10px;
        }
        .amount-display {
            text-align: center;
            margin-bottom: 20px;
        }
        .amount-display input {
            width: 80%;
            padding: 15px;
            font-size: 24px;
            text-align: center;
            border: 2px solid black;
            border-radius: 5px;
        }
        .amount-options {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }
        .amount-options button {
            width: 22%;
            padding: 15px;
            background-color: black;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            margin-bottom: 10px;
        }
        .amount-options button.selected {
            background: linear-gradient(to right, #00bfff, #1e90ff);
        }
        .add-money {
            text-align: center;
        }
        .add-money button {
            padding: 15px 30px;
            background: linear-gradient(to right, #00bfff, #1e90ff);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
        }
        .add-money button:hover{
        	font-size:20px;
        	cursor:pointer;
        }
        .buttons button:hover{
        	baground-color:white;
        	color:white;
        	font-size:20px;
        	cursor:pointer;
        	border-radius:20px;
        }
        @media (min-width: 768px) {
            .sidebar {
                width: 20%;
                text-align: left;
            }
            .main-content {
                width: 80%;
            }
        }
        .btn-hover.color-2 {
    background-image: linear-gradient(to right, #f5ce62, #e43603, #fa7199, #e85a19);
    box-shadow: 0 4px 15px 0 rgba(229, 66, 10, 0.75);
}
.btn-hover:focus {
    outline: none;
}
.btn-hover {
    width: 200px;
    font-size: 16px;
    font-weight: 600;
    color: #fff;
    cursor: pointer;
    margin: 20px;
    height: 55px;
    text-align:center;
    border: none;
    background-size: 300% 100%;

    border-radius: 50px;
    moz-transition: all .4s ease-in-out;
    -o-transition: all .4s ease-in-out;
    -webkit-transition: all .4s ease-in-out;
    transition: all .4s ease-in-out;
}

.btn-hover:hover {
    background-position: 100% 0;
    moz-transition: all .4s ease-in-out;
    -o-transition: all .4s ease-in-out;
    -webkit-transition: all .4s ease-in-out;
    transition: all .4s ease-in-out;
}
$primary: #004385;
.btn4{
  text-decoration: none;
  display: inline-block;
  background: #004385;
  padding: 1em 3em;
  color: white;
  font-size: 1.25em;
  text-transform: capitalize;
}.btn4:hover{
  transition: all ease-in-out 200ms;
  transform: translateY(-5px);
}
.btn-mg{
  margin-right: 2rem .5rem;
}
    </style>
    
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

    <div class="main-content">
    
        <div class="header">
            <!-- Bonus amount section -->
            <div class="btn4 btn-lrg btn-smooth btn-success btn-mg">Rs. <span id="bonusAmount">50</span><br>Amount</div>
            <div class="btn4 btn-lrg btn-smooth btn-success btn-mg">Rs. 0<br>Win Amt.</div>
        </div>

        <div class="buttons">
         <p>Your Withdraw Amount: Rs. <span id="walletWithdrawAmount"></span></p>
          <button onclick="initiateWithdrawal()">Withdraw</button>
        </div>

        <div class="amount-display">
            <input type="text" value="Rs. 100" readonly>
        </div>

       <div class="amount-options">
            <button class="btn-hover color-2" onclick="selectAmount(this, 50)">50</button>
            <button class="btn-hover color-2" onclick="selectAmount(this, 100)">100</button>
            <button class="btn-hover color-2" onclick="selectAmount(this, 150)">150</button>
            <button class="btn-hover color-2" onclick="selectAmount(this, 200)">200</button>
            <button class="btn-hover color-2" onclick="selectAmount(this, 230)">230</button>
            <button class="btn-hover color-2" onclick="selectAmount(this, 260)">260</button>
            <button class="btn-hover color-2" onclick="selectAmount(this, 300)">300</button>
            <button class="btn-hover color-2" onclick="selectAmount(this, 500)">500</button>
        </div>

        <div class="add-money">
            <button onclick="addMoney()">Add Money</button>
        </div>
           </div>

    <script>
        let selectedAmount = 0; // Default selected amount
        let bonusAmount = 50; // Initial bonus amount (displayed value)

        // Function to handle amount selection
        function selectAmount(button, amount) {
            // Deselect all buttons
            const buttons = document.querySelectorAll('.amount-options button');
            buttons.forEach(btn => btn.classList.remove('selected'));

            // Select the clicked button
            button.classList.add('selected');
            selectedAmount = amount;

            // Update the input display
            document.querySelector('.amount-display input').value = 'Rs. ' + selectedAmount;
        }

        // Function to handle "Add Money" button click
        function addMoney() {
            if (selectedAmount > 0) {
                bonusAmount += selectedAmount; // Add the selected amount to the current bonus
                document.getElementById('bonusAmount').innerText = bonusAmount; // Update bonus amount on the page

                alert('You have added Rs. ' + selectedAmount + ' to your bonus! New bonus amount: Rs. ' + bonusAmount);
            } else {
                alert('Please select an amount to add.');
            }
        }
    </script>
<script type="text/javascript" src="">function initiateWithdrawal() {
    // Get the value from the input field
    const withdrawAmountInput = document.getElementById('walletWithdrawAmount');
    const withdrawAmount = withdrawAmountInput.value; // Use value instead of textContent

    // Debugging: Log the withdraw amount
    console.log("Withdraw Amount:", withdrawAmount); // Log the amount to check its value

    // Ensure withdrawAmount is not empty or null and is a valid number
    if (withdrawAmount && parseFloat(withdrawAmount) > 0) {
        // Use AJAX to send the withdrawal request to the server
        const xhr = new XMLHttpRequest();
        xhr.open("POST", "WithdrawServlet", true); // Replace with your servlet URL
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                const response = JSON.parse(xhr.responseText);
                console.log("Server Response:", response); // Log the server response
                if (response.success) {
                    Swal.fire({
                        title: 'Withdrawal Successful!',
                        text: 'You have withdrawn Rs. ' + withdrawAmount,
                        icon: 'success'
                    });
                    // Reset the input field after a successful withdrawal
                    withdrawAmountInput.value = ''; 
                } else {
                    Swal.fire({
                        title: 'Error!',
                        text: response.message,
                        icon: 'error'
                    });
                }
            }
        };

        // Send the withdrawal amount to the servlet
        xhr.send("amount=" + encodeURIComponent(withdrawAmount)); 
    } else {
        // If the amount is invalid, display an error message
        Swal.fire({
            title: 'Invalid Amount!',
            text: 'Please enter a valid amount greater than 0.',
            icon: 'warning'
        });
        console.log("Invalid amount entered."); // Log for debugging
    }
}
</script>
   <script src="">
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
// Function to get the withdraw amount from URL parameters
function getWithdrawAmount() {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get('withdrawAmount') || 0;
}

document.addEventListener("DOMContentLoaded", function() {
    const withdrawAmount = getWithdrawAmount();
    document.getElementById('walletWithdrawAmount').textContent = withdrawAmount;
});


</script>
</body>
</html>