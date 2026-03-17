package com.example.carrental.model.entity;

/**
 * Entity đại diện tài khoản ngân hàng của chủ xe (nhận thanh toán).
 */
public class BankAccount {
    private int id;
    private int ownerId;
    private String bankCode;
    private String accountNumber;
    private String accountName;
    private String branch;
    private boolean active;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOwnerId() { return ownerId; }
    public void setOwnerId(int ownerId) { this.ownerId = ownerId; }

    public String getBankCode() { return bankCode; }
    public void setBankCode(String bankCode) { this.bankCode = bankCode; }

    public String getAccountNumber() { return accountNumber; }
    public void setAccountNumber(String accountNumber) { this.accountNumber = accountNumber; }

    public String getAccountName() { return accountName; }
    public void setAccountName(String accountName) { this.accountName = accountName; }

    public String getBranch() { return branch; }
    public void setBranch(String branch) { this.branch = branch; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
