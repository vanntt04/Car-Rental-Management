<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quản lý ảnh xe - ${car.name} | CarRental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/woox-customer.css" rel="stylesheet">
    <style>
        .add-img-form { display: flex; gap: 12px; margin-bottom: 0; align-items: flex-end; }
        .add-img-form input[type="file"] { flex: 1; }
        @media (max-width: 576px) { .add-img-form { flex-direction: column; } }
    </style>
</head>
<body>
<jsp:include page="../layout/header.jsp"><jsp:param name="page" value="owner"/></jsp:include>

<section class="woox-section">
    <div class="container">
        <p class="woox-breadcrumb">
            <a href="${ctx}/owner">Quản lý xe</a> / <a href="${ctx}/cars?id=${car.id}">${car.name}</a> / Ảnh xe
        </p>

        <h1 class="woox-page-title" style="margin-bottom: 28px;"><i class="bi bi-images"></i> Quản lý ảnh - ${car.name}</h1>

        <c:if test="${not empty param.success}">
            <div class="woox-alert success">
                <c:choose>
                    <c:when test="${param.success == 'added'}">
                        <c:choose>
                            <c:when test="${not empty param.count && param.count > 1}">Đã thêm ${param.count} ảnh thành công!</c:when>
                            <c:otherwise>Đã thêm ảnh thành công!</c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:when test="${param.success == 'deleted'}">Đã xóa ảnh thành công!</c:when>
                    <c:when test="${param.success == 'primary'}">Đã đặt làm ảnh chính!</c:when>
                </c:choose>
            </div>
        </c:if>
        <c:if test="${param.error == 'empty'}">
            <div class="woox-alert danger">Vui lòng chọn file ảnh để tải lên.</div>
        </c:if>
        <c:if test="${param.error == 'invalid'}">
            <div class="woox-alert danger">File không hợp lệ. Chỉ chấp nhận JPG, PNG, GIF, WEBP (tối đa 5MB).</div>
        </c:if>

        <div class="woox-card" style="margin-bottom: 28px;">
            <h5 style="margin-bottom: 16px;">Thêm ảnh mới (tải từ máy)</h5>
            <form method="post" action="${ctx}/owner" enctype="multipart/form-data" class="woox-form add-img-form">
                <input type="hidden" name="action" value="add-image-upload">
                <input type="hidden" name="carId" value="${car.id}">
                <div style="flex: 1;">
                    <label class="woox-label">Chọn một hoặc nhiều ảnh</label>
                    <input type="file" name="imageFile" accept="image/jpeg,image/png,image/gif,image/webp" multiple>
                </div>
                <button type="submit" class="btn-woox-primary">Tải ảnh lên</button>
            </form>
            <p style="font-size: 13px; color: var(--woox-text); margin-top: 8px;">Định dạng: JPG, PNG, GIF, WEBP. Tối đa 5MB/ảnh. Có thể chọn nhiều file cùng lúc.</p>
        </div>

        <div class="woox-card">
            <h5 style="margin-bottom: 16px;">Danh sách ảnh</h5>
            <c:if test="${empty images}">
                <p style="color: var(--woox-text);">Chưa có ảnh nào.</p>
            </c:if>
            <c:if test="${not empty images}">
                <div class="woox-img-grid">
                    <c:forEach var="img" items="${images}">
                        <div class="woox-img-card">
                            <img src="${ctx}${img.imageUrl}" alt="Ảnh xe" onerror="this.parentElement.querySelector('.img-fallback').style.display='flex'; this.style.display='none';">
                            <div class="img-fallback" style="height:180px; background: #f0f0f0; display: none; align-items: center; justify-content: center; color: var(--woox-text);"><i class="bi bi-image"></i></div>
                            <div class="woox-img-card-body">
                                <c:if test="${img.primary}"><span class="badge badge-avail" style="margin-bottom: 8px;">Ảnh chính</span></c:if>
                                <div style="display: flex; gap: 8px; flex-wrap: wrap;">
                                    <c:if test="${not img.primary}">
                                        <form action="${ctx}/owner" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="set-primary-image">
                                            <input type="hidden" name="id" value="${img.id}">
                                            <button type="submit" class="btn-woox-outline" style="padding: 6px 12px; font-size: 13px; border-radius: 20px;">Chính</button>
                                        </form>
                                    </c:if>
                                    <form action="${ctx}/owner" method="post" style="display: inline;" onsubmit="return confirm('Xóa ảnh này?');">
                                        <input type="hidden" name="action" value="delete-image">
                                        <input type="hidden" name="id" value="${img.id}">
                                        <button type="submit" class="woox-danger" style="background: none; border: none; cursor: pointer; padding: 6px;"><i class="bi bi-trash"></i></button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>

        <p style="margin-top: 24px;">
            <span class="border-button"><a href="${ctx}/owner"><i class="bi bi-arrow-left"></i> Quay lại danh sách xe</a></span>
        </p>
    </div>
</section>

<jsp:include page="../layout/footer.jsp"/>
</body>
</html>
