<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Lich san co - Owner</title>
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
        <div class="owner-topbar"><h1>Lich san co - ${car.name}</h1><div class="owner-user">Owner</div></div>
        <div class="owner-page">
            <div class="owner-card">
                <form method="post" action="${ctx}/owner">
                    <input type="hidden" name="action" value="add-availability">
                    <input type="hidden" name="carId" value="${car.id}">
                    <div class="owner-form-grid cols-3">
                        <div><label class="owner-label">Tu ngay</label><input class="owner-input" type="date" name="startDate" required></div>
                        <div><label class="owner-label">Den ngay</label><input class="owner-input" type="date" name="endDate" required></div>
                        <div><label class="owner-label">Trang thai</label><select class="owner-select" name="isAvailable"><option value="1">San co</option><option value="0">Khong san co</option></select></div>
                    </div>
                    <div style="margin-top:12px;"><label class="owner-label">Ghi chu</label><input class="owner-input" type="text" name="note"></div>
                    <div class="owner-actions"><button type="submit" class="owner-btn primary">Them lich</button></div>
                </form>
            </div>

            <div class="owner-card">
                <div class="owner-table-wrap">
                    <table class="owner-table">
                        <thead><tr><th>Tu ngay</th><th>Den ngay</th><th>Trang thai</th><th>Ghi chu</th><th></th></tr></thead>
                        <tbody>
                        <c:forEach var="av" items="${availabilities}">
                            <tr>
                                <td>${av.startDate}</td><td>${av.endDate}</td>
                                <td><span class="badge ${av.available ? 'badge-avail' : 'badge-maint'}">${av.available ? 'San co' : 'Khong san co'}</span></td>
                                <td>${av.note}</td>
                                <td>
                                    <form action="${ctx}/owner" method="post" style="display:inline;" onsubmit="return confirm('Xoa lich nay?');">
                                        <input type="hidden" name="action" value="delete-availability"><input type="hidden" name="id" value="${av.id}">
                                        <button type="submit" class="owner-btn outline"><i class="bi bi-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
