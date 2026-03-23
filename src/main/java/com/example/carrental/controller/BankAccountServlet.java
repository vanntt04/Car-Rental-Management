package com.example.carrental.controller;

import com.example.carrental.model.dao.BankAccountDAO;
import com.example.carrental.model.entity.BankAccount;
import com.example.carrental.model.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet quản lý tài khoản ngân hàng của chủ xe (owner).
 * URL: /owner/bank-account
 */
@WebServlet(name = "BankAccountServlet", urlPatterns = "/owner/bank-account")
public class BankAccountServlet extends HttpServlet {

    private BankAccountDAO bankAccountDAO;

    @Override
    public void init() {
        bankAccountDAO = new BankAccountDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        showForm(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        saveBankAccount(request, response);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        BankAccount bank = bankAccountDAO.getByOwnerId(user.getId());
        if (bank == null) {
            bank = new BankAccount();
            bank.setOwnerId(user.getId());
            bank.setActive(true);
        }
        request.setAttribute("bankAccount", bank);
        request.getRequestDispatcher("/WEB-INF/views/owner/bank-account.jsp").forward(request, response);
    }

    private void saveBankAccount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String bankCode = request.getParameter("bankCode");
        String accountNumber = request.getParameter("accountNumber");
        String accountName = request.getParameter("accountName");
        String branch = request.getParameter("branch");

        if (bankCode == null || bankCode.trim().isEmpty()) {
            request.setAttribute("error", "Mã ngân hàng không được để trống");
            forwardFormWithParams(request, response, user.getId(), bankCode, accountNumber, accountName, branch);
            return;
        }
        if (accountNumber == null || accountNumber.trim().isEmpty()) {
            request.setAttribute("error", "Số tài khoản không được để trống");
            forwardFormWithParams(request, response, user.getId(), bankCode, accountNumber, accountName, branch);
            return;
        }
        if (accountName == null || accountName.trim().isEmpty()) {
            request.setAttribute("error", "Tên chủ tài khoản không được để trống");
            forwardFormWithParams(request, response, user.getId(), bankCode, accountNumber, accountName, branch);
            return;
        }

        BankAccount ba = bankAccountDAO.getByOwnerId(user.getId());
        if (ba == null) {
            ba = new BankAccount();
            ba.setOwnerId(user.getId());
            ba.setActive(true);
        }
        ba.setBankCode(bankCode.trim());
        ba.setAccountNumber(accountNumber.trim());
        ba.setAccountName(accountName.trim());
        ba.setBranch(branch != null ? branch.trim() : "");

        if (bankAccountDAO.save(ba)) {
            response.sendRedirect(request.getContextPath() + "/owner/bank-account?success=saved");
        } else {
            request.setAttribute("error", "Lưu thất bại. Vui lòng thử lại.");
            request.setAttribute("bankAccount", ba);
            request.getRequestDispatcher("/WEB-INF/views/owner/bank-account.jsp").forward(request, response);
        }
    }

    private void forwardFormWithParams(HttpServletRequest request, HttpServletResponse response, int ownerId,
            String bankCode, String accountNumber, String accountName, String branch) throws ServletException, IOException {
        BankAccount ba = new BankAccount();
        ba.setOwnerId(ownerId);
        ba.setBankCode(bankCode != null ? bankCode : "");
        ba.setAccountNumber(accountNumber != null ? accountNumber : "");
        ba.setAccountName(accountName != null ? accountName : "");
        ba.setBranch(branch != null ? branch : "");
        ba.setActive(true);
        request.setAttribute("bankAccount", ba);
        request.getRequestDispatcher("/WEB-INF/views/owner/bank-account.jsp").forward(request, response);
    }
}
