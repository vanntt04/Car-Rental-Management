<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đơn hàng của tôi | My Booking</title>

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
        <link href="${ctx}/assets/css/woox-customer.css" rel="stylesheet">

        <style>
            :root {
                --primary-color: #0d6efd;
                --bg-body: #f1f5f9;
            }
            body {
                font-family: 'Inter', sans-serif;
                background-color: var(--bg-body);
                color: #334155;
            }
            .booking-card {
                border: none;
                border-radius: 20px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.05);
                overflow: hidden;
            }
            .table thead th {
                background-color: #f8fafc;
                text-transform: uppercase;
                font-size: 0.75rem;
                letter-spacing: 0.05em;
                color: #64748b;
                border-top: none;
                padding: 1.25rem 1rem;
            }
            .table tbody td {
                padding: 1.25rem 1rem;
                vertical-align: middle;
            }
            /* Status Badges Style */
            .status {
                display: inline-flex;
                align-items: center;
                padding: 0.35rem 0.75rem;
                border-radius: 50px;
                font-size: 0.7rem;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.02em;
            }
            .status-pending {
                background: #fff7ed;
                color: #c2410c;
                border: 1px solid #ffedd5;
            }
            .status-approved {
                background: #f0fdf4;
                color: #15803d;
                border: 1px solid #dcfce7;
            }
            .status-completed {
                background: #eff6ff;
                color: #1d4ed8;
                border: 1px solid #dbeafe;
            }
            .status-cancelled {
                background: #fef2f2;
                color: #b91c1c;
                border: 1px solid #fee2e2;
            }

            .countdown {
                display: inline-block;
                padding: 2px 8px;
                background: #fff1f2;
                border-radius: 4px;
                font-weight: 600;
            }
            .btn-action {
                border-radius: 10px;
                font-weight: 600;
                font-size: 0.85rem;
                padding: 0.5rem 1rem;
                transition: all 0.2s;
            }
            .alert-modern {
                background: #fffbeb;
                border: 1px solid #fef3c7;
                border-left: 4px solid #f59e0b;
                border-radius: 12px;
            }
            .page-link {
                border-radius: 8px !important;
                margin: 0 3px;
                border: none;
                color: #64748b;
            }
            .page-item.active .page-link {
                background-color: var(--primary-color);
            }
        </style>
    </head>
    <body>
        <jsp:include page="../layout/header.jsp"></jsp:include>

            <div class="container mt-5 mb-5">
                <div class="row">
                    <div class="col-12">
                        <div class="card booking-card bg-white">
                            <div class="card-body p-4 p-md-5">

                                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
                                    <div>
                                        <h2 class="fw-bold mb-1" style="color: #1e293b;">
                                            <i class="fa-solid fa-car-side text-primary me-2"></i>LIST CAR
                                        </h2>
                                        <p class="text-muted small mb-0">Quản lý và theo dõi xe bạn đã chọn.</p>
                                    </div>
                                    <a href="home" class="btn btn-outline-secondary btn-action shadow-sm">
                                        <i class="fa-solid fa-arrow-left me-1"></i> BACK HOME
                                    </a>
                                </div>

                                <div class="alert alert-modern d-flex align-items-center mb-4 shadow-sm" role="alert">
                                    <i class="bi bi-clock-history fs-4 me-3 text-warning"></i>
                                    <div>
                                        <span class="text-dark"><strong>Notice:</strong> Your request booking will expire after <span class="badge bg-warning text-dark px-2 py-1 ms-1">10 minutes</span>.</span>
                                    </div>
                                </div>

                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead>
                                            <tr>
                                                <th width="80">No.</th>
                                                <th>Car Details</th>
                                                <th>Price/Day</th>
                                                <th class="text-center">Status</th>
                                                <th class="text-center">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody class="border-top-0">
                                        <%-- RENDER SELECT LIST --%>
                                    <c:choose>
                                        <c:when test="${not empty requestScope['Select-List']}">
                                            <c:forEach items="${requestScope['Select-List']}" var="car" varStatus="loop">
                                                <tr>
                                                    <td class="text-muted fw-medium">#${loop.count}</td>
                                                    <td>
                                                        <div class="fw-bold text-dark fs-6">${car.name}</div>
                                                        <div class="d-flex align-items-center gap-2 mt-1">
                                                            <div class="d-flex flex-column gap-1 mt-1">
                                                                <span class="badge bg-light text-secondary border text-uppercase" style="font-size: 10px; width: fit-content;">
                                                                    <i class="bi bi-card-list me-1"></i> Biển số: ${car.licensePlate}
                                                                </span>
                                                                <span class="badge bg-light text-secondary border text-uppercase" style="font-size: 10px; width: fit-content;">
                                                                    <i class="bi bi-palette me-1"></i> Màu: ${car.color}
                                                                </span>
                                                                <span class="badge bg-light text-secondary border text-uppercase" style="font-size: 10px; width: fit-content;">
                                                                    <i class="bi bi-info-circle me-1"></i> Loại xe: ${car.seats} chỗ
                                                                </span>
                                                            </div>
                                                            <div class="text-danger small countdown" data-time="${sessionScope.hold_until}">
                                                                <i class="fa-solid fa-spinner fa-spin me-1"></i>Loading...
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="fw-bold text-primary">
                                                            <fmt:formatNumber value="${car.pricePerDay}" type="currency" currencySymbol="VNĐ" />

                                                        </span>
                                                    </td>
                                                    <td class="text-center">
                                                        <span class="status
                                                              <c:choose>
                                                              <c:when test="${car.status == 'RENTED'}">status-pending</c:when>
                                                            <c:when test="${car.status == 'AVAILABLE'}">status-approved</c:when>
                                                            <c:otherwise>status-completed</c:otherwise>
                                                            </c:choose>">
                                                            ${car.status}
                                                        </span>
                                                    </td>
                                                    <td class="text-center">
                                                        <div class="d-flex justify-content-center gap-2">
                                                            <a href="booking?id=${car.id}" class="btn btn-sm btn-primary btn-action text-white">
                                                                <i class="fa-solid fa-calendar-plus me-1"></i>Booking
                                                            </a>
                                                            <a href="remove?id=${car.id}" class="btn btn-sm btn-light btn-action text-danger border">
                                                                <i class="fa-solid fa-trash-can"></i>Cancel
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                    </c:choose>

                                    <%-- RENDER BOOK LIST --%>
                                    <c:choose>
                                        <c:when test="${not empty requestScope['Book-List']}">
                                            <c:forEach items="${requestScope['Book-List']}" var="book" varStatus="loop">
                                                <c:set var="car" value="${requestScope['Book-Car'][loop.index]}" />
                                                <tr>
                                                    <td class="text-muted fw-medium">#${loop.count}</td>
                                                    <td>
                                                        <div class="fw-bold text-dark fs-6">${car.name}</div>
                                                        <div class="d-flex flex-column gap-1 mt-1">
                                                            <span class="badge bg-light text-secondary border text-uppercase" style="font-size: 10px; width: fit-content;">
                                                                <i class="bi bi-card-list me-1"></i> Biển số: ${car.licensePlate}
                                                            </span>
                                                            <span class="badge bg-light text-secondary border text-uppercase" style="font-size: 10px; width: fit-content;">
                                                                <i class="bi bi-palette me-1"></i> Màu: ${car.color}
                                                            </span>
                                                            <span class="badge bg-light text-secondary border text-uppercase" style="font-size: 10px; width: fit-content;">
                                                                <i class="bi bi-info-circle me-1"></i> Loại xe: ${car.seats} chỗ
                                                            </span>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="mb-2">
                                                            <span class="fw-bold text-primary fs-5">
                                                                <fmt:formatNumber value="${car.pricePerDay}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                            </span>
                                                            <small class="text-muted">/ ngày</small>
                                                        </div>

                                                        <div class="d-flex flex-column gap-1">
                                                            <span class="badge bg-light text-secondary border-0 p-0 text-start text-uppercase" style="font-size: 15px;">
                                                                <i class="fa-regular fa-calendar-check me-1 text-success"></i> 
                                                                Từ: <span class="text-dark fw-semibold">${book.start_date}</span>
                                                            </span>
                                                            <span class="badge bg-light text-secondary border-0 p-0 text-start text-uppercase" style="font-size: 15px;">
                                                                <i class="fa-regular fa-calendar-xmark me-1 text-danger"></i> 
                                                                Đến: <span class="text-dark fw-semibold">${book.end_date}</span>
                                                            </span>
                                                        </div>
                                                    </td>
                                                    <td class="text-center">
                                                        <span class="status
                                                              <c:choose>
                                                              <c:when test="${book.booking_status == 'PENDING'}">status-pending</c:when>
                                                            <c:when test="${book.booking_status == 'APPROVED'}">status-approved</c:when>
                                                            <c:when test="${book.booking_status == 'COMPLETED'}">status-completed</c:when>
                                                            <c:when test="${book.booking_status == 'PAID'}">status-completed</c:when>
                                                            <c:when test="${book.booking_status == 'CANCELLED'}">status-cancelled</c:when>
                                                            </c:choose>">
                                                            ${book.booking_status}
                                                        </span>
                                                    </td>
                                                    <td class="text-center">
                                                        <div class="d-flex justify-content-center gap-2">
                                                            <c:choose>
                                                                <c:when test="${book.booking_status == 'APPROVED' || book.booking_status == 'PENDING'}">
                                                                    <a href="invoice?id=${car.id}&book_id=${book.booking_id}" class="btn btn-sm btn-primary btn-action text-white">
                                                                        <i class="fa-solid fa-circle-info me-1"></i>Detail
                                                                    </a>
                                                                    <a href="remove?book_id=${book.booking_id}" class="btn btn-sm btn-light btn-action text-danger border" onclick="return confirm('Are you sure?')">
                                                                        <i class="fa-solid fa-xmark me-1"></i>Cancel
                                                                    </a>
                                                                </c:when>
                                                                <c:when test="${book.booking_status == 'CANCELLED'}">
                                                                    <a href="remove?book_id=${book.booking_id}" class="btn btn-sm btn-light btn-action text-danger border">
                                                                        <i class="fa-solid fa-trash"></i> Clear
                                                                    </a>
                                                                </c:when>
                                                                <c:when test="${book.booking_status == 'PAID'}">
                                                                    <a hhref="delivery?book_id=${book.booking_id}"  class="btn btn-sm btn-primary btn-action text-white">
                                                                        <i class="fa-solid fa-circle-info me-1"></i>CheckOut
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <a href="booking?id=${car.id}" class="btn btn-sm btn-primary btn-action text-white">
                                                                        <i class="fa-solid fa-rotate-right me-1"></i>Re-book
                                                                    </a>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                    </c:choose>

                                    <%-- EMPTY CASE --%>
                                    <c:if test="${empty requestScope['Select-List'] && empty requestScope['Book-List']}">
                                        <tr>
                                            <td colspan="5" class="text-center py-5">
                                                <img src="https://cdn-icons-png.flaticon.com/512/4076/4076432.png" width="80" class="mb-3 opacity-25">
                                                <p class="text-muted">Bạn chưa chọn chiếc xe nào.</p>
                                                <a href="home" class="btn btn-primary btn-sm btn-action">Khám phá xe ngay</a>
                                            </td>
                                        </tr>
                                    </c:if>
                                    </tbody>
                                </table>
                            </div>

                            <nav aria-label="Page navigation" class="mt-4">
                                <ul class="pagination justify-content-center">
                                    <li class="page-item disabled"><a class="page-link shadow-sm" href="#"><i class="bi bi-chevron-left"></i></a></li>
                                    <li class="page-item active"><a class="page-link shadow-sm" href="#">1</a></li>
                                    <li class="page-item"><a class="page-link shadow-sm" href="#">2</a></li>
                                    <li class="page-item"><a class="page-link shadow-sm" href="#"><i class="bi bi-chevron-right"></i></a></li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="../layout/footer.jsp"/>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                                        function updateCountdown() {
                                                                            const countdowns = document.querySelectorAll(".countdown");
                                                                            countdowns.forEach(el => {
                                                                                if (!el.dataset.time)
                                                                                    return;
                                                                                const endTime = new Date(el.dataset.time).getTime();
                                                                                const now = new Date().getTime();
                                                                                const diff = endTime - now;

                                                                                if (diff <= 0) {
                                                                                    el.innerHTML = "<i class='bi bi-exclamation-circle me-1'></i>Expired";
                                                                                    el.classList.replace("text-danger", "text-muted");
                                                                                    return;
                                                                                }

                                                                                const minutes = Math.floor(diff / (1000 * 60));
                                                                                const seconds = Math.floor((diff % (1000 * 60)) / 1000);
                                                                                el.innerHTML = "<i class='bi bi-hourglass-split me-1'></i>Hold: " + minutes + "m " + seconds + "s";
                                                                            });
                                                                        }
                                                                        setInterval(updateCountdown, 1000);
                                                                        updateCountdown();
        </script>
    </body>
</html>