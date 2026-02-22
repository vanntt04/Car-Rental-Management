<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chi tiết xe - ${car.name} | CarRental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/style.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../layout/header.jsp"><jsp:param name="page" value="cars"/></jsp:include>

<div class="container py-4">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${ctx}/home">Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="${ctx}/cars">Danh sách xe</a></li>
            <li class="breadcrumb-item active">${car.name}</li>
        </ol>
    </nav>

    <c:if test="${not empty param.success}">
        <div class="alert alert-success">
            <c:if test="${param.success == 'updated'}">Đã cập nhật thông tin xe thành công!</c:if>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <c:if test="${not empty car}">
        <div class="row">
            <!-- Ảnh xe -->
            <div class="col-lg-6 mb-4">
                <div class="card border-0 shadow-sm">
                    <c:choose>
                        <c:when test="${not empty carImages}">
                            <div id="carImageCarousel" class="carousel slide" data-bs-ride="carousel">
                                <div class="carousel-inner">
                                    <c:forEach var="img" items="${carImages}" varStatus="st">
                                        <div class="carousel-item ${st.first ? 'active' : ''}">
                                            <img src="${img.imageUrl}" class="d-block w-100" alt="Ảnh xe" style="height:400px;object-fit:cover"
                                                 onerror="this.src='data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 width=%22400%22 height=%22400%22><rect fill=%22%23eee%22 width=%22100%25%22 height=%22100%25%22/><text x=%2250%25%22 y=%2250%25%22 fill=%22%23999%22 text-anchor=%22middle%22 dy=%22.3em%22>Ảnh không khả dụng</text></svg>'">
                                        </div>
                                    </c:forEach>
                                </div>
                                <c:if test="${carImages != null && carImages.size() > 1}">
                                    <button class="carousel-control-prev" type="button" data-bs-target="#carImageCarousel" data-bs-slide="prev">
                                        <span class="carousel-control-prev-icon"></span>
                                    </button>
                                    <button class="carousel-control-next" type="button" data-bs-target="#carImageCarousel" data-bs-slide="next">
                                        <span class="carousel-control-next-icon"></span>
                                    </button>
                                </c:if>
                            </div>
                        </c:when>
                        <c:when test="${not empty car.imageUrl}">
                            <img src="${car.imageUrl}" class="card-img-top" alt="${car.name}" style="height:400px;object-fit:cover">
                        </c:when>
                        <c:otherwise>
                            <div class="bg-light d-flex align-items-center justify-content-center" style="height:400px">
                                <i class="bi bi-car-front display-1 text-muted"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Thông tin xe -->
            <div class="col-lg-6">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body">
                        <h1 class="card-title">${car.name}</h1>
                        <span class="badge ${car.status == 'AVAILABLE' ? 'bg-success' : car.status == 'RENTED' ? 'bg-warning' : 'bg-secondary'} fs-6 mb-3">${car.status}</span>
                        <p class="text-primary fs-4 mb-4">
                            <strong><fmt:formatNumber value="${car.pricePerDay}" type="currency" currencyCode="VND"/></strong> / ngày
                        </p>

                        <dl class="row mb-0">
                            <dt class="col-sm-4">Biển số</dt>
                            <dd class="col-sm-8">${car.licensePlate}</dd>
                            <dt class="col-sm-4">Hãng</dt>
                            <dd class="col-sm-8">${car.brand}</dd>
                            <dt class="col-sm-4">Model</dt>
                            <dd class="col-sm-8">${car.model}</dd>
                            <dt class="col-sm-4">Năm sản xuất</dt>
                            <dd class="col-sm-8">${car.year}</dd>
                            <dt class="col-sm-4">Màu</dt>
                            <dd class="col-sm-8">${car.color}</dd>
                        </dl>

                        <hr>

                        <c:if test="${sessionScope.role == 'OWNER' || sessionScope.role == 'ADMIN'}">
                            <c:set var="isOwner" value="false"/>
                            <c:if test="${car.ownerId != null && car.ownerId == sessionScope.userId}">
                                <c:set var="isOwner" value="true"/>
                            </c:if>
                            <c:if test="${isOwner || sessionScope.role == 'ADMIN'}">
                                <div class="d-flex gap-2 flex-wrap">
                                    <a href="${ctx}/owner/edit/${car.id}" class="btn btn-outline-secondary"><i class="bi bi-pencil"></i> Sửa xe</a>
                                    <a href="${ctx}/owner/availability/${car.id}" class="btn btn-outline-info"><i class="bi bi-calendar3"></i> Lịch sẵn có</a>
                                    <a href="${ctx}/owner/images/${car.id}" class="btn btn-outline-success"><i class="bi bi-images"></i> Quản lý ảnh</a>
                                </div>
                            </c:if>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Lịch sẵn có -->
        <c:if test="${not empty carAvailabilities}">
            <div class="card border-0 shadow-sm mt-4">
                <div class="card-header bg-white">
                    <h5 class="mb-0"><i class="bi bi-calendar3"></i> Lịch sẵn có</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-sm">
                            <thead>
                            <tr>
                                <th>Từ ngày</th>
                                <th>Đến ngày</th>
                                <th>Trạng thái</th>
                                <th>Ghi chú</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="av" items="${carAvailabilities}">
                                <tr>
                                    <td><fmt:formatDate value="${av.startDate}" pattern="dd/MM/yyyy"/></td>
                                    <td><fmt:formatDate value="${av.endDate}" pattern="dd/MM/yyyy"/></td>
                                    <td>
                                        <span class="badge ${av.available ? 'bg-success' : 'bg-secondary'}">
                                            ${av.available ? 'Sẵn có' : 'Không sẵn có'}
                                        </span>
                                    </td>
                                    <td>${av.note}</td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </c:if>

        <div class="mt-4">
            <a href="${ctx}/cars" class="btn btn-outline-primary"><i class="bi bi-arrow-left"></i> Quay lại danh sách xe</a>
        </div>
    </c:if>
</div>

<jsp:include page="../layout/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
