package com.example.carrental.controller;

import com.example.carrental.model.dao.CarAvailabilityDAO;
import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.dao.CarImageDAO;
import com.example.carrental.model.entity.Car;
import com.example.carrental.model.entity.CarImage;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Servlet phục vụ danh sách xe và chi tiết xe cho khách hàng.
 * URL: /searchcar (danh sách), /searchcar?id=123 (chi tiết)
 */
public class SearchCarServlet extends HttpServlet {

    private final CarDAO carDAO = new CarDAO();
    private final CarAvailabilityDAO availabilityDAO = new CarAvailabilityDAO();
    private final CarImageDAO carImageDAO = new CarImageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int carId = Integer.parseInt(idParam.trim());
                Car car = carDAO.getCarById(carId);
                if (car == null) {
                    response.sendRedirect(request.getContextPath() + "/searchcar");
                    return;
                }
                java.util.List<CarImage> carImages = carImageDAO.getByCarId(carId);
                if (car.getImageUrl() == null || car.getImageUrl().trim().isEmpty()) {
                    if (!carImages.isEmpty() && carImages.get(0).getImageUrl() != null) {
                        String url = carImages.get(0).getImageUrl();
                        car.setImageUrl(url.startsWith("/") ? url : "/" + url);
                    }
                }
                request.setAttribute("car_detail", car);
                request.setAttribute("carAvailabilities", availabilityDAO.getByCarId(carId));
                RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/car/detail.jsp");
                rd.forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/searchcar");
            }
        } else {
            String keyword = request.getParameter("keyword");
            List<Car> cars;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = keyword.trim().toLowerCase();
                cars = carDAO.getActiveCars().stream()
                        .filter(c -> (c.getName() != null && c.getName().toLowerCase().contains(kw))
                                || (c.getLicensePlate() != null && c.getLicensePlate().toLowerCase().contains(kw))
                                || (c.getBrand() != null && c.getBrand().toLowerCase().contains(kw)))
                        .collect(Collectors.toList());
            } else {
                cars = carDAO.getActiveCars();
            }
            request.setAttribute("cars", cars);
            RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/car/list.jsp");
            rd.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking?carId=" + idParam.trim());
        } else {
            doGet(request, response);
        }
    }
}
