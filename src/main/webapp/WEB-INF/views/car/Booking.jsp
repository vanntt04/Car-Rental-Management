<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt xe - CarRental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/woox-customer.css" rel="stylesheet">
    <link href="${ctx}/assets/css/forms.css" rel="stylesheet">
    <style>
        .booking-form-card { background: #fff; border-radius: 16px; box-shadow: 0 4px 24px rgba(0,0,0,0.06); padding: 2rem; border: 1px solid #f0f0f0; }
        .booking-summary-card { background: linear-gradient(135deg, #f0fdfa 0%, #e6f9f6 100%); border-radius: 16px; border: 1px solid #99f6e4; padding: 1.5rem; }
        .booking-summary-card .price { font-size: 1.75rem; font-weight: 700; color: #0d9488; }
        .booking-form-card .form-control { padding: 0.75rem 1rem; border-radius: 10px; }
        .booking-form-card .form-control:focus { border-color: #22b3c1; box-shadow: 0 0 0 3px rgba(34,179,193,0.15); }
        .btn-booking { background: linear-gradient(135deg, #22b3c1 0%, #1a9ba8 100%); border: none; padding: 0.875rem 1.75rem; font-weight: 600; border-radius: 10px; }
        .btn-booking:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(34,179,193,0.35); }
    </style>
</head>
<body>
<jsp:include page="../layout/header.jsp"><jsp:param name="page" value="cars"/></jsp:include>

<section class="woox-section" style="padding: 60px 0;">
    <div class="container">
        <c:if test="${not empty BookCar}">
            <div class="row g-4">
                <div class="col-lg-7">
                    <div class="booking-form-card">
                        <h2 class="mb-4"><i class="bi bi-calendar-check text-primary me-2"></i>Chọn thời gian thuê xe</h2>
                        <c:if test="${not empty error}">
                            <div class="alert alert-warning">${error}</div>
                        </c:if>
                        <form action="${ctx}/booking" method="post" accept-charset="UTF-8" class="form-modern">
                            <input type="hidden" name="action" value="accept"/>

                            <div class="mb-3">
                                <h4 class="h6 mb-2 fw-bold"><i class="bi bi-person me-2"></i>Thông tin khách hàng</h4>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label"><i class="bi bi-person-badge me-1"></i>Họ và tên *</label>
                                        <input type="text"
                                               name="fullName"
                                               class="form-control"
                                               value="${sessionScope.user.fullName}"
                                               required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label"><i class="bi bi-telephone me-1"></i>Số điện thoại *</label>
                                        <input type="text"
                                               name="phone"
                                               class="form-control"
                                               value="${sessionScope.user.phone}"
                                               required>
                                    </div>
                                </div>
                                <div class="mt-3 p-2" style="background:#f8fafc;border:1px solid #e5e7eb;border-radius:12px;">
                                    <div class="small text-muted mb-1"><i class="bi bi-qr-code-scan me-1"></i>Mã QR</div>
                                    <div class="small text-muted">
                                        Mã QR thanh toán sẽ được tạo ở trang thanh toán khi bạn chọn <strong>Chuyển khoản</strong>.
                                    </div>
                                </div>
                            </div>

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label"><i class="bi bi-calendar-event me-1"></i>Ngày lấy xe *</label>
                                    <input type="date" id="pickupTime" name="pickupTime" class="form-control" required/>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label"><i class="bi bi-calendar-x me-1"></i>Ngày trả xe *</label>
                                    <input type="date" id="returnTime" name="returnTime" class="form-control" required/>
                                </div>
                            </div>
                            <div class="mt-3">
                                <label class="form-label"><i class="bi bi-geo-alt me-1"></i>Ghi chú (địa điểm trả xe)</label>
                                <input type="text" name="returnLocation" class="form-control" placeholder="Ví dụ: 123 Nguyễn Huệ, Q.1, TP.HCM"/>
                            </div>
                            <div class="mt-4">
                                <button type="submit" class="btn btn-primary btn-booking px-4">
                                    <i class="bi bi-check2-circle me-2"></i> Xác nhận đặt xe
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="col-lg-5">
                    <div class="booking-summary-card sticky-top" style="top: 100px;">
                        <div class="d-flex align-items-center gap-2 mb-3">
                            <i class="bi bi-car-front fs-4 text-primary"></i>
                            <h5 class="mb-0 fw-bold">${BookCar.name}</h5>
                        </div>
                        <p class="mb-1 text-muted small">Giá thuê</p>
                        <p class="price mb-0">
                            <fmt:formatNumber value="${BookCar.pricePerDay}" type="currency" currencyCode="VND"/><span class="fs-6 fw-normal text-muted">/ngày</span>
                        </p>
                        <hr class="my-3">
                        <p class="small text-muted mb-0">
                            <i class="bi bi-info-circle me-1"></i>Bạn sẽ nhận hóa đơn xác nhận sau khi đặt xe thành công.
                        </p>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</section>

<jsp:include page="../layout/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function () {
        const pickup = document.getElementById('pickupTime');
        const ret = document.getElementById('returnTime');
        const form = document.querySelector('form.form-modern');
        if (!pickup || !ret || !form) return;

        const today = new Date();
        const yyyy = today.getFullYear();
        const mm = String(today.getMonth() + 1).padStart(2, '0');
        const dd = String(today.getDate()).padStart(2, '0');
        const todayStr = yyyy + '-' + mm + '-' + dd;

        // Ngày lấy xe phải >= hôm nay (ngày đặt)
        pickup.min = todayStr;
        // Ngày trả xe phải >= ngày lấy xe (set khi user chọn)
        ret.min = pickup.value ? pickup.value : todayStr;

        pickup.addEventListener('change', function () {
            if (pickup.value) {
                ret.min = pickup.value;
                if (ret.value && ret.value < pickup.value) {
                    ret.value = pickup.value;
                }
            }
        });

        form.addEventListener('submit', function (e) {
            const p = pickup.value;
            const r = ret.value;
            if (!p || !r) return;
            if (p < todayStr) {
                e.preventDefault();
                alert('Ngày lấy xe phải sau hoặc bằng ngày hiện tại.');
                return;
            }
            if (r < p) {
                e.preventDefault();
                alert('Ngày trả xe không được trước ngày lấy xe.');
            }
        });
    })();
</script>
</body>
</html>
