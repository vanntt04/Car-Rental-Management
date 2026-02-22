<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<header class="site-header">
    <nav class="navbar navbar-expand-lg navbar-light">
        <div class="container">
            <a class="navbar-brand logo" href="${ctx}/home">
                <span class="logo-icon">🚗</span>
                <span class="logo-text">CarRental</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav" aria-controls="mainNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="mainNav">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link ${param.page == 'home' ? 'active' : ''}" href="${ctx}/home">Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${param.page == 'cars' ? 'active' : ''}" href="${ctx}/cars">Danh sách xe</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/home#about">Về chúng tôi</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link cta-link" href="${ctx}/cars">Đặt xe ngay</a>
                    </li>
                    <c:if test="${sessionScope.role == 'OWNER' || sessionScope.role == 'ADMIN'}">
                    <li class="nav-item">
                        <a class="nav-link ${param.page == 'owner' ? 'active' : ''}" href="${ctx}/owner">Quản lý xe</a>
                    </li>
                    </c:if>
                </ul>
                <div class="d-flex align-items-center gap-2">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <span class="user-greeting">Xin chào, <strong>${sessionScope.fullName != null ? sessionScope.fullName : sessionScope.username}</strong></span>
                            <a href="${ctx}/logout" class="btn btn-outline-danger btn-sm">Đăng xuất</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${ctx}/login" class="btn btn-primary btn-sm">Đăng nhập</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>
</header>
