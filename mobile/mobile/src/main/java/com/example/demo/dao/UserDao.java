package com.example.demo.dao;

import com.example.demo.model.User;
import com.example.demo.util.SM3Util;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 用户数据访问类
 */
public class UserDao extends BaseDao {
    
    /**
     * 保存用户 - 用于注册功能
     */
    public boolean save(User user) throws SQLException {
        try {
            Long userId = createUser(user);
            user.setId(userId);
            return userId != null && userId > 0;
        } catch (SQLException e) {
            System.err.println("保存用户失败: " + e.getMessage());
            throw e;
        }
    }
    
    /**
     * 创建用户
     */
    public Long createUser(User user) throws SQLException {
        String sql = "INSERT INTO users (username, phone, password_hash, phone_encrypted, phone_hash, " +
                    "real_name, id_card_encrypted, id_card_hash, status, email, avatar_url, " +
                    "login_attempts, last_login_time, last_login_ip, password_expire_time, " +
                    "create_time, update_time, data_integrity) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        // 计算数据完整性哈希
        String dataIntegrity = SM3Util.hash(user.getUsername() + user.getPhoneHash() + 
                                          user.getPasswordHash() + System.currentTimeMillis());
        user.setDataIntegrity(dataIntegrity);
        
        Long userId = executeUpdateWithGeneratedKey(sql,
            user.getUsername(),
            user.getPhone(),
            user.getPasswordHash(),
            user.getPhoneEncrypted(),
            user.getPhoneHash(),
            user.getRealName(),
            user.getIdCardEncrypted(),
            user.getIdCardHash(),
            user.getStatus(),
            user.getEmail(),
            user.getAvatarUrl(),
            user.getLoginAttempts(),
            user.getLastLoginTime(),
            user.getLastLoginIp(),
            user.getPasswordExpireTime(),
            new java.util.Date(),
            new java.util.Date(),
            dataIntegrity
        );
        
        // 记录数据访问日志
        logDataAccess("users", userId, "insert", 
                     "phone_encrypted,id_card_encrypted", 
                     user.getUsername(), user.getIdCardHash(), 
                     "", true);
        
        return userId;
    }
    
    /**
     * 根据用户名查找用户
     */
    public User findByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = ? AND status = 'active'";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    User user = mapResultSetToUser(rs);
                    
                    // 记录数据访问日志
                    logDataAccess("users", user.getId(), "select", 
                                 "phone_encrypted,id_card_encrypted", 
                                 username, user.getIdCardHash(), 
                                 "", true);
                    
