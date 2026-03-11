package com.example.carrental.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "PageServlet", urlPatterns = {"/about", "/policy"})
public class PageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/about".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/static/about.jsp").forward(request, response);
            return;
        }
        if ("/policy".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/static/policy.jsp").forward(request, response);
            return;
        }
        response.sendError(HttpServletResponse.SC_NOT_FOUND);
    }
}
