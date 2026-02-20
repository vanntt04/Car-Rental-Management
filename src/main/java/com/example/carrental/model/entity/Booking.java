/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package com.example.carrental.model.entity;

/**
 *
 * @author PC
 */
import java.util.*;
import java.lang.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
public class Booking {
    int booking_id , car_id , customer_id;
    LocalDate start_date , end_date;
    int Total_price ; 
    String booking_status;
    LocalDateTime created_at;

    public Booking() {
    }

    public Booking(int booking_id, int car_id, int customer_id, LocalDate start_date, LocalDate end_date, int Total_price, String booking_status, LocalDateTime created_at) {
        this.booking_id = booking_id;
        this.car_id = car_id;
        this.customer_id = customer_id;
        this.start_date = start_date;
        this.end_date = end_date;
        this.Total_price = Total_price;
        this.booking_status = booking_status;
        this.created_at = created_at;
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

    public void setEnd_date(LocalDate end_date) {
        this.end_date = end_date;
    }

    public int getTotal_price() {
        return Total_price;
    }

    public void setTotal_price(int Total_price) {
        this.Total_price = Total_price;
    }

    public String getBooking_status() {
        return booking_status;
    }

    public void setBooking_status(String booking_status) {
        this.booking_status = booking_status;
    }

    public LocalDateTime getCreated_at() {
        return created_at;
    }

    public void setCreated_at(LocalDateTime created_at) {
        this.created_at = created_at;
    }
      
}
