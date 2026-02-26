<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Thêm xe mới - CarRental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/woox-customer.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../layout/header.jsp"><jsp:param name="page" value="owner"/></jsp:include>

<section class="woox-section">
    <div class="container">
        <h1 class="woox-page-title" style="margin-bottom: 28px;">Thêm xe mới</h1>

        <c:if test="${not empty error}">
            <div class="woox-alert danger">${error}</div>
        </c:if>

        <form method="post" action="${ctx}/owner" enctype="multipart/form-data" class="woox-card woox-form">
            <input type="hidden" name="action" value="create">

            <div class="woox-form-row cols-2">
                <div>
                    <label class="woox-label">Tên xe *</label>
                    <input type="text" name="name" value="${car != null ? car.name : ''}" required>
                </div>
                <div>
                    <label class="woox-label">Biển số *</label>
                    <input type="text" name="licensePlate" value="${car != null ? car.licensePlate : ''}" required>
                </div>
            </div>
            <div class="woox-form-row cols-2">
                <div>
                    <label class="woox-label">Hãng</label>
                    <input type="text" name="brand" value="${car != null ? car.brand : ''}">
                </div>
                <div>
                    <label class="woox-label">Model</label>
                    <input type="text" name="model" value="${car != null ? car.model : ''}">
                </div>
            </div>
            <div class="woox-form-row cols-3">
                <div>
                    <label class="woox-label">Năm sản xuất</label>
                    <input type="number" name="year" value="${car != null ? car.year : ''}" min="1990" max="2030">
                </div>
                <div>
                    <label class="woox-label">Màu</label>
                    <input type="text" name="color" value="${car != null ? car.color : ''}">
                </div>
                <div>
                    <label class="woox-label">Giá/ngày (VNĐ) *</label>
                    <input type="number" name="pricePerDay" value="${car != null ? car.pricePerDay : ''}" min="0" required>
                </div>
            </div>
            <div class="woox-form-row cols-2">
                <div>
                    <label class="woox-label">Trạng thái</label>
                    <select name="status">
                        <option value="AVAILABLE" ${(empty car || car.status == 'AVAILABLE') ? 'selected' : ''}>Sẵn có</option>
                        <option value="RENTED" ${car != null && car.status == 'RENTED' ? 'selected' : ''}>Đang thuê</option>
                        <option value="MAINTENANCE" ${car != null && car.status == 'MAINTENANCE' ? 'selected' : ''}>Bảo trì</option>
                    </select>
                </div>
                <div>
                    <label class="woox-label">Ảnh chính (tải từ máy)</label>
                    <input type="file" name="imageFile" accept="image/jpeg,image/png,image/gif,image/webp">
                </div>
            </div>
            <div class="woox-form-row">
                <label class="woox-label">Mô tả xe</label>
                <textarea name="description" rows="4" placeholder="Mô tả chi tiết về xe (tình trạng, tiện nghi, ghi chú...)">${car != null ? car.description : ''}</textarea>
            </div>
            <input type="hidden" name="active" value="1">
            <div class="woox-form-row">
                <button type="submit" class="btn-woox-primary">Thêm xe</button>
                <span class="border-button" style="margin-left: 12px;"><a href="${ctx}/owner">Hủy</a></span>
            </div>
        </form>

        <p style="margin-top: 24px;">
            <span class="border-button"><a href="${ctx}/owner"><i class="bi bi-arrow-left"></i> Quay lại danh sách xe</a></span>
        </p>
    </div>
</section>

<jsp:include page="../layout/footer.jsp"/>
</body>
</html>
