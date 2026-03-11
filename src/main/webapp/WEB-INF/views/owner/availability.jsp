<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.carrental.model.entity.Car" %>
<%@ page import="com.example.carrental.model.entity.Booking" %>
<%
    Car car = (Car) request.getAttribute("car");
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bookings</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/templatemo-customer.css">
    <style>
        .owner-card{background:#fff;border:1px solid #e9eef4;border-radius:16px;padding:18px;box-shadow:0 12px 30px rgba(0,0,0,.06)}
        .owner-table{width:100%;border-collapse:collapse;font-size:14px}
        .owner-table th,.owner-table td{padding:12px 10px;border-bottom:1px solid #edf2f7;text-align:left}
        .owner-table th{background:#f8fbfd;color:#0f6f79}
        .chip{padding:4px 10px;border-radius:999px;background:#eef2ff;color:#3730a3;font-weight:600;font-size:12px}
    </style>
</head>
<body>


<div class="owner-card">
    <a href="<%= request.getContextPath() %>/owner">&larr; Back</a>
    <h2 style="margin:8px 0 14px">Bookings - <%= car != null ? car.getName() : "" %></h2>

    <% if (bookings == null || bookings.isEmpty()) { %>
    <p>No bookings.</p>
    <% } else { %>
    <table class="owner-table">
        <tr><th>ID</th><th>Customer</th><th>Start</th><th>End</th><th>Status</th></tr>
        <% for (Booking b : bookings) { %>
        <tr>
            <td><%= b.getId() %></td>
            <td><%= b.getCustomerName() != null ? b.getCustomerName() : ("#" + b.getCustomerId()) %></td>
            <td><%= b.getStartDate() %></td>
            <td><%= b.getEndDate() %></td>
            <td><span class="chip"><%= b.getBookingStatus() %></span></td>
        </tr>
        <% } %>
    </table>
    <% } %>
</div>

</body>
</html>
