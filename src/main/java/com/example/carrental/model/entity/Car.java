package com.example.carrental.model.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Entity Car gộp tương thích cho cả code cũ và mới.
 */
public class Car {

    private int id;
    private Integer ownerId;
    private String imageUrl;
    private String name;
    private String brand;
    private String model;
    private String location;
    private int pricePerDay;
    private String status;
    private String description;
    private LocalDateTime createdAt;

    // Optional fields cho các màn hình/flow mới
    private String licensePlate;
    private Integer year;
    private String color;
    private boolean active = true;

    public Car() {
    }

    public Car(int id, Integer ownerId, String imageUrl, String name, String brand, String model,
            String location, int pricePerDay, String status, String description, LocalDateTime createdAt) {
        this.id = id;
        this.ownerId = ownerId;
        this.imageUrl = imageUrl;
        this.name = name;
        this.brand = brand;
        this.model = model;
        this.location = location;
        this.pricePerDay = pricePerDay;
        this.status = status;
        this.description = description;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Integer getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(Integer ownerId) {
        this.ownerId = ownerId;
    }

    // Tương thích code cũ snake_case
    public int getOwner_id() {
        return ownerId == null ? 0 : ownerId;
    }

    public void setOwner_id(int owner_id) {
        this.ownerId = owner_id;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    // Tương thích code cũ
    public String getImg() {
        return imageUrl;
    }

    public void setImg(String img) {
        this.imageUrl = img;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public String getLocal() {
        return location;
    }

    public void setLocal(String local) {
        this.location = local;
    }

    public int getPricePerDay() {
        return pricePerDay;
    }

    public void setPricePerDay(int pricePerDay) {
        this.pricePerDay = pricePerDay;
    }

    public void setPricePerDay(BigDecimal pricePerDay) {
        this.pricePerDay = pricePerDay == null ? 0 : pricePerDay.intValue();
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    // Tương thích code cũ
    public String getDes() {
        return description;
    }

    public void setDes(String des) {
        this.description = des;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
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

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
