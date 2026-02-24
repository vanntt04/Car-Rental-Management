package com.example.carrental.controller;

import com.example.carrental.model.dao.CarAvailabilityDAO;
import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.dao.CarImageDAO;
import com.example.carrental.model.entity.Car;
import com.example.carrental.model.entity.CarAvailability;
import com.example.carrental.model.entity.CarImage;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Servlet hiển thị danh sách xe (cho khách) và trang chi tiết xe.
 * GET /cars -> danh sách tất cả xe
 * GET /cars?id=1 -> chi tiết xe
 */
@WebServlet(name = "CarServlet", urlPatterns = { "/cars" })
public class CarServlet extends HttpServlet {
    private CarDAO carDAO;
    private CarImageDAO carImageDAO;
    private CarAvailabilityDAO availabilityDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        carDAO = new CarDAO();
        carImageDAO = new CarImageDAO();
        availabilityDAO = new CarAvailabilityDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int carId = Integer.parseInt(idParam.trim());
                showCarDetail(request, response, carId);
                return;
            } catch (NumberFormatException ignored) { }
        }
        showCarList(request, response);
    }

    private void showCarList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Car> cars = carDAO.getAllCars();
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
        List<CarImage> carImages = carImageDAO.getByCarId(carId);
        List<CarAvailability> carAvailabilities = availabilityDAO.getByCarId(carId);
        request.setAttribute("car", car);
        request.setAttribute("carImages", carImages);
        request.setAttribute("carAvailabilities", carAvailabilities);
        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/car/detail.jsp");
        rd.forward(request, response);
    }
}
