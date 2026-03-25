package com.example.carrental.model.entity;

import java.time.LocalDateTime;

/**
 * Entity class tương ứng với bảng car_holds
 */
public class Car_holds {

    private int id;
    private int carId;
    private int userId;
    private LocalDateTime holdUntil;

    // Constructor không tham số
    public Car_holds() {
    }

    // Constructor đầy đủ
    public Car_holds(int id, int carId, int userId, LocalDateTime holdUntil) {
        this.id = id;
        this.carId = carId;
        this.userId = userId;
        this.holdUntil = holdUntil;
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

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public LocalDateTime getHoldUntil() {
        return holdUntil;
    }

    public void setHoldUntil(LocalDateTime holdUntil) {
        this.holdUntil = holdUntil;
    }

    @Override
    public String toString() {
        return "CarHold{"
                + "id=" + id
                + ", carId=" + carId
                + ", userId=" + userId
                + ", holdUntil=" + holdUntil
                + '}';
    }
}
