<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.carrental.model.entity.Car" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Car Listings</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/templatemo-customer.css">
    <style>
        .owner-card{background:#fff;border:1px solid #e9eef4;border-radius:16px;padding:18px;box-shadow:0 12px 30px rgba(0,0,0,.06)}
        .owner-top{display:flex;justify-content:space-between;align-items:center;gap:10px;flex-wrap:wrap;margin-bottom:14px}
        .owner-title{margin:0;color:#1f2937}
        .btn-owner{display:inline-block;background:#22b3c1;color:#fff;padding:10px 14px;border-radius:999px;font-weight:600}
        .owner-table{width:100%;border-collapse:collapse;font-size:14px}
        .owner-table th,.owner-table td{padding:12px 10px;border-bottom:1px solid #edf2f7;text-align:left}
        .owner-table th{background:#f8fbfd;color:#0f6f79}
        .chip{padding:4px 10px;border-radius:999px;background:#e6fffa;color:#0f766e;font-weight:600;font-size:12px}
        .actions{display:flex;gap:6px;flex-wrap:wrap}
        .actions a{padding:6px 10px;border:1px solid #dbe4ee;border-radius:8px;color:#334155;background:#fff}
        .actions a:hover{border-color:#22b3c1;color:#22b3c1}
    </style>
</head>
<body>


<div class="owner-card">
    <div class="owner-top">
        <h2 class="owner-title">Manage Car Listings</h2>
        <a class="btn-owner" href="<%= request.getContextPath() %>/owner/new">+ Add New Car</a>
    </div>

    <%
        List<Car> cars = (List<Car>) request.getAttribute("cars");
        if (cars == null || cars.isEmpty()) {
    %>
        <p>Chưa có xe nào.</p>
    <%
        } else {
    %>
    <table class="owner-table">
        <tr>
            <th>ID</th><th>Name</th><th>Brand</th><th>Model</th><th>Price/day</th><th>Status</th><th>Actions</th>
        </tr>
        <% for (Car c : cars) { %>
        <tr>
            <td><%= c.getId() %></td>
            <td><strong><%= c.getName() %></strong></td>
            <td><%= c.getBrand() %></td>
            <td><%= c.getModel() %></td>
            <td><%= c.getPricePerDay() %></td>
            <td><span class="chip"><%= c.getStatus() %></span></td>
            <td>
                <div class="actions">
                    <a href="<%= request.getContextPath() %>/owner/edit/<%= c.getId() %>">Edit</a>
                    <a href="<%= request.getContextPath() %>/owner/images/<%= c.getId() %>">Images</a>
                    <a href="<%= request.getContextPath() %>/owner/bookings/<%= c.getId() %>">Bookings</a>
                    <a href="<%= request.getContextPath() %>/cars?id=<%= c.getId() %>">View</a>
                </div>
            </td>
        </tr>
        <% } %>
    </table>
    <% } %>
</div>

</body>
</html>
