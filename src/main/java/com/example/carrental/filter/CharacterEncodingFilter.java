package com.example.carrental.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;

import java.io.IOException;

/**
 * Filter đặt encoding UTF-8 cho mọi request/response để hiển thị đúng tiếng Việt.
 * Phải gọi setCharacterEncoding TRƯỚC khi đọc parameter từ request.
 */
public class CharacterEncodingFilter implements Filter {

    private String encoding = "UTF-8";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        try {
            if (filterConfig != null) {
                String enc = filterConfig.getInitParameter("encoding");
                if (enc != null && !enc.isEmpty()) {
                    encoding = enc;
                }
            }
        } catch (Exception e) {
            System.err.println("CharacterEncodingFilter init error: " + e.getMessage());
            // Không throw - giữ encoding mặc định UTF-8
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        request.setCharacterEncoding(encoding);
        response.setCharacterEncoding(encoding);
        chain.doFilter(request, response);
    }
}
