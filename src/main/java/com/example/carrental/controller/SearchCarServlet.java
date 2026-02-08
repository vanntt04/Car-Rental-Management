/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.example.carrental.controller;

import com.example.carrental.model.entity.Car;
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
public class SearchCarServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<h1>Servlet SearchCarServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
         HttpSession session = request.getSession();

        List<Car> searchResults = (List<Car>) session.getAttribute("searchResults");
        String searchQuery = (String) session.getAttribute("searchQuery");
        String error = (String) session.getAttribute("error");

        try {
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);

            List<BouquetTemplate> featuredBouquets = bouquetDAO.getAllBouquets(); // Cho slider
            request.setAttribute("featuredBouquets", featuredBouquets);

            List<BouquetTemplate> bouquets;
            String pageType;

            // Phân trang: lấy page từ request, mặc định pageNum = 1
            String pageStr = request.getParameter("pageNum");
            int page = 1;
            if (pageStr != null) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) {
                        page = 1;
                    }
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            int pageSize = 12; // số sản phẩm mỗi trang, bạn tùy chỉnh

            String categoryIdStr = request.getParameter("categoryId");
            int totalItems = 0;
            int totalPages = 0;

            if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                pageType = "category";
                try {
                    int categoryId = Integer.parseInt(categoryIdStr);
                    totalItems = bouquetDAO.countBouquetsByCategory(categoryId);
                    totalPages = (int) Math.ceil((double) totalItems / pageSize);
                    if (page > totalPages) {
                        page = totalPages;
                    }

                    int offset = (page - 1) * pageSize;
                    bouquets = bouquetDAO.getBouquetsByCategoryIdPaging(categoryId, offset, pageSize);
                } catch (NumberFormatException e) {
                    bouquets = bouquetDAO.getAllBouquetsPaging((page - 1) * pageSize, pageSize);
                    pageType = "home";
                    totalItems = bouquetDAO.countAllBouquets();
                    totalPages = (int) Math.ceil((double) totalItems / pageSize);
                }
            } else if (searchResults != null) {
                pageType = "search";
                bouquets = searchResults; // Có thể cần phân trang cho search tùy trường hợp
                request.setAttribute("searchQuery", searchQuery);
                totalItems = bouquets.size();
                totalPages = 1; // hoặc tùy logic nếu search có phân trang
            } else {
                pageType = "home";
                totalItems = bouquetDAO.countAllBouquets();
                totalPages = (int) Math.ceil((double) totalItems / pageSize);
                if (page > totalPages) {
                    page = totalPages;
                }
                int offset = (page - 1) * pageSize;
                bouquets = bouquetDAO.getAllBouquetsPaging(offset, pageSize);
            }

            request.setAttribute("bouquets", bouquets);
            request.setAttribute("page", pageType);

            // Truyền thông tin phân trang cho JSP
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            if (error != null) {
                request.setAttribute("error", error);
            }

            session.removeAttribute("searchResults");
            session.removeAttribute("searchQuery");
            session.removeAttribute("error");

            request.getRequestDispatcher("index.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi tải trang chủ. Vui lòng thử lại.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }


    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
