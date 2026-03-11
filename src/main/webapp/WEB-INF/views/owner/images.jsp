<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.carrental.model.entity.Car" %>
<%@ page import="com.example.carrental.model.entity.CarImage" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Car Images</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/templatemo-customer.css">
    <style>
        .owner-card{background:#fff;border:1px solid #e9eef4;border-radius:16px;padding:18px;box-shadow:0 12px 30px rgba(0,0,0,.06)}
        .row{display:flex;gap:8px;flex-wrap:wrap;margin:12px 0}
        .input{flex:1;min-width:260px;padding:10px;border:1px solid #dbe4ee;border-radius:10px}
        .btn-owner{background:#22b3c1;color:#fff;border:none;padding:10px 14px;border-radius:999px;font-weight:600;cursor:pointer}
        .grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(240px,1fr));gap:14px;margin-top:16px}
        .card{border:1px solid #e6edf5;border-radius:12px;padding:10px;background:#fff}
        .img{width:100%;height:160px;object-fit:cover;border-radius:10px;background:#f5f7fa}
        .meta{margin:8px 0;color:#475569;font-size:14px}
        .btn-small{padding:6px 10px;border:1px solid #dbe4ee;border-radius:8px;background:#fff;cursor:pointer}
        .btn-small:hover{border-color:#22b3c1;color:#22b3c1}
    </style>
</head>
<body>

<%
    Car car = (Car) request.getAttribute("car");
    List<CarImage> images = (List<CarImage>) request.getAttribute("images");
%>

<div class="owner-card">
    <a href="<%= request.getContextPath() %>/owner">&larr; Back</a>
    <h2 style="margin:10px 0 6px">Manage Car Images - <%= car != null ? car.getName() : "" %></h2>

    <div class="row">
        <form action="<%= request.getContextPath() %>/owner" method="post" style="display:flex;gap:8px;flex:1;flex-wrap:wrap">
            <input type="hidden" name="action" value="add-image" />
            <input type="hidden" name="carId" value="<%= car != null ? car.getId() : 0 %>" />
            <input class="input" type="text" name="imageUrl" placeholder="Image URL" required />
            <button class="btn-owner" type="submit">Add URL</button>
        </form>
    </div>

    <div class="row">
        <form action="<%= request.getContextPath() %>/owner" method="post" enctype="multipart/form-data" style="display:flex;gap:8px;flex-wrap:wrap;align-items:center">
            <input type="hidden" name="action" value="add-image-upload" />
            <input type="hidden" name="carId" value="<%= car != null ? car.getId() : 0 %>" />
            <input class="input" type="file" name="imageFile" multiple accept="image/*" />
            <button class="btn-owner" type="submit">Upload</button>
        </form>
    </div>

    <% if (images == null || images.isEmpty()) { %>
        <p>No images yet.</p>
    <% } else { %>
    <div class="grid">
        <% for (CarImage img : images) { %>
        <div class="card">
            <img class="img" src="<%= request.getContextPath() + img.getImageUrl() %>" alt="image" />
            <p class="meta">Primary: <strong><%= img.isPrimary() ? "Yes" : "No" %></strong></p>
            <div style="display:flex;gap:6px;flex-wrap:wrap">
                <form action="<%= request.getContextPath() %>/owner" method="post">
                    <input type="hidden" name="action" value="set-primary-image" />
                    <input type="hidden" name="id" value="<%= img.getId() %>" />
                    <button class="btn-small" type="submit">Set Primary</button>
                </form>
                <form action="<%= request.getContextPath() %>/owner" method="post">
                    <input type="hidden" name="action" value="delete-image" />
                    <input type="hidden" name="id" value="<%= img.getId() %>" />
                    <button class="btn-small" type="submit">Delete</button>
                </form>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>
</div>


</body>
</html>
