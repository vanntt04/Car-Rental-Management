package com.example.carrental.controller;

import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.entity.Car;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Controller xử lý các request liên quan đến xe
 * Controller trong mô hình MVC
 */
@WebServlet(name = "CarServlet", urlPatterns = "/cars")
public class CarServlet extends HttpServlet {
    private CarDAO carDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        carDAO = new CarDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        try {
            if (idParam != null && !idParam.isEmpty()) {
                // Hiển thị chi tiết xe
                showCarDetail(request, response, Integer.parseInt(idParam));
            } else if ("new".equals(action)) {
                // Hiển thị form thêm xe mới (có thể mở rộng sau)
                showCarList(request, response);
            } else {
                // Hiển thị danh sách xe
                showCarList(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid car ID");
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
        } else if ("delete".equals(action)) {
            deleteCar(request, response);
        } else {
            doGet(request, response);
        }
    }

    /**
     * Hiển thị danh sách xe
     */
    private void showCarList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Car> cars = carDAO.getAllCars();
        request.setAttribute("cars", cars);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/car/list.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Hiển thị chi tiết xe
     */
    private void showCarDetail(HttpServletRequest request, HttpServletResponse response, int carId)
            throws ServletException, IOException {
        
        Car car = carDAO.getCarById(carId);
        
        if (car != null) {
            request.setAttribute("car", car);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/car/detail.jsp");
            dispatcher.forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Car not found");
        }
    }

    /**
     * Tạo xe mới
     */
    private void createCar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Car car = new Car();
            car.setName(request.getParameter("name"));
            car.setBrand(request.getParameter("brand"));
            car.setModel(request.getParameter("model"));
            
            String yearStr = request.getParameter("year");

            
 
            
            String priceStr = request.getParameter("pricePerDay");
            if (priceStr != null && !priceStr.isEmpty()) {
                car.setPricePerDay(Integer.parseInt(priceStr));
            }
            
            car.setStatus(request.getParameter("status") != null ? 
                         request.getParameter("status") : "AVAILABLE");

            
            if (carDAO.addCar(car)) {
                response.sendRedirect(request.getContextPath() + "/cars?success=created");
            } else {
                request.setAttribute("error", "Không thể thêm xe mới");
                showCarList(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            showCarList(request, response);
        }
    }

    /**
     * Cập nhật thông tin xe
     */
    private void updateCar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int carId = Integer.parseInt(request.getParameter("id"));
            Car car = carDAO.getCarById(carId);
            
            if (car != null) {
                car.setName(request.getParameter("name"));

                car.setBrand(request.getParameter("brand"));
                car.setModel(request.getParameter("model"));
                
                String yearStr = request.getParameter("year");
                

                
                String priceStr = request.getParameter("pricePerDay");
                if (priceStr != null && !priceStr.isEmpty()) {
                    car.setPricePerDay(Integer.parseInt(priceStr));
                }
                
                car.setStatus(request.getParameter("status"));

                
                if (carDAO.updateCar(car)) {
                    response.sendRedirect(request.getContextPath() + "/cars?id=" + carId + "&success=updated");
                } else {
                    request.setAttribute("error", "Không thể cập nhật thông tin xe");
                    showCarDetail(request, response, carId);
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Car not found");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            String idParam = request.getParameter("id");
            if (idParam != null) {
                showCarDetail(request, response, Integer.parseInt(idParam));
            } else {
                showCarList(request, response);
            }
        }
    }

    /**
     * Xóa xe
     */
    private void deleteCar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int carId = Integer.parseInt(request.getParameter("id"));
            
            if (carDAO.deleteCar(carId)) {
                response.sendRedirect(request.getContextPath() + "/cars?success=deleted");
            } else {
                request.setAttribute("error", "Không thể xóa xe");
                showCarList(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            showCarList(request, response);
        }
    }
}
