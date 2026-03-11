<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.carrental.model.entity.Car" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Car Listings</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 24px; }
        .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 16px; }
        .card { border: 1px solid #ddd; border-radius: 10px; padding: 12px; }
        .img { width: 100%; height: 160px; object-fit: cover; border-radius: 8px; background: #f5f5f5; }
        .muted { color: #666; font-size: 14px; }
        .btn { display: inline-block; padding: 8px 12px; border-radius: 8px; text-decoration: none; background: #1f6feb; color: #fff; }
    </style>
</head>
<body>

<h2>Available Cars</h2>
<%
    List<Car> cars = (List<Car>) request.getAttribute("cars");
    if (cars == null || cars.isEmpty()) {
%>
    <p class="muted">Không có xe nào để hiển thị.</p>
<%
    } else {
%>
    <div class="grid">
    <% for (Car c : cars) { %>
        <div class="card">
            <img class="img" src="<%= c.getImg() != null ? (request.getContextPath() + c.getImg()) : "https://via.placeholder.com/600x400?text=No+Image" %>" alt="car">
            <h3><%= c.getName() != null ? c.getName() : "Unnamed Car" %></h3>
            <p class="muted"><%= c.getBrand() %> - <%= c.getModel() %></p>
            <p><strong><%= c.getPricePerDay() %> VND/day</strong></p>
            <a class="btn" href="<%= request.getContextPath() %>/cars?id=<%= c.getId() %>">View details</a>
        </div>
    <% } %>
    </div>
<%
    }
%>

</body>
</html>
