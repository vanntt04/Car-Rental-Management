<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chi tiết xe - Car Rental</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: system-ui, sans-serif; margin: 0; padding: 2rem; background: #f5f5f5; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        h1 { color: #333; }
        nav { margin-bottom: 1.5rem; }
        nav a { display: inline-block; margin-right: 0.5rem; padding: 0.5rem 1rem; background: #2563eb; color: white; text-decoration: none; border-radius: 6px; }
        dl { display: grid; grid-template-columns: 140px 1fr; gap: 0.5rem 1rem; }
        dt { font-weight: 600; color: #64748b; }
        dd { margin: 0; }
    </style>
</head>
<body>
<div class="container">
    <h1>Chi tiết xe</h1>
    <nav>
        <a href="<c:url value='/home'/>">Trang chủ</a>
        <a href="<c:url value='/cars'/>">Danh sách xe</a>
        <a href="<c:url value='/users'/>">Danh sách người dùng</a>
    </nav>

    <c:if test="${not empty car}">
        <dl>
            <dt>ID</dt><dd><c:out value="${car.id}"/></dd>
            <dt>Tên</dt><dd><c:out value="${car.name}"/></dd>
            <dt>Biển số</dt><dd><c:out value="${car.licensePlate}"/></dd>
            <dt>Hãng</dt><dd><c:out value="${car.brand}"/></dd>
            <dt>Model</dt><dd><c:out value="${car.model}"/></dd>
            <dt>Năm</dt><dd><c:out value="${car.year}"/></dd>
            <dt>Màu</dt><dd><c:out value="${car.color}"/></dd>
            <dt>Giá/ngày</dt><dd><fmt:formatNumber value="${car.pricePerDay}" type="currency" currencyCode="VND"/></dd>
            <dt>Trạng thái</dt><dd><c:out value="${car.status}"/></dd>
            <dt>Ảnh</dt><dd><c:out value="${car.imageUrl}" default="-"/></dd>
        </dl>
    </c:if>
</div>
</body>
</html>
