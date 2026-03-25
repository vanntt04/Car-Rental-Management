/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.example.carrental.controller;

import com.example.carrental.model.dao.BookingDAO;
import com.example.carrental.model.dao.CarAvailabilityDAO;
import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.entity.Car;
import com.example.carrental.model.util.HoldCleanupScheduler;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author PC
 */
@WebServlet(name = "SearchCarServlet", urlPatterns = "/searchcar")
public class SearchCarServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SearchCarServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SearchCarServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu home.jsp gửi start/end (datetime-local), ta lọc theo availability theo khoảng ngày.
        String startStr = request.getParameter("start");
        String endStr = request.getParameter("end");

        CarDAO carDAO = new CarDAO();
        CarAvailabilityDAO availabilityDAO = new CarAvailabilityDAO();
        BookingDAO bookingDAO = new BookingDAO();

        LocalDate pickupTime = null;
        LocalDate returnTime = null;
        try {
            if (startStr != null && !startStr.isEmpty()) {
                String v = startStr;
                if (v.contains("T")) v = v.substring(0, v.indexOf('T'));
                pickupTime = LocalDate.parse(v);
            }
            if (endStr != null && !endStr.isEmpty()) {
                String v = endStr;
                if (v.contains("T")) v = v.substring(0, v.indexOf('T'));
                returnTime = LocalDate.parse(v);
            }
        } catch (Exception ignored) {
        }

        List<Car> resultList = new ArrayList<>();
        String error = null;

        if (pickupTime != null && returnTime != null && !returnTime.isBefore(pickupTime)) {
            List<Car> candidates = carDAO.getAllCars();
            for (Car car : candidates) {
                if (car == null) continue;
                if (car.getStatus() != null && !"AVAILABLE".equalsIgnoreCase(car.getStatus())) {
                    continue;
                }

                boolean available = availabilityDAO.isCarAvailableForRange(car.getId(), pickupTime, returnTime);
                if (!available) continue;

                boolean hasConflict = bookingDAO.hasOverlappingBooking(car.getId(), pickupTime, returnTime);
                if (hasConflict) continue;

                resultList.add(car);
            }
            if (resultList.isEmpty()) {
                error = "Không tìm thấy kết quả phù hợp";
            }
        } else {
            // Trường hợp chưa có start/end: hiển thị danh sách xe hiện có
            List<Car> list = carDAO.getAllCars();
            for (Car c : list) {
                if (c != null && (c.getStatus() == null || !"RENTED".equalsIgnoreCase(c.getStatus()))) {
                    resultList.add(c);
                }
            }
        }

        request.setAttribute("error", error);
        request.setAttribute("CarList", resultList);
        request.setAttribute("pickupTime", pickupTime);
        request.setAttribute("returnTime", returnTime);

        HoldCleanupScheduler.start();
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/car/SearchCar.jsp");
        dispatcher.forward(request, response);

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String pickupStr = request.getParameter("pickupTime");
        LocalDate pickupTime = null;
        try {
            if (pickupStr != null && !pickupStr.isEmpty()) {
                String v = pickupStr;
                if (v.contains("T")) v = v.substring(0, v.indexOf('T'));
                pickupTime = LocalDate.parse(v);
            }
        } catch (Exception e) {
            System.out.println("pickupTime null hoặc sai định dạng, bỏ qua");
        }
        String returnStr = request.getParameter("returnTime");
        LocalDate returnTime = null;
        try {
            if (returnStr != null && !returnStr.isEmpty()) {
                String v = returnStr;
                if (v.contains("T")) v = v.substring(0, v.indexOf('T'));
                returnTime = LocalDate.parse(v);
            }
        } catch (Exception e) {
            System.out.println("returnTime null hoặc sai định dạng, bỏ qua");
        }
        String error = null;
        if (pickupTime == null || returnTime == null) {
            error = "Vui lòng nhập đủ ngày nhận và trả xe";
        } else if (returnTime.isBefore(pickupTime)) {
            error = "Ngày trả xe phải sau ngày nhận";
        }
        CarDAO carDAO = new CarDAO();
        CarAvailabilityDAO availabilityDAO = new CarAvailabilityDAO();
        BookingDAO bookingDAO = new BookingDAO();

        List<Car> resultList = new ArrayList<>();

        Integer seatRequested = null;
        String seat = request.getParameter("seat");
        try {
            if (seat != null && !seat.isEmpty()) {
                seatRequested = Integer.parseInt(seat);
            }
        } catch (Exception ignored) {
        }

        if (error == null) {
            // Lọc theo khoảng ngày người dùng nhập:
            // 1) phải có car_availability.is_available = 1 bao phủ toàn bộ khoảng
            // 2) không bị booking trùng (PENDING/APPROVED)
            List<Car> candidates = carDAO.getAllCars();
            for (Car car : candidates) {
                if (car == null) continue;
                if (car.getStatus() != null && !"AVAILABLE".equalsIgnoreCase(car.getStatus())) {
                    continue;
                }
                Integer carSeats = car.getSeats();
                if (seatRequested != null) {
                    if (carSeats == null || carSeats < seatRequested) continue;
                }

                boolean available = availabilityDAO.isCarAvailableForRange(car.getId(), pickupTime, returnTime);
                if (!available) continue;

                boolean hasConflict = bookingDAO.hasOverlappingBooking(car.getId(), pickupTime, returnTime);
                if (hasConflict) continue;

                resultList.add(car);
            }

            if (resultList.isEmpty()) {
                error = "Không tìm thấy kết quả phù hợp";
            }
        } else {
            // Nếu nhập sai ngày thì trả về danh sách xe hiện có (giữ UX như code cũ)
            resultList = carDAO.getAllCars();
        }

        request.setAttribute("error", error);
        request.setAttribute("CarList", resultList);  // CHỈ DÙNG 1 BIẾN
        request.setAttribute("error", error);
        request.setAttribute("pickupTime", pickupTime);
        request.setAttribute("returnTime", returnTime);
        request.setAttribute("CarList", resultList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/car/SearchCar.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
