package com.example.carrental.controller;

import com.example.carrental.model.dao.CarAvailabilityDAO;
import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.dao.CarImageDAO;
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
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * Servlet quản lý xe cho Car Owner: Listings, Availability, Images
 * Chỉ OWNER và ADMIN mới truy cập được
 */
@WebServlet(name = "CarOwnerServlet", urlPatterns = "/owner/*")
public class CarOwnerServlet extends HttpServlet {
    private CarDAO carDAO;
    private CarAvailabilityDAO availabilityDAO;
    private CarImageDAO carImageDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        carDAO = new CarDAO();
        availabilityDAO = new CarAvailabilityDAO();
        carImageDAO = new CarImageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureOwnerOrAdmin(request, response)) return;

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) pathInfo = "/";

        try {
            if (pathInfo.equals("/") || pathInfo.equals("")) {
                listOwnerCars(request, response);
            } else if (pathInfo.startsWith("/new")) {
                showCarForm(request, response, null);
            } else if (pathInfo.startsWith("/edit/")) {
                int carId = Integer.parseInt(pathInfo.substring(6));
                showCarForm(request, response, carId);
            } else if (pathInfo.startsWith("/availability/")) {
                int carId = Integer.parseInt(pathInfo.substring(14));
                showAvailability(request, response, carId);
            } else if (pathInfo.startsWith("/images/")) {
                int carId = Integer.parseInt(pathInfo.substring(8));
                showImages(request, response, carId);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureOwnerOrAdmin(request, response)) return;

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String pathInfo = request.getPathInfo() != null ? request.getPathInfo() : "/";

        try {
            if ("create".equals(action) || "update".equals(action)) {
                saveCar(request, response);
            } else if ("delete".equals(action)) {
                deleteCar(request, response);
            } else if ("add-availability".equals(action)) {
                addAvailability(request, response);
            } else if ("delete-availability".equals(action)) {
                deleteAvailability(request, response);
            } else if ("add-image".equals(action)) {
                addImage(request, response);
            } else if ("delete-image".equals(action)) {
                deleteImage(request, response);
            } else if ("set-primary-image".equals(action)) {
                setPrimaryImage(request, response);
            } else {
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            doGet(request, response);
        }
    }

    private boolean ensureOwnerOrAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        String role = user != null ? user.getRole() : null;

        if (user == null || (!"OWNER".equalsIgnoreCase(role) && !"ADMIN".equalsIgnoreCase(role))) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" +
                    request.getRequestURI());
            return false;
        }
        return true;
    }

    private void listOwnerCars(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        List<Car> cars = carDAO.getCarsByOwnerId(user.getId());
        request.setAttribute("cars", cars);
        forward(request, response, "/WEB-INF/views/owner/list.jsp");
    }

    private void showCarForm(HttpServletRequest request, HttpServletResponse response, Integer carId)
            throws ServletException, IOException {
        if (carId != null) {
            Car car = carDAO.getCarById(carId);
            if (car == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            User user = (User) request.getSession().getAttribute("user");
            if (!"ADMIN".equals(user.getRole()) && (car.getOwnerId() == null || car.getOwnerId() != user.getId())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            request.setAttribute("car", car);
        }
        forward(request, response, "/WEB-INF/views/owner/car-form.jsp");
    }

    private void saveCar(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        User user = (User) request.getSession().getAttribute("user");
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        Car car;
        if ("update".equals(action) && idParam != null && !idParam.isEmpty()) {
            int carId = Integer.parseInt(idParam);
            car = carDAO.getCarById(carId);
            if (car == null || (!"ADMIN".equals(user.getRole()) && (car.getOwnerId() == null || car.getOwnerId() != user.getId()))) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        } else {
            car = new Car();
            car.setOwnerId(user.getId());
        }

        car.setName(request.getParameter("name"));
        car.setLicensePlate(request.getParameter("licensePlate"));
        car.setBrand(request.getParameter("brand"));
        car.setModel(request.getParameter("model"));
        String yearStr = request.getParameter("year");
        if (yearStr != null && !yearStr.isEmpty()) car.setYear(Integer.parseInt(yearStr));
        car.setColor(request.getParameter("color"));
        String priceStr = request.getParameter("pricePerDay");
        if (priceStr != null && !priceStr.isEmpty()) car.setPricePerDay(new BigDecimal(priceStr));
        car.setStatus(request.getParameter("status") != null ? request.getParameter("status") : "AVAILABLE");
        car.setImageUrl(request.getParameter("imageUrl"));

        boolean ok = "update".equals(action) ? carDAO.updateCar(car) : carDAO.addCar(car);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/owner?success=" + ("update".equals(action) ? "updated" : "created"));
        } else {
            request.setAttribute("error", "Không thể lưu xe");
            request.setAttribute("car", car);
            forward(request, response, "/WEB-INF/views/owner/car-form.jsp");
        }
    }

    private void deleteCar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        int carId = Integer.parseInt(request.getParameter("id"));
        Car car = carDAO.getCarById(carId);
        if (car == null || (!"ADMIN".equals(user.getRole()) && (car.getOwnerId() == null || car.getOwnerId() != user.getId()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        carDAO.deleteCar(carId);
        response.sendRedirect(request.getContextPath() + "/owner?success=deleted");
    }

    private void showAvailability(HttpServletRequest request, HttpServletResponse response, int carId)
            throws ServletException, IOException {
        Car car = carDAO.getCarById(carId);
        if (car == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        User user = (User) request.getSession().getAttribute("user");
        if (!"ADMIN".equals(user.getRole()) && (car.getOwnerId() == null || car.getOwnerId() != user.getId())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        List<CarAvailability> list = availabilityDAO.getByCarId(carId);
        request.setAttribute("car", car);
        request.setAttribute("availabilities", list);
        forward(request, response, "/WEB-INF/views/owner/availability.jsp");
    }

    private void addAvailability(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int carId = Integer.parseInt(request.getParameter("carId"));
        Car car = carDAO.getCarById(carId);
        User user = (User) request.getSession().getAttribute("user");
        if (car == null || (!"ADMIN".equals(user.getRole()) && (car.getOwnerId() == null || car.getOwnerId() != user.getId()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        CarAvailability av = new CarAvailability();
        av.setCarId(carId);
        av.setStartDate(LocalDate.parse(request.getParameter("startDate")));
        av.setEndDate(LocalDate.parse(request.getParameter("endDate")));
        av.setAvailable("1".equals(request.getParameter("isAvailable")));
        av.setNote(request.getParameter("note"));
        availabilityDAO.add(av);
        response.sendRedirect(request.getContextPath() + "/owner/availability/" + carId + "?success=added");
    }

    private void deleteAvailability(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int avId = Integer.parseInt(request.getParameter("id"));
        CarAvailability av = availabilityDAO.getById(avId);
        if (av == null) {
            response.sendRedirect(request.getContextPath() + "/owner");
            return;
        }
        Car car = carDAO.getCarById(av.getCarId());
        User user = (User) request.getSession().getAttribute("user");
        if (car == null || (!"ADMIN".equals(user.getRole()) && (car.getOwnerId() == null || car.getOwnerId() != user.getId()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        availabilityDAO.delete(avId);
        response.sendRedirect(request.getContextPath() + "/owner/availability/" + av.getCarId() + "?success=deleted");
    }

    private void showImages(HttpServletRequest request, HttpServletResponse response, int carId)
            throws ServletException, IOException {
        Car car = carDAO.getCarById(carId);
        if (car == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        User user = (User) request.getSession().getAttribute("user");
        if (!"ADMIN".equals(user.getRole()) && (car.getOwnerId() == null || car.getOwnerId() != user.getId())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        List<CarImage> images = carImageDAO.getByCarId(carId);
        request.setAttribute("car", car);
        request.setAttribute("images", images);
        forward(request, response, "/WEB-INF/views/owner/images.jsp");
    }

    private void addImage(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int carId = Integer.parseInt(request.getParameter("carId"));
        Car car = carDAO.getCarById(carId);
        User user = (User) request.getSession().getAttribute("user");
        if (car == null || (!"ADMIN".equals(user.getRole()) && (car.getOwnerId() == null || car.getOwnerId() != user.getId()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        String url = request.getParameter("imageUrl");
        if (url == null || url.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/owner/images/" + carId + "?error=empty");
            return;
        }
        List<CarImage> existing = carImageDAO.getByCarId(carId);
        CarImage img = new CarImage(carId, url.trim(), existing.isEmpty(), existing.size());
        carImageDAO.add(img);
        response.sendRedirect(request.getContextPath() + "/owner/images/" + carId + "?success=added");
    }

    private void deleteImage(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int imgId = Integer.parseInt(request.getParameter("id"));
        CarImage img = carImageDAO.getById(imgId);
        if (img == null) {
            response.sendRedirect(request.getContextPath() + "/owner");
            return;
        }
        Car car = carDAO.getCarById(img.getCarId());
        User user = (User) request.getSession().getAttribute("user");
        if (car == null || (!"ADMIN".equals(user.getRole()) && (car.getOwnerId() == null || car.getOwnerId() != user.getId()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        carImageDAO.delete(imgId);
        response.sendRedirect(request.getContextPath() + "/owner/images/" + img.getCarId() + "?success=deleted");
    }

    private void setPrimaryImage(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int imgId = Integer.parseInt(request.getParameter("id"));
        CarImage img = carImageDAO.getById(imgId);
        if (img == null) {
            response.sendRedirect(request.getContextPath() + "/owner");
            return;
        }
        Car car = carDAO.getCarById(img.getCarId());
        User user = (User) request.getSession().getAttribute("user");
        if (car == null || (!"ADMIN".equals(user.getRole()) && (car.getOwnerId() == null || car.getOwnerId() != user.getId()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        carImageDAO.setPrimary(img.getCarId(), imgId);
        response.sendRedirect(request.getContextPath() + "/owner/images/" + img.getCarId() + "?success=primary");
    }

    private void forward(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        RequestDispatcher rd = request.getRequestDispatcher(path);
        rd.forward(request, response);
    }
}
