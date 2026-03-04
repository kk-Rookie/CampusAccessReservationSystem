package com.example.passcode.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * 数据库连接状态检查控制器
 * 提供数据库连接状态监控功能
 */
@WebServlet("/admin/checkDbConnection")
public class DatabaseStatusServlet extends HttpServlet {

    // 数据库连接信息（与BaseDao保持一致）
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/kqy";
    private static final String USER = "root";
    private static final String PASS = "mysql@123";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 检查登录状态
        if (!checkLogin(request, response)) {
            return;
        }

        // 设置响应类型为JSON
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        
        try {
            // 尝试获取数据库连接
            boolean isConnected = checkDatabaseConnection();
            
            if (isConnected) {
                // 数据库连接成功
                out.print("{\"connected\": true, \"message\": \"数据库连接正常\"}");
                System.out.println("✅ 数据库连接状态检查：连接正常");
            } else {
                // 数据库连接失败
                out.print("{\"connected\": false, \"message\": \"未连接成功\"}");
                System.out.println("❌ 数据库连接状态检查：连接失败");
            }
            
        } catch (Exception e) {
            // 异常情况
            System.err.println("❌ 数据库连接状态检查异常: " + e.getMessage());
            out.print("{\"connected\": false, \"message\": \"未连接成功\", \"error\": \"" + e.getMessage() + "\"}");
        } finally {
            out.flush();
            out.close();
        }
    }

    /**
     * 检查数据库连接状态
     * @return true表示连接成功，false表示连接失败
     */
    private boolean checkDatabaseConnection() {
        Connection conn = null;
        try {
            // 加载JDBC驱动
            Class.forName(JDBC_DRIVER);
            
            // 尝试获取数据库连接
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
            
            // 执行一个简单的查询来验证连接是否有效
            if (conn != null && !conn.isClosed()) {
                // 执行一个轻量级查询来测试连接
                try (var stmt = conn.createStatement();
                     var rs = stmt.executeQuery("SELECT 1")) {
                    return rs.next();
                }
            }
            return false;
            
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC驱动加载失败: " + e.getMessage());
            return false;
        } catch (SQLException e) {
            System.err.println("数据库连接检查失败: " + e.getMessage());
            return false;
        } catch (Exception e) {
            System.err.println("数据库连接检查异常: " + e.getMessage());
            return false;
        } finally {
            // 确保连接被关闭
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("关闭数据库连接时出错: " + e.getMessage());
                }
            }
        }
    }

    /**
     * 检查用户登录状态
     */
    private boolean checkLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            // 如果是AJAX请求，返回JSON错误
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json;charset=UTF-8");
                PrintWriter out = response.getWriter();
                out.print("{\"connected\": false, \"message\": \"未登录\", \"error\": \"用户未登录\"}");
                out.close();
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/login");
            }
            return false;
        }
        return true;
    }
}
