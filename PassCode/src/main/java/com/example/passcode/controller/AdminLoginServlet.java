// filepath: /Users/xueshizhuo/Documents/all_实验/javaweb/302023315371_薛世卓_javaweb—DAO实验/passcode/src/main/java/com/example/passcode/controller/AdminLoginServlet.java
package com.example.passcode.controller;

import com.example.passcode.dao.AdminDao;
import com.example.passcode.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 管理员登录控制器
 * 处理管理员登录和登出功能
 */
@WebServlet({"/admin/login", "/admin/logout"})
public class AdminLoginServlet extends HttpServlet {

    private final AdminDao adminDao = new AdminDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if ("/admin/logout".equals(servletPath)) {
            // 处理登出
            handleLogout(request, response);
        } else {
            // 显示登录页面
            showLoginPage(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 处理登录表单提交
        handleLogin(request, response);
    }

    /**
     * 显示登录页面
     */
    private void showLoginPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 如果已经登录，直接跳转到仪表盘
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("admin") != null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(request, response);
    }

    /**
     * 处理登录逻辑
     */
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String loginName = request.getParameter("loginName");
        String password = request.getParameter("password");

        System.out.println("========== 登录请求 ==========");
        System.out.println("接收到的登录名: " + loginName);
        System.out.println("密码是否为空: " + (password == null || password.isEmpty()));

        // 参数验证
        if (loginName == null || loginName.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            System.out.println("❌ 参数验证失败: 登录名或密码为空");
            request.setAttribute("error", "登录名和密码不能为空");
            request.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(request, response);
            return;
        }

        // 验证登录
        Admin admin = adminDao.login(loginName.trim(), password);

        if (admin != null) {
            // 登录成功，创建会话
            HttpSession session = request.getSession();
            session.setAttribute("admin", admin);
            session.setMaxInactiveInterval(30 * 60); // 30分钟超时

            // 记录登录日志
            System.out.println("🎉 管理员登录成功: " + admin.getName() + " (" + admin.getLoginName() + ")");
            System.out.println("重定向到: " + request.getContextPath() + "/admin/dashboard");

            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            // 登录失败
            System.out.println("❌ 登录失败: 用户名或密码错误");
            request.setAttribute("error", "用户名或密码错误");
            request.setAttribute("loginName", loginName); // 保留用户输入的登录名
            request.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(request, response);
        }
        System.out.println("=============================");
    }

    /**
     * 处理登出逻辑
     */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Admin admin = (Admin) session.getAttribute("admin");
            if (admin != null) {
                System.out.println("管理员登出: " + admin.getName() + " (" + admin.getLoginName() + ")");
            }
            session.invalidate();
        }

        response.sendRedirect(request.getContextPath() + "/admin/login?message=logout");
    }
}