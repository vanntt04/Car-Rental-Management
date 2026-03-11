<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.carrental.model.entity.Car" %>
<%@ page import="com.example.carrental.model.entity.CarImage" %>
<%@ page import="com.example.carrental.model.entity.CarAvailability" %>
<%@ page import="com.example.carrental.model.entity.Booking" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Car Details</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 24px; }
        .row { display: grid; grid-template-columns: 1.2fr 1fr; gap: 20px; }
        .box { border: 1px solid #ddd; border-radius: 10px; padding: 14px; margin-bottom: 16px; }
        .img-main { width: 100%; height: 320px; object-fit: cover; border-radius: 8px; background: #f5f5f5; }
        .thumbs { display: flex; gap: 8px; flex-wrap: wrap; margin-top: 8px; }
        .thumb { width: 100px; height: 70px; object-fit: cover; border-radius: 6px; border: 1px solid #ddd; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border-bottom: 1px solid #eee; padding: 8px; text-align: left; }
        .muted { color: #666; }
    </style>
</head>
<body>

<%
    Car car = (Car) request.getAttribute("car");
    List<CarImage> images = (List<CarImage>) request.getAttribute("carImages");
    List<CarAvailability> availabilities = (List<CarAvailability>) request.getAttribute("carAvailabilities");
    List<Booking> bookings = (List<Booking>) request.getAttribute("carBookings");
    String mainImage = (car != null && car.getImg() != null) ? car.getImg() : null;
    if ((mainImage == null || mainImage.isEmpty()) && images != null && !images.isEmpty()) {
        mainImage = images.get(0).getImageUrl();
    }
%>
<a href="<%= request.getContextPath() %>/cars">&larr; Back to listings</a>
<h2>Car Details</h2>

<% if (car == null) { %>
    <p class="muted">Không tìm thấy xe.</p>
<% } else { %>
<div class="row">
    <div>
        <div class="box">
            <img class="img-main" src="<%= mainImage != null ? (request.getContextPath() + mainImage) : "https://via.placeholder.com/900x600?text=No+Image" %>" alt="car">
            <% if (images != null && !images.isEmpty()) { %>
                <div class="thumbs">
                    <% for (CarImage img : images) { %>
                        <img class="thumb" src="<%= request.getContextPath() + img.getImageUrl() %>" alt="img">
                    <% } %>
                </div>
            <% } %>
        </div>

        <div class="box">
            <h3><%= car.getName() %></h3>
            <p><strong>Brand/Model:</strong> <%= car.getBrand() %> - <%= car.getModel() %></p>
            <p><strong>Location:</strong> <%= car.getLocal() %></p>
            <p><strong>Status:</strong> <%= car.getStatus() %></p>
            <p><strong>Price:</strong> <%= car.getPricePerDay() %> VND/day</p>
            <p><strong>Description:</strong> <%= car.getDes() != null ? car.getDes() : "-" %></p>
        </div>
    </div>

    <div>
        <div class="box">
            <h4>Availability</h4>
            <% if (availabilities == null || availabilities.isEmpty()) { %>
                <p class="muted">No availability data.</p>
            <% } else { %>
                <table>
                    <tr><th>Start</th><th>End</th><th>Available</th><th>Note</th></tr>
                    <% for (CarAvailability av : availabilities) { %>
                        <tr>
                            <td><%= av.getStartDate() %></td>
                            <td><%= av.getEndDate() %></td>
                            <td><%= av.isAvailable() ? "Yes" : "No" %></td>
                            <td><%= av.getNote() != null ? av.getNote() : "" %></td>
                        </tr>
                    <% } %>
                </table>
            <% } %>
        </div>

        <div class="box">
            <h4>Bookings</h4>
            <% if (bookings == null || bookings.isEmpty()) { %>
                <p class="muted">No booking data.</p>
            <% } else { %>
                <table>
                    <tr><th>Customer</th><th>Start</th><th>End</th><th>Status</th></tr>
                    <% for (Booking b : bookings) { %>
                        <tr>
                            <td><%= b.getCustomerName() != null ? b.getCustomerName() : ("#" + b.getCustomerId()) %></td>
                            <td><%= b.getStartDate() %></td>
                            <td><%= b.getEndDate() %></td>
                            <td><%= b.getBookingStatus() %></td>
                        </tr>
                    <% } %>
                </table>
            <% } %>
        </div>
    </div>
</div>
<% } %>
</body>
</html>
