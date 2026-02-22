<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Lịch sẵn có - ${car.name} | CarRental</title>
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
            <li class="breadcrumb-item active">Lịch sẵn có</li>
        </ol>
    </nav>

    <h1 class="mb-4"><i class="bi bi-calendar3"></i> Lịch sẵn có - ${car.name}</h1>

    <c:if test="${not empty param.success}">
        <div class="alert alert-success">
            <c:choose>
                <c:when test="${param.success == 'added'}">Đã thêm lịch thành công!</c:when>
                <c:when test="${param.success == 'deleted'}">Đã xóa lịch thành công!</c:when>
            </c:choose>
        </div>
    </c:if>

    <div class="card mb-4">
        <div class="card-header">Thêm khoảng thời gian</div>
        <div class="card-body">
            <form method="post" action="${ctx}/owner" class="row g-3">
                <input type="hidden" name="action" value="add-availability">
                <input type="hidden" name="carId" value="${car.id}">
                <div class="col-md-3">
                    <label class="form-label">Từ ngày</label>
                    <input type="date" name="startDate" class="form-control" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Đến ngày</label>
                    <input type="date" name="endDate" class="form-control" required>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Trạng thái</label>
                    <select name="isAvailable" class="form-select">
                        <option value="1">Sẵn có</option>
                        <option value="0">Không sẵn có</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Ghi chú</label>
                    <input type="text" name="note" class="form-control">
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100">Thêm</button>
                </div>
            </form>
        </div>
    </div>

    <div class="card">
        <div class="card-header">Danh sách lịch</div>
        <div class="card-body">
            <c:if test="${empty availabilities}">
                <p class="text-muted mb-0">Chưa có lịch nào. Thêm khoảng thời gian sẵn có hoặc không sẵn có của xe.</p>
            </c:if>
            <c:if test="${not empty availabilities}">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>Từ ngày</th>
                            <th>Đến ngày</th>
                            <th>Trạng thái</th>
                            <th>Ghi chú</th>
                            <th></th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="av" items="${availabilities}">
                            <tr>
                                <td><fmt:formatDate value="${av.startDate}" pattern="dd/MM/yyyy"/></td>
                                <td><fmt:formatDate value="${av.endDate}" pattern="dd/MM/yyyy"/></td>
                                <td>
                                    <span class="badge ${av.available ? 'bg-success' : 'bg-secondary'}">
                                        ${av.available ? 'Sẵn có' : 'Không sẵn có'}
                                    </span>
                                </td>
                                <td>${av.note}</td>
                                <td>
                                    <form action="${ctx}/owner" method="post" class="d-inline" onsubmit="return confirm('Xóa lịch này?');">
                                        <input type="hidden" name="action" value="delete-availability">
                                        <input type="hidden" name="id" value="${av.id}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
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
