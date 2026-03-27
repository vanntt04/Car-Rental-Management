package com.example.carrental.controller;

import com.example.carrental.model.dao.BookingDAO;
import com.example.carrental.model.dao.CarAvailabilityDAO;
import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.entity.Car;
import com.example.carrental.model.util.HoldCleanupScheduler;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

/**
 * Danh sách / tìm xe khách hàng — phân trang, sắp xếp theo giá thuê tăng dần.
 */
@WebServlet(name = "SearchCarServlet", urlPatterns = "/searchcar")
public class SearchCarServlet extends HttpServlet {

    private static final int CAR_LIST_PAGE_SIZE = 9;

    private static LocalDate parseDateParam(String raw) {
        if (raw == null || raw.isEmpty()) return null;
        String v = raw;
        if (v.contains("T")) v = v.substring(0, v.indexOf('T'));
        return LocalDate.parse(v);
    }

    private static Integer parseSeatParam(String seat) {
        try {
            if (seat != null && !seat.isEmpty()) return Integer.parseInt(seat);
        } catch (NumberFormatException ignored) {}
        return null;
    }

    private List<Car> filterByDateRange(CarDAO carDAO, CarAvailabilityDAO availabilityDAO, BookingDAO bookingDAO,
                                        LocalDate pickupTime, LocalDate returnTime, Integer seatRequested) {
        List<Car> resultList = new ArrayList<>();
        List<Car> candidates = carDAO.getAllCars();
        for (Car car : candidates) {
            if (car == null) continue;
            if (car.getStatus() != null && !"AVAILABLE".equalsIgnoreCase(car.getStatus())) continue;
            if (seatRequested != null) {
                if (car.getSeats() == null || car.getSeats() < seatRequested) continue;
            }
            if (!availabilityDAO.isCarAvailableForRange(car.getId(), pickupTime, returnTime)) continue;
            if (bookingDAO.hasOverlappingBooking(car.getId(), pickupTime, returnTime)) continue;
            resultList.add(car);
        }
        return resultList;
    }

    private List<Car> listDefaultCars(CarDAO carDAO) {
        List<Car> resultList = new ArrayList<>();
        for (Car c : carDAO.getAllCars()) {
            if (c != null && (c.getStatus() == null || !"RENTED".equalsIgnoreCase(c.getStatus()))) {
                resultList.add(c);
            }
        }
        return resultList;
    }

    private void setPaginationLinkParams(HttpServletRequest request, String pickup, String ret, String seat, String start, String end) {
        request.setAttribute("paginationPickup", pickup != null ? pickup : "");
        request.setAttribute("paginationReturn", ret != null ? ret : "");
        request.setAttribute("paginationSeat", seat != null ? seat : "");
        request.setAttribute("paginationStart", start != null ? start : "");
        request.setAttribute("paginationEnd", end != null ? end : "");
    }

