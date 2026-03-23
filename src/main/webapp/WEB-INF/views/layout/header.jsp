<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="roleUp" value="${fn:toUpperCase(sessionScope.role)}"/>
<c:set var="isOwnerOrAdmin" value="${roleUp == 'OWNER' || roleUp == 'ADMIN'}"/>
<header class="header-area">
    <div class="container">
        <nav class="main-nav">
            <a href="${ctx}/home" class="logo">
                <span>CarRental</span>
            </a>
            <ul class="nav" id="mainNav">
                <li><a href="${ctx}/home" class="${param.page == 'home' ? 'active' : ''}">Trang chủ</a></li>
                <li><a href="${ctx}/cars" class="${param.page == 'cars' ? 'active' : ''}">Danh sách xe</a></li>
                <li><a href="${ctx}/home#about">Về chúng tôi</a></li>
                <li><a href="${ctx}/cars" class="btn-book">Đặt xe ngay</a></li>
                <c:if test="${isOwnerOrAdmin}">
                    <li><a href="${ctx}/owner" class="${param.page == 'owner' ? 'active' : ''}">Quản lý xe</a></li>
                    <li><a href="${ctx}/owner/bookings">Yêu cầu đặt xe</a></li>
                    <%-- Tài khoản ngân hàng: hàng phụ bên dưới (giống layout mẫu), vẫn có trong menu mobile --%>
                    <li class="owner-bank-mobile-only"><a href="${ctx}/owner/bank-account">Tài khoản ngân hàng</a></li>
                </c:if>
            </ul>
            <div class="user-wrap">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <span class="user-text">Xin chào, <strong>${sessionScope.fullName != null ? sessionScope.fullName : sessionScope.username}</strong></span>
                        <a href="${ctx}/logout" class="btn-outline-light">Đăng xuất</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${ctx}/login" class="btn-woox-primary" style="padding: 8px 20px;">Đăng nhập</a>
                    </c:otherwise>
                </c:choose>
            </div>
            <a class="menu-trigger" href="javascript:void(0)" onclick="document.getElementById('mainNav').classList.toggle('show')" aria-label="Menu">☰</a>
        </nav>
        <c:if test="${isOwnerOrAdmin}">
            <div class="owner-header-subnav">
                <a href="${ctx}/owner/bank-account" class="${param.page == 'bank' ? 'active' : ''}">Tài khoản ngân hàng</a>
            </div>
        </c:if>
    </div>
</header>
