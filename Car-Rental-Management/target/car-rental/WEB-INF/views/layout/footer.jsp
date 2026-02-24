<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<footer class="woox-footer">
    <div class="container">
        <p>
            <a href="${ctx}/home">Trang chủ</a> &middot;
            <a href="${ctx}/cars">Danh sách xe</a> &middot;
            <a href="${ctx}/home#about">Về chúng tôi</a> &middot;
            <a href="${ctx}/login">Đăng nhập</a>
        </p>
        <p style="margin-top: 10px;">© 2025 CarRental. Bảo lưu mọi quyền.</p>
    </div>
</footer>
