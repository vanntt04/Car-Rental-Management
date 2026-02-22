<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quản lý ảnh xe - ${car.name} | CarRental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/style.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../layout/header.jsp"><jsp:param name="page" value="owner"/></jsp:include>

<div class="container py-4">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${ctx}/owner">Quản lý xe</a></li>
            <li class="breadcrumb-item"><a href="${ctx}/cars?id=${car.id}">${car.name}</a></li>
            <li class="breadcrumb-item active">Ảnh xe</li>
        </ol>
    </nav>

    <h1 class="mb-4"><i class="bi bi-images"></i> Quản lý ảnh - ${car.name}</h1>

    <c:if test="${not empty param.success}">
        <div class="alert alert-success">
            <c:choose>
                <c:when test="${param.success == 'added'}">Đã thêm ảnh thành công!</c:when>
                <c:when test="${param.success == 'deleted'}">Đã xóa ảnh thành công!</c:when>
                <c:when test="${param.success == 'primary'}">Đã đặt làm ảnh chính!</c:when>
            </c:choose>
        </div>
    </c:if>
    <c:if test="${param.error == 'empty'}">
        <div class="alert alert-warning">Vui lòng nhập URL ảnh.</div>
    </c:if>

    <div class="card mb-4">
        <div class="card-header">Thêm ảnh mới</div>
        <div class="card-body">
            <form method="post" action="${ctx}/owner" class="row g-2">
                <input type="hidden" name="action" value="add-image">
                <input type="hidden" name="carId" value="${car.id}">
                <div class="col-md-10">
                    <input type="url" name="imageUrl" class="form-control" placeholder="Nhập URL ảnh (https://...)" required>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100">Thêm ảnh</button>
                </div>
            </form>
        </div>
    </div>

    <div class="card">
        <div class="card-header">Danh sách ảnh</div>
        <div class="card-body">
            <c:if test="${empty images}">
                <p class="text-muted mb-0">Chưa có ảnh nào. Thêm ảnh để khách hàng xem xe của bạn.</p>
            </c:if>
            <c:if test="${not empty images}">
                <div class="row g-3">
                    <c:forEach var="img" items="${images}">
                        <div class="col-md-4 col-lg-3">
                            <div class="card h-100">
                                <img src="${img.imageUrl}" class="card-img-top" alt="Ảnh xe" style="height:180px;object-fit:cover" onerror="this.src='data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 width=%22100%22 height=%22180%22><rect fill=%22%23ddd%22 width=%22100%25%22 height=%22100%25%22/><text x=%2250%25%22 y=%2250%25%22 fill=%22%23999%22 text-anchor=%22middle%22 dy=%22.3em%22>No image</text></svg>'">
                                <div class="card-body p-2">
                                    <c:if test="${img.primary}">
                                        <span class="badge bg-primary mb-2">Ảnh chính</span>
                                    </c:if>
                                    <div class="btn-group btn-group-sm w-100">
                                        <c:if test="${not img.primary}">
                                            <form action="${ctx}/owner" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="set-primary-image">
                                                <input type="hidden" name="id" value="${img.id}">
                                                <button type="submit" class="btn btn-outline-primary" title="Đặt làm ảnh chính">Chính</button>
                                            </form>
                                        </c:if>
                                        <form action="${ctx}/owner" method="post" class="d-inline" onsubmit="return confirm('Xóa ảnh này?');">
                                            <input type="hidden" name="action" value="delete-image">
                                            <input type="hidden" name="id" value="${img.id}">
                                            <button type="submit" class="btn btn-outline-danger"><i class="bi bi-trash"></i></button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
    </div>

    <div class="mt-3">
        <a href="${ctx}/owner" class="btn btn-link"><i class="bi bi-arrow-left"></i> Quay lại danh sách xe</a>
    </div>
</div>

<jsp:include page="../layout/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
