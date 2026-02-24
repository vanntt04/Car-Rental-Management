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
    <link href="${ctx}/assets/css/woox-customer.css" rel="stylesheet">
    <style>
        .detail-placeholder { height: 400px; display: flex; align-items: center; justify-content: center; background: #f0f0f0; color: #999; font-size: 80px; }
        .breadcrumb-woox { padding: 15px 0; margin: 0; list-style: none; display: flex; flex-wrap: wrap; gap: 8px; font-size: 14px; color: #888; }
        .breadcrumb-woox a { color: #22b3c1; }
        .detail-actions { display: flex; gap: 10px; flex-wrap: wrap; margin-top: 24px; }
        .detail-actions a { padding: 10px 18px; border-radius: 25px; font-weight: 500; font-size: 14px; }
        .detail-actions .btn-woox-outline { border: 1px solid #22b3c1; color: #22b3c1; }
        .detail-actions .btn-woox-outline:hover { background: #22b3c1; color: #fff; }
    </style>
</head>
<body>
<jsp:include page="../layout/header.jsp"><jsp:param name="page" value="cars"/></jsp:include>

<section class="woox-section">
    <div class="container">
        <ul class="breadcrumb-woox">
            <li><a href="${ctx}/home">Trang chủ</a></li>
            <li>/</li>
            <li><a href="${ctx}/cars">Danh sách xe</a></li>
            <li>/</li>
            <li>${car.name}</li>
        </ul>

        <c:if test="${not empty param.success}">
            <div class="woox-alert success">Đã cập nhật thông tin xe thành công!</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="woox-alert danger">${error}</div>
        </c:if>

        <c:if test="${not empty car}">
            <div class="woox-detail-grid">
                <div class="woox-detail-img">
                    <c:choose>
                        <c:when test="${not empty carImages}">
                            <div id="carImageCarousel" class="carousel slide" data-bs-ride="carousel">
                                <div class="carousel-inner">
                                    <c:forEach var="img" items="${carImages}" varStatus="st">
                                        <div class="carousel-item ${st.first ? 'active' : ''}">
                                            <img src="${ctx}${img.imageUrl}" alt="Ảnh xe" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                            <div class="detail-placeholder" style="display: none;"><i class="bi bi-car-front"></i></div>
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
                            <img src="${ctx}${car.imageUrl}" alt="${car.name}" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                            <div class="detail-placeholder" style="display: none;"><i class="bi bi-car-front"></i></div>
                        </c:when>
                        <c:otherwise>
                            <div class="detail-placeholder"><i class="bi bi-car-front"></i></div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="woox-detail-info">
                    <h1>${car.name}</h1>
                    <span class="badge ${car.status == 'AVAILABLE' ? 'badge-avail' : car.status == 'RENTED' ? 'badge-rented' : 'badge-maint'}">${car.status}</span>
                    <p class="price"><strong><fmt:formatNumber value="${car.pricePerDay}" type="currency" currencyCode="VND"/></strong> / ngày</p>
                    <dl>
                        <dt>Biển số</dt><dd>${car.licensePlate}</dd>
                        <dt>Hãng</dt><dd>${car.brand}</dd>
                        <dt>Model</dt><dd>${car.model}</dd>
                        <dt>Năm</dt><dd>${car.year}</dd>
                        <dt>Màu</dt><dd>${car.color}</dd>
                    </dl>
                    <c:if test="${sessionScope.role == 'OWNER' || sessionScope.role == 'ADMIN'}">
                        <c:set var="isOwner" value="false"/>
                        <c:if test="${car.ownerId != null && car.ownerId == sessionScope.userId}"><c:set var="isOwner" value="true"/></c:if>
                        <c:if test="${isOwner || sessionScope.role == 'ADMIN'}">
                            <div class="detail-actions">
                                <a href="${ctx}/owner/edit/${car.id}" class="btn-woox-outline"><i class="bi bi-pencil"></i> Sửa xe</a>
                                <a href="${ctx}/owner/availability/${car.id}" class="btn-woox-outline"><i class="bi bi-calendar3"></i> Lịch sẵn có</a>
                                <a href="${ctx}/owner/images/${car.id}" class="btn-woox-outline"><i class="bi bi-images"></i> Quản lý ảnh</a>
                            </div>
                        </c:if>
                    </c:if>
                </div>
            </div>

            <c:if test="${not empty carAvailabilities}">
                <div style="margin-top: 40px;">
                    <h5 style="margin-bottom: 16px;"><i class="bi bi-calendar3"></i> Lịch sẵn có</h5>
                    <div class="woox-table-wrap">
                        <table class="woox-table">
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
                                    <td><span class="badge ${av.available ? 'badge-avail' : 'badge-maint'}">${av.available ? 'Sẵn có' : 'Không sẵn có'}</span></td>
                                    <td>${av.note}</td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>

            <p style="margin-top: 30px;">
                <span class="border-button"><a href="${ctx}/cars"><i class="bi bi-arrow-left"></i> Quay lại danh sách xe</a></span>
            </p>
        </c:if>
    </div>
</section>

<jsp:include page="../layout/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
