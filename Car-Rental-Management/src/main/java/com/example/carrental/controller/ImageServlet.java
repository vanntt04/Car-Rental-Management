package com.example.carrental.controller;

import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.dao.CarImageDAO;
import com.example.carrental.model.entity.Car;
import com.example.carrental.model.entity.CarImage;
import com.example.carrental.model.entity.User;
import com.example.carrental.model.util.ImageUploadUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@MultipartConfig
@WebServlet("/owner/images/*")
public class ImageServlet extends HttpServlet {

    private CarDAO carDAO;
    private CarImageDAO carImageDAO;

    @Override
    public void init() {
        carDAO = new CarDAO();
        carImageDAO = new CarImageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int carId = Integer.parseInt(request.getPathInfo().substring(1));

        Car car = carDAO.getCarById(carId);
        List<CarImage> images = carImageDAO.getByCarId(carId);

        request.setAttribute("car", car);
        request.setAttribute("images", images);

        request.getRequestDispatcher("/WEB-INF/views/owner/images.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addImage(request, response);
        } else if ("delete".equals(action)) {
            deleteImage(request, response);
        } else if ("primary".equals(action)) {
            setPrimary(request, response);
        }
    }

    private void addImage(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        int carId = Integer.parseInt(request.getParameter("carId"));

        Part file = request.getPart("imageFile");

        String path = ImageUploadUtil.saveCarImage(file, getServletContext());

        List<CarImage> list = carImageDAO.getByCarId(carId);

        CarImage img = new CarImage(carId, path, list.isEmpty(), list.size());

        carImageDAO.add(img);

        response.sendRedirect(request.getContextPath() + "/owner/images/" + carId);
    }

    private void deleteImage(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        CarImage img = carImageDAO.getById(id);

        carImageDAO.delete(id);

        response.sendRedirect(request.getContextPath() + "/owner/images/" + img.getCarId());
    }

    private void setPrimary(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        CarImage img = carImageDAO.getById(id);

        carImageDAO.setPrimary(img.getCarId(), id);

        response.sendRedirect(request.getContextPath() + "/owner/images/" + img.getCarId());
    }
}