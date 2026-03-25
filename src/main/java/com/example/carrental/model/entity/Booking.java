
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.example.carrental.model.entity;

/**
 *
 * @author PC
 */
import com.example.carrental.model.dao.CarDAO;
import java.util.*;
import java.lang.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class Booking {

    int booking_id, car_id, customer_id;
    LocalDate start_date, end_date;
    BigDecimal Total_price;
    String booking_status;
    Car car;
    User cus;
    int total_days;

    public Booking() {
    }

    public Booking(int booking_id, int car_id, int customer_id, LocalDate start_date, int total_days, LocalDate end_date, BigDecimal Total_price, String booking_status) {
        this.booking_id = booking_id;
        this.car_id = car_id;
        this.total_days = total_days;
        this.customer_id = customer_id;
        this.start_date = start_date;
        this.end_date = end_date;
        this.Total_price = Total_price;
        this.booking_status = booking_status;
    }

    public int getBooking_id() {
        return booking_id;
    }

    public void setBooking_id(int booking_id) {
        this.booking_id = booking_id;
    }

    public int getCar_id() {
        return car_id;
    }

    public Car getCar() {
        return car;
    }

    public void setCar(Car car) {
        this.car = car;
    }

    public User getCus() {
        return cus;
    }

    public void setCus(User user) {
        this.cus = user;
    }

    public void setCar_id(int car_id) {
        this.car_id = car_id;
    }

    public int getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
    }

    public LocalDate getStart_date() {
        return start_date;
    }

    public void setStart_date(LocalDate start_date) {
        this.start_date = start_date;
    }

    public LocalDate getEnd_date() {
        return end_date;
    }

    public int getTotal_days() {
        return total_days;
    }

    public void setTotal_days(int total_days) {
        this.total_days = total_days;
    }

    public void setEnd_date(LocalDate end_date) {
        this.end_date = end_date;
    }

    public BigDecimal getTotal_price() {
        return Total_price;
    }

    public void setTotal_price(BigDecimal Total_price) {
        this.Total_price = Total_price;
    }

    public String getBooking_status() {
        return booking_status;
    }

    public void setBooking_status(String booking_status) {
        this.booking_status = booking_status;
    }
}