                    return user;
                }
            }
        }
        return null;
    }
    
    /**
     * 根据手机号哈希查找用户
     */
    public User findByPhoneHash(String phoneHash) throws SQLException {
        String sql = "SELECT * FROM users WHERE phone_hash = ? AND status = 'active'";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, phoneHash);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        return null;
    }
    
    /**
     * 更新最后登录信息（通过username）
     */
    public int updateLastLoginByUsername(String username, String ip) throws SQLException {
        String sql = "UPDATE users SET last_login_time = ?, last_login_ip = ?, " +
                    "login_attempts = 0, update_time = ? WHERE username = ?";
        return executeUpdate(sql, new java.util.Date(), ip, new java.util.Date(), username);
    }
    
    /**
     * 增加登录失败次数
     */
    public int incrementLoginAttempts(String username) throws SQLException {
        String sql = "UPDATE users SET login_attempts = login_attempts + 1, update_time = ? " +
                    "WHERE username = ?";
        
        return executeUpdate(sql, new java.util.Date(), username);
    }
    
    /**
     * 锁定用户账户
     */
    public int lockUser(String username) throws SQLException {
        String sql = "UPDATE users SET status = 'locked', update_time = ? WHERE username = ?";
        return executeUpdate(sql, new java.util.Date(), username);
    }
    
    /**
     * 根据用户ID查找用户
     */
    public User findById(Long id) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        return null;
    }
    
    /**
     * 检查用户名是否存在
     */
    public boolean usernameExists(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
    
    /**
     * 检查手机号是否存在
     */
    public boolean phoneExists(String phone) throws SQLException {
        String phoneHash = SM3Util.hash(phone);
        String sql = "SELECT COUNT(*) FROM users WHERE phone_hash = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, phoneHash);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
    
    /**
     * 根据手机号查找用户 - 修复版本
     */
    public User findByPhone(String phone) throws SQLException {
        // 使用哈希值查找，保持与数据库设计一致
        String phoneHash = SM3Util.hash(phone);
        String sql = "SELECT * FROM users WHERE phone_hash = ? AND status = 'active'";
        
        try (Connection conn = getConnection();  // 使用继承的方法
             PreparedStatement stmt = conn.prepareStatement(sql)) {
        
            stmt.setString(1, phoneHash);
        
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = mapResultSetToUser(rs);
                
                    // 记录数据访问日志
                    logDataAccess("users", user.getId(), "select", 
                                 "phone_encrypted,id_card_encrypted", 
                                 phone, user.getIdCardHash(), 
                                 "", true);
                
                    return user;
                }
            }
        }
    
        return null;
    }
    
    /**
     * 管理员获取用户列表
     */
    public List<User> findUsersForAdmin(String keyword, String status) throws SQLException {
        List<User> users = new ArrayList<>();
    
        StringBuilder sql = new StringBuilder(
            "SELECT id, username, real_name, phone, status, login_attempts, " +
            "create_time, last_login_time FROM users WHERE 1=1"
        );
    
        List<Object> params = new ArrayList<>();
    
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (username LIKE ? OR phone LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
    
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND status = ?");
            params.add(status);
        }
    
        sql.append(" ORDER BY create_time DESC");
    
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
        
            for (int i = 0; i < params.size(); i++) {
                setPreparedStatementParameter(stmt, i + 1, params.get(i));
            }
        
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setId(rs.getLong("id"));
                    user.setUsername(rs.getString("username"));
                    user.setRealName(rs.getString("real_name"));
                    user.setPhone(rs.getString("phone"));
                    user.setStatus(rs.getString("status"));
                    user.setLoginAttempts(rs.getInt("login_attempts"));
                    user.setCreateTime(rs.getTimestamp("create_time"));
                    user.setLastLoginTime(rs.getTimestamp("last_login_time"));
                
                    users.add(user);
                }
            }
        }
    
        return users;
    }
    
    /**
     * 管理员更新用户密码（通过username）
     */
    public boolean updatePasswordByAdminByUsername(String username, String passwordHash) throws SQLException {
        String sql = "UPDATE users SET password_hash = ?, update_time = ? WHERE username = ?";
        int rowsAffected = executeUpdate(sql, passwordHash, new java.util.Date(), username);
        return rowsAffected > 0;
    }
    
    /**
     * 更新用户状态（通过username）
     */
    public boolean updateUserStatusByUsername(String username, String status) throws SQLException {
        String sql = "UPDATE users SET status = ?, update_time = ? WHERE username = ?";
        int rowsAffected = executeUpdate(sql, status, new java.util.Date(), username);
        return rowsAffected > 0;
    }
    
    /**
     * 重置登录失败次数（通过username）
     */
    public boolean resetLoginAttemptsByUsername(String username) throws SQLException {
        String sql = "UPDATE users SET login_attempts = 0, update_time = ? WHERE username = ?";
        int rowsAffected = executeUpdate(sql, new java.util.Date(), username);
        return rowsAffected > 0;
    }
    
    /**
     * 修复 mapResultSetToUser 方法 - 添加密码哈希字段
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getLong("id"));
        user.setUsername(rs.getString("username"));
        user.setPhone(rs.getString("phone")); // 这里是脱敏的手机号
        user.setRealName(rs.getString("real_name"));
        user.setStatus(rs.getString("status"));
        user.setEmail(rs.getString("email"));
        user.setAvatarUrl(rs.getString("avatar_url"));
        user.setLoginAttempts(rs.getInt("login_attempts"));
        user.setLastLoginTime(rs.getTimestamp("last_login_time"));
        user.setLastLoginIp(rs.getString("last_login_ip"));
        user.setCreateTime(rs.getTimestamp("create_time"));
        user.setUpdateTime(rs.getTimestamp("update_time"));
        user.setDataIntegrity(rs.getString("data_integrity"));
    
        // 添加密码哈希字段 - 用于登录验证
        user.setPasswordHash(rs.getString("password_hash"));
    
        // 注意：出于安全考虑，不设置敏感数据的解密值
        return user;
    }
    
    /**
     * 更新用户信息
     */
    public boolean update(User user) throws SQLException {
        String sql = "UPDATE users SET real_name = ?, email = ?, phone = ?, phone_encrypted = ?, " +
                    "phone_hash = ?, avatar_url = ?, status = ?, update_time = CURRENT_TIMESTAMP, " +
                    "data_integrity = ? WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user.getRealName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPhone());
            pstmt.setString(4, user.getPhoneEncrypted());
            pstmt.setString(5, user.getPhoneHash());
            pstmt.setString(6, user.getAvatarUrl());
            pstmt.setString(7, user.getStatus());
            pstmt.setString(8, user.getDataIntegrity());
            pstmt.setLong(9, user.getId());
            
            int rowsUpdated = pstmt.executeUpdate();
            return rowsUpdated > 0;
            
        } finally {
            closeResources(null, pstmt, conn);
        }
    }
}