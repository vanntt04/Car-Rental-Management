<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Sua xe - Owner</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/owner-dashboard.css" rel="stylesheet">
</head>
<body>
<div class="owner-dashboard">
    <aside class="owner-sidebar">
        <div class="owner-brand">CarRental Owner</div>
        <div class="owner-group-title">Dashboard</div>
        <a href="${ctx}/owner" class="owner-link active"><i class="bi bi-car-front"></i> Quan ly xe</a>
    </aside>
    <main class="owner-main">
        <div class="owner-topbar"><h1>Sua thong tin xe</h1><div class="owner-user">Owner</div></div>
        <div class="owner-page">
            <c:if test="${not empty error}"><div class="owner-alert danger">${error}</div></c:if>
            <div class="owner-card">
                <form action="${ctx}/owner?action=update" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="id" value="${car.id}">
                    <div class="owner-form-grid cols-2">
                        <div><label class="owner-label">Ten xe *</label><input class="owner-input" type="text" name="name" value="${car.name}" required></div>
                        <div><label class="owner-label">Bien so *</label><input class="owner-input" type="text" name="licensePlate" value="${car.licensePlate}" required></div>
                    </div>
                    <div class="owner-form-grid cols-2" style="margin-top:12px;">
                        <div><label class="owner-label">Hang *</label><input class="owner-input" type="text" name="brand" value="${car.brand}" required></div>
                        <div><label class="owner-label">Model *</label><input class="owner-input" type="text" name="model" value="${car.model}" required></div>
                    </div>
                    <div class="owner-form-grid cols-3" style="margin-top:12px;">
                        <div><label class="owner-label">Nam san xuat *</label><input class="owner-input" type="number" name="year" value="${car.year}" required></div>
                        <div><label class="owner-label">Mau *</label><input class="owner-input" type="text" name="color" value="${car.color}" required></div>
                        <div><label class="owner-label">So ghe *</label><input class="owner-input" type="number" name="seats" value="${car.seats}" required></div>
                    </div>
                    <div class="owner-form-grid cols-2" style="margin-top:12px;">
                        <div><label class="owner-label">Gia/ngay *</label><input class="owner-input" type="number" name="pricePerDay" value="${car.pricePerDay}" required></div>
                        <div><label class="owner-label">Trang thai *</label>
                            <select class="owner-select" name="status" required>
                                <option value="AVAILABLE" ${car.status == 'AVAILABLE' ? 'selected' : ''}>San co</option>
                                <option value="RENTED" ${car.status == 'RENTED' ? 'selected' : ''}>Dang thue</option>
                                <option value="MAINTENANCE" ${car.status == 'MAINTENANCE' ? 'selected' : ''}>Bao tri</option>
                            </select>
                        </div>
                    </div>
                    <div style="margin-top:12px;"><label class="owner-label">Doi anh chinh</label><input class="owner-input" type="file" name="imageFile" accept="image/*"></div>
                    <div style="margin-top:12px;"><label class="owner-label">Mo ta *</label><textarea class="owner-textarea" name="description" required>${car.description}</textarea></div>
                    <div class="owner-actions">
                        <button type="submit" class="owner-btn primary"><i class="bi bi-save"></i> Cap nhat</button>
                        <a href="${ctx}/owner" class="owner-btn outline">Huy</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>
