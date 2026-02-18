<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý yêu cầu đặt xe</title>

        <style>
            body{
                font-family: system-ui, sans-serif;
                background:#f3f4f6;
                padding:30px;
            }

            h2{
                margin-bottom:20px;
            }

            table{
                width:100%;
                border-collapse:collapse;
                background:white;
                border-radius:10px;
                overflow:hidden;
                box-shadow:0 4px 12px rgba(0,0,0,0.1);
            }

            th, td{
                padding:12px;
                text-align:center;
                border-bottom:1px solid #eee;
            }

            th{
                background:#111827;
                color:white;
            }

            .btn{
                padding:6px 12px;
                border:none;
                border-radius:6px;
                cursor:pointer;
                font-weight:600;
            }

            .accept{
                background:#10b981;
                color:white;
            }

            .reject{
                background:#ef4444;
                color:white;
            }

            .status-pending{
                color:#f59e0b;
                font-weight:bold;
            }

            .status-accepted{
                color:#10b981;
                font-weight:bold;
            }

            .status-rejected{
                color:#ef4444;
                font-weight:bold;
            }

        </style>
    </head>

    <body>

        <h2>Danh sách yêu cầu đặt xe</h2>

        <table>
            <tr>
                <th>Khách hàng</th>
                <th>Xe</th>
                <th>Ngày nhận</th>
                <th>Ngày trả</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
            <c:choose>
                <c:when test="${not empty user}">
                    <c:forEach var="booking" items="${bookingList}">
                        <tr>
                            <td>${booking.customerName}</td>
                            <td>${booking.carName}</td>
                            <td>${booking.startDate}</td>
                            <td>${booking.endDate}</td>

                            <td>
                                <span class="status-${booking.status.toLowerCase()}">
                                    ${booking.status}
                                </span>
                            </td>

                            <td>
                                <c:if test="${booking.status == 'PENDING'}">

                                    <form action="${pageContext.request.contextPath}/bookingAction" method="post" style="display:inline;">
                                        <input type="hidden" name="bookingId" value="${booking.id}">
                                        <input type="hidden" name="action" value="accept">
                                        <button class="btn accept">Accept</button>
                                    </form>

                                    <form action="${pageContext.request.contextPath}/bookingAction" method="post" style="display:inline;">
                                        <input type="hidden" name="bookingId" value="${booking.id}">
                                        <input type="hidden" name="action" value="reject">
                                        <button class="btn reject">Reject</button>
                                    </form>

                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <c:if test="${not empty error}">
                        <div style="color:red; font-weight:600; padding:10px 32px;">
                            ${error}
                        </div>
                    </c:if>
                </c:otherwise>
            </c:choose>

        </table>

    </body>
</html>
