package com.example.carrental.model.entity;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Entity đại diện cho đơn đặt xe (booking).
 */
public class Booking {
    private int id;
    private int carId;
    private int customerId;
    private String customerName;
    private LocalDate startDate;
    private LocalDate endDate;
    private int totalDays;
    private BigDecimal totalPrice;
    private String bookingStatus; // PENDING, APPROVED, REJECTED, CANCELLED, COMPLETED

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getCarId() { return carId; }
    public void setCarId(int carId) { this.carId = carId; }
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }
    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }
    public int getTotalDays() { return totalDays; }
    public void setTotalDays(int totalDays) { this.totalDays = totalDays; }
    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }
    public String getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }
}