    private void applyCarListPagination(List<Car> fullList, HttpServletRequest request) {
        List<Car> filtered = new ArrayList<>();
        for (Car c : fullList) {
            if (c == null) continue;
            filtered.add(c);
        }

        filtered.sort(Comparator.comparing(Car::getPricePerDay, Comparator.nullsLast(Comparator.naturalOrder())));

        int page = 1;
        try {
            String p = request.getParameter("page");
            if (p != null && !p.isEmpty()) page = Math.max(1, Integer.parseInt(p));
        } catch (NumberFormatException ignored) {}

        int total = filtered.size();
        int totalPages = total <= 0 ? 1 : (int) Math.ceil((double) total / CAR_LIST_PAGE_SIZE);
        page = Math.min(page, totalPages);
        int from = (page - 1) * CAR_LIST_PAGE_SIZE;
        List<Car> pageList = new ArrayList<>();
        if (from < total) {
            pageList.addAll(filtered.subList(from, Math.min(from + CAR_LIST_PAGE_SIZE, total)));
        }

        request.setAttribute("CarList", pageList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCarCount", total);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String startStr = request.getParameter("start");
        String endStr = request.getParameter("end");
        String pickupGet = request.getParameter("pickupTime");
        String returnGet = request.getParameter("returnTime");
        String seatStr = request.getParameter("seat");

        CarDAO carDAO = new CarDAO();
        CarAvailabilityDAO availabilityDAO = new CarAvailabilityDAO();
        BookingDAO bookingDAO = new BookingDAO();

        LocalDate pickupTime = null;
        LocalDate returnTime = null;
        Integer seatRequested = parseSeatParam(seatStr);

        try {
            if (pickupGet != null && !pickupGet.isEmpty() && returnGet != null && !returnGet.isEmpty()) {
                pickupTime = parseDateParam(pickupGet);
                returnTime = parseDateParam(returnGet);
            } else if (startStr != null && !startStr.isEmpty() && endStr != null && !endStr.isEmpty()) {
                pickupTime = parseDateParam(startStr);
                returnTime = parseDateParam(endStr);
                seatRequested = null;
            }
        } catch (Exception ignored) {
            pickupTime = null;
            returnTime = null;
        }

        List<Car> resultList;
        String error = null;

        if (pickupTime != null && returnTime != null && !returnTime.isBefore(pickupTime)) {
            resultList = filterByDateRange(carDAO, availabilityDAO, bookingDAO, pickupTime, returnTime, seatRequested);
            if (resultList.isEmpty()) {
                error = "Không tìm thấy kết quả phù hợp";
            }
        } else {
            resultList = listDefaultCars(carDAO);
        }

        setPaginationLinkParams(request,
                pickupGet != null ? pickupGet : "",
                returnGet != null ? returnGet : "",
                seatStr != null ? seatStr : "",
                startStr != null ? startStr : "",
                endStr != null ? endStr : "");

        request.setAttribute("error", error);
        request.setAttribute("pickupTime", pickupTime);
        request.setAttribute("returnTime", returnTime);
        applyCarListPagination(resultList, request);

        HoldCleanupScheduler.start();
        request.getRequestDispatcher("/WEB-INF/views/car/SearchCar.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String pickupStr = request.getParameter("pickupTime");
        String returnStr = request.getParameter("returnTime");
        String seat = request.getParameter("seat");

        LocalDate pickupTime = null;
        LocalDate returnTime = null;
        try {
            if (pickupStr != null && !pickupStr.isEmpty()) pickupTime = parseDateParam(pickupStr);
            if (returnStr != null && !returnStr.isEmpty()) returnTime = parseDateParam(returnStr);
        } catch (Exception e) {
            pickupTime = null;
            returnTime = null;
        }

        String error = null;
        if (pickupTime == null || returnTime == null) {
            error = "Vui lòng nhập đủ ngày nhận và trả xe";
        } else if (returnTime.isBefore(pickupTime)) {
            error = "Ngày trả xe phải sau ngày nhận";
        }

        CarDAO carDAO = new CarDAO();
        CarAvailabilityDAO availabilityDAO = new CarAvailabilityDAO();
        BookingDAO bookingDAO = new BookingDAO();
        Integer seatRequested = parseSeatParam(seat);

        List<Car> resultList;
        if (error == null) {
            resultList = filterByDateRange(carDAO, availabilityDAO, bookingDAO, pickupTime, returnTime, seatRequested);
            if (resultList.isEmpty()) {
                error = "Không tìm thấy kết quả phù hợp";
            }
        } else {
            resultList = listDefaultCars(carDAO);
        }

        setPaginationLinkParams(request,
                pickupStr != null ? pickupStr : "",
                returnStr != null ? returnStr : "",
                seat != null ? seat : "",
                "",
                "");

        request.setAttribute("error", error);
        request.setAttribute("pickupTime", pickupTime);
        request.setAttribute("returnTime", returnTime);
        applyCarListPagination(resultList, request);

        request.getRequestDispatcher("/WEB-INF/views/car/SearchCar.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Search cars with pagination";
    }
}
