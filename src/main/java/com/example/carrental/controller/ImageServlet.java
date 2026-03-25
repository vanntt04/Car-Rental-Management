package com.example.carrental.controller;

import com.example.carrental.model.dao.CarDAO;
import com.example.carrental.model.dao.CarImageDAO;
import com.example.carrental.model.entity.Car;
import com.example.carrental.model.entity.CarImage;
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
        List<CarImage> list = carImageDAO.getByCarId(carId);
        int added = 0;

        for (Part part : request.getParts()) {
            if (!"imageFile".equals(part.getName()) || part.getSize() == 0) continue;
            String path = ImageUploadUtil.saveCarImage(part, getServletContext());
            if (path != null) {
                boolean isFirst = list.isEmpty() && added == 0;
                CarImage img = new CarImage(carId, path, isFirst, list.size() + added);
                carImageDAO.add(img);
                if (isFirst) {
                    carDAO.updateCarImageUrl(carId, path);
                }
                added++;
            }
        }

        response.sendRedirect(request.getContextPath() + "/owner/images/" + carId);
    }

    private void deleteImage(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        CarImage img = carImageDAO.getById(id);
        if (img == null) {
            response.sendRedirect(request.getContextPath() + "/owner");
            return;
        }
        int carId = img.getCarId();
        boolean wasPrimary = img.isPrimary();

        carImageDAO.delete(id);

        if (wasPrimary) {
            List<CarImage> remaining = carImageDAO.getByCarId(carId);
            if (!remaining.isEmpty()) {
                CarImage next = remaining.get(0);
                carImageDAO.setPrimary(carId, next.getId());
                carDAO.updateCarImageUrl(carId, next.getImageUrl());
            } else {
                carDAO.updateCarImageUrl(carId, null);
            }
        }

        response.sendRedirect(request.getContextPath() + "/owner/images/" + carId);
    }

    private void setPrimary(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        CarImage img = carImageDAO.getById(id);
        if (img == null) {
            response.sendRedirect(request.getContextPath() + "/owner");
            return;
        }

        carImageDAO.setPrimary(img.getCarId(), id);
        carDAO.updateCarImageUrl(img.getCarId(), img.getImageUrl());

        response.sendRedirect(request.getContextPath() + "/owner/images/" + img.getCarId());
    }
}