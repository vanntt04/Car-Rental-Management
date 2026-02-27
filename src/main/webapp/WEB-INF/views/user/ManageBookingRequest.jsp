<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý yêu cầu đặt xe</title>

        <style>
            *{
                margin:0;
                padding:0;
                box-sizing:border-box;
            }

            body{
                font-family: 'Segoe UI', sans-serif;
                background:#f8fafc;
            }

            /* Header */
            .header{
                background:#111827;
                color:white;
                padding:18px 40px;
                font-size:20px;
                font-weight:600;
            }

            /* Container */
            .container{
                padding:40px;
            }

            .card{
                background:white;
                border-radius:12px;
                padding:25px;
                box-shadow:0 6px 20px rgba(0,0,0,0.08);
            }

            .card h2{
                margin-bottom:20px;
                font-size:22px;
            }

            table{
                width:100%;
                border-collapse:collapse;
            }

            th{
                background:#f1f5f9;
                padding:14px;
                text-align:left;
                font-size:14px;
                color:#475569;
                border-bottom:2px solid #e2e8f0;
            }

            td{
                padding:14px;
                border-bottom:1px solid #e2e8f0;
                font-size:14px;
                color:#334155;
            }

            tr:hover{
                background:#f9fafb;
            }

            /* Badge trạng thái */
            .badge{
                padding:6px 12px;
                border-radius:20px;
                font-size:12px;
                font-weight:600;
                display:inline-block;
            }

            .pending{
                background:#fef3c7;
                color:#b45309;
            }

            .accepted{
                background:#dcfce7;
                color:#166534;
            }

            .rejected{
                background:#fee2e2;
                color:#991b1b;
            }

            /* Buttons */
            .btn{
                padding:6px 14px;
                border:none;
                border-radius:6px;
                font-size:13px;
                cursor:pointer;
                font-weight:600;
                transition:0.2s;
            }

            .accept{
                background:#10b981;
                color:white;
            }

            .accept:hover{
                background:#059669;
            }

            .reject{
                background:#ef4444;
                color:white;
            }

            .reject:hover{
                background:#dc2626;
            }

            .error-box{
                background:#fee2e2;
                color:#991b1b;
                padding:12px;
                border-radius:6px;
                margin-bottom:20px;
                font-weight:600;
            }
            .header {
                background-color: #1e3a8a; /* xanh đậm */
                color: white;
                padding: 15px 20px;
                font-size: 20px;
                font-weight: bold;
                display: flex;
                align-items: center;
                justify-content: space-between; /* để Home nút ra bên phải */
                border-radius: 8px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            }

            .btn-home {
                background-color: #facc15; /* vàng nổi bật */
                color: #1e3a8a;
                text-decoration: none;
                padding: 8px 16px;
                border-radius: 6px;
                font-weight: bold;
                transition: all 0.3s ease;
            }

            .btn-home:hover {
                background-color: #fde68a; /* sáng hơn khi hover */
                color: #1e3a8a;
                transform: translateY(-2px);
                box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            }
        </style>
    </head>

    <body>

        <div class="header">
            🚗 Admin Dashboard - Quản lý yêu cầu đặt xe
            <a href="${pageContext.request.contextPath}/home" class="btn-home">🏠 Home</a>
        </div>
        <div class="container">
            <div class="card">
                <h2>Danh sách yêu cầu đặt xe</h2>

                <c:if test="${not empty error}">
                    <div class="error-box">
                        ${error}
                    </div>
                </c:if>

                <table>
                    <tr>
                        <th>Khách hàng</th>
                        <th>Xe</th>
                        <th>Ngày nhận</th>
                        <th>Ngày trả</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>

                    <c:forEach var="book" items="${bookingList}">
                        <tr>
                            <td>
                                Name: ${book.cus.fullName}<br>
                                Phone: ${book.cus.phone}<br>
                            </td>
                            <td>
                                Name: ${book.car.brand}_${book.car.name}<br>
                                Price/Day: ${book.car.pricePerDay}
                            </td>
                            <td>${book.start_date}</td>
                            <td>${book.end_date}</td>

                            <td>
                                <span class="badge ${book.booking_status.toLowerCase()}">
                                    ${book.booking_status}
                                </span>
                            </td>

                            <td>
                                <c:if test="${book.booking_status == 'PENDING'}">

                                    <form action="${pageContext.request.contextPath}/listbooking" method="post" style="display:inline;">
                                        <input type="hidden" name="bookingId" value="${book.booking_id}">
                                        <input type="hidden" name="action" value="accept">
                                        <button class="btn accept">Accept</button>
                                    </form>

                                    <form action="${pageContext.request.contextPath}/listbooking" method="post" style="display:inline;">
                                        <input type="hidden" name="bookingId" value="${book.booking_id}">
                                        <input type="hidden" name="action" value="reject">
                                        <button class="btn reject">Reject</button>
                                    </form>

                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </div>

    </body>
</html>