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
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;

/**
 * Servlet hiển thị danh sách xe (cho khách) và trang chi tiết xe. GET /cars ->
 * danh sách tất cả xe GET /cars?id=1 -> chi tiết xe
 */
@WebServlet(name = "CarServlet", urlPatterns = {"/cars"})
public class CarServlet extends HttpServlet {

    private CarDAO carDAO;
    private CarImageDAO carImageDAO;
    private CarAvailabilityDAO availabilityDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        carDAO = new CarDAO();
        carImageDAO = new CarImageDAO();
        availabilityDAO = new CarAvailabilityDAO();
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int carId = Integer.parseInt(idParam);
                showCarDetail(request, response, carId);
            } catch (NumberFormatException ignored) {
            }
        }

        showCarList(request, response);
    }

    private void showCarList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Car> cars = carDAO.getActiveCars();
        request.setAttribute("cars", cars);

        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/car/list.jsp");
        rd.forward(request, response);
    }

    private void showCarDetail(HttpServletRequest request, HttpServletResponse response, int carId)
            throws ServletException, IOException {

        Car car = carDAO.getCarById(carId);

        if (car == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy xe");
            return;
        }

        // Nếu xe không active thì chỉ ADMIN hoặc OWNER mới xem được
        if (!car.isActive()) {

            HttpSession session = request.getSession();
            User user = session != null ? (User) session.getAttribute("user") : null;

            boolean canView
                    = user != null
                    && ("ADMIN".equals(user.getRole())
                    || (car.getOwnerId() != null && car.getOwnerId().equals(user.getId())));

            if (!canView) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy xe");
                return;
            }
        }

        List<CarImage> carImages = carImageDAO.getByCarId(carId);
        List<CarAvailability> carAvailabilities = availabilityDAO.getByCarId(carId);
        List<Booking> carBookings = bookingDAO.getByCarId(carId, "all");
        request.setAttribute("car_detail", car);
        request.setAttribute("carImages", carImages);
        request.setAttribute("carAvailabilities", carAvailabilities);
        request.setAttribute("carBookings", carBookings);

        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/car/detail.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");
        int carId = Integer.parseInt(request.getParameter("id"));
        LocalDateTime holdStart = LocalDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh"));
        CarDAO car_dao = new CarDAO();
        int minutes = 1;
        car_dao.setCarOnHold(carId, userId, holdStart, 1);
        String notification = "Car select add to My Booking";
        request.setAttribute("Notification", notification);
        session.setAttribute("hold_until", holdStart.plusMinutes(minutes));
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/car/SearchCar.jsp");
        dispatcher.forward(request, response);
    }
}
