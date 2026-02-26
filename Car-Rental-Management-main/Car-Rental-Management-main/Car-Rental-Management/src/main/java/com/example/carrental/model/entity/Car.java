package com.example.carrental.model.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Entity class đại diện cho xe trong hệ thống
 * Model trong mô hình MVC
 */
public class Car {
    private int id;
    private String name;
    private String licensePlate;
    private String brand;
    private String model;
    private Integer year;
    private String color;
    private BigDecimal pricePerDay;
    private String status; // AVAILABLE, RENTED, MAINTENANCE
    private String imageUrl;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public Car() {
    }

    public Car(String name, String licensePlate, String brand, String model, 
               Integer year, String color, BigDecimal pricePerDay, String status) {
        this.name = name;
        this.licensePlate = licensePlate;
        this.brand = brand;
        this.model = model;
        this.year = year;
        this.color = color;
        this.pricePerDay = pricePerDay;
        this.status = status;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public Integer getYear() {
        return year;
    }

    public void setYear(Integer year) {
        this.year = year;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public BigDecimal getPricePerDay() {
        return pricePerDay;
    }

    public void setPricePerDay(BigDecimal pricePerDay) {
        this.pricePerDay = pricePerDay;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Car{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", licensePlate='" + licensePlate + '\'' +
                ", brand='" + brand + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
