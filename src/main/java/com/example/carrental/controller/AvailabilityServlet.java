package com.example.carrental.controller;

import com.example.carrental.model.dao.CarAvailabilityDAO;
import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.dao.BookingDAO;
import com.example.carrental.model.entity.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/owner/availability/*")
public class AvailabilityServlet extends HttpServlet {

    private CarDAO carDAO;
    private CarAvailabilityDAO availabilityDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() {
        carDAO = new CarDAO();
        availabilityDAO = new CarAvailabilityDAO();
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int carId = Integer.parseInt(request.getPathInfo().substring(1));

        Car car = carDAO.getCarById(carId);

        List<CarAvailability> list = availabilityDAO.getByCarId(carId);

        List<Booking> bookings = bookingDAO.getByCarId(carId, "all");

        request.setAttribute("car", car);
        request.setAttribute("availabilities", list);
        request.setAttribute("bookings", bookings);

        request.getRequestDispatcher("/WEB-INF/views/owner/availability.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addAvailability(request, response);
        } else if ("delete".equals(action)) {
            deleteAvailability(request, response);
        }
    }

    private void addAvailability(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int carId = Integer.parseInt(request.getParameter("carId"));

        CarAvailability av = new CarAvailability();

        av.setCarId(carId);
        av.setStartDate(LocalDate.parse(request.getParameter("startDate")));
        av.setEndDate(LocalDate.parse(request.getParameter("endDate")));
        av.setAvailable(true);
        av.setNote(request.getParameter("note"));

        availabilityDAO.add(av);

        response.sendRedirect(request.getContextPath() + "/owner/availability/" + carId);
    }

    private void deleteAvailability(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        CarAvailability av = availabilityDAO.getById(id);

        availabilityDAO.delete(id);

        response.sendRedirect(request.getContextPath() + "/owner/availability/" + av.getCarId());
    }
}