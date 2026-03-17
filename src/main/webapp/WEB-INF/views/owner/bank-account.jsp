<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Tài khoản ngân hàng - CarRental</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
        <link href="${ctx}/assets/css/woox-customer.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="../layout/header.jsp"><jsp:param name="page" value="owner"/></jsp:include>

        <section class="woox-section">
            <div class="container">
                <h1 class="woox-page-title" style="margin-bottom: 28px;">Tài khoản ngân hàng</h1>
                <p class="text-muted mb-4">Thông tin tài khoản dùng để nhận thanh toán từ khách thuê xe.</p>

                <c:if test="${param.success == 'saved'}">
                    <div class="woox-alert success">Đã lưu thông tin tài khoản ngân hàng.</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="woox-alert danger">${error}</div>
                </c:if>

                <form action="${ctx}/owner?action=saveBankAccount" method="post" class="woox-card woox-form">
                    <div class="woox-form-row cols-2">
                        <div>
                            <label class="woox-label">Mã ngân hàng *</label>
                            <input type="text" name="bankCode" value="${bankAccount != null ? bankAccount.bankCode : ''}" placeholder="VD: VCB, TCB, BIDV, MB" required>
                        </div>
                        <div>
                            <label class="woox-label">Số tài khoản *</label>
                            <input type="text" name="accountNumber" value="${bankAccount != null ? bankAccount.accountNumber : ''}" placeholder="Số tài khoản ngân hàng" required>
                        </div>
                    </div>
                    <div class="woox-form-row cols-2">
                        <div>
                            <label class="woox-label">Chủ tài khoản *</label>
                            <input type="text" name="accountName" value="${bankAccount != null ? bankAccount.accountName : ''}" placeholder="Tên in trên thẻ/tài khoản" required>
                        </div>
                        <div>
                            <label class="woox-label">Chi nhánh</label>
                            <input type="text" name="branch" value="${bankAccount != null ? bankAccount.branch : ''}" placeholder="VD: Chi nhánh Hà Nội">
                        </div>
                    </div>
                    <div class="woox-form-row">
                        <button type="submit" class="btn-woox-primary">Lưu thông tin</button>
                        <span class="border-button" style="margin-left: 12px;"><a href="${ctx}/owner">Quay lại quản lý xe</a></span>
                    </div>
                </form>

                <p style="margin-top: 24px;">
                    <span class="border-button"><a href="${ctx}/owner"><i class="bi bi-arrow-left"></i> Quay lại danh sách xe</a></span>
                </p>
            </div>
        </section>

        <jsp:include page="../layout/footer.jsp"/>
    </body>
</html>
