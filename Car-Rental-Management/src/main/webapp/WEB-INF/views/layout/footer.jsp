<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<footer class="site-footer">
    <div class="footer-main">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-4 col-md-6">
                    <div class="footer-brand">
                        <span class="logo-icon">🚗</span>
                        <span class="logo-text">CarRental</span>
                    </div>
                    <p class="footer-desc">Dịch vụ thuê xe uy tín, chuyên nghiệp. Đặt xe dễ dàng, nhanh chóng với giá cả hợp lý nhất.</p>
                </div>
                <div class="col-lg-2 col-md-6">
                    <h5 class="footer-title">Liên kết</h5>
                    <ul class="footer-links">
                        <li><a href="${ctx}/home">Trang chủ</a></li>
                        <li><a href="${ctx}/cars">Danh sách xe</a></li>
                        <li><a href="${ctx}/home#about">Về chúng tôi</a></li>
                        <li><a href="${ctx}/login">Đăng nhập</a></li>
                    </ul>
                </div>
                <div class="col-lg-3 col-md-6">
                    <h5 class="footer-title">Hỗ trợ</h5>
                    <ul class="footer-links">
                        <li><a href="#">Chính sách thuê xe</a></li>
                        <li><a href="#">Câu hỏi thường gặp</a></li>
                        <li><a href="#">Điều khoản sử dụng</a></li>
                    </ul>
                </div>
                <div class="col-lg-3 col-md-6">
                    <h5 class="footer-title">Liên hệ</h5>
                    <ul class="footer-contact">
                        <li><i class="bi bi-geo-alt"></i> 123 Đường ABC, Quận 1, TP.HCM</li>
                        <li><i class="bi bi-telephone"></i> 1900 1234</li>
                        <li><i class="bi bi-envelope"></i> support@carrental.vn</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <div class="footer-bottom">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <p class="copyright">© 2025 CarRental. Bảo lưu mọi quyền.</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <div class="footer-social">
                        <a href="#" aria-label="Facebook"><i class="bi bi-facebook"></i></a>
                        <a href="#" aria-label="Zalo"><i class="bi bi-chat-dots"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</footer>
