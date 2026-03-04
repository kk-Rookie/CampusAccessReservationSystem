package com.example.demo.test;

import com.example.demo.dao.UserDao;
import com.example.demo.model.User;
import com.example.demo.util.SM3Util;

/**
 * 登录功能测试
 */
public class LoginTest {
    
    public static void main(String[] args) {
        System.out.println("=== 校园预约系统登录测试 ===");
        
        UserDao userDao = new UserDao();
        
        // 测试数据库连接
        if (!userDao.testConnection()) {
            System.err.println("❌ 数据库连接失败，无法进行测试");
            return;
        }
        
        System.out.println("✅ 数据库连接正常");
        
        // 测试用户登录
        testLogin("20241001001", "123456", userDao);
        testLogin("20241001002", "123456", userDao);
        testLogin("20241001003", "123456", userDao);
        testLogin("20241001001", "wrongpassword", userDao);
        testLogin("99999999999", "123456", userDao);
        
        System.out.println("\n=== 测试完成 ===");
    }
    
    private static void testLogin(String username, String password, UserDao userDao) {
        System.out.println("\n--- 测试登录: " + username + " ---");
        
        try {
            // 查找用户
            User user = userDao.findByUsername(username);
            if (user == null) {
                System.out.println("❌ 用户不存在");
                return;
            }
            
            System.out.println("✅ 找到用户: " + user.getRealName());
            System.out.println("   状态: " + user.getStatus());
            System.out.println("   失败次数: " + user.getLoginAttempts());
            
            // 验证密码
            String inputHash = SM3Util.hash(password);
            String storedHash = user.getPasswordHash();
            boolean passwordMatch = inputHash.equals(storedHash);
            
            System.out.println("   密码验证: " + (passwordMatch ? "✅ 正确" : "❌ 错误"));
            
            if (passwordMatch) {
                System.out.println("🎉 登录成功！");
            } else {
                System.out.println("⚠️  登录失败");
            }
            
        } catch (Exception e) {
            System.err.println("❌ 测试异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
