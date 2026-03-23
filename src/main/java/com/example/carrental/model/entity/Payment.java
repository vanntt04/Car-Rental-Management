package com.example.carrental.model.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Payment {
    private int id;
    private int bookingId;
    private BigDecimal amount;
    private String paymentMethod; // CASH, BANK_TRANSFER, MOMO, VNPAY, PAYPAL
    private String paymentStatus; // UNPAID, PAID, REFUNDED
    private LocalDateTime paidAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    public LocalDateTime getPaidAt() { return paidAt; }
    public void setPaidAt(LocalDateTime paidAt) { this.paidAt = paidAt; }
}

