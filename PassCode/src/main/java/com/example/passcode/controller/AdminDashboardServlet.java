package com.example.passcode.controller;

import com.example.passcode.dao.AdminDao;
import com.example.passcode.dao.DepartmentDao;
import com.example.passcode.dao.ReservationDao;
import com.example.passcode.model.Reservation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * 管理员仪表盘控制器
 * 显示系统主要统计信息和导航菜单
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private AdminDao adminDao = new AdminDao();
    private DepartmentDao departmentDao = new DepartmentDao();
    private ReservationDao reservationDao = new ReservationDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 检查登录状态
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // 获取统计数据
        try {
            // 基础统计
            int departmentCount = departmentDao.getDepartmentCount();
            int adminCount = adminDao.getTotalAdminCount();
            
            // 预约统计
            int totalReservations = reservationDao.getTotalReservationCount();
            int pendingReservations = reservationDao.getReservationCountByStatus("pending");
            int approvedReservations = reservationDao.getReservationCountByStatus("approved");
            int rejectedReservations = reservationDao.getReservationCountByStatus("rejected");
            
            // 计算通过率
            int approvalRate = totalReservations > 0 ? (approvedReservations * 100 / totalReservations) : 0;
            
            // 获取最近预约记录
            List<Reservation> recentReservations = reservationDao.getRecentReservations(10);
            
            // 部门相关统计
            int activeDepartments = departmentDao.getActiveDepartmentCount();
            int monthlyNewReservations = reservationDao.getMonthlyNewReservations();

            // 设置属性
            request.setAttribute("totalDepartments", departmentCount);
            request.setAttribute("activeDepartments", activeDepartments);
            request.setAttribute("totalManagers", adminCount);
            request.setAttribute("totalReservations", totalReservations);
            request.setAttribute("pendingReservations", pendingReservations);
            request.setAttribute("approvedReservations", approvedReservations);
            request.setAttribute("rejectedReservations", rejectedReservations);
            request.setAttribute("approvalRate", approvalRate);
            request.setAttribute("monthlyNewReservations", monthlyNewReservations);
            request.setAttribute("recentReservations", recentReservations);

        } catch (Exception e) {
            System.err.println("获取统计数据时发生错误: " + e.getMessage());
            e.printStackTrace();
            // 即使获取统计数据失败，也设置默认值避免JSP中的null值错误
            request.setAttribute("totalDepartments", 0);
            request.setAttribute("activeDepartments", 0);
            request.setAttribute("totalManagers", 0);
            request.setAttribute("totalReservations", 0);
            request.setAttribute("pendingReservations", 0);
            request.setAttribute("approvedReservations", 0);
            request.setAttribute("rejectedReservations", 0);
            request.setAttribute("approvalRate", 0);
            request.setAttribute("monthlyNewReservations", 0);
            request.setAttribute("recentReservations", java.util.Collections.emptyList());
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 仪表盘页面通常不处理POST请求，重定向到GET
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}