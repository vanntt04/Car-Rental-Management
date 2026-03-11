package com.example.carrental.controller;

import com.example.carrental.model.util.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class ForgetPassServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/WEB-INF/views/auth/forget_password.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String otp = generateOTP();
        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("email", email);
        session.setAttribute("otpExpireTime",
                System.currentTimeMillis() + 5 * 60 * 1000);
        EmailUtil.sendEmail(
                email,
                "Mã xác nhận đặt lại mật khẩu",
                "Mã OTP của bạn là: " + otp + "\nCó hiệu lực trong 5 phút."
        );
        response.sendRedirect(
                request.getContextPath() + "/verify_code"
        );
    }

    private String generateOTP() {
        return String.valueOf((int) (Math.random() * 900000) + 100000);
    }
}
