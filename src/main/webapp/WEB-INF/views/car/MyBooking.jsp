<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn đặt xe của tôi | CarRental</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/woox-customer.css" rel="stylesheet">
    <link href="${ctx}/assets/css/pagination-pills.css" rel="stylesheet">
    <style>
        :root {
            --mb-primary: #2563eb;
            --mb-bg: #f1f5f9;
        }
        body { font-family: 'Inter', sans-serif; background: var(--mb-bg); color: #334155; }
        .order-card {
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(15, 23, 42, 0.06);
            border: 1px solid #e2e8f0;
            overflow: hidden;
            margin-bottom: 1.5rem;
        }
        .order-card-head {
            padding: 1rem 1.25rem;
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;
            gap: 0.75rem;
        }
        .order-card-body { padding: 1.25rem 1.5rem 1.5rem; }
        .badge-status {
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            padding: 0.35rem 0.75rem;
            border-radius: 50px;
        }
        .booking-progress-wrap { margin: 1rem 0 1.25rem; overflow-x: auto; padding-bottom: 6px; }
        .booking-progress {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            min-width: 520px;
            position: relative;
            padding: 0 4px;
        }
        .booking-progress::before {
            content: '';
            position: absolute;
            top: 14px;
            left: 5%;
            right: 5%;
            height: 3px;
            background: #e2e8f0;
            z-index: 0;
        }
        .progress-step {
            flex: 1;
            text-align: center;
            position: relative;
            z-index: 1;
            max-width: 90px;
        }
        .progress-step .dot {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: #e2e8f0;
            margin: 0 auto 6px;
            line-height: 28px;
            font-size: 11px;
            font-weight: 800;
            color: #64748b;
            transition: background 0.2s, box-shadow 0.2s, color 0.2s;
        }
        .progress-step.done .dot {
            background: #22c55e;
            color: #fff;
        }
        .progress-step.active .dot {
            background: var(--mb-primary);
            color: #fff;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.22);
        }
        .progress-step .lbl {
            font-size: 9px;
            color: #64748b;
            line-height: 1.25;
            font-weight: 500;
        }
        .progress-step.done .lbl { color: #15803d; }
        .progress-step.active .lbl { color: #1d4ed8; font-weight: 700; }
        .booking-progress.cancelled::before { background: #fecaca; }
        .booking-progress.cancelled .progress-step .dot {
            background: #fee2e2;
            color: #991b1b;
        }
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px dashed #e2e8f0;
        }
        .detail-item label {
            display: block;
            font-size: 0.68rem;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            color: #94a3b8;
            margin-bottom: 0.2rem;
        }
        .detail-item .val { font-weight: 600; color: #1e293b; font-size: 0.95rem; }
        .hold-section .table thead th { background: #f8fafc; font-size: 0.72rem; text-transform: uppercase; color: #64748b; }
        .btn-action { border-radius: 10px; font-weight: 600; font-size: 0.85rem; }
        .countdown { display: inline-block; padding: 2px 8px; background: #fff1f2; border-radius: 4px; font-weight: 600; }
    </style>
</head>
<body>
<jsp:include page="../layout/header.jsp"/>

<div class="container py-4 py-md-5 mb-5">
    <c:if test="${param.success == 'returned'}">
        <div class="alert alert-success rounded-3 border-0 shadow-sm mb-4">
            <i class="bi bi-check-circle-fill me-2"></i>
            Đã gửi xác nhận trả xe. Vui lòng chờ chủ xe xác nhận nhận xe để hoàn tất đơn.
        </div>
    </c:if>

    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
        <div>
            <h1 class="h3 fw-bold mb-1" style="color: #0f172a;">
                <i class="fa-solid fa-receipt text-primary me-2"></i>Đơn đặt xe của tôi
            </h1>
            <p class="text-muted small mb-0">Theo dõi tiến độ, thanh toán và chi tiết từng đơn thuê.</p>
        </div>
        <a href="${ctx}/searchcar" class="btn btn-outline-primary btn-action">
            <i class="fa-solid fa-car me-1"></i>Thuê xe mới
        </a>
    </div>

    <form method="get" action="${ctx}/mybooking" class="row g-2 align-items-end mb-4">
        <div class="col-md-4 col-lg-3">
            <label class="form-label small text-muted mb-0">Lọc đơn theo trạng thái</label>
            <select name="bookingStatus" class="form-select form-select-sm">
                <option value="" ${empty bookingStatusFilter ? 'selected' : ''}>Tất cả</option>
                <option value="PENDING" ${bookingStatusFilter == 'PENDING' ? 'selected' : ''}>PENDING</option>
                <option value="APPROVED" ${bookingStatusFilter == 'APPROVED' ? 'selected' : ''}>APPROVED</option>
                <option value="PICKED_UP" ${bookingStatusFilter == 'PICKED_UP' ? 'selected' : ''}>PICKED_UP</option>
                <option value="RETURN" ${bookingStatusFilter == 'RETURN' ? 'selected' : ''}>RETURN</option>
                <option value="COMPLETED" ${bookingStatusFilter == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                <option value="REJECTED" ${bookingStatusFilter == 'REJECTED' ? 'selected' : ''}>REJECTED</option>
                <option value="CANCELLED" ${bookingStatusFilter == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
            </select>
        </div>
        <div class="col-auto">
            <input type="hidden" name="bookPage" value="1"/>
            <input type="hidden" name="holdPage" value="${holdCurrentPage}"/>
            <button type="submit" class="btn btn-primary btn-sm btn-action"><i class="bi bi-funnel me-1"></i>Lọc</button>
        </div>
    </form>

    <%-- Danh sách đơn (card + tiến độ) --%>
    <c:if test="${not empty bookingRows}">
            <c:forEach items="${bookingRows}" var="row">
                <c:set var="book" value="${row.booking}"/>
                <c:set var="car" value="${row.car}"/>
                <c:set var="pay" value="${row.payment}"/>
                <c:set var="pStep" value="${row.progressStep}"/>
                <article class="order-card">
                    <div class="order-card-head">
                        <div>
                            <span class="text-muted small">Mã đơn</span>
                            <strong class="d-block fs-5 text-dark">#${book.booking_id}</strong>
                        </div>
                        <span class="badge-status
                            ${book.booking_status == 'PENDING' ? 'bg-warning text-dark' : ''}
                            ${book.booking_status == 'APPROVED' ? 'bg-success-subtle text-success' : ''}
                            ${book.booking_status == 'PICKED_UP' ? 'bg-primary-subtle text-primary' : ''}
                            ${book.booking_status == 'RETURN' ? 'bg-info-subtle text-info' : ''}
                            ${book.booking_status == 'COMPLETED' ? 'bg-secondary-subtle text-secondary' : ''}
                            ${book.booking_status == 'REJECTED' || book.booking_status == 'CANCELLED' ? 'bg-danger-subtle text-danger' : ''}">
                            ${book.booking_status}
                        </span>
                    </div>
                    <div class="order-card-body">
                        <%-- Thanh tiến độ --%>
                        <c:choose>
                            <c:when test="${pStep == 0}">
                                <div class="alert alert-danger mb-0 py-2 small rounded-3 border-0">
                                    <i class="bi bi-x-octagon me-1"></i>
                                    Đơn đã bị từ chối hoặc đã hủy. Bạn có thể đặt xe khác.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="small text-muted mb-1"><i class="bi bi-signpost-split me-1"></i>Tiến độ đơn hàng</div>
                                <div class="booking-progress-wrap">
                                    <div class="booking-progress ${pStep == 0 ? 'cancelled' : ''}">
                                        <c:forEach begin="1" end="6" var="s">
                                            <div class="progress-step ${pStep >= s ? 'done' : ''} ${pStep == s ? 'active' : ''}">
                                                <div class="dot">${s}</div>
                                                <div class="lbl">
                                                    <c:choose>
                                                        <c:when test="${s == 1}">Chờ thanh toán</c:when>
                                                        <c:when test="${s == 2}">Chờ chủ duyệt</c:when>
                                                        <c:when test="${s == 3}">Đã duyệt</c:when>
                                                        <c:when test="${s == 4}">Đã giao xe</c:when>
                                                        <c:when test="${s == 5}">Đã trả xe</c:when>
                                                        <c:when test="${s == 6}">Hoàn thành</c:when>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <%-- Chi tiết đơn --%>
                        <div class="detail-grid">
                            <div class="detail-item">
                                <label>Xe</label>
                                <div class="val">
                                    <c:choose>
                                        <c:when test="${not empty car}">${car.name}</c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="detail-item">
                                <label>Biển số</label>
                                <div class="val">${not empty car ? car.licensePlate : '—'}</div>
                            </div>
                            <div class="detail-item">
                                <label>Màu / Loại</label>
                                <div class="val">
                                    <c:choose>
                                        <c:when test="${not empty car}">${car.color} · ${car.seats} chỗ</c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="detail-item">
                                <label>Ngày nhận → trả</label>
                                <div class="val">${book.start_date} <i class="bi bi-arrow-right mx-1 text-muted"></i> ${book.end_date}</div>
                            </div>
                            <div class="detail-item">
                                <label>Số ngày thuê</label>
                                <div class="val">${book.total_days} ngày</div>
                            </div>
                            <div class="detail-item">
                                <label>Tổng tiền</label>
                                <div class="val text-primary">
                                    <fmt:formatNumber value="${row.totalPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                </div>
                            </div>
                            <div class="detail-item">
                                <label>Phương thức TT</label>
                                <div class="val">
                                    <c:choose>
                                        <c:when test="${empty pay || empty pay.paymentMethod}">Chưa chọn</c:when>
                                        <c:otherwise>${pay.paymentMethod}</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="detail-item">
                                <label>Trạng thái thanh toán</label>
                                <div class="val">
                                    <c:choose>
                                        <c:when test="${empty pay}">—</c:when>
                                        <c:otherwise>
                                            <span class="${pay.paymentStatus == 'PAID' ? 'text-success' : 'text-warning'}">${pay.paymentStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <%-- Gợi ý bước tiếp theo --%>
                        <div class="mt-3 small text-muted">
                            <c:if test="${pStep > 0}">
                                <c:choose>
                                    <c:when test="${book.booking_status == 'PENDING' && (empty pay || pay.paymentStatus != 'PAID')}">
                                        Bước tiếp theo: thanh toán trước; sau đó chủ xe xác nhận tiền rồi mới duyệt đơn.
                                    </c:when>
                                    <c:when test="${book.booking_status == 'PENDING' && pay.paymentStatus == 'PAID'}">
                                        Bước tiếp theo: chờ chủ xe duyệt đơn.
                                    </c:when>
                                    <c:when test="${book.booking_status == 'APPROVED'}">
                                        Bước tiếp theo: chủ xe xác nhận giao xe khi bạn đến nhận xe.
                                    </c:when>
                                    <c:when test="${book.booking_status == 'PICKED_UP'}">Bước tiếp theo: khi kết thúc hành trình, bấm <strong>Trả xe</strong>.</c:when>
                                    <c:when test="${book.booking_status == 'RETURN'}">Bước tiếp theo: chờ chủ xe xác nhận nhận xe (hoàn thành).</c:when>
                                    <c:when test="${book.booking_status == 'COMPLETED'}">Đơn đã hoàn thành. Cảm ơn bạn!</c:when>
                                </c:choose>
                            </c:if>
                        </div>

                        <%-- Thao tác --%>
                        <div class="d-flex flex-wrap gap-2 mt-3 pt-3 border-top">
                            <c:if test="${not empty car}">
                                <a href="${ctx}/invoice?book_id=${book.booking_id}&id=${car.id}" class="btn btn-primary btn-sm btn-action">
                                    <i class="fa-solid fa-file-invoice me-1"></i>Chi tiết / Hóa đơn
                                </a>
                            </c:if>
                            <c:if test="${(book.booking_status == 'PENDING' && (empty pay || pay.paymentStatus != 'PAID')) || (book.booking_status == 'APPROVED' && (empty pay || pay.paymentStatus != 'PAID'))}">
                                <a href="${ctx}/pay?bookingId=${book.booking_id}" class="btn btn-outline-primary btn-sm btn-action">
                                    <i class="fa-solid fa-wallet me-1"></i>Thanh toán
                                </a>
                            </c:if>
                            <c:if test="${book.booking_status == 'PENDING' || book.booking_status == 'APPROVED'}">
                                <a href="${ctx}/remove?book_id=${book.booking_id}" class="btn btn-outline-danger btn-sm btn-action"
                                   onclick="return confirm('Hủy đơn này?');">
                                    <i class="fa-solid fa-xmark me-1"></i>Hủy đơn
                                </a>
                            </c:if>
                            <c:if test="${book.booking_status == 'PICKED_UP'}">
                                <form action="${ctx}/mybooking" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="return-car"/>
                                    <input type="hidden" name="bookingId" value="${book.booking_id}"/>
                                    <button type="submit" class="btn btn-success btn-sm btn-action" onclick="return confirm('Xác nhận đã trả xe?');">
                                        <i class="fa-solid fa-right-left me-1"></i>Xác nhận trả xe
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </article>
            </c:forEach>
            <nav class="mt-3" aria-label="Phân trang đơn">
                <ul class="pagination pagination-sm cr-pagination justify-content-center flex-wrap mb-0">
                    <li class="page-item ${bookCurrentPage <= 1 ? 'disabled' : ''}">
                        <c:choose>
                            <c:when test="${bookCurrentPage > 1}">
                                <c:url var="bookPrev" value="/mybooking">
                                    <c:param name="bookPage" value="${bookCurrentPage - 1}"/>
                                    <c:param name="holdPage" value="${holdCurrentPage}"/>
                                    <c:if test="${not empty bookingStatusFilter}"><c:param name="bookingStatus" value="${bookingStatusFilter}"/></c:if>
                                </c:url>
                                <a class="page-link" href="${bookPrev}">Trước</a>
                            </c:when>
                            <c:otherwise><span class="page-link">Trước</span></c:otherwise>
                        </c:choose>
                    </li>
                    <c:forEach begin="1" end="${bookTotalPages}" var="p">
                        <c:if test="${p == 1 || p == bookTotalPages || (p >= bookCurrentPage - 1 && p <= bookCurrentPage + 1)}">
                            <li class="page-item ${p == bookCurrentPage ? 'active' : ''}">
                                <c:url var="bookPu" value="/mybooking">
                                    <c:param name="bookPage" value="${p}"/>
                                    <c:param name="holdPage" value="${holdCurrentPage}"/>
                                    <c:if test="${not empty bookingStatusFilter}"><c:param name="bookingStatus" value="${bookingStatusFilter}"/></c:if>
                                </c:url>
                                <a class="page-link" href="${bookPu}">${p}</a>
                            </li>
                        </c:if>
                    </c:forEach>
                    <li class="page-item nav-next ${bookCurrentPage >= bookTotalPages ? 'disabled' : ''}">
                        <c:choose>
                            <c:when test="${bookCurrentPage < bookTotalPages}">
                                <c:url var="bookNext" value="/mybooking">
                                    <c:param name="bookPage" value="${bookCurrentPage + 1}"/>
                                    <c:param name="holdPage" value="${holdCurrentPage}"/>
                                    <c:if test="${not empty bookingStatusFilter}"><c:param name="bookingStatus" value="${bookingStatusFilter}"/></c:if>
                                </c:url>
                                <a class="page-link" href="${bookNext}">Sau &gt;</a>
                            </c:when>
                            <c:otherwise><span class="page-link">Sau &gt;</span></c:otherwise>
                        </c:choose>
                    </li>
                </ul>
            </nav>
            <p class="text-center small text-muted mb-0">Trang ${bookCurrentPage}/${bookTotalPages} · ${bookTotalCount} đơn</p>
    </c:if>
    <c:if test="${bookTotalCount == 0 && holdTotalCount == 0}">
            <div class="order-card p-5 text-center text-muted">
                <i class="fa-solid fa-inbox fa-3x mb-3 opacity-25"></i>
                <p class="mb-2">Bạn chưa có đơn đặt xe nào.</p>
                <a href="${ctx}/searchcar" class="btn btn-primary btn-action">Khám phá xe</a>
            </div>
    </c:if>

    <%-- Giữ chỗ (nếu có) --%>
    <c:if test="${not empty requestScope['Select-List']}">
        <h2 class="h5 fw-bold mt-5 mb-3"><i class="bi bi-hourglass-split text-warning me-2"></i>Xe đang giữ chỗ</h2>
        <div class="order-card hold-section">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Xe</th>
                        <th>Giá/ngày</th>
                        <th>Trạng thái</th>
                        <th class="text-end">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${requestScope['Select-List']}" var="hcar" varStatus="loop">
                        <tr>
                            <td>${loop.count}</td>
                            <td>
                                <strong>${hcar.name}</strong>
                                <div class="small text-muted">${hcar.licensePlate}</div>
                            </td>
                            <td><fmt:formatNumber value="${hcar.pricePerDay}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                            <td><span class="badge bg-light text-dark border">${hcar.status}</span></td>
                            <td class="text-end">
                                <c:if test="${not empty sessionScope.hold_until}">
                                    <span class="countdown small text-danger me-2" data-time="${sessionScope.hold_until}"><i class="fa-solid fa-spinner fa-spin"></i></span>
                                </c:if>
                                <a href="${ctx}/booking?id=${hcar.id}" class="btn btn-sm btn-primary btn-action">Đặt xe</a>
                                <a href="${ctx}/remove?id=${hcar.id}" class="btn btn-sm btn-outline-danger btn-action">Bỏ chỗ</a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
            <nav class="mt-3" aria-label="Phân trang giữ chỗ">
                <ul class="pagination pagination-sm cr-pagination justify-content-center flex-wrap mb-0">
                    <li class="page-item ${holdCurrentPage <= 1 ? 'disabled' : ''}">
                        <c:choose>
                            <c:when test="${holdCurrentPage > 1}">
                                <c:url var="hPrev" value="/mybooking">
                                    <c:param name="holdPage" value="${holdCurrentPage - 1}"/>
                                    <c:param name="bookPage" value="${bookCurrentPage}"/>
                                    <c:if test="${not empty bookingStatusFilter}"><c:param name="bookingStatus" value="${bookingStatusFilter}"/></c:if>
                                </c:url>
                                <a class="page-link" href="${hPrev}">Trước</a>
                            </c:when>
                            <c:otherwise><span class="page-link">Trước</span></c:otherwise>
                        </c:choose>
                    </li>
                    <c:forEach begin="1" end="${holdTotalPages}" var="hp">
                        <c:if test="${hp == 1 || hp == holdTotalPages || (hp >= holdCurrentPage - 1 && hp <= holdCurrentPage + 1)}">
                            <li class="page-item ${hp == holdCurrentPage ? 'active' : ''}">
                                <c:url var="hPu" value="/mybooking">
                                    <c:param name="holdPage" value="${hp}"/>
                                    <c:param name="bookPage" value="${bookCurrentPage}"/>
                                    <c:if test="${not empty bookingStatusFilter}"><c:param name="bookingStatus" value="${bookingStatusFilter}"/></c:if>
                                </c:url>
                                <a class="page-link" href="${hPu}">${hp}</a>
                            </li>
                        </c:if>
                    </c:forEach>
                    <li class="page-item nav-next ${holdCurrentPage >= holdTotalPages ? 'disabled' : ''}">
                        <c:choose>
                            <c:when test="${holdCurrentPage < holdTotalPages}">
                                <c:url var="hNext" value="/mybooking">
                                    <c:param name="holdPage" value="${holdCurrentPage + 1}"/>
                                    <c:param name="bookPage" value="${bookCurrentPage}"/>
                                    <c:if test="${not empty bookingStatusFilter}"><c:param name="bookingStatus" value="${bookingStatusFilter}"/></c:if>
                                </c:url>
                                <a class="page-link" href="${hNext}">Sau &gt;</a>
                            </c:when>
                            <c:otherwise><span class="page-link">Sau &gt;</span></c:otherwise>
                        </c:choose>
                    </li>
                </ul>
            </nav>
            <p class="text-center small text-muted mb-0">Giữ chỗ: trang ${holdCurrentPage}/${holdTotalPages} · ${holdTotalCount} xe</p>
        </div>
    </c:if>
</div>

<jsp:include page="../layout/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function updateCountdown() {
        document.querySelectorAll(".countdown").forEach(function (el) {
            if (!el.dataset.time) return;
            var endTime = new Date(el.dataset.time).getTime();
            var now = Date.now();
            var diff = endTime - now;
            if (diff <= 0) {
                el.innerHTML = "<i class='bi bi-exclamation-circle me-1'></i>Hết hạn";
                el.classList.add("text-muted");
                return;
            }
            var minutes = Math.floor(diff / 60000);
            var seconds = Math.floor((diff % 60000) / 1000);
            el.innerHTML = "<i class='bi bi-hourglass-split me-1'></i>Còn " + minutes + "m " + seconds + "s";
        });
    }
    setInterval(updateCountdown, 1000);
    updateCountdown();
</script>
</body>
</html>
