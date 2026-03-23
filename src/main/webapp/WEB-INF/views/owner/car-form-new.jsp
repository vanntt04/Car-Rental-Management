<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Them xe moi - Owner</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/owner-dashboard.css" rel="stylesheet">
</head>
<body>
<div class="owner-dashboard">
    <aside class="owner-sidebar">
        <div class="owner-brand">CarRental Owner</div>
        <div class="owner-group-title">Dashboard</div>
        <a href="${ctx}/owner" class="owner-link"><i class="bi bi-car-front"></i> Quan ly xe</a>
        <a href="${ctx}/owner/new" class="owner-link active"><i class="bi bi-plus-circle"></i> Them xe moi</a>
    </aside>
    <main class="owner-main">
        <div class="owner-topbar"><h1>Them xe moi</h1><div class="owner-user">Owner</div></div>
        <div class="owner-page">
            <c:if test="${not empty error}"><div class="owner-alert danger">${error}</div></c:if>
            <div class="owner-card">
                <form action="${ctx}/owner?action=create" method="post" enctype="multipart/form-data">
                    <div class="owner-form-grid cols-2">
                        <div><label class="owner-label">Ten xe *</label><input class="owner-input" type="text" name="name" value="${car != null ? car.name : ''}" required></div>
                        <div><label class="owner-label">Bien so *</label><input class="owner-input" type="text" name="licensePlate" value="${car != null ? car.licensePlate : ''}" required></div>
                    </div>
                    <div class="owner-form-grid cols-2" style="margin-top:12px;">
                        <div><label class="owner-label">Hang *</label><input class="owner-input" type="text" name="brand" value="${car != null ? car.brand : ''}" required></div>
                        <div><label class="owner-label">Model *</label><input class="owner-input" type="text" name="model" value="${car != null ? car.model : ''}" required></div>
                    </div>
                    <div class="owner-form-grid cols-3" style="margin-top:12px;">
                        <div><label class="owner-label">Nam san xuat *</label><input class="owner-input" type="number" name="year" value="${car != null ? car.year : ''}" required></div>
                        <div><label class="owner-label">Mau *</label><input class="owner-input" type="text" name="color" value="${car != null ? car.color : ''}" required></div>
                        <div><label class="owner-label">So ghe *</label><input class="owner-input" type="number" name="seats" value="${car != null ? car.seats : ''}" required></div>
                    </div>
                    <div class="owner-form-grid cols-2" style="margin-top:12px;">
                        <div><label class="owner-label">Gia/ngay *</label><input class="owner-input" type="number" name="pricePerDay" value="${car != null ? car.pricePerDay : ''}" required></div>
                        <div><label class="owner-label">Trang thai *</label>
                            <select class="owner-select" name="status" required>
                                <option value="AVAILABLE">San co</option>
                                <option value="RENTED">Dang thue</option>
                                <option value="MAINTENANCE">Bao tri</option>
                            </select>
                        </div>
                    </div>
                    <div style="margin-top:12px;"><label class="owner-label">Anh chinh</label><input class="owner-input" type="file" name="imageFile" accept="image/*"></div>
                    <div style="margin-top:12px;"><label class="owner-label">Mo ta *</label><textarea class="owner-textarea" name="description" required>${car != null ? car.description : ''}</textarea></div>
                    <input type="hidden" name="active" value="1">
                    <div class="owner-actions">
                        <button type="submit" class="owner-btn primary"><i class="bi bi-plus-lg"></i> Them xe</button>
                        <a href="${ctx}/owner" class="owner-btn outline">Huy</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>
