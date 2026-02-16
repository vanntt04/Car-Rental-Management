package com.example.carrental.model.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Entity class đại diện cho xe trong hệ thống
 * Model trong mô hình MVC
 */
public class Car {
    private int id;
    private int owner_id;
    private String img;
    private String name;
    private String brand;
    private String model;
    private String local;
    private int pricePerDay;
    private String status; 
    private String des;
    private LocalDateTime createdAt;

    public Car() {
    }

    public Car(int id, int owner_id, String img, String name, String brand, String model, String local,  int pricePerDay, String status, String des, LocalDateTime createdAt) {
        this.id = id;
        this.owner_id = owner_id;
        this.img = img;
        this.name = name;
        this.brand = brand;
        this.model = model;
        this.local = local;
        this.pricePerDay = pricePerDay;
        this.status = status;
        this.des = des;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOwner_id() {
        return owner_id;
    }

    public void setOwner_id(int owner_id) {
        this.owner_id = owner_id;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
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
        return local;
    }

    public void setLocal(String local) {
        this.local = local;
    }

    public int getPricePerDay() {
        return pricePerDay;
    }

    public void setPricePerDay(int pricePerDay) {
        this.pricePerDay = pricePerDay;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDes() {
        return des;
    }

    public void setDes(String des) {
        this.des = des;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

   

   
}

    