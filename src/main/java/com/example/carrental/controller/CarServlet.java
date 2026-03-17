package com.example.carrental.controller;

import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.entity.Car;
import com.example.carrental.model.entity.User;

import com.example.carrental.model.dao.CarImageDAO;
import com.example.carrental.model.dao.CarAvailabilityDAO;
import com.example.carrental.model.dao.BookingDAO;
import com.example.carrental.model.dao.BankAccountDAO;
import com.example.carrental.model.entity.CarImage;
import com.example.carrental.model.entity.CarAvailability;
import com.example.carrental.model.entity.Booking;
import com.example.carrental.model.entity.BankAccount;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@MultipartConfig
@WebServlet(name = "CarOwnerServlet", urlPatterns = {"/owner", "/owner/*"})
public class CarServlet extends HttpServlet {

    private CarDAO carDAO;
    private CarImageDAO carImageDAO;
    private CarAvailabilityDAO availabilityDAO;
    private BookingDAO bookingDAO;
    private BankAccountDAO bankAccountDAO;

    private static final int PAGE_SIZE = 5;

    @Override
    public void init() {

        carDAO = new CarDAO();
        carImageDAO = new CarImageDAO();
        availabilityDAO = new CarAvailabilityDAO();
        bookingDAO = new BookingDAO();
        bankAccountDAO = new BankAccountDAO();

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            listCars(request, response);
        } else if (action.equals("new")) {
            showForm(request, response);
        } else if (action.equals("edit")) {
            showEditForm(request, response);
        } else if ("detail".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            showCarDetail(request, response, id);
        } else if ("bankAccount".equals(action)) {
            showBankAccountForm(request, response);
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {

            if ("create".equals(action)) {
                createCar(request, response);
            } else if ("update".equals(action)) {
                updateCar(request, response);
            } else if ("saveBankAccount".equals(action)) {
                saveBankAccount(request, response);
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
        int ownerId = user.getId();

        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
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

        List<Car> cars = carDAO.searchCarsByOwner(ownerId, keyword, status, sort, offset, PAGE_SIZE);

        int totalCars = carDAO.countCarsByOwnerId(ownerId, status, null);
        int totalPages = (int) Math.ceil((double) totalCars / PAGE_SIZE);

        request.setAttribute("cars", cars);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCars);
        request.setAttribute("sortBy", sort);

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
    // BANK ACCOUNT (tài khoản ngân hàng)
    // =========================
    private void showBankAccountForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        BankAccount bank = bankAccountDAO.getByOwnerId(user.getId());
        if (bank == null) {
            bank = new BankAccount();
            bank.setOwnerId(user.getId());
            bank.setActive(true);
        }
        request.setAttribute("bankAccount", bank);
        request.getRequestDispatcher("/WEB-INF/views/owner/bank-account.jsp").forward(request, response);
    }

    private void saveBankAccount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String bankCode = request.getParameter("bankCode");
        String accountNumber = request.getParameter("accountNumber");
        String accountName = request.getParameter("accountName");
        String branch = request.getParameter("branch");

        if (bankCode == null || bankCode.trim().isEmpty()) {
            request.setAttribute("error", "Mã ngân hàng không được để trống");
            forwardBankFormWithParams(request, response, user.getId(), bankCode, accountNumber, accountName, branch);
            return;
        }
        if (accountNumber == null || accountNumber.trim().isEmpty()) {
            request.setAttribute("error", "Số tài khoản không được để trống");
            forwardBankFormWithParams(request, response, user.getId(), bankCode, accountNumber, accountName, branch);
            return;
        }
        if (accountName == null || accountName.trim().isEmpty()) {
            request.setAttribute("error", "Tên chủ tài khoản không được để trống");
            forwardBankFormWithParams(request, response, user.getId(), bankCode, accountNumber, accountName, branch);
            return;
        }

        BankAccount ba = bankAccountDAO.getByOwnerId(user.getId());
        if (ba == null) {
            ba = new BankAccount();
            ba.setOwnerId(user.getId());
            ba.setActive(true);
        }
        ba.setBankCode(bankCode.trim());
        ba.setAccountNumber(accountNumber.trim());
        ba.setAccountName(accountName.trim());
        ba.setBranch(branch != null ? branch.trim() : "");

        if (bankAccountDAO.save(ba)) {
            response.sendRedirect(request.getContextPath() + "/owner?action=bankAccount&success=saved");
        } else {
            request.setAttribute("error", "Lưu thất bại. Vui lòng thử lại.");
            request.setAttribute("bankAccount", ba);
            request.getRequestDispatcher("/WEB-INF/views/owner/bank-account.jsp").forward(request, response);
        }
    }

    private void forwardBankFormWithParams(HttpServletRequest request, HttpServletResponse response, int ownerId,
            String bankCode, String accountNumber, String accountName, String branch) throws ServletException, IOException {
        BankAccount ba = new BankAccount();
        ba.setOwnerId(ownerId);
        ba.setBankCode(bankCode != null ? bankCode : "");
        ba.setAccountNumber(accountNumber != null ? accountNumber : "");
        ba.setAccountName(accountName != null ? accountName : "");
        ba.setBranch(branch != null ? branch : "");
        ba.setActive(true);
        request.setAttribute("bankAccount", ba);
        request.getRequestDispatcher("/WEB-INF/views/owner/bank-account.jsp").forward(request, response);
    }

    // =========================
    // CREATE CAR
    // =========================
    private void createCar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

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
            year = Integer.parseInt(yearStr);
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

        carDAO.addCar(car);

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

        // ===== VALIDATE =====
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
        car.setYear(Integer.parseInt(request.getParameter("year")));
        car.setColor(request.getParameter("color"));
        car.setStatus(request.getParameter("status"));
        car.setDescription(request.getParameter("description"));

        carDAO.updateCar(car);

        response.sendRedirect(request.getContextPath() + "/owner?success=updated");
    }
}
