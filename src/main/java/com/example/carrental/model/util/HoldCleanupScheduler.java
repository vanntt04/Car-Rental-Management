/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.example.carrental.model.util;

/**
 *
 * @author PC
 */
import com.example.carrental.model.dao.CarDAO;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class HoldCleanupScheduler {

    private static final ScheduledExecutorService scheduler
            = Executors.newSingleThreadScheduledExecutor();

    public static void start() {

        scheduler.scheduleAtFixedRate(() -> {
            System.out.println("Running expired hold cleanup...");
            new CarDAO().releaseExpiredHolds();
        }, 0, 1, TimeUnit.MINUTES); // mỗi 1 phút

    }
}
