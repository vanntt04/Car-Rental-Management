<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Car Rental</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #22b3c1;
            --primary-hover: #1a9ba8;
            --bg-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --text-main: #1e293b;
            --text-muted: #64748b;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background: var(--bg-gradient);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-container {
            background: white;
            border-radius: 24px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            width: 100%;
            max-width: 440px;
            padding: 48px 40px;
            position: relative;
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .login-header {
            text-align: center;
            margin-bottom: 32px;
        }

        .login-header h1 {
            color: var(--text-main);
            font-size: 30px;
            font-weight: 700;
            letter-spacing: -0.5px;
        }

        .close-btn {
            position: absolute;
            top: 24px;
            right: 24px;
            background: #f1f5f9;
            border: none;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-muted);
            transition: all 0.2s;
            text-decoration: none;
        }

        .close-btn:hover {
            background: #e2e8f0;
            color: var(--text-main);
            transform: rotate(90deg);
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--text-main);
            font-weight: 500;
            font-size: 14px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-icon-left {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 18px;
            transition: color 0.2s;
        }

        .form-control {
            width: 100%;
            padding: 14px 16px 14px 48px;
            border: 1.5px solid #e2e8f0;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.2s ease;
            background: #f8fafc;
            font-family: inherit;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            background: #fff;
            box-shadow: 0 0 0 4px rgba(34, 179, 193, 0.15);
        }

        .form-control:focus + .input-icon-left {
            color: var(--primary-color);
        }

        .password-toggle {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            color: var(--text-muted);
            padding: 8px;
            display: flex;
            align-items: center;
        }

        .btn-login {
            width: 100%;
            padding: 16px;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }

        .btn-login:hover {
            background: var(--primary-hover);
            box-shadow: 0 10px 15px -3px rgba(34, 179, 193, 0.3);
        }

        .btn-login:active {
            transform: scale(0.98);
        }

        .divider {
            display: flex;
            align-items: center;
            text-align: center;
            margin: 24px 0;
            color: var(--text-muted);
            font-size: 13px;
        }

        .divider::before, .divider::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid #e2e8f0;
        }

        .divider:not(:empty)::before { margin-right: .75em; }
        .divider:not(:empty)::after { margin-left: .75em; }

        .social-login {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .btn-social {
            padding: 12px;
            border: 1.5px solid #e2e8f0;
            border-radius: 12px;
            background: white;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
        }

        .btn-social:hover {
            background: #f8fafc;
            border-color: #cbd5e1;
        }

        .bi-google { color: #ea4335; }
        .bi-facebook { color: #1877f2; }

        .register-link {
            text-align: center;
            margin-top: 24px;
            font-size: 14px;
            color: var(--text-muted);
        }

        .register-link a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
        }

        .error-message {
            background: #fef2f2;
            color: #b91c1c;
            padding: 12px 16px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 14px;
            border-left: 4px solid #ef4444;
            display: flex;
            align-items: center;
            gap: 8px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <a href="${pageContext.request.contextPath}/home" class="close-btn" title="Đóng">
            <i class="bi bi-x-lg"></i>
        </a>
        
        <div class="login-header">
            <h1>Chào mừng trở lại</h1>
            <p style="color: var(--text-muted); font-size: 14px; margin-top: 8px;">Vui lòng nhập thông tin để đăng nhập</p>
        </div>

        <c:if test="${not empty error}">
            <div class="error-message">
                <i class="bi bi-exclamation-circle-fill"></i>
                ${error}
            </div>
        </c:if>

        <form id="loginForm" method="POST" action="${pageContext.request.contextPath}/login">
            <div class="form-group">
                <label for="emailOrUsername">Email hoặc Tên đăng nhập</label>
                <div class="input-wrapper">
                    <i class="bi bi-person input-icon-left"></i>
                    <input 
                        type="text" 
                        id="emailOrUsername" 
                        name="emailOrUsername" 
                        class="form-control" 
                        placeholder="Nhập email hoặc username"
                        value="${emailOrUsername}"
                        required
                        autofocus
                    >
                </div>
            </div>

            <div class="form-group">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                    <label style="margin-bottom: 0;">Mật khẩu</label>
                    <a href="#" style="color: var(--primary-color); text-decoration: none; font-size: 13px; font-weight: 500;">Quên mật khẩu?</a>
                </div>
                <div class="input-wrapper">
                    <i class="bi bi-shield-lock input-icon-left"></i>
                    <input 
                        type="password" 
                        id="password" 
                        name="password" 
                        class="form-control" 
                        placeholder="••••••••"
                        required
                    >
                    <button type="button" class="password-toggle" onclick="togglePassword()">
                        <i id="toggleIcon" class="bi bi-eye"></i>
                    </button>
                </div>
            </div>

            <button type="submit" class="btn-login" id="submitBtn">
                <span class="btn-text">Đăng nhập</span>
            </button>
        </form>

        <div class="divider">Hoặc đăng nhập với</div>

        <div class="social-login">
            <button type="button" class="btn-social" onclick="loginWithGoogle()">
                <i class="bi bi-google"></i> Google
            </button>
            <button type="button" class="btn-social" onclick="loginWithFacebook()">
                <i class="bi bi-facebook"></i> Facebook
            </button>
        </div>

        <div class="register-link">
            Bạn chưa có tài khoản? <a href="#">Đăng ký ngay</a>
        </div>
    </div>

    <script>
        function togglePassword() {
            const passwordInput = document.getElementById('password');
            const toggleIcon = document.getElementById('toggleIcon');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.classList.replace('bi-eye', 'bi-eye-slash');
            } else {
                passwordInput.type = 'password';
                toggleIcon.classList.replace('bi-eye-slash', 'bi-eye');
            }
        }

        // Hiệu ứng Loading khi submit
        document.getElementById('loginForm').onsubmit = function() {
            const btn = document.getElementById('submitBtn');
            btn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Đang xử lý...';
            btn.style.opacity = '0.7';
            btn.style.pointerEvents = 'none';
        };

        function loginWithFacebook() {
            alert('Tính năng Facebook đang được bảo trì.');
        }

        function loginWithGoogle() {
            alert('Tính năng Google đang được bảo trì.');
        }
    </script>
</body>
</html>
