package com.example.carrental.model.entity;

/**
 * Entity đại diện cho ảnh của xe (1 xe có thể có nhiều ảnh)
 */
public class CarImage {
    private int id;
    private int carId;
    private String imageUrl;
    private boolean primary;
    private int sortOrder;

    public CarImage() {
    }

    public CarImage(int carId, String imageUrl, boolean primary, int sortOrder) {
        this.carId = carId;
        this.imageUrl = imageUrl;
        this.primary = primary;
        this.sortOrder = sortOrder;
    }

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

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isPrimary() {
        return primary;
    }

    public void setPrimary(boolean primary) {
        this.primary = primary;
    }

    public int getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
    }
}
