package com.example.carrental.controller;

import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.entity.Car;
import com.example.carrental.model.entity.User;

import com.example.carrental.model.dao.CarImageDAO;
import com.example.carrental.model.dao.CarAvailabilityDAO;
import com.example.carrental.model.dao.BookingDAO;
import com.example.carrental.model.entity.CarImage;
import com.example.carrental.model.entity.CarAvailability;
import com.example.carrental.model.entity.Booking;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.Year;
import java.util.List;
import jakarta.servlet.http.Part;
import com.example.carrental.model.util.ImageUploadUtil;

@MultipartConfig
@WebServlet(name = "CarOwnerServlet", urlPatterns = {"/owner", "/owner/*"})
public class CarServlet extends HttpServlet {

    private CarDAO carDAO;
    private CarImageDAO carImageDAO;
    private CarAvailabilityDAO availabilityDAO;
    private BookingDAO bookingDAO;

    private static final int PAGE_SIZE = 5;

    private Integer parseAndValidateYear(String yearStr) {
        if (yearStr == null || yearStr.trim().isEmpty()) return null;
        try {
            int year = Integer.parseInt(yearStr.trim());
            int currentYear = Year.now().getValue();
            if (year < 0 || year > currentYear) return null;
            return year;
        } catch (NumberFormatException e) {
            return null;
        }
    }

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
        //lấy phần đường dẫn phía sau URL mapping của Servlet
        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");

        if (pathInfo != null && !pathInfo.isEmpty()) {
            if ("/new".equals(pathInfo)) {
                showForm(request, response);
                return;
            }
            if (pathInfo.startsWith("/edit/")) {
                String idStr = pathInfo.substring(6).split("/")[0];
                try {
                    int id = Integer.parseInt(idStr);
                    Car car = carDAO.getCarById(id);
                    if (car != null) {
                        request.setAttribute("car", car);
                        request.getRequestDispatcher("/WEB-INF/views/owner/car-form-edit.jsp").forward(request, response);
                    } else {
                        listCars(request, response);
                    }
                } catch (NumberFormatException e) {
                    listCars(request, response);
                }
                return;
            }
        }

        if (action != null) {
            if ("new".equals(action)) {
                showForm(request, response);
                return;
            }
            if ("edit".equals(action)) {
                String idParam = request.getParameter("id");
                if (idParam != null) {
                    try {
                        showEditForm(request, response);
                        return;
                    } catch (Exception e) {
                        listCars(request, response);
                        return;
                    }
                }
            }
            if ("detail".equals(action)) {
                String idParam = request.getParameter("id");
                if (idParam != null) {
                    try {
                        int id = Integer.parseInt(idParam);
                        showCarDetail(request, response, id);
                        return;
                    } catch (NumberFormatException e) {
                    }
                }
            }
        }

        listCars(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("create".equals(action)) {
                createCar(request, response);
            } else if ("edit".equals(action) || "update".equals(action)) {
                updateCar(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    // =========================
    // LIST + SEARCH + FILTER
    // =========================
    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Car car = carDAO.getCarById(id);

        request.setAttribute("car", car);

        request.getRequestDispatcher("/WEB-INF/views/car/detail.jsp")
                .forward(request, response);
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
            boolean canView = user != null && ("ADMIN".equals(user.getRole()) || (car.getOwnerId() != null && car.getOwnerId().equals(user.getId())));
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
        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/car/detail.jsp");
        rd.forward(request, response);
    }

    private void listCars(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int ownerId = user.getId();

        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        String brand = request.getParameter("brand");
        String sort = request.getParameter("sort");

        if (sort == null) {
            sort = "newest";
        }

        int page = 1;

        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception e) {
        }

        int offset = (page - 1) * PAGE_SIZE;

        List<Car> cars = carDAO.searchCarsByOwner(ownerId, keyword, status, brand, sort, offset, PAGE_SIZE);

        int totalCars = carDAO.countCarsByOwnerId(ownerId, status, null, keyword, brand);
        int totalPages = (int) Math.ceil((double) totalCars / PAGE_SIZE);

        List<String> brands = carDAO.getDistinctBrandsByOwnerId(ownerId);

        request.setAttribute("cars", cars);
        request.setAttribute("brands", brands);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCars);
        request.setAttribute("sortBy", sort);
        request.setAttribute("statusFilter", status);
        request.setAttribute("brandFilter", brand);

        request.getRequestDispatcher("/WEB-INF/views/owner/list.jsp")
                .forward(request, response);
    }

