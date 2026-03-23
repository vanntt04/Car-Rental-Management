<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="active" value="${param.activePage}"/>
<aside class="owner-sidebar">
    <div class="brand">CarRental Owner</div>
    <div class="sidebar-group-title">Dashboard</div>
    <a href="${ctx}/owner" class="sidebar-link ${active == 'owner' ? 'active' : ''}"><i class="bi bi-speedometer2"></i> Quản lý xe</a>
    <a href="${ctx}/owner/bookings" class="sidebar-link ${active == 'bookings' ? 'active' : ''}"><i class="bi bi-journal-check"></i> Yêu cầu đặt xe</a>
    <a href="${ctx}/owner/bank-account" class="sidebar-link ${active == 'bank' ? 'active' : ''}"><i class="bi bi-bank"></i> Tài khoản ngân hàng</a>
    <a href="${ctx}/owner/bank-qr" class="sidebar-link ${active == 'bankqr' ? 'active' : ''}"><i class="bi bi-qr-code-scan"></i> Mã QR ngân hàng</a>
    <a href="${ctx}/owner/new" class="sidebar-link ${active == 'new' ? 'active' : ''}"><i class="bi bi-plus-circle"></i> Thêm xe mới</a>
    <div class="sidebar-group-title">Điều hướng</div>
    <a href="${ctx}/home" class="sidebar-link"><i class="bi bi-house"></i> Về trang chủ</a>
    <a href="${ctx}/logout" class="sidebar-link"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>
</aside>
