<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${empty car ? 'Thêm xe mới' : 'Sửa xe'} - CarRental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/style.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../layout/header.jsp"><jsp:param name="page" value="owner"/></jsp:include>

<div class="container py-4">
    <h1 class="mb-4">${empty car ? 'Thêm xe mới' : 'Sửa thông tin xe'}</h1>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <form method="post" action="${ctx}/owner" class="card">
        <div class="card-body">
            <input type="hidden" name="action" value="${empty car ? 'create' : 'update'}">
            <c:if test="${not empty car}">
                <input type="hidden" name="id" value="${car.id}">
            </c:if>

            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Tên xe *</label>
                    <input type="text" name="name" class="form-control" value="${car.name}" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Biển số *</label>
                    <input type="text" name="licensePlate" class="form-control" value="${car.licensePlate}" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Hãng</label>
                    <input type="text" name="brand" class="form-control" value="${car.brand}">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Model</label>
                    <input type="text" name="model" class="form-control" value="${car.model}">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Năm sản xuất</label>
                    <input type="number" name="year" class="form-control" value="${car.year}" min="1990" max="2030">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Màu</label>
                    <input type="text" name="color" class="form-control" value="${car.color}">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Giá/ngày (VNĐ) *</label>
                    <input type="number" name="pricePerDay" class="form-control" value="${car.pricePerDay}" min="0" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Trạng thái</label>
                    <select name="status" class="form-select">
                        <option value="AVAILABLE" ${car.status == 'AVAILABLE' ? 'selected' : ''}>Sẵn có</option>
                        <option value="RENTED" ${car.status == 'RENTED' ? 'selected' : ''}>Đang thuê</option>
                        <option value="MAINTENANCE" ${car.status == 'MAINTENANCE' ? 'selected' : ''}>Bảo trì</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">URL ảnh chính</label>
                    <input type="url" name="imageUrl" class="form-control" value="${car.imageUrl}" placeholder="https://...">
                </div>
                <div class="col-12">
                    <button type="submit" class="btn btn-primary">${empty car ? 'Thêm xe' : 'Cập nhật'}</button>
                    <a href="${ctx}/owner" class="btn btn-secondary">Hủy</a>
                </div>
            </div>
        </div>
    </form>

    <div class="mt-3">
        <a href="${ctx}/owner" class="btn btn-link"><i class="bi bi-arrow-left"></i> Quay lại danh sách xe</a>
    </div>
</div>

<jsp:include page="../layout/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
