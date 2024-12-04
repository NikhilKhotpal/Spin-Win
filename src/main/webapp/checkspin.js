  let currentPrize = null;
        let bonusAmount = 50; // User's starting bonus amount
        const spinCost = 25; // Cost per spin

        // Define a mapping of prizes to their corresponding degrees
        const prizeDegrees = {
            "1000": 292,
            "0": 330,
            "100": 67,
            "0": 157,
            "500": 248,
            "200": 200
        };

        function spinWheel(selectedPrize) {
            if (bonusAmount < spinCost) {
                Swal.fire({
                    icon: 'error',
                    title: 'Insufficient Bonus!',
                    text: 'You need at least ₹25 to spin the wheel.',
                });
                return;
            }

            // Deduct the cost of the spin
            bonusAmount -= spinCost;

            // Get the degree to stop based on the selected prize
            const degreeToStop = prizeDegrees[selectedPrize];
            const totalSpins = 10;  // Full rotations
            const finalDegree = degreeToStop + totalSpins * 360;

            const wheel = document.getElementById('wheel');
            wheel.style.transition = 'transform 4s ease-out';  // Ensure the spin has a smooth transition
            wheel.style.transform = `rotate(${finalDegree}deg)`;

            setTimeout(function() {
                currentPrize = selectedPrize;  // Set current prize to the selected prize
                savePrize(currentPrize);

                Swal.fire({
                    icon: currentPrize !== '0' ? 'success' : 'error',
                    title: currentPrize !== '0' ? `You won ₹${currentPrize}!` : 'You lost!',
                    showConfirmButton: true
                });

                document.getElementById('withdrawButton').innerHTML = `Withdraw ₹${currentPrize !== '0' ? currentPrize : 'N/A'}`;
            }, 4000);
        }

        function savePrize(prize) {
            $.ajax({
                type: 'POST',
                url: 'SavePrizeServlet',
                data: { prize: prize },
                success: function(response) {
                    console.log('Prize saved successfully');
                },
                error: function(error) {
                    console.error('Error saving prize', error);
                }
            });
        }

        function withdrawAmount() {
            if (!currentPrize || currentPrize === '0') {
                Swal.fire({
                    icon: 'error',
                    title: 'No prize to withdraw!',
                    text: 'Please spin the wheel and win a prize to withdraw.'
                });
                return;
            }

            $.ajax({
                type: 'POST',
                url: 'WithdrawPrizeServlet',
                data: { winAmount: currentPrize },
                success: function(response) {
                    Swal.fire({
                        icon: 'success',
                        title: `You successfully withdrew ₹${currentPrize}!`,
                        showConfirmButton: true
                    });
                },
                error: function(error) {
                    console.error('Error withdrawing prize', error);
                }
            });
        }