<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">

        <style>
            body {
                margin: 0;
                font-family: 'Inter', sans-serif;
                height: 100vh;
                background: linear-gradient(135deg, #6f7bf7, #7a5bd4);
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .auth-card {
                background: #fff;
                width: 420px;
                border-radius: 20px;
                padding: 30px;
                box-shadow: 0 20px 40px rgba(0,0,0,0.15);
                position: relative;
            }

            .auth-card h2 {
                text-align: center;
                margin-bottom: 10px;
            }

            .auth-card p {
                text-align: center;
                color: #666;
                font-size: 14px;
                margin-bottom: 25px;
            }

            label {
                font-size: 14px;
                font-weight: 600;
            }

            input {
                width: 100%;
                padding: 12px 14px;
                border-radius: 10px;
                border: 1px solid #ddd;
                margin-top: 6px;
                margin-bottom: 20px;
                font-size: 14px;
                background: #eef4ff;
            }

            .btn-submit {
                width: 100%;
                padding: 14px;
                border-radius: 12px;
                border: none;
                background: #4caf50;
                color: white;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
            }

            .btn-submit:hover {
                background: #43a047;
            }

            .back-link {
                display: block;
                text-align: center;
                margin-top: 20px;
                color: #4caf50;
                text-decoration: none;
                font-size: 14px;
            }

            .close-btn {
                position: absolute;
                top: 15px;
                right: 15px;
                width: 32px;
                height: 32px;
                border-radius: 50%;
                border: none;
                background: #f1f1f1;
                font-size: 18px;
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <div class="auth-card">
            <button class="close-btn">×</button>

            <h2>Quên mật khẩu</h2>
            <p>Nhập email đặt lại mật khẩu </p>
            <form action="forget_password" method="post">
                <label>Email</label>
                <input type="text" name="email" placeholder="example@email.com" required>
                <button type="submit" class="btn-submit">
                    Send
                </button>
            </form>

            <a href="login" class="back-link">? Quay lại đăng nhập</a>
        </div>
    </body>
</html>
 