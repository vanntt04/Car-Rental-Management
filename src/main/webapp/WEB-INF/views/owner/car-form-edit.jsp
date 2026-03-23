<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Sửa thông tin xe | CarRental Owner</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/owner-dashboard.css" rel="stylesheet">
    <style>
        .owner-card { max-width: 900px; margin: 0 auto; }
        
        /* Hiển thị ảnh preview */
        .image-preview-container {
            display: flex;
            gap: 20px;
            align-items: center;
            background: #f8fafc;
            padding: 15px;
            border-radius: 12px;
            border: 1px dashed #cbd5e1;
        }
        .preview-box {
            width: 150px;
            height: 100px;
            border-radius: 8px;
            object-fit: cover;
            border: 2px solid #fff;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .preview-label { font-size: 12px; color: #64748b; text-align: center; margin-top: 5px; }

        /* Status colors trong select */
        option[value="AVAILABLE"] { color: #166534; font-weight: 600; }
        option[value="MAINTENANCE"] { color: #991b1b; font-weight: 600; }
        
        .owner-textarea {
            width: 100%;
            min-height: 120px;
            padding: 12px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-family: inherit;
            resize: vertical;
        }
        .owner-textarea:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
        }
    </style>
</head>
<body>
<div class="owner-dashboard">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="activePage" value="owner"/>
    </jsp:include>

    <main class="owner-main">
        <div class="owner-topbar">
            <h1><i class="bi bi-pencil-square"></i> Sửa thông tin: ${car.name}</h1>
            <div class="owner-user">Xin chào, <strong>${sessionScope.fullName != null ? sessionScope.fullName : sessionScope.username}</strong></div>
        </div>

        <div class="owner-page">
            <c:if test="${not empty error}">
                <div class="owner-alert danger"><i class="bi bi-x-circle"></i> ${error}</div>
            </c:if>

            <div class="owner-card">
                <form action="${ctx}/owner?action=update" method="post" id="updateCarForm">
                    <input type="hidden" name="id" value="${car.id}">
                    
                    <div class="owner-form-section">
                        <div class="owner-form-section-title"><i class="bi bi-info-circle"></i> Thông tin cơ bản</div>
                        <div class="owner-form-grid cols-2">
                            <div>
                                <label class="owner-label">Tên xe *</label>
                                <input class="owner-input" type="text" name="name" value="${car.name}" required>
                            </div>
                            <div>
                                <label class="owner-label">Biển số *</label>
                                <input class="owner-input" type="text" name="licensePlate" value="${car.licensePlate}" required>
                            </div>
                        </div>
                        <div class="owner-form-grid cols-2" style="margin-top:16px;">
                            <div>
                                <label class="owner-label">Hãng xe</label>
                                <input class="owner-input" type="text" name="brand" value="${car.brand}" required>
                            </div>
                            <div>
                                <label class="owner-label">Model</label>
                                <input class="owner-input" type="text" name="model" value="${car.model}" required>
                            </div>
                        </div>
                    </div>

                    <div class="owner-form-section">
                        <div class="owner-form-section-title"><i class="bi bi-sliders"></i> Thông số & Giá thuê</div>
                        <div class="owner-form-grid cols-3">
                            <div>
                                <label class="owner-label">Năm sản xuất</label>
                                <input class="owner-input" type="number" name="year" min="2010" max="2026" value="${car.year}" required>
                            </div>
                            <div>
                                <label class="owner-label">Màu sắc</label>
                                <input class="owner-input" type="text" name="color" value="${car.color}" required>
                            </div>
                            <div>
                                <label class="owner-label">Số ghế</label>
                                <select class="owner-input" name="seats">
                                    <option value="4" ${car.seats == 4 ? 'selected' : ''}>4 Chỗ</option>
                                    <option value="5" ${car.seats == 5 ? 'selected' : ''}>5 Chỗ</option>
                                    <option value="7" ${car.seats == 7 ? 'selected' : ''}>7 Chỗ</option>
                                    <option value="16" ${car.seats == 16 ? 'selected' : ''}>16 Chỗ</option>
                                </select>
                            </div>
                        </div>
                        <div class="owner-form-grid cols-2" style="margin-top:16px;">
                            <div>
                                <label class="owner-label">Giá thuê / ngày (VNĐ)</label>
                                <div style="position: relative;">
                                    <input class="owner-input" type="number" name="pricePerDay" step="10000" value="${car.pricePerDay}" required>
                                    <span style="position: absolute; right: 12px; top: 10px; color: #94a3b8; font-size: 14px;">đ</span>
                                </div>
                            </div>
                            <div>
                                <label class="owner-label">Trạng thái xe</label>
                                <select class="owner-select" name="status" required>
                                    <option value="AVAILABLE" ${car.status == 'AVAILABLE' ? 'selected' : ''}>🟢 Sẵn có</option>
                                    <option value="RENTED" ${car.status == 'RENTED' ? 'selected' : ''}>🟡 Đang được thuê</option>
                                    <option value="MAINTENANCE" ${car.status == 'MAINTENANCE' ? 'selected' : ''}>🔴 Bảo trì</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="owner-form-section">
                        <div class="owner-form-section-title"><i class="bi bi-image"></i> Hình ảnh & Mô tả</div>
                        
                        <div class="image-preview-container">
                            <div style="text-align: center;">
                                <c:choose>
                                    <c:when test="${not empty car.imageUrl}">
                                        <img src="${ctx}${car.imageUrl}" class="preview-box" id="oldImg" alt="Ảnh xe">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="preview-box" id="oldImg" style="background:#e2e8f0; display:flex; align-items:center; justify-content:center; color:#64748b; font-size:12px;">Chưa có ảnh</div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="preview-label">Ảnh hiện tại</div>
                            </div>
                            <div style="flex: 1;">
                                <label class="owner-label">Thay đổi ảnh xe</label>
                                <a href="${ctx}/owner/images/${car.id}" class="owner-btn outline"><i class="bi bi-images"></i> Quản lý ảnh xe</a>
                                <small style="color: #64748b; display:block; margin-top:8px;">Để thêm/xóa ảnh, dùng trang Quản lý ảnh</small>
                            </div>
                        </div>

                        <div style="margin-top:20px;">
                            <label class="owner-label">Mô tả chi tiết</label>
                            <textarea class="owner-textarea" name="description" placeholder="Mô tả các tiện nghi như: Bluetooth, Camera hành trình, Bản đồ...">${car.description}</textarea>
                        </div>
                    </div>

                    <div class="owner-actions">
                        <a href="${ctx}/owner" class="owner-btn outline">Hủy bỏ</a>
                        <button type="submit" class="owner-btn primary" style="min-width: 150px;">
                            <i class="bi bi-cloud-arrow-up"></i> Lưu thay đổi
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script>
    document.getElementById('updateCarForm').onsubmit = function() {
        return confirm('Bạn có chắc chắn muốn cập nhật các thay đổi này không?');
    };
</script>
</body>
</html>