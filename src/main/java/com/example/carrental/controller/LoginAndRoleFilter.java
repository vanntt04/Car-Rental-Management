package com.example.carrental.controller;

import com.example.carrental.model.entity.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Trang công khai: home, tìm xe, chi tiết xe, đăng nhập.
 * Còn lại: bắt buộc đăng nhập; /owner dành OWNER/ADMIN; /users dành ADMIN;
 * đặt xe / thanh toán / hóa đơn… dành CUSTOMER.
 */
@WebFilter(filterName = "LoginAndRoleFilter", urlPatterns = "/*")
public class LoginAndRoleFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String ctx = request.getContextPath();
        String uri = request.getRequestURI();
        String path = uri.startsWith(ctx) ? uri.substring(ctx.length()) : uri;
        if (path.isEmpty()) path = "/";

        if (isPublicPath(path)) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) {
            sendLoginRedirect(request, response);
            return;
        }

        String role = user.getRole() != null ? user.getRole().trim().toUpperCase() : "";

        if (path.startsWith("/owner")) {
            if (!"OWNER".equals(role) && !"ADMIN".equals(role)) {
                response.sendRedirect(ctx + "/home");
                return;
            }
        }

        if (path.startsWith("/users")) {
            if (!"ADMIN".equals(role)) {
                response.sendRedirect(ctx + "/home");
                return;
            }
        }

        if (isCustomerOnlyPath(path)) {
            if (!"CUSTOMER".equals(role)) {
                response.sendRedirect(ctx + "/home");
                return;
            }
        }

        chain.doFilter(req, res);
    }

    private static boolean isPublicPath(String path) {
        if ("/".equals(path) || "/index.jsp".equals(path)) return true;
        if (path.startsWith("/assets/") || path.startsWith("/uploads/")) return true;
        if ("/login".equals(path) || "/logout".equals(path)) return true;
        if ("/home".equals(path)) return true;
        if ("/searchcar".equals(path)) return true;
        if ("/cars".equals(path)) return true;
        if ("/filter".equals(path)) return true;
        int slash = path.lastIndexOf('/');
        String name = slash >= 0 ? path.substring(slash + 1) : path;
        if (name.contains(".")) {
            String lower = name.toLowerCase();
            if (lower.endsWith(".css") || lower.endsWith(".js") || lower.endsWith(".ico")
                    || lower.endsWith(".png") || lower.endsWith(".jpg") || lower.endsWith(".jpeg")
                    || lower.endsWith(".gif") || lower.endsWith(".webp") || lower.endsWith(".svg")
                    || lower.endsWith(".woff") || lower.endsWith(".woff2") || lower.endsWith(".ttf")) {
                return true;
            }
        }
        return false;
    }

    private static boolean isCustomerOnlyPath(String path) {
        return "/booking".equals(path)
                || "/mybooking".equals(path)
                || "/pay".equals(path)
                || "/invoice".equals(path)
                || "/receipt".equals(path)
                || "/remove".equals(path);
    }

    private static void sendLoginRedirect(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String ctx = request.getContextPath();
        StringBuilder target = new StringBuilder(request.getRequestURI());
        String q = request.getQueryString();
        if (q != null) target.append('?').append(q);
        String enc = URLEncoder.encode(target.toString(), StandardCharsets.UTF_8);
        response.sendRedirect(ctx + "/login?redirect=" + enc);
    }
}
