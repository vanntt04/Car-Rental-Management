<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Thêm xe mới | CarRental Owner</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/owner-dashboard.css" rel="stylesheet">
    <style>
        .owner-card { max-width: 900px; margin: 0 auto; border-bottom: 4px solid #2563eb; }
        
        /* Dropzone giả lập cho việc upload ảnh */
        .upload-dropzone {
            border: 2px dashed #cbd5e1;
            background: #f8fafc;
            border-radius: 12px;
            padding: 30px;
            text-align: center;
            cursor: pointer;
            transition: 0.3s;
            position: relative;
        }
        .upload-dropzone:hover { background: #f1f5f9; border-color: #2563eb; }
        .upload-dropzone i { font-size: 40px; color: #94a3b8; }
        
        #previewContainer {
            display: none;
            margin-top: 15px;
            position: relative;
        }
        #imagePreview {
            width: 100%;
            max-height: 300px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #e2e8f0;
        }
        
        .owner-input-group { position: relative; }
        .owner-input-group .unit {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-size: 14px;
            pointer-events: none;
        }
        
        .tip-box {
            background: #fffbeb;
            border-left: 4px solid #f59e0b;
            padding: 12px;
            margin-bottom: 20px;
            font-size: 14px;
            color: #92400e;
        }
    </style>
</head>
<body>
<div class="owner-dashboard">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="activePage" value="new"/>
    </jsp:include>

    <main class="owner-main">
        <div class="owner-topbar">
            <h1><i class="bi bi-plus-square-dotted"></i> Đăng ký xe cho thuê</h1>
            <div class="owner-user">Xin chào, <strong>${sessionScope.fullName != null ? sessionScope.fullName : sessionScope.username}</strong></div>
        </div>

        <div class="owner-page">
            <c:if test="${not empty error}">
                <div class="owner-alert danger"><i class="bi bi-exclamation-octagon"></i> ${error}</div>
            </c:if>

            <div class="tip-box">
                <i class="bi bi-lightbulb"></i> <strong>Mẹo:</strong> Cung cấp hình ảnh rõ nét và mô tả chi tiết các tiện nghi (Wifi, Camera, Bảo hiểm...) để tăng tỉ lệ khách đặt xe lên 40%!
            </div>

            <div class="owner-card">
                <form action="${ctx}/owner?action=create" method="post" enctype="multipart/form-data" id="createCarForm">
                    <div class="owner-form-section">
                        <div class="owner-form-section-title"><i class="bi bi-info-circle"></i> 1. Thông tin định danh</div>
                        <div class="owner-form-grid cols-2">
                            <div>
                                <label class="owner-label">Tên hiển thị *</label>
                                <input class="owner-input" type="text" name="name" placeholder="Ví dụ: Honda City RS 2023" value="${car != null ? car.name : ''}" required>
                            </div>
                            <div>
                                <label class="owner-label">Biển số xe *</label>
                                <input class="owner-input" type="text" name="licensePlate" placeholder="Ví dụ: 51H-123.45" value="${car != null ? car.licensePlate : ''}" required>
                            </div>
                        </div>
                        <div class="owner-form-grid cols-2" style="margin-top:16px;">
                            <div>
                                <label class="owner-label">Hãng sản xuất</label>
                                <input class="owner-input" type="text" name="brand" placeholder="Ví dụ: Honda" value="${car != null ? car.brand : ''}" required>
                            </div>
                            <div>
                                <label class="owner-label">Dòng xe (Model)</label>
                                <input class="owner-input" type="text" name="model" placeholder="Ví dụ: City" value="${car != null ? car.model : ''}" required>
                            </div>
                        </div>
                    </div>

                    <div class="owner-form-section">
                        <div class="owner-form-section-title"><i class="bi bi-gear-wide-connected"></i> 2. Thông số & Chi phí</div>
                        <div class="owner-form-grid cols-3">
                            <div>
                                <label class="owner-label">Năm sản xuất</label>
                                <input class="owner-input" type="number" name="year" min="0" max="<%= java.time.Year.now().getValue() %>" placeholder="2023" value="${car != null ? car.year : ''}" required>
                            </div>
                            <div>
                                <label class="owner-label">Màu ngoại thất</label>
                                <input class="owner-input" type="text" name="color" placeholder="Trắng" value="${car != null ? car.color : ''}" required>
                            </div>
                            <div>
                                <label class="owner-label">Số chỗ ngồi</label>
                                <select class="owner-select" name="seats" required>
                                    <option value="4" ${car.seats == 4 ? 'selected' : ''}>4 Chỗ</option>
                                    <option value="5" ${car.seats == 5 ? 'selected' : ''}>5 Chỗ</option>
                                    <option value="7" ${car.seats == 7 ? 'selected' : ''}>7 Chỗ</option>
                                </select>
                            </div>
                        </div>
                        <div class="owner-form-grid cols-2" style="margin-top:16px;">
                            <div class="owner-input-group">
                                <label class="owner-label">Giá thuê đề xuất (1 ngày)</label>
                                <input class="owner-input" type="number" name="pricePerDay" step="50000" placeholder="700000" value="${car != null ? car.pricePerDay : ''}" required>
                                <span class="unit">VNĐ</span>
                            </div>
                            <div>
                                <label class="owner-label">Trạng thái ban đầu</label>
                                <select class="owner-select" name="status">
                                    <option value="AVAILABLE">Sẵn sàng cho thuê ngay</option>
                                    <option value="MAINTENANCE">Chưa sẵn sàng (Bảo trì)</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="owner-form-section">
                        <div class="owner-form-section-title"><i class="bi bi-camera"></i> 3. Hình ảnh & Mô tả chi tiết</div>
                        
                        <div class="upload-dropzone" onclick="document.getElementById('imageFile').click()">
                            <i class="bi bi-cloud-arrow-up"></i>
                            <p style="margin: 10px 0 5px; font-weight: 500;">Bấm để tải ảnh xe lên</p>
                            <p style="font-size: 12px; color: #64748b;">Hỗ trợ: JPG, PNG, WEBP. Tối đa 5MB, ảnh sẽ được resize 500×500px</p>
                            <input type="file" name="imageFile" id="imageFile" accept="image/*" style="display: none;" onchange="previewImage(this)">
                        </div>

                        <div id="previewContainer">
                            <img src="" id="imagePreview">
                            <button type="button" class="owner-btn outline" style="margin-top: 10px; width: 100%;" onclick="removeImage()">Chọn ảnh khác</button>
                        </div>

                        <div style="margin-top:20px;">
                            <label class="owner-label">Giới thiệu về xe</label>
                            <textarea class="owner-textarea" name="description" placeholder="Hãy mô tả xe của bạn thật hấp dẫn...">${car != null ? car.description : ''}</textarea>
                        </div>
                    </div>

                    <input type="hidden" name="active" value="1">
                    
                    <div class="owner-actions">
                        <a href="${ctx}/owner" class="owner-btn outline">Hủy bỏ</a>
                        <button type="submit" class="owner-btn primary" style="min-width: 200px;">
                            <i class="bi bi-check-all"></i> Đăng ký xe
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script>
    function previewImage(input) {
        const preview = document.getElementById('imagePreview');
        const container = document.getElementById('previewContainer');
        const dropzone = document.querySelector('.upload-dropzone');
        
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                container.style.display = 'block';
                dropzone.style.display = 'none';
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    function removeImage() {
        document.getElementById('imageFile').value = '';
        document.getElementById('previewContainer').style.display = 'none';
        document.querySelector('.upload-dropzone').style.display = 'block';
    }

</script>
</body>
</html>