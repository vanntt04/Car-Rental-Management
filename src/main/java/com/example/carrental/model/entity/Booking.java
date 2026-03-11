package com.example.carrental.model.entity;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Entity đại diện cho đơn đặt xe (booking).
 */
public class Booking {

    private int id;
    private int carId;
    private int customerId;

    // Các đối tượng liên kết (Dùng để hiển thị thông tin chi tiết xe và khách hàng)
    private Car car;
    private User customer;

    private String customerName; // Có thể giữ nếu không muốn join bảng User liên tục
    private LocalDate startDate;
    private LocalDate endDate;
    private int totalDays;
    private BigDecimal totalPrice;
    private String bookingStatus; // PENDING, APPROVED, REJECTED, CANCELLED, COMPLETED
    private LocalDateTime createdAt;

    // Constructor không tham số
    public Booking() {
    }

    // Constructor đầy đủ tham số
    public Booking(int id, int carId, int customerId, LocalDate startDate, LocalDate endDate,
            BigDecimal totalPrice, String bookingStatus, LocalDateTime createdAt) {
        this.id = id;
        this.carId = carId;
        this.customerId = customerId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.totalPrice = totalPrice;
        this.bookingStatus = bookingStatus;
        this.createdAt = createdAt;
    }

    // Getter và Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCarId() {
        return carId;
    }

    public void setCarId(int carId) {
        this.carId = carId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public Car getCar() {
        return car;
    }

    public void setCar(Car car) {
        this.car = car;
    }

    public User getCustomer() {
        return customer;
    }

    public void setCustomer(User customer) {
        this.customer = customer;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public int getTotalDays() {
        return totalDays;
    }

    public void setTotalDays(int totalDays) {
        this.totalDays = totalDays;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getBookingStatus() {
        return bookingStatus;
    }

    public void setBookingStatus(String bookingStatus) {
        this.bookingStatus = bookingStatus;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
