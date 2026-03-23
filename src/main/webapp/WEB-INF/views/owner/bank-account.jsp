<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Tai khoan ngan hang - Owner</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/owner-dashboard.css" rel="stylesheet">
</head>
<body>
<div class="owner-dashboard">
    <aside class="owner-sidebar">
        <div class="owner-brand">CarRental Owner</div>
        <div class="owner-group-title">Dashboard</div>
        <a href="${ctx}/owner" class="owner-link"><i class="bi bi-car-front"></i> Quan ly xe</a>
        <a href="${ctx}/owner/bookings" class="owner-link"><i class="bi bi-journal-check"></i> Yeu cau dat xe</a>
        <a href="${ctx}/owner/bank-account" class="owner-link active"><i class="bi bi-bank"></i> Tai khoan ngan hang</a>
        <a href="${ctx}/owner/new" class="owner-link"><i class="bi bi-plus-circle"></i> Them xe moi</a>
        <div class="owner-group-title">Dieu huong</div>
        <a href="${ctx}/home" class="owner-link"><i class="bi bi-house"></i> Ve trang chu</a>
    </aside>
    <main class="owner-main">
        <div class="owner-topbar">
            <h1>Tai khoan ngan hang</h1>
            <div class="owner-user">Xin chao, <strong>${sessionScope.fullName != null ? sessionScope.fullName : sessionScope.username}</strong></div>
        </div>
        <div class="owner-page">
            <c:if test="${param.success == 'saved'}"><div class="owner-alert success">Da luu thong tin tai khoan ngan hang.</div></c:if>
            <c:if test="${not empty error}"><div class="owner-alert danger">${error}</div></c:if>
            <div class="owner-card">
                <form action="${ctx}/owner/bank-account" method="post">
                    <input type="hidden" name="action" value="save-bank-account">
                    <div class="owner-form-grid cols-2">
                        <div>
                            <label class="owner-label">Ma ngan hang *</label>
                            <input class="owner-input" type="text" name="bankCode" value="${bankAccount != null ? bankAccount.bankCode : ''}" required>
                        </div>
                        <div>
                            <label class="owner-label">So tai khoan *</label>
                            <input class="owner-input" type="text" name="accountNumber" value="${bankAccount != null ? bankAccount.accountNumber : ''}" required>
                        </div>
                    </div>
                    <div class="owner-form-grid cols-2" style="margin-top:12px;">
                        <div>
                            <label class="owner-label">Chu tai khoan *</label>
                            <input class="owner-input" type="text" name="accountName" value="${bankAccount != null ? bankAccount.accountName : ''}" required>
                        </div>
                        <div>
                            <label class="owner-label">Chi nhanh *</label>
                            <input class="owner-input" type="text" name="branch" value="${bankAccount != null ? bankAccount.branch : ''}" required>
                        </div>
                    </div>
                    <div class="owner-actions">
                        <button type="submit" class="owner-btn primary"><i class="bi bi-save"></i> Luu thong tin</button>
                        <a href="${ctx}/owner" class="owner-btn outline">Quay lai</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>
