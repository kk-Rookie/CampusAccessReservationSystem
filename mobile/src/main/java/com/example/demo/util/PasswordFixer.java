package com.example.demo.util;

import com.example.demo.dao.BaseDao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * 密码修复工具 - 更新服务器数据库中的测试用户密码哈希
 */
public class PasswordFixer extends BaseDao {
    
    public static void main(String[] args) {
        PasswordFixer fixer = new PasswordFixer();
        
        System.out.println("=== 密码修复工具启动 ===");
        
        // 1. 测试数据库连接
        if (!fixer.testConnection()) {
            System.err.println("❌ 数据库连接失败，无法继续");
            return;
        }
        
        // 2. 生成正确的密码哈希
        String password = "123456";
        String correctHash = SM3Util.hash(password);
        System.out.println("🔐 密码: " + password);
        System.out.println("🔑 SM3哈希: " + correctHash);
        
        // 3. 检查现有用户
        fixer.checkExistingUsers();
        
        // 4. 更新密码哈希
        fixer.updatePasswordHashes(correctHash);
        
        // 5. 验证更新结果
        fixer.verifyUpdate();
        
        System.out.println("=== 密码修复完成 ===");
    }
    
    /**
     * 检查现有用户数据
     */
    private void checkExistingUsers() {
        System.out.println("\n=== 检查现有用户 ===");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            String sql = "SELECT username, SUBSTRING(password_hash, 1, 20) as hash_prefix, status, real_name " +
                        "FROM users WHERE username LIKE '2024%' ORDER BY username";
            
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            System.out.println("📋 现有用户列表:");
            while (rs.next()) {
                System.out.printf("  %-12s | %-20s | %-8s | %s%n", 
                    rs.getString("username"),
                    rs.getString("hash_prefix") + "...",
                    rs.getString("status"),
                    rs.getString("real_name"));
            }
            
        } catch (SQLException e) {
            System.err.println("❌ 检查用户失败: " + e.getMessage());
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }
    
    /**
     * 更新密码哈希
     */
    private void updatePasswordHashes(String correctHash) {
        System.out.println("\n=== 更新密码哈希 ===");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = getConnection();
            String sql = "UPDATE users SET password_hash = ? WHERE username IN (?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, correctHash);
            pstmt.setString(2, "20241001001");
            pstmt.setString(3, "20241001002");
            pstmt.setString(4, "20241001003");
            pstmt.setString(5, "20241001004");
            pstmt.setString(6, "20241001005");
            
            int rowsUpdated = pstmt.executeUpdate();
            System.out.println("✅ 成功更新 " + rowsUpdated + " 个用户的密码哈希");
            
        } catch (SQLException e) {
            System.err.println("❌ 更新密码哈希失败: " + e.getMessage());
        } finally {
            closeResources(pstmt, conn);
        }
    }
    
    /**
     * 验证更新结果
     */
    private void verifyUpdate() {
        System.out.println("\n=== 验证更新结果 ===");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            String sql = "SELECT username, password_hash, status FROM users " +
                        "WHERE username IN ('20241001001', '20241001002', '20241001003', '20241001004', '20241001005') " +
                        "ORDER BY username";
            
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            String expectedHash = SM3Util.hash("123456");
            int correctCount = 0;
            
            System.out.println("📊 验证结果:");
            while (rs.next()) {
                String username = rs.getString("username");
                String hash = rs.getString("password_hash");
                String status = rs.getString("status");
                boolean isCorrect = expectedHash.equals(hash);
                
                System.out.printf("  %-12s | %s | %-8s | %s%n", 
                    username,
                    hash.substring(0, 20) + "...",
                    status,
                    isCorrect ? "✅ 正确" : "❌ 错误");
                
                if (isCorrect) correctCount++;
            }
            
            System.out.println("📈 统计: " + correctCount + "/5 个用户密码哈希正确");
            
            if (correctCount == 5) {
                System.out.println("🎉 所有测试用户密码哈希已正确更新！");
            } else {
                System.out.println("⚠️  仍有用户密码哈希不正确，请检查");
            }
            
        } catch (SQLException e) {
            System.err.println("❌ 验证更新结果失败: " + e.getMessage());
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }
}
