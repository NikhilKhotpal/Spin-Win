const wheelCanvas = document.getElementById("wheel");
const ctx = wheelCanvas.getContext("2d");

const numbers = [-20, -40, 0, 20, 100, 300, 5000];  // Values associated with each segment
const colors = ["red", "yellow", "green", "blue", "purple", "orange", "pink"];  // Segment colors

let isSpinning = false;
let spinCount = 0;
let bonusAmount = 50;
let withdrawAmount = 0;
let angle = 0;  // Initial rotation angle
let spinVelocity = 0;  // Rotation velocity
let deceleration = 0.99;  // Deceleration factor (adjust for desired slowdown)

const segmentAngle = (2 * Math.PI) / numbers.length;  // Angle of each segment
const arrowAngle = 3 * Math.PI / 2;  // Arrow is at the bottom (270 degrees position)

const bonusDisplay = document.getElementById('bonusAmount');
const withdrawDisplay = document.getElementById('withdrawAmount');
const messageBox = document.getElementById('message-box');

// Function to draw the stand for the wheel
function drawStand() {
    ctx.fillStyle = "black";
    ctx.fillRect(wheelCanvas.width / 2 - 5, wheelCanvas.height -50, 10, 50); // A simple rectangle as a stand
}

// Function to draw the arrow at the bottom of the circle
function drawArrow() {
    ctx.fillStyle = "black";
    ctx.beginPath();
    // Draw the arrow at the bottom (270 degrees position)
    ctx.moveTo(wheelCanvas.width / 2 - 10, wheelCanvas.height - 40); // Left point of the arrow
    ctx.lineTo(wheelCanvas.width / 2 + 10, wheelCanvas.height - 40); // Right point of the arrow
    ctx.lineTo(wheelCanvas.width / 2, wheelCanvas.height - 10); // Bottom tip of the arrow
    ctx.closePath();
    ctx.fill();
}

// Function to draw the winning indicator arrow at the top of the wheel
function drawWinningArrow() {
    ctx.fillStyle = "black";
    ctx.beginPath();
    // Draw the winning indicator arrow at the top center of the wheel
    ctx.moveTo(wheelCanvas.width / 2 - 10, 10); // Left point of the arrow
    ctx.lineTo(wheelCanvas.width / 2 + 10, 10); // Right point of the arrow
    ctx.lineTo(wheelCanvas.width / 2, 30); // Bottom tip of the arrow
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
        const textX = centerX + radius * 0.6 * Math.cos(angleMid); // Adjusted position towards the center
        const textY = centerY + radius * 0.6 * Math.sin(angleMid);

        // Rotate text to align with the segment direction
        ctx.save();
        ctx.translate(textX, textY);
        ctx.rotate(angleMid + Math.PI / 2); // Rotate text to be readable from the center
        ctx.fillStyle = "black";
        ctx.font = "18px Arial";
        ctx.textAlign = "center";
        ctx.textBaseline = "middle";
        ctx.fillText(numbers[i], 0, 0); // Text position is now centered
        ctx.restore();
    }

    // Draw the winning arrow and the arrow at the bottom
    drawWinningArrow();
    

    // Draw the stand below the wheel
    drawStand();
}

function updateWithdraw(winningAmount) {
    withdrawAmount += winningAmount;
    withdrawDisplay.textContent = withdrawAmount;
}

function addMoney() {
    // Redirect to Wallet.jsp when the "Add money to wallet" button is clicked
    window.location.href = "Wallet.jsp";
}

// Example usage in the HTML when bonus amount is less than 25
function checkBonus() {
    if (bonusAmount < 25) {
        messageBox.innerHTML = 'Insufficient amount! <button class="add-money-button" onclick="addMoney()">Add money to wallet</button>';
        return false;
    }
    return true;
}


function startSpin() {
    if (!checkBonus()) return;

    if (!isSpinning) {
        isSpinning = true;
        spinCount++;
        bonusAmount -= 25;
        bonusDisplay.textContent = bonusAmount;

        // Spin the wheel by adding random velocity, and start the animation
        spinVelocity = Math.random() * 40 + 20;  // Random velocity between 20 and 60
        requestAnimationFrame(animateSpin);
    }
}

function animateSpin() {
    // Update the rotation angle based on the current velocity
    angle += spinVelocity;

    // Slow down the wheel by applying deceleration
    spinVelocity *= deceleration;

    // Redraw the wheel with the new angle
    drawWheel(angle);

    // Stop the wheel when the velocity is low enough
    if (spinVelocity > 0.1) {
        requestAnimationFrame(animateSpin);
    } else {
        isSpinning = false;
        determineWinningSegment();
    }
}

function determineWinningSegment() {
    // Normalize the final angle to [0, 2π]
    const totalAngle = angle % (2 * Math.PI);

    // Calculate the winning segment based on the arrow position (top of canvas)
    const adjustedAngle = (2 * Math.PI + arrowAngle - totalAngle) % (2 * Math.PI);
    const winningIndex = Math.floor(adjustedAngle / segmentAngle);  // Get the index of the winning segment
    const winningColor = colors[winningIndex];
    const winningNumber = numbers[winningIndex];

    // Display message for the winning color and number
    messageBox.textContent = `You won Rs. ${winningNumber} from the ${winningColor} segment!`;

    // Update the withdraw amount only if the winning number is positive
    if (winningNumber > 0) {
        updateWithdraw(winningNumber);
    } else {
        messageBox.textContent += ' Spin again!';
    }

    // Apply additional rewards based on the number of spins
    if (spinCount === 3) {
        messageBox.textContent += ' You won Rs. 20 bonus!';
        updateWithdraw(20);
    } else if (spinCount === 10) {
        messageBox.textContent += ' You won Rs. 100 bonus!';
        updateWithdraw(100);
    } else if (spinCount === 20) {
        messageBox.textContent += ' You won Rs. 300 bonus!';
        updateWithdraw(300);
    } else if (spinCount === 50) {
        messageBox.textContent += ' You won Rs. 5000 bonus!';
        updateWithdraw(5000);
    }
}

document.querySelector(".spin-button").addEventListener("click", startSpin);

// Initial drawing
drawWheel(angle);
