package com.example.carrental.model.entity;

import java.time.LocalDate;

/**
 * Entity đại diện cho lịch sẵn có / không sẵn có của xe
 */
public class CarAvailability {
    private int id;
    private int carId;
    private LocalDate startDate;
    private LocalDate endDate;
    private boolean available;
    private String note;

    public CarAvailability() {
    }

    public CarAvailability(int carId, LocalDate startDate, LocalDate endDate, boolean available) {
        this.carId = carId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.available = available;
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

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}