    // =========================
    // SHOW CREATE FORM
    // =========================
    private void showForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/owner/car-form-new.jsp")
                .forward(request, response);
    }

    // =========================
    // SHOW EDIT FORM
    // =========================
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Car car = carDAO.getCarById(id);

        request.setAttribute("car", car);

        request.getRequestDispatcher("/WEB-INF/views/owner/car-form-edit.jsp")
                .forward(request, response);
    }

    // =========================
    // CREATE CAR
    // =========================
    private void createCar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        //take ìnormation from session
        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Car car = new Car();

        String name = request.getParameter("name");
        String license = request.getParameter("licensePlate");
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        String color = request.getParameter("color");
        String seats = request.getParameter("seats");
        String status = request.getParameter("status");
        String description = request.getParameter("description");

        String yearStr = request.getParameter("year");
        String priceStr = request.getParameter("pricePerDay");

        if (license == null || license.trim().isEmpty()) {
            request.setAttribute("error", "Biển số không được để trống");
            showForm(request, response);
            return;
        }

        if (priceStr == null || priceStr.isEmpty()) {
            request.setAttribute("error", "Giá thuê không hợp lệ");
            showForm(request, response);
            return;
        }

        BigDecimal price = new BigDecimal(priceStr);

        if (price.compareTo(new BigDecimal("1000")) < 0) {
            request.setAttribute("error", "Giá thuê phải lớn hơn 1000");
            showForm(request, response);
            return;
        }

        if (carDAO.isLicensePlateExist(license)) {
            request.setAttribute("error", "Biển số xe bị trùng");
            showForm(request, response);
            return;
        }

        Integer year = null;
        if (yearStr != null && !yearStr.isEmpty()) {
            year = parseAndValidateYear(yearStr);
            if (year == null) {
                request.setAttribute("error", "Năm sản xuất phải từ 0 đến năm hiện tại.");
                showForm(request, response);
                return;
            }
        }

        Integer seatNum = null;
        if (seats != null && !seats.isEmpty()) {
            seatNum = Integer.parseInt(seats);
        }
        

        System.out.println("Form submitted");
        System.out.println("licensePlate = [" + request.getParameter("licensePlate") + "]");

        car.setName(name);
        car.setLicensePlate(license);
        car.setBrand(brand);
        car.setModel(model);
        car.setColor(color);
        car.setYear(year);
        car.setPricePerDay(price);
        car.setSeats(seatNum);
        car.setStatus(status);
        car.setDescription(description);
        car.setOwnerId(user.getId());

        int carId = carDAO.addCar(car);
        if (carId > 0) {
            Part imagePart = request.getPart("imageFile");
            if (imagePart != null && imagePart.getSize() > 0) {
                String path = ImageUploadUtil.saveCarImage(imagePart, getServletContext());
                if (path != null) {
                    car.setImageUrl(path);
                    carDAO.updateCarImageUrl(carId, path);
                    CarImage img = new CarImage(carId, path, true, 0);
                    carImageDAO.add(img);
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/owner?success=created");
//        System.out.println("licensePlate = [" + request.getParameter("licensePlate") + "]");
    }

    // =========================
    // UPDATE CAR
    // =========================
    private void updateCar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        int id = Integer.parseInt(request.getParameter("id"));

        Car car = carDAO.getCarById(id);

        String license = request.getParameter("licensePlate");
        BigDecimal price = new BigDecimal(request.getParameter("pricePerDay"));
        String yearParam = request.getParameter("year");
        Integer year = parseAndValidateYear(yearParam);

        // ===== VALIDATE =====
        if (yearParam != null && !yearParam.trim().isEmpty() && year == null) {
            request.setAttribute("error", "Năm sản xuất phải từ 0 đến năm hiện tại.");
            request.setAttribute("car", car);
            request.getRequestDispatcher("/WEB-INF/views/owner/car-form-edit.jsp")
                    .forward(request, response);
            return;
        }

        if (price.compareTo(new BigDecimal("1000")) < 0) {

            request.setAttribute("error", "Giá thuê phải lớn hơn 1000");
            request.setAttribute("car", car);
            request.getRequestDispatcher("/WEB-INF/views/owner/car-form-edit.jsp")
                    .forward(request, response);
            return;
        }

        if (!license.equals(car.getLicensePlate()) && carDAO.isLicensePlateExist(license)) {

            request.setAttribute("error", "Biển số xe bị trùng");
            request.setAttribute("car", car);
            request.getRequestDispatcher("/WEB-INF/views/owner/car-form-edit.jsp")
                    .forward(request, response);
            return;
        }

        // ===== UPDATE =====
        car.setName(request.getParameter("name"));
        car.setLicensePlate(license);
        car.setBrand(request.getParameter("brand"));
        car.setModel(request.getParameter("model"));
        car.setPricePerDay(price);
        if (yearParam != null && !yearParam.isEmpty()) {
            car.setYear(year);
        }
        car.setColor(request.getParameter("color"));
        String seatsParam = request.getParameter("seats");
        if (seatsParam != null && !seatsParam.isEmpty()) {
            car.setSeats(Integer.parseInt(seatsParam));
        }
        car.setStatus(request.getParameter("status"));
        car.setDescription(request.getParameter("description"));

        Part imagePart = request.getPart("imageFile");
        if (imagePart != null && imagePart.getSize() > 0) {
            String path = ImageUploadUtil.saveCarImage(imagePart, getServletContext());
            if (path != null) {
                car.setImageUrl(path);
                List<CarImage> existing = carImageDAO.getByCarId(id);
                CarImage newImg = new CarImage(id, path, true, existing.size());
                int newImgId = carImageDAO.addAndGetId(newImg);
                if (newImgId > 0) {
                    carImageDAO.setPrimary(id, newImgId);
                }
                carDAO.updateCarImageUrl(id, path);
            }
        }

        carDAO.updateCar(car);

        response.sendRedirect(request.getContextPath() + "/owner?success=updated");
    }
}
