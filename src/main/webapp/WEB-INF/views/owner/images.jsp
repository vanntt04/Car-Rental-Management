<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quan ly anh xe - Owner</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/owner-dashboard.css" rel="stylesheet">
</head>
<body>
<div class="owner-dashboard">
    <aside class="owner-sidebar">
        <div class="owner-brand">CarRental Owner</div>
        <a href="${ctx}/owner" class="owner-link active"><i class="bi bi-car-front"></i> Quan ly xe</a>
    </aside>
    <main class="owner-main">
        <div class="owner-topbar"><h1>Quan ly anh - ${car.name}</h1><div class="owner-user">Owner</div></div>
        <div class="owner-page">
            <div class="owner-card">
                <form method="post" action="${ctx}/owner" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add-image-upload">
                    <input type="hidden" name="carId" value="${car.id}">
                    <label class="owner-label">Chon mot hoac nhieu anh</label>
                    <input class="owner-input" type="file" name="imageFile" accept="image/*" multiple>
                    <div class="owner-actions"><button type="submit" class="owner-btn primary"><i class="bi bi-upload"></i> Tai anh len</button></div>
                </form>
            </div>

            <div class="owner-card">
                <div class="owner-img-grid">
                    <c:forEach var="img" items="${images}">
                        <div class="owner-img-card">
                            <img src="${ctx}${img.imageUrl}" alt="Anh xe">
                            <div class="owner-img-card-body">
                                <c:if test="${img.primary}"><span class="badge badge-avail">Anh chinh</span></c:if>
                                <div class="owner-actions">
                                    <c:if test="${not img.primary}">
                                        <form action="${ctx}/owner" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="set-primary-image">
                                            <input type="hidden" name="id" value="${img.id}">
                                            <button type="submit" class="owner-btn outline">Dat chinh</button>
                                        </form>
                                    </c:if>
                                    <form action="${ctx}/owner" method="post" style="display:inline;" onsubmit="return confirm('Xoa anh nay?');">
                                        <input type="hidden" name="action" value="delete-image">
                                        <input type="hidden" name="id" value="${img.id}">
                                        <button type="submit" class="owner-btn outline"><i class="bi bi-trash"></i></button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
