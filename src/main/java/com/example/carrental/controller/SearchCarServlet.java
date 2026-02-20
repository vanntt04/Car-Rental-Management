/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.example.carrental.controller;

import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.entity.Car;
import com.example.carrental.model.entity.User;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.List;

/**
 *
 * @author PC
 */
public class SearchCarServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SearchCarServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SearchCarServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        CarDAO carDAO = new CarDAO();
        List<Car> CarList = carDAO.getAllCars();
        List<String> BrandList = carDAO.getAllBrandCars();
        HttpSession session = request.getSession();
        session.setAttribute("CarList", CarList);
        session.setAttribute("BrandList", BrandList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/car/SearchCar.jsp");
        dispatcher.forward(request, response);

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String pickupStr = request.getParameter("pickupTime");
        LocalDate pickupTime = null;
        try {
            if (pickupStr != null && !pickupStr.isEmpty()) {
                pickupTime = LocalDate.parse(pickupStr);
            }
        } catch (Exception e) {
            System.out.println("pickupTime null hoặc sai định dạng, bỏ qua");
        }
        String returnStr = request.getParameter("returnTime");
        LocalDate returnTime = null;
        try {
            if (returnStr != null && !returnStr.isEmpty()) {
                returnTime = LocalDate.parse(returnStr);
            }
        } catch (Exception e) {
            System.out.println("returnTime null hoặc sai định dạng, bỏ qua");
        }
        String error = null;
        if (pickupTime == null || returnTime == null) {
            error = "Vui lòng nhập đủ ngày nhận và trả xe";
        } else if (returnTime.isBefore(pickupTime)) {
            error = "Ngày trả xe phải sau ngày nhận";
        }
        String location = request.getParameter("local");
        CarDAO carDAO = new CarDAO();
        List<Car> SearchByDate = null;
        HttpSession session = request.getSession();
        if (error == null) {
            SearchByDate = carDAO.getCarByDate(location, pickupTime, returnTime);
            if (SearchByDate.isEmpty()) {
                error = "Không tìm thấy kết quả phù hợp";
            }
        } else {
            SearchByDate = carDAO.getAllCars();
        }
        session.setAttribute("error", error);
        session.setAttribute("pickupTime", pickupTime);
        session.setAttribute("returnTime", returnTime);
        session.setAttribute("SearchByDate", SearchByDate);
        session.setAttribute("FilterCar", SearchByDate);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/car/SearchCar.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
