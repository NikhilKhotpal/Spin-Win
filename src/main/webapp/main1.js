const wheelCanvas = document.getElementById("wheel");
const ctx = wheelCanvas.getContext("2d");

const numbers = [-20, -40, 0, 20, 100, 300, 5000]; 
const colors = ["red", "yellow", "green", "blue", "purple", "orange", "pink"]; 

let isSpinning = false;
let spinCount = 0;
let bonusAmount = parseInt(document.getElementById('bonusAmount').textContent);
let withdrawAmount = 0;
let angle = 0; 
let spinVelocity = 0;  
let deceleration = 0.99;  

const segmentAngle = (2 * Math.PI) / numbers.length;
const arrowAngle = 3 * Math.PI / 2; 

const bonusDisplay = document.getElementById('bonusAmount');
const withdrawDisplay = document.getElementById('withdrawAmount');
const messageBox = document.getElementById('message-box');

// Function to draw the stand for the wheel
function drawStand() {
    ctx.fillStyle = "black";
    ctx.fillRect(wheelCanvas.width / 2 - 5, wheelCanvas.height - 50, 10, 50); // A simple rectangle as a stand
}

// Function to draw the arrow at the bottom of the circle
function drawArrow() {
    ctx.fillStyle = "black";
    ctx.beginPath();
    ctx.moveTo(wheelCanvas.width / 2 - 10, wheelCanvas.height - 40);
    ctx.lineTo(wheelCanvas.width / 2 + 10, wheelCanvas.height - 40);
    ctx.lineTo(wheelCanvas.width / 2, wheelCanvas.height - 10);
    ctx.closePath();
    ctx.fill();
}

// Function to draw the winning indicator arrow at the top of the wheel
function drawWinningArrow() {
    ctx.fillStyle = "black";
    ctx.beginPath();
    ctx.moveTo(wheelCanvas.width / 2 - 10, 10);
    ctx.lineTo(wheelCanvas.width / 2 + 10, 10);
    ctx.lineTo(wheelCanvas.width / 2, 30);
    ctx.closePath();
    ctx.fill();
}

function drawWheel(rotationAngle) {
    const centerX = wheelCanvas.width / 2;
    const centerY = wheelCanvas.height / 2;
    const radius = 150;

    ctx.clearRect(0, 0, wheelCanvas.width, wheelCanvas.height);

    // Draw wheel segments
    for (let i = 0; i < numbers.length; i++) {
        const angleStart = (2 * Math.PI / numbers.length) * i + rotationAngle;
        const angleEnd = (2 * Math.PI / numbers.length) * (i + 1) + rotationAngle;

        ctx.beginPath();
        ctx.moveTo(centerX, centerY);
        ctx.arc(centerX, centerY, radius, angleStart, angleEnd);
        ctx.lineTo(centerX, centerY);
        ctx.fillStyle = colors[i];
        ctx.fill();

        const angleMid = (angleStart + angleEnd) / 2;
        const textX = centerX + radius * 0.6 * Math.cos(angleMid);
        const textY = centerY + radius * 0.6 * Math.sin(angleMid);

        ctx.save();
        ctx.translate(textX, textY);
        ctx.rotate(angleMid + Math.PI / 2);
        ctx.fillStyle = "black";
        ctx.font = "18px Arial";
        ctx.textAlign = "center";
        ctx.textBaseline = "middle";
        ctx.fillText(numbers[i], 0, 0);
        ctx.restore();
    }

    // Draw the winning arrow and the arrow at the bottom
    drawWinningArrow();
    drawStand();
}

function updateWithdraw(winningAmount) {
    withdrawAmount += winningAmount;
    withdrawDisplay.textContent = withdrawAmount;
}

function checkBonus() {
    if (bonusAmount < 25) {
        messageBox.innerHTML = 'Insufficient amount! <a href="Wallet.jsp">Add To Wallet</a>';
        return false;
    }
    return true;
}

function StartSpin() {
    if (!checkBonus()) return;

    if (!isSpinning) {
        isSpinning = true;
        spinCount++;
        bonusAmount -= 25; // Deduct Rs. 25 for the spin
        bonusDisplay.textContent = bonusAmount;

        spinVelocity = Math.random() * 40 + 20;
        requestAnimationFrame(animateSpin);
    }
}

function animateSpin() {
    angle += spinVelocity;
    spinVelocity *= deceleration;

    drawWheel(angle);

    if (spinVelocity > 0.1) {
        requestAnimationFrame(animateSpin);
    } else {
        isSpinning = false;
        determineWinningSegment();
    }
}

function determineWinningSegment() {
    const totalAngle = angle % (2 * Math.PI);
    const adjustedAngle = (2 * Math.PI + arrowAngle - totalAngle) % (2 * Math.PI);
    const winningIndex = Math.floor(adjustedAngle / segmentAngle);
    const winningColor = colors[winningIndex];
    const winningNumber = numbers[winningIndex];

    Swal.fire({
        title: `You won Rs. ${winningNumber} from the ${winningColor} segment!`,
        text: winningNumber > 0 ? 'Spinning Wheel Sucess!' : 'Spin again!',
        icon: winningNumber > 0 ? 'success' : 'info',
        confirmButtonText: 'Spin again',
        customClass: {
            title: 'big-title', // Custom class for title
            content: 'big-content' // Custom class for content
        }
    });

    if (winningNumber > 0) {
        updateWithdraw(winningNumber);
    } else {
        messageBox.textContent += ' Spin again!';
    }
    

    // Send data to backend
    const phone = '9876543210';  // Replace with the dynamic phone number from the user session
    const data = {
        phone: phone,
        wonAmount: winningNumber,
        bonusAmount: bonusAmount,
        withdrawAmount: withdrawAmount
    };

    fetch('/RegUser', {  // Adjusted URL to match your servlet mapping
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: new URLSearchParams(data)
    })
    .then(response => response.text())
    .then(result => {
        if (result === "Success") {
            console.log('Amounts updated successfully');
        } else {
            console.error('Error updating amounts:', result);
        }
    })
    .catch(error => console.error('Fetch error:', error));
}
document.getElementById('wallet-button').addEventListener('click', function() {
    if (withdrawAmount > 0) {
        // Redirect to the Wallet page, sending the withdraw amount as a query parameter
        window.location.href = `Wallet.jsp?withdrawAmount=${withdrawAmount}`;
    } else {
        // Show a message if there's no amount to withdraw
        Swal.fire({
            title: 'No Amount to Withdraw!',
            text: 'You need to win some money first!',
            icon: 'info',
            confirmButtonText: 'Okay'
        });
    }
});



document.querySelector(".spin-button").addEventListener("click", StartSpin);

drawWheel(angle);
// Handle Logout


