<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quản lý lịch xe | CarRental Owner</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/owner-dashboard.css" rel="stylesheet">
    <style>
        .card-title { font-weight: 600; margin-bottom: 20px; display: flex; align-items: center; gap: 8px; font-size: 15px; color: #1f2937; }
        .owner-form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; }
    </style>
</head>
<body>
<div class="owner-dashboard">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="activePage" value="owner"/>
    </jsp:include>

    <main class="owner-main">
        <div class="owner-topbar">
            <h1><i class="bi bi-calendar3"></i> Lịch sẵn có: ${car.name}</h1>
            <div class="owner-user">Xin chào, <strong>${sessionScope.fullName != null ? sessionScope.fullName : sessionScope.username}</strong></div>
        </div>

        <div class="owner-page">
        <div class="owner-card">
            <div class="card-title"><i class="bi bi-plus-circle"></i> Thêm khoảng thời gian mới</div>
            <form method="post" action="${ctx}/owner/availability/${car.id}" id="availabilityForm">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="carId" value="${car.id}">
                
                <div class="owner-form-grid">
                    <div>
                        <label class="owner-label">Từ ngày</label>
                        <input class="owner-input" type="date" name="startDate" id="startDate" required>
                    </div>
                    <div>
                        <label class="owner-label">Đến ngày</label>
                        <input class="owner-input" type="date" name="endDate" id="endDate" required>
                    </div>
                    <div>
                        <label class="owner-label">Trạng thái xe</label>
                        <select class="owner-select" name="isAvailable">
                            <option value="1">Sẵn có (Cho thuê)</option>
                            <option value="0">Bận / Bảo trì</option>
                        </select>
                    </div>
                </div>
                <div style="margin-top:20px;">
                    <label class="owner-label">Ghi chú (Ví dụ: Bảo trì định kỳ, xe gia đình dùng...)</label>
                    <input class="owner-input" type="text" name="note" placeholder="Nhập ghi chú nếu có">
                </div>
                <div class="owner-actions">
                    <button type="submit" class="owner-btn primary">Xác nhận thêm lịch</button>
                </div>
            </form>
        </div>

        <div class="owner-card">
            <div class="card-title"><i class="bi bi-list-ul"></i> Danh sách lịch đã thiết lập</div>
            <div class="owner-table-wrap">
                <table class="owner-table">
                    <thead>
                        <tr>
                            <th>Từ ngày</th>
                            <th>Đến ngày</th>
                            <th>Trạng thái</th>
                            <th>Ghi chú</th>
                            <th style="text-align: right;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="av" items="${availabilities}">
                        <tr>
                            <td style="font-weight: 500;">${av.formattedStartDate}</td>
                            <td style="font-weight: 500;">${av.formattedEndDate}</td>
                            <td>
                                <span class="badge ${av.available ? 'badge-avail' : 'badge-maint'}">
                                    <i class="bi ${av.available ? 'bi-check-circle' : 'bi-x-circle'}"></i>
                                    ${av.available ? 'Sẵn có' : 'Không sẵn có'}
                                </span>
                            </td>
                            <td style="color: #64748b; font-style: italic;">
                                ${empty av.note ? '-' : av.note}
                            </td>
                            <td style="text-align: right;">
                                <form action="${ctx}/owner/availability/${car.id}" method="post" style="display:inline;" onsubmit="return confirm('Bạn chắc chắn muốn xóa lịch này?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${av.id}">
                                    <button type="submit" class="owner-btn outline" title="Xóa">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty availabilities}">
                        <tr>
                            <td colspan="5" style="text-align: center; padding: 40px; color: #64748b;">
                                <i class="bi bi-calendar-x" style="font-size: 24px;"></i><br>Chưa có lịch nào được thiết lập.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
        </div>
    </main>
</div>

<script>
    // UX: Tự động giới hạn ngày kết thúc không được nhỏ hơn ngày bắt đầu
    const startInput = document.getElementById('startDate');
    const endInput = document.getElementById('endDate');

    startInput.addEventListener('change', () => {
        if (startInput.value) {
            endInput.min = startInput.value;
        }
    });

    document.getElementById('availabilityForm').onsubmit = function(e) {
        if (new Date(startInput.value) > new Date(endInput.value)) {
            alert('Ngày kết thúc không thể trước ngày bắt đầu!');
            return false;
        }
    };
</script>

</body>
</html>