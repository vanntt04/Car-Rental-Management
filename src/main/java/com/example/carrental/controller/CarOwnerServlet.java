package com.example.carrental.controller;

import com.example.carrental.model.dao.BookingDAO;
import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.dao.CarImageDAO;
import com.example.carrental.model.entity.Booking;
import com.example.carrental.model.entity.Car;
import com.example.carrental.model.entity.CarImage;
import com.example.carrental.model.entity.User;
import com.example.carrental.model.util.ImageUploadUtil;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "CarOwnerServlet", urlPatterns = {"/owner", "/owner/*"})
public class CarOwnerServlet extends HttpServlet {

    private CarDAO carDAO;
    private CarImageDAO carImageDAO;
    private BookingDAO bookingDAO;

    private static final int PAGE_SIZE = 5;

    @Override
    public void init() throws ServletException {
        super.init();
        carDAO = new CarDAO();
        carImageDAO = new CarImageDAO();
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureOwner(request, response)) return;

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) pathInfo = "/";

        try {
            if ("/".equals(pathInfo) || "".equals(pathInfo)) {
                listOwnerCars(request, response);
            } else if (pathInfo.startsWith("/new")) {
                showCarForm(request, response, null);
            } else if (pathInfo.startsWith("/edit/")) {
                int carId = Integer.parseInt(pathInfo.substring(6));
                showCarForm(request, response, carId);
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
        if (!ensureOwner(request, response)) return;

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("create".equals(action) || "update".equals(action)) {
                saveCar(request, response);
            } else if ("set-active".equals(action)) {
                setCarActive(request, response);
            } else if ("add-image".equals(action)) {
                addImage(request, response);
            } else if ("add-image-upload".equals(action)) {
                addImageUpload(request, response);
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

    private boolean ensureOwner(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        String role = user != null ? user.getRole() : null;

        if (user == null || !"OWNER".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + request.getRequestURI());
            return false;
        }
        return true;
    }

    private void listOwnerCars(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        String pageParam = request.getParameter("page");
        String statusFilter = request.getParameter("status");
        String activeFilter = request.getParameter("active");
        String sortBy = request.getParameter("sort");
        if (sortBy == null || sortBy.isEmpty()) sortBy = "date_desc";

        int page = 1;
        try {
            if (pageParam != null && !pageParam.isEmpty()) page = Math.max(1, Integer.parseInt(pageParam));
        } catch (NumberFormatException ignored) {
        }

        int totalCount = carDAO.countCarsByOwnerId(user.getId(), statusFilter, activeFilter);
        int totalPages = totalCount == 0 ? 1 : (int) Math.ceil((double) totalCount / PAGE_SIZE);
        page = Math.min(page, totalPages);
        int offset = (page - 1) * PAGE_SIZE;

        List<Car> cars = carDAO.getCarsByOwnerId(user.getId(), offset, PAGE_SIZE, statusFilter, activeFilter, sortBy);
        request.setAttribute("cars", cars);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("activeFilter", activeFilter);
        request.setAttribute("sortBy", sortBy);
        forward(request, response, "/WEB-INF/views/owner/list.jsp");
    }

    private void showCarForm(HttpServletRequest request, HttpServletResponse response, Integer carId)
            throws ServletException, IOException {
        if (carId == null) {
            forward(request, response, "/WEB-INF/views/owner/car-form-new.jsp");
            return;
        }

        Car car = carDAO.getCarById(carId);
        if (car == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        User user = (User) request.getSession().getAttribute("user");
        if (car.getOwnerId() == null || car.getOwnerId() != user.getId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        request.setAttribute("car", car);
        forward(request, response, "/WEB-INF/views/owner/car-form-edit.jsp");
    }

    private void saveCar(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        User user = (User) request.getSession().getAttribute("user");
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        Car car;
        if ("update".equals(action) && idParam != null && !idParam.isEmpty()) {
            int carId = Integer.parseInt(idParam);
            car = carDAO.getCarById(carId);
            if (car == null || car.getOwnerId() == null || car.getOwnerId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        } else {
            car = new Car();
            car.setOwnerId(user.getId());
            car.setActive(true);
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
        String activeParam = request.getParameter("active");
        if (activeParam != null && !activeParam.isEmpty()) {
            car.setActive("1".equals(activeParam));
        }
        car.setDescription(request.getParameter("description"));

        Part imagePart = null;
        try {
            imagePart = request.getPart("imageFile");
        } catch (Exception ignored) {
        }
        if (imagePart != null && imagePart.getSize() > 0) {
            String savedPath = ImageUploadUtil.saveCarImage(imagePart, getServletContext());
            if (savedPath != null) car.setImageUrl(savedPath);
        }

        try {
            boolean ok = "update".equals(action) ? carDAO.updateCar(car) : carDAO.addCar(car);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/owner?success=" + ("update".equals(action) ? "updated" : "created"));
            } else {
                request.setAttribute("error", "Không thể lưu xe.");
                request.setAttribute("car", car);
                forward(request, response, "update".equals(action)
                        ? "/WEB-INF/views/owner/car-form-edit.jsp"
                        : "/WEB-INF/views/owner/car-form-new.jsp");
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Không thể lưu xe: " + e.getMessage());
            request.setAttribute("car", car);
            forward(request, response, "update".equals(action)
                    ? "/WEB-INF/views/owner/car-form-edit.jsp"
                    : "/WEB-INF/views/owner/car-form-new.jsp");
        }
    }

    private void setCarActive(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        String idParam = request.getParameter("id");
        String activeParam = request.getParameter("active");

        if (idParam == null || activeParam == null) {
            response.sendRedirect(request.getContextPath() + "/owner");
            return;
        }

        int carId = Integer.parseInt(idParam);
        Car car = carDAO.getCarById(carId);
        if (car == null || car.getOwnerId() == null || car.getOwnerId() != user.getId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        car.setActive("1".equals(activeParam));
        try {
            carDAO.updateCar(car);
            response.sendRedirect(request.getContextPath() + "/owner?success=" + (car.isActive() ? "activated" : "deactivated"));
        } catch (SQLException e) {
            response.sendRedirect(request.getContextPath() + "/owner?error=update");
        }
    }

    private void showImages(HttpServletRequest request, HttpServletResponse response, int carId)
            throws ServletException, IOException {
        Car car = carDAO.getCarById(carId);
        if (car == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        User user = (User) request.getSession().getAttribute("user");
        if (car.getOwnerId() == null || car.getOwnerId() != user.getId()) {
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

        if (car == null || car.getOwnerId() == null || car.getOwnerId() != user.getId()) {
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

    private void addImageUpload(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        int carId = Integer.parseInt(request.getParameter("carId"));
        Car car = carDAO.getCarById(carId);
        User user = (User) request.getSession().getAttribute("user");

        if (car == null || car.getOwnerId() == null || car.getOwnerId() != user.getId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        List<CarImage> existing = carImageDAO.getByCarId(carId);
        int sortOrder = existing.size();
        int added = 0;
        int invalid = 0;

        for (Part part : request.getParts()) {
            if (!"imageFile".equals(part.getName()) || part.getSize() == 0) continue;
            String savedPath = ImageUploadUtil.saveCarImage(part, getServletContext());
            if (savedPath == null) {
                invalid++;
                continue;
            }
            boolean isFirst = (existing.isEmpty() && added == 0);
            CarImage img = new CarImage(carId, savedPath, isFirst, sortOrder);
            carImageDAO.add(img);
            sortOrder++;
            added++;
        }

        if (added == 0 && invalid == 0) {
            response.sendRedirect(request.getContextPath() + "/owner/images/" + carId + "?error=empty");
            return;
        }
        if (invalid > 0 && added == 0) {
            response.sendRedirect(request.getContextPath() + "/owner/images/" + carId + "?error=invalid");
            return;
        }

        String qs = added > 0 ? "?success=added" + (added > 1 ? "&count=" + added : "") : "";
        response.sendRedirect(request.getContextPath() + "/owner/images/" + carId + qs);
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
        if (car == null || car.getOwnerId() == null || car.getOwnerId() != user.getId()) {
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
        if (car == null || car.getOwnerId() == null || car.getOwnerId() != user.getId()) {
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
