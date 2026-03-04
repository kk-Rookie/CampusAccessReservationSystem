package com.example.demo.service;

import com.example.demo.dao.UserDao;
import com.example.demo.dao.ReservationDao;
import com.example.demo.model.User;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

/**
 * 用户服务类
 */
public class UserService {
    
    private UserDao userDao = new UserDao();
    private ReservationDao reservationDao = new ReservationDao();
    
    /**
     * 获取用户统计信息
     */
    public Map<String, Object> getUserStatistics(String username) throws SQLException {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("用户名不能为空");
        }
        
        Map<String, Object> stats = new HashMap<>();
        
        // 获取总预约数
        int totalReservations = reservationDao.countByUsername(username);
        
        // 获取各状态的预约数
        int approvedReservations = reservationDao.countByUsernameAndStatus(username, "approved");
        int pendingReservations = reservationDao.countByUsernameAndStatus(username, "pending");
        int rejectedReservations = reservationDao.countByUsernameAndStatus(username, "rejected");
        
        stats.put("totalReservations", totalReservations);
        stats.put("approvedReservations", approvedReservations);
        stats.put("pendingReservations", pendingReservations);
        stats.put("rejectedReservations", rejectedReservations);
        stats.put("username", username);
        stats.put("lastUpdateTime", new java.util.Date());
        
        return stats;
    }
    
    /**
     * 获取用户资料
     */
    public User getUserProfile(String username) throws SQLException {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("用户名不能为空");
        }
        
        User user = userDao.findByUsername(username);
        if (user != null) {
            // 清除敏感数据
            user.clearSensitiveData();
        }
        return user;
    }
    
    /**
     * 更新用户资料
     */
    public boolean updateUserProfile(String username, User updatedUser) throws SQLException {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("用户名不能为空");
        }
        
        User existingUser = userDao.findByUsername(username);
        if (existingUser == null) {
            throw new IllegalArgumentException("用户不存在");
        }
        
        // 只允许更新特定字段
        existingUser.setRealName(updatedUser.getRealName());
        existingUser.setEmail(updatedUser.getEmail());
        
        return userDao.update(existingUser);
    }
}
