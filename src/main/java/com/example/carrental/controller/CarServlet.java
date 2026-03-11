package com.example.carrental.controller;

import com.example.carrental.model.dao.BookingDAO;
import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.dao.CarImageDAO;
import com.example.carrental.model.entity.Car;
import com.example.carrental.model.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CarServlet", urlPatterns = {"/cars"})
public class CarServlet extends HttpServlet {
    private CarDAO carDAO;
    private CarImageDAO carImageDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        carDAO = new CarDAO();
        carImageDAO = new CarImageDAO();
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int carId = Integer.parseInt(idParam.trim());
                showCarDetail(request, response, carId);
            } catch (NumberFormatException e) {
                response.sendRedirect("cars");
            }
        } else {
            showCarList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createCar(request, response);
        } else if ("update".equals(action)) {
            updateCar(request, response);
        } else {
            response.sendRedirect("cars");
        }
    }

    private void showCarList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Car> cars = carDAO.getActiveCars();
        request.setAttribute("cars", cars);
        request.getRequestDispatcher("/WEB-INF/views/car/list.jsp").forward(request, response);
    }

    private void showCarDetail(HttpServletRequest request, HttpServletResponse response, int carId)
            throws ServletException, IOException {
        Car car = carDAO.getCarById(carId);

        if (car == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy xe");
            return;
        }

        if (!car.isActive()) {
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;
            boolean canView = user != null && (car.getOwnerId() != null && car.getOwnerId().equals(user.getId()));

            if (!canView) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem xe này");
                return;
            }
        }

        request.setAttribute("car", car);
        request.setAttribute("carImages", carImageDAO.getByCarId(carId));
        request.setAttribute("carBookings", bookingDAO.getByCarId(carId, "all"));

        request.getRequestDispatcher("/WEB-INF/views/car/detail.jsp").forward(request, response);
    }

    private void createCar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Car car = mapRequestToCar(request);
            if (carDAO.addCar(car)) {
                response.sendRedirect("cars?success=created");
            } else {
                response.sendRedirect("cars?error=failed");
            }
        } catch (Exception e) {
            response.sendRedirect("cars?error=" + e.getMessage());
        }
    }

    private void updateCar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int carId = Integer.parseInt(request.getParameter("id"));
        try {
            Car car = carDAO.getCarById(carId);
            if (car != null) {
                updateCarData(car, request);
                if (carDAO.updateCar(car)) {
                    response.sendRedirect("cars?id=" + carId + "&success=updated");
                } else {
                    response.sendRedirect("cars?id=" + carId + "&error=update_failed");
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            response.sendRedirect("cars?id=" + carId + "&error=" + e.getMessage());
        }
    }

    private Car mapRequestToCar(HttpServletRequest request) {
        Car car = new Car();
        updateCarData(car, request);
        return car;
    }

    private void updateCarData(Car car, HttpServletRequest request) {
        car.setName(request.getParameter("name"));
        car.setBrand(request.getParameter("brand"));
        car.setModel(request.getParameter("model"));

        String yearStr = request.getParameter("year");
        if (yearStr != null && !yearStr.isEmpty()) car.setYear(Integer.parseInt(yearStr));

        String priceStr = request.getParameter("pricePerDay");
        if (priceStr != null && !priceStr.isEmpty()) car.setPricePerDay(Integer.parseInt(priceStr));

        car.setStatus(request.getParameter("status") != null ? request.getParameter("status") : "AVAILABLE");
    }
}
