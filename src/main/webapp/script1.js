function initiateWithdrawal() {
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
