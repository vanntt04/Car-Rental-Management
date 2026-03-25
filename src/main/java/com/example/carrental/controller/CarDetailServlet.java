package com.example.carrental.controller;

import com.example.carrental.model.dao.BookingDAO;
import com.example.carrental.model.dao.CarAvailabilityDAO;
import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.dao.CarImageDAO;
import com.example.carrental.model.entity.Booking;
import com.example.carrental.model.entity.Car;
import com.example.carrental.model.entity.CarAvailability;
import com.example.carrental.model.entity.CarImage;
import com.example.carrental.model.entity.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Servlet hiển thị chi tiết xe cho khách hàng.
 * URL: /cars?id={carId} - Xem chi tiết xe
 * URL: /cars - Redirect về danh sách xe
 */
@WebServlet(name = "CarDetailServlet", urlPatterns = "/cars")
public class CarDetailServlet extends HttpServlet {

    private CarDAO carDAO;
    private CarImageDAO carImageDAO;
    private CarAvailabilityDAO availabilityDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() {
        carDAO = new CarDAO();
        carImageDAO = new CarImageDAO();
        availabilityDAO = new CarAvailabilityDAO();
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/searchcar");
            return;
        }
        int carId;
        try {
            carId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/searchcar");
            return;
        }
        showCarDetail(request, response, carId);
    }

    private void showCarDetail(HttpServletRequest request, HttpServletResponse response, int carId)
            throws ServletException, IOException {
        Car car = carDAO.getCarById(carId);
        if (car == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy xe");
            return;
        }
        if (!"AVAILABLE".equals(car.getStatus())) {
            HttpSession session = request.getSession(false);
            User user = session != null ? (User) session.getAttribute("user") : null;
            boolean canView = user != null && ("ADMIN".equals(user.getRole())
                    || (car.getOwnerId() != null && car.getOwnerId().equals(user.getId())));
            if (!canView) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy xe");
                return;
            }
        }
        List<CarImage> carImages = carImageDAO.getByCarId(carId);
        List<CarAvailability> carAvailabilities = availabilityDAO.getByCarId(carId);
        List<Booking> carBookings = bookingDAO.getByCarId(carId, "all");
        if (car.getImageUrl() == null || car.getImageUrl().trim().isEmpty()) {
            if (!carImages.isEmpty()) {
                String firstUrl = carImages.get(0).getImageUrl();
                if (firstUrl != null && !firstUrl.startsWith("/")) firstUrl = "/" + firstUrl;
                car.setImageUrl(firstUrl);
            }
        }
        request.setAttribute("car_detail", car);
        request.setAttribute("car", car);
        request.setAttribute("carImages", carImages);
        request.setAttribute("carAvailabilities", carAvailabilities);
        request.setAttribute("carBookings", carBookings);
        request.getRequestDispatcher("/WEB-INF/views/car/detail.jsp").forward(request, response);
    }
}
