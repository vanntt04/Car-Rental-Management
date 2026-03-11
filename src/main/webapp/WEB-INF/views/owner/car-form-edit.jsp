<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.carrental.model.entity.Car" %>
<%
    Car car = (Car) request.getAttribute("car");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Car</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/templatemo-customer.css">
    <style>
        .owner-card{max-width:900px;margin:0 auto;background:#fff;border:1px solid #e9eef4;border-radius:16px;padding:18px;box-shadow:0 12px 30px rgba(0,0,0,.06)}
        .grid{display:grid;grid-template-columns:repeat(2,minmax(240px,1fr));gap:12px}
        .field label{display:block;font-weight:600;margin-bottom:6px;color:#334155}
        .field input,.field textarea,.field select{width:100%;padding:10px;border:1px solid #dbe4ee;border-radius:10px}
        .field textarea{min-height:120px}
        .btn-owner{background:#22b3c1;color:#fff;border:none;padding:10px 16px;border-radius:999px;font-weight:600;cursor:pointer}
    </style>
</head>
<body>


<div class="owner-card">
    <h2>Edit Car #<%= car != null ? car.getId() : 0 %></h2>
    <form action="<%= request.getContextPath() %>/owner" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="update"/>
        <input type="hidden" name="id" value="<%= car != null ? car.getId() : 0 %>"/>
        <div class="grid">
            <div class="field"><label>Name</label><input type="text" name="name" value="<%= car != null ? car.getName() : "" %>" required/></div>
            <div class="field"><label>License Plate</label><input type="text" name="licensePlate" value="<%= car != null && car.getLicensePlate()!=null ? car.getLicensePlate() : "" %>" required/></div>
            <div class="field"><label>Brand</label><input type="text" name="brand" value="<%= car != null ? car.getBrand() : "" %>"/></div>
            <div class="field"><label>Model</label><input type="text" name="model" value="<%= car != null ? car.getModel() : "" %>"/></div>
            <div class="field"><label>Year</label><input type="number" name="year" min="1990" max="2100" value="<%= car != null && car.getYear()!=null ? car.getYear() : "" %>"/></div>
            <div class="field"><label>Color</label><input type="text" name="color" value="<%= car != null && car.getColor()!=null ? car.getColor() : "" %>"/></div>
            <div class="field"><label>Price/Day</label><input type="number" name="pricePerDay" min="0" value="<%= car != null ? car.getPricePerDay() : 0 %>"/></div>
            <div class="field"><label>Status</label><select name="status"><option value="AVAILABLE" <%= car!=null && "AVAILABLE".equalsIgnoreCase(car.getStatus()) ? "selected" : "" %>>AVAILABLE</option><option value="RENTED" <%= car!=null && "RENTED".equalsIgnoreCase(car.getStatus()) ? "selected" : "" %>>RENTED</option><option value="MAINTENANCE" <%= car!=null && "MAINTENANCE".equalsIgnoreCase(car.getStatus()) ? "selected" : "" %>>MAINTENANCE</option></select></div>
            <div class="field"><label>Active</label><select name="active"><option value="1" <%= car!=null && car.isActive() ? "selected" : "" %>>Active</option><option value="0" <%= car!=null && !car.isActive() ? "selected" : "" %>>Inactive</option></select></div>
            <div class="field" style="grid-column:1/-1"><label>Description</label><textarea name="description"><%= car != null && car.getDescription() != null ? car.getDescription() : "" %></textarea></div>
            <div class="field" style="grid-column:1/-1"><label>Replace Cover Image</label><input type="file" name="imageFile" accept="image/*"/></div>
        </div>
        <div style="margin-top:14px;display:flex;gap:8px">
            <button class="btn-owner" type="submit">Update</button>
            <a class="btn-owner" style="background:#64748b" href="<%= request.getContextPath() %>/owner">Cancel</a>
        </div>
    </form>
</div>


</body>
</html>
