<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%
    // Trang khởi đầu: điều hướng về controller HomeServlet
    response.sendRedirect(request.getContextPath() + "/home");
%>