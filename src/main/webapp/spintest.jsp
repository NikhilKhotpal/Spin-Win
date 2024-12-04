<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <title>Spin the Wheel</title>
    <style>
        body {
            background-color: #8B0000;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .wheel-container {
            position: relative;
            width: 300px;
            height: 300px;
        }
        .wheel {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            background: conic-gradient(
                #FF4500 0% 12.5%, 
                #FFD700 12.5% 25%, 
                #FF4500 25% 37.5%, 
                #FFD700 37.5% 50%, 
                #FF4500 50% 62.5%, 
                #FFD700 62.5% 75%, 
                #FF4500 75% 87.5%, 
                #FFD700 87.5% 100%
            );
            position: relative;
            transition: transform 4s ease-out;
        }
        .wheel::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 20px;
            height: 20px;
            background-color: #B8860B;
            border-radius: 50%;
            transform: translate(-50%, -50%);
            z-index: 1;
        }
        .wheel-text {
            position: absolute;
            width: 100%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: Arial, sans-serif;
            font-size: 20px;
            color: white;
            text-align: center;
        }
        .wheel-text div {
            position: absolute;
            width: 50%;
            height: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .wheel-text .jackpot { transform: rotate(-23deg) translate(0, -80%); }
        .wheel-text .lose1 { transform: rotate(21deg) translate(0, -80%); }
        .wheel-text .win100 { transform: rotate(67deg) translate(0, -80%); }
        .wheel-text .lose2 { transform: rotate(114deg) translate(0, -80%); }
        .wheel-text .win500 { transform: rotate(157deg) translate(0, -80%); }
        .wheel-text .lose3 { transform: rotate(203deg) translate(0, -80%); }
        .wheel-text .win200 { transform: rotate(248deg) translate(0, -80%); }
        .wheel-text .win1000 { transform: rotate(292deg) translate(0, -80%); }
        .lights {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 340px;
            height: 340px;
            border-radius: 50%;
            transform: translate(-50%, -50%);
            box-shadow: 0 0 20px 5px rgba(255, 69, 0, 0.8);
        }
        .spin-button {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            padding: 20px;
            font-size: 16px;
            background-color: #FFD700;
            border: none;
            border-radius: 50%;
            cursor: pointer;
            z-index: 2;
        }
        .arrow {
            position: absolute;
            bottom: -17px;
            left: 50%;
            transform: translateX(-50%);
            width: 0; 
            height: 0; 
            border-left: 10px solid transparent;
            border-right: 10px solid transparent;
            border-bottom: 20px solid #FFD700;
        }
        .withdraw-button {
            margin-top: 60px;
            padding: 10px 20px;
            font-size: 16px;
            background-color: #FFD700;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-left: 96px;
        }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
</head>
<body>
  <div class="wheel-container">
        <div class="arrow"></div>
        <div class="wheel" id="wheel">
            <div class="wheel-text">
                <div class="jackpot">1000</div>
                <div class="lose1">0</div>
                <div class="win100">100</div>
                <div class="lose2">0</div>
                <div class="win500">500</div>
                <div class="lose3">0</div>
                <div class="win200">200</div>
                <div class="win1000">1000</div>
            </div>
        </div>
        <div class="lights"></div>
        <button class="spin-button" onclick="spinWheel('1000')">Spin for 1000</button>
        <button class="spin-button" onclick="spinWheel('100')">Spin for 100</button>
        <button class="spin-button" onclick="spinWheel('500')">Spin for 500</button>
        <button class="spin-button" onclick="spinWheel('200')">Spin for 200</button>
        <button class="withdraw-button" id="withdrawButton" onclick="withdrawAmount()">Withdraw</button>
    </div>
    <script src="checkspin.js">
      
    </script>
</body>
</html>
