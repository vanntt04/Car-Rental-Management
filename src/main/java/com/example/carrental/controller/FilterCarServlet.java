/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.example.carrental.controller;

import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.entity.Car;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author PC
 */
public class FilterCarServlet extends HttpServlet {

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
            out.println("<title>Servlet FilterCarServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FilterCarServlet at " + request.getContextPath() + "</h1>");
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

        HttpSession session = request.getSession(true);
        String brand = request.getParameter("brand");
        String price = request.getParameter("price");

        // Lấy danh sách nguồn
        List<Car> sourceList = (List<Car>) session.getAttribute("SearchByDate");
        if (sourceList == null || sourceList.isEmpty()) {
            sourceList = (List<Car>) session.getAttribute("CarList");
        }

        if (sourceList == null) {
            CarDAO carDAO = new CarDAO();
            sourceList = carDAO.getAllCars(); // load từ DB nếu chưa có
            session.setAttribute("CarList", sourceList);
        }

        List<Car> result = sourceList;
        CarDAO carDAO = new CarDAO();


        if (brand != null && !brand.isEmpty() && (price == null || price.isEmpty())) {
            result = carDAO.filterCarByBrand(brand, result);
        }

        if (price != null && !price.isEmpty() && (brand == null || brand.isEmpty())) {
            try {
                String[] parts = price.split("-");
                int minPrice = Integer.parseInt(parts[0].trim());
                int maxPrice = Integer.parseInt(parts[1].trim());
                result = carDAO.filterCarByPrice(minPrice, maxPrice, result);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if (brand != null && !brand.isEmpty() && price != null && !price.isEmpty()) {
            try {
                String[] parts = price.split("-");
                int minPrice = Integer.parseInt(parts[0].trim());
                int maxPrice = Integer.parseInt(parts[1].trim());
                result = carDAO.filterCar(brand, minPrice, maxPrice, result); // phương thức filter cả 2
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Lưu vào session để JSP có thể dùng
        request.setAttribute("FilterCar", result);

        // Chuyển tiếp sang JSP
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
