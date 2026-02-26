<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đăng ký tài khoản - Car Rental</title>

            <style>
                * {
                    box-sizing: border-box;
                    margin: 0;
                    padding: 0;
                }
                
                body {
                    min-height: 100vh;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    padding: 24px;
                    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
                    background: radial-gradient(circle at top left, #4f46e5, #0f172a 40%, #020617);
                    color: #e5e7eb;
                }
                
                .register-wrapper {
                    width: 100%;
                    max-width: 440px;
                }
                
                .card {
                    background: rgba(15, 23, 42, 0.9);
                    border-radius: 18px;
                    padding: 32px 28px;
                    box-shadow: 0 20px 60px rgba(15, 23, 42, 0.9), 0 0 0 1px rgba(148, 163, 184, 0.15);
                    backdrop-filter: blur(18px);
                }
                
                .card-header {
                    text-align: center;
                    margin-bottom: 24px;
                }
                
                .logo-circle {
                    width: 56px;
                    height: 56px;
                    margin: 0 auto 16px;
                    border-radius: 999px;
                    background: conic-gradient(from 150deg, #22c55e, #22c55e, #38bdf8, #a855f7, #22c55e);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    box-shadow: 0 12px 40px rgba(34, 197, 94, 0.35);
                    color: #f9fafb;
                    font-weight: 700;
                    font-size: 22px;
                }
                
                .card-title {
                    font-size: 24px;
                    font-weight: 600;
                    margin-bottom: 4px;
                }
                
                .card-subtitle {
                    font-size: 14px;
                    color: #9ca3af;
                }
                
                .error-box {
                    margin-bottom: 18px;
                    padding: 10px 12px;
                    border-radius: 10px;
                    background: rgba(248, 113, 113, 0.08);
                    border: 1px solid rgba(248, 113, 113, 0.6);
                    color: #fecaca;
                    font-size: 13px;
                }
                
                .form-group {
                    margin-bottom: 16px;
                }
                
                label {
                    display: block;
                    margin-bottom: 6px;
                    font-size: 13px;
                    font-weight: 500;
                    color: #e5e7eb;
                }
                
                .form-control {
                    width: 100%;
                    padding: 11px 12px;
                    border-radius: 10px;
                    border: 1px solid rgba(148, 163, 184, 0.6);
                    background: rgba(15, 23, 42, 0.8);
                    color: #f9fafb;
                    font-size: 14px;
                    outline: none;
                    transition: border-color 0.15s, box-shadow 0.15s, background-color 0.15s;
                }
                
                .form-control::placeholder {
                    color: #6b7280;
                }
                
                .form-control:focus {
                    border-color: #22c55e;
                    box-shadow: 0 0 0 1px rgba(34, 197, 94, 0.7);
                    background: rgba(15, 23, 42, 0.95);
                }
                
                .row-inline {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin: 4px 0 14px;
                    font-size: 13px;
                    color: #9ca3af;
                }
                
                .row-inline label {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    margin: 0;
                    font-weight: 400;
                }
                
                .row-inline input[type="checkbox"] {
                    width: 15px;
                    height: 15px;
                    accent-color: #22c55e;
                }
                
                .link {
                    color: #22c55e;
                    text-decoration: none;
                }
                
                .link:hover {
                    text-decoration: underline;
                }
                
                .btn-primary {
                    width: 100%;
                    margin-top: 6px;
                    padding: 11px 14px;
                    border: none;
                    border-radius: 999px;
                    background: linear-gradient(135deg, #22c55e, #16a34a);
                    color: #f9fafb;
                    font-size: 15px;
                    font-weight: 600;
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    gap: 8px;
                    box-shadow: 0 14px 35px rgba(34, 197, 94, 0.5);
                    transition: transform 0.1s, box-shadow 0.1s, filter 0.1s;
                }
                
                .btn-primary:hover {
                    filter: brightness(1.05);
                    box-shadow: 0 18px 40px rgba(34, 197, 94, 0.6);
                }
                
                .btn-primary:active {
                    transform: translateY(1px);
                    box-shadow: 0 10px 26px rgba(34, 197, 94, 0.45);
                }
                
                .footer-text {
                    margin-top: 18px;
                    text-align: center;
                    font-size: 13px;
                    color: #9ca3af;
                }
                
                .footer-text a {
                    color: #22c55e;
                    text-decoration: none;
                    font-weight: 500;
                }
                
                .footer-text a:hover {
                    text-decoration: underline;
                }
                
                @media (max-width: 480px) {
                    .card {
                        padding: 24px 18px;
                    }
                    .card-title {
                        font-size: 21px;
                    }
                }
            </style>
        </head>

        <body>
            <div class="register-wrapper">
                <div class="card">
                    <div class="card-header">
                        <div class="logo-circle">CR</div>
                        <h1 class="card-title">Tạo tài khoản</h1>
                        <p class="card-subtitle">Đăng ký để bắt đầu thuê xe dễ dàng hơn.</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="error-box">
                            ${error}
                        </div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/register">
                        <div class="form-group">
                            <label for="username">Tên đăng nhập</label>
                            <input type="text" id="username" name="username" class="form-control" placeholder="vd: cust_an" value="${username}" required>
                        </div>

                        <div class="form-group">
                            <label for="fullname">Họ và tên</label>
                            <input type="text" id="fullname" name="fullName" class="form-control" placeholder="Nguyễn Văn A" value="${fullName}" required>
                        </div>

                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" class="form-control" placeholder="you@example.com" value="${email}" required>
                        </div>

                        <div class="form-group">
                            <label for="phone">Số điện thoại</label>
                            <input type="text" id="phone" name="phone" class="form-control" placeholder="Nhập số điện thoại" value="${phone}">
                        </div>

                        <div class="form-group">
                            <label for="password">Mật khẩu</label>
                            <input type="password" id="password" name="password" class="form-control" placeholder="Tối thiểu 6 ký tự" required>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Xác nhận mật khẩu</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu" required>
                        </div>

                        <div class="row-inline">
                            <label>
                    <input type="checkbox" required>
                    Tôi đồng ý với <a href="#" class="link">Điều khoản & Chính sách</a>
                </label>
                        </div>

                        <button type="submit" class="btn-primary">
                Tạo tài khoản
                <span>→</span>
            </button>
                    </form>

                    <p class="footer-text">
                        Đã có tài khoản?
                        <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                    </p>
                </div>
            </div>
        </body>

        </html>