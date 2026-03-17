package com.example.carrental.model.dao;

import com.example.carrental.model.entity.BankAccount;
import com.example.carrental.model.util.DBConnection;

import java.sql.*;

/**
 * DAO cho bảng bank_accounts (tài khoản ngân hàng của chủ xe).
 */
public class BankAccountDAO {
    private final DBConnection dbConnection = DBConnection.getInstance();

    /** Lấy tài khoản ngân hàng của một chủ xe (lấy bản ghi đầu tiên nếu có nhiều). */
    public BankAccount getByOwnerId(int ownerId) {
        String sql = "SELECT id, owner_id, bank_code, account_number, account_name, branch, is_active FROM bank_accounts WHERE owner_id = ? LIMIT 1";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
            rs.close();
        } catch (SQLException e) {
            System.err.println("BankAccountDAO.getByOwnerId: " + e.getMessage());
        }
        return null;
    }

    /** Thêm mới hoặc cập nhật. Nếu id > 0 thì update, ngược lại insert. */
    public boolean save(BankAccount ba) {
        if (ba.getId() > 0) {
            return update(ba);
        }
        return insert(ba);
    }

    private boolean insert(BankAccount ba) {
        String sql = "INSERT INTO bank_accounts (owner_id, bank_code, account_number, account_name, branch, is_active) VALUES (?,?,?,?,?,?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, ba.getOwnerId());
            ps.setString(2, ba.getBankCode());
            ps.setString(3, ba.getAccountNumber());
            ps.setString(4, ba.getAccountName());
            ps.setString(5, ba.getBranch());
            ps.setInt(6, ba.isActive() ? 1 : 0);
            if (ps.executeUpdate() > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) ba.setId(keys.getInt(1));
                keys.close();
                return true;
            }
        } catch (SQLException e) {
            System.err.println("BankAccountDAO.insert: " + e.getMessage());
        }
        return false;
    }

    private boolean update(BankAccount ba) {
        String sql = "UPDATE bank_accounts SET bank_code=?, account_number=?, account_name=?, branch=?, is_active=? WHERE id=?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ba.getBankCode());
            ps.setString(2, ba.getAccountNumber());
            ps.setString(3, ba.getAccountName());
            ps.setString(4, ba.getBranch());
            ps.setInt(5, ba.isActive() ? 1 : 0);
            ps.setInt(6, ba.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("BankAccountDAO.update: " + e.getMessage());
        }
        return false;
    }

    private BankAccount mapRow(ResultSet rs) throws SQLException {
        BankAccount ba = new BankAccount();
        ba.setId(rs.getInt("id"));
        ba.setOwnerId(rs.getInt("owner_id"));
        ba.setBankCode(rs.getString("bank_code"));
        ba.setAccountNumber(rs.getString("account_number"));
        ba.setAccountName(rs.getString("account_name"));
        ba.setBranch(rs.getString("branch"));
        ba.setActive(rs.getInt("is_active") == 1);
        return ba;
    }
}
