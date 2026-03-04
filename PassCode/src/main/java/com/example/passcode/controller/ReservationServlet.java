package com.example.passcode.controller;

import com.example.passcode.dao.ReservationDao;
import com.example.passcode.dao.DepartmentDao;
import com.example.passcode.model.Reservation;
import com.example.passcode.model.ReservationPage;
import com.example.passcode.model.Admin;
import com.example.passcode.model.Department;
import com.example.passcode.util.AdminPermissionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.ArrayList;

/**
 * 预约管理控制器
 * 处理预约的查询、审核和统计功能
 */
@WebServlet("/admin/reservation/*")
public class ReservationServlet extends HttpServlet {

    private ReservationDao reservationDao = new ReservationDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 检查登录状态
        if (!checkLogin(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
            // 预约列表页面
            handleList(request, response);
        } else if (pathInfo.equals("/audit")) {
            // 预约审核页面
            handleAuditList(request, response);
        } else if (pathInfo.startsWith("/audit/")) {
            // 预约审核详情页面
            handleAuditDetail(request, response);
        } else if (pathInfo.startsWith("/view/")) {
            // 查看预约详情
            handleView(request, response);
        } else if (pathInfo.equals("/statistics")) {
            // 统计页面
            handleStatistics(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/reservation/list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 检查登录状态
        if (!checkLogin(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");
        
        if (pathInfo != null && pathInfo.startsWith("/audit/")) {
            // 处理审核操作
            handleAudit(request, response);
        } else if ("revoke".equals(action)) {
            // 处理撤销操作
            handleRevoke(request, response);
        } else if ("changeStatus".equals(action)) {
            // 处理状态修改操作
            handleChangeStatus(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/reservation/list");
        }
    }

    /**
     * 检查登录状态
     */
    private boolean checkLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return false;
        }
        return true;
    }

    /**
     * 处理预约列表页面
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 获取当前登录的管理员信息
            HttpSession session = request.getSession();
            Admin currentAdmin = (Admin) session.getAttribute("admin");
            
            // 检查管理员权限
            if (currentAdmin == null) {
                response.sendRedirect(request.getContextPath() + "/admin/login");
                return;
            }

            // 获取查询参数
            String campus = request.getParameter("campus");
            String reservationType = request.getParameter("reservationType");
            String status = request.getParameter("status");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String applicationDateStr = request.getParameter("applicationDate");
            String name = request.getParameter("name");  // 申请人姓名
            String idNumber = request.getParameter("idNumber");  // 学号/工号
            String departmentIdStr = request.getParameter("departmentId");  // 部门ID

            // 转换日期参数
            Date startDate = null;
            Date endDate = null;
            if (startDateStr != null && !startDateStr.isEmpty()) {
                try {
                    startDate = Date.valueOf(startDateStr);
                } catch (IllegalArgumentException e) {
                    // 忽略无效日期
                }
            }
            if (endDateStr != null && !endDateStr.isEmpty()) {
                try {
                    endDate = Date.valueOf(endDateStr);
                } catch (IllegalArgumentException e) {
                    // 忽略无效日期
                }
            }
            if (applicationDateStr != null && !applicationDateStr.isEmpty()) {
                try {
                    // 如果提供了申请日期，同时设置开始和结束日期
                    startDate = Date.valueOf(applicationDateStr);
                    endDate = Date.valueOf(applicationDateStr);
                } catch (IllegalArgumentException e) {
                    // 忽略无效日期
                }
            }
            
            // 转换部门ID
            Integer departmentId = null;
            if (departmentIdStr != null && !departmentIdStr.isEmpty()) {
                try {
                    departmentId = Integer.parseInt(departmentIdStr);
                } catch (NumberFormatException e) {
                    // 忽略无效部门ID
                }
            }
            
            // 分页参数
            int page = 1;
            int pageSize = 20;
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.isEmpty()) {
                    page = Integer.parseInt(pageParam);
                }
                String pageSizeParam = request.getParameter("pageSize");
                if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
                    pageSize = Integer.parseInt(pageSizeParam);
                }
            } catch (NumberFormatException e) {
                // 使用默认值
            }

            // 计算偏移量
            int offset = (page - 1) * pageSize;

            // 查询预约记录 - 先获取所有符合条件的记录
            List<Reservation> allReservations = reservationDao.getReservationsByConditions(
                    startDate, endDate, campus, reservationType, departmentId, status, name, pageSize, offset);

            // 获取当前管理员的部门名称（用于权限过滤）
            String adminDeptName = null;
            if (currentAdmin.getDeptId() > 0) {
                try {
                    DepartmentDao deptDao = new DepartmentDao();
                    Department dept = deptDao.getDepartmentById(currentAdmin.getDeptId());
                    if (dept != null) {
                        adminDeptName = dept.getDepartmentName();
                    }
                } catch (Exception e) {
                    // 获取部门名称失败，使用null
                }
            }
            
            // 基于 organization 字段进行权限过滤
            List<Reservation> filteredReservations = new ArrayList<>();
            for (Reservation reservation : allReservations) {
                if (AdminPermissionUtil.canViewReservationByOrganization(currentAdmin, reservation.getOrganization(), adminDeptName)) {
                    filteredReservations.add(reservation);
                }
            }

            // 创建分页数据结构
            ReservationPage reservationPage = new ReservationPage();
            reservationPage.setContent(filteredReservations);
            reservationPage.setNumber(page - 1); // JSP使用0基础的页码
            reservationPage.setSize(pageSize);
            reservationPage.setTotalElements(filteredReservations.size());
            reservationPage.setTotalPages((int) Math.ceil((double) filteredReservations.size() / pageSize));

            // 设置请求属性
            request.setAttribute("reservations", reservationPage);
            request.setAttribute("totalElements", filteredReservations.size());
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            
            // 保留查询条件
            request.setAttribute("campus", campus);
            request.setAttribute("reservationType", reservationType);
            request.setAttribute("status", status);
            request.setAttribute("startDate", startDateStr);
            request.setAttribute("endDate", endDateStr);
            request.setAttribute("applicationDate", applicationDateStr);
            request.setAttribute("name", name);
            request.setAttribute("idNumber", idNumber);
            request.setAttribute("departmentId", departmentId);
            
            // 获取部门列表供筛选使用 - 根据权限过滤
            try {
                DepartmentDao departmentDao = new DepartmentDao();
                List<Department> departments;
                if (AdminPermissionUtil.canViewAllDepartments(currentAdmin)) {
                    departments = departmentDao.getAllDepartments();
                } else {
                    departments = new ArrayList<>();
                    Department dept = departmentDao.getDepartmentById(currentAdmin.getDeptId());
                    if (dept != null) {
                        departments.add(dept);
                    }
                }
                request.setAttribute("departments", departments);
            } catch (Exception e) {
                System.err.println("获取部门列表失败: " + e.getMessage());
                // 设置空列表，避免页面出错
                request.setAttribute("departments", new ArrayList<>());
            }
            
            // 设置当前管理员信息，用于前端权限控制
            request.setAttribute("currentAdmin", currentAdmin);
            request.setAttribute("isSystemAdmin", AdminPermissionUtil.isSystemAdmin(currentAdmin));
            request.setAttribute("isDepartmentAdmin", AdminPermissionUtil.isDepartmentAdmin(currentAdmin));
            request.setAttribute("canViewAllDepartments", AdminPermissionUtil.canViewAllDepartments(currentAdmin));

            request.getRequestDispatcher("/WEB-INF/views/admin/reservation/list.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("处理预约列表时发生错误: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "查询预约记录时发生错误");
            request.getRequestDispatcher("/WEB-INF/views/admin/reservation/list.jsp").forward(request, response);
        }
    }

    /**
     * 处理预约审核列表页面
     */
    private void handleAuditList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 获取当前登录的管理员信息
            HttpSession session = request.getSession();
            Admin currentAdmin = (Admin) session.getAttribute("admin");
            
            // 检查管理员权限
            if (currentAdmin == null) {
                response.sendRedirect(request.getContextPath() + "/admin/login");
                return;
            }

            // 获取查询参数
            String status = request.getParameter("status");
            if (status == null || status.isEmpty()) {
                status = "pending"; // 默认显示待审核
            }
            
            // 查询所有预约记录
            List<Reservation> allReservations = reservationDao.getReservationsByConditions(
                    null, null, null, null, null, status, null, 100, 0);

            // 获取当前管理员的部门名称（用于权限过滤）
            String adminDeptName = null;
            if (currentAdmin.getDeptId() > 0) {
                try {
                    DepartmentDao deptDao = new DepartmentDao();
                    Department dept = deptDao.getDepartmentById(currentAdmin.getDeptId());
                    if (dept != null) {
                        adminDeptName = dept.getDepartmentName();
                    }
                } catch (Exception e) {
                    // 获取部门名称失败，使用null
                }
            }
            
            // 基于 organization 字段进行权限过滤
            List<Reservation> filteredReservations = new ArrayList<>();
            for (Reservation reservation : allReservations) {
                if (AdminPermissionUtil.canViewReservationByOrganization(currentAdmin, reservation.getOrganization(), adminDeptName)) {
                    filteredReservations.add(reservation);
                }
            }

            request.setAttribute("reservations", filteredReservations);
            request.setAttribute("currentStatus", status);
            request.setAttribute("totalCount", filteredReservations.size());
            
            // 统计各状态数量 - 也需要应用权限过滤
            int pendingCount = 0, approvedCount = 0, rejectedCount = 0;
            
            // 分别查询各状态的记录并过滤
            List<Reservation> pendingReservations = reservationDao.getReservationsByConditions(
                    null, null, null, null, null, "pending", null, 1000, 0);
            List<Reservation> approvedReservations = reservationDao.getReservationsByConditions(
                    null, null, null, null, null, "approved", null, 1000, 0);
            List<Reservation> rejectedReservations = reservationDao.getReservationsByConditions(
                    null, null, null, null, null, "rejected", null, 1000, 0);
            
            // 过滤并统计
            for (Reservation reservation : pendingReservations) {
                if (AdminPermissionUtil.canViewReservationByOrganization(currentAdmin, reservation.getOrganization(), adminDeptName)) {
                    pendingCount++;
                }
            }
            for (Reservation reservation : approvedReservations) {
                if (AdminPermissionUtil.canViewReservationByOrganization(currentAdmin, reservation.getOrganization(), adminDeptName)) {
                    approvedCount++;
                }
            }
            for (Reservation reservation : rejectedReservations) {
                if (AdminPermissionUtil.canViewReservationByOrganization(currentAdmin, reservation.getOrganization(), adminDeptName)) {
                    rejectedCount++;
                }
            }
            
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("approvedCount", approvedCount);
            request.setAttribute("rejectedCount", rejectedCount);
            
            // 设置权限信息
            request.setAttribute("currentAdmin", currentAdmin);
            request.setAttribute("isSystemAdmin", AdminPermissionUtil.isSystemAdmin(currentAdmin));
            request.setAttribute("isDepartmentAdmin", AdminPermissionUtil.isDepartmentAdmin(currentAdmin));
            request.setAttribute("canAuditReservations", AdminPermissionUtil.canAuditReservations(currentAdmin));
            
            request.getRequestDispatcher("/WEB-INF/views/admin/reservation/audit-list.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("处理预约审核列表时发生错误: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "查询待审核预约时发生错误");
            request.setAttribute("reservations", new ArrayList<>());
            request.getRequestDispatcher("/WEB-INF/views/admin/reservation/audit-list.jsp").forward(request, response);
        }
    }

    /**
     * 处理预约详情查看
     */
    private void handleView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            String reservationIdStr = pathInfo.substring("/view/".length());
            int reservationId = Integer.parseInt(reservationIdStr);

            Reservation reservation = reservationDao.getReservationById(reservationId);
            if (reservation == null) {
                request.setAttribute("error", "预约记录不存在");
                response.sendRedirect(request.getContextPath() + "/admin/reservation/list");
                return;
            }

            request.setAttribute("reservation", reservation);
            request.getRequestDispatcher("/WEB-INF/views/admin/reservation/view.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/reservation/list");
        } catch (Exception e) {
            System.err.println("查看预约详情时发生错误: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "查看预约详情时发生错误");
            response.sendRedirect(request.getContextPath() + "/admin/reservation/list");
        }
    }

    /**
     * 处理特定预约的审核详情页面
     */
    private void handleAuditDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            String reservationIdStr = pathInfo.substring("/audit/".length());
            int reservationId = Integer.parseInt(reservationIdStr);
            
            // 查询预约详情
            Reservation reservation = reservationDao.getReservationById(reservationId);
            
            if (reservation == null) {
                request.setAttribute("error", "预约不存在");
                request.getRequestDispatcher("/WEB-INF/views/admin/reservation/audit.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("reservation", reservation);
            request.getRequestDispatcher("/WEB-INF/views/admin/reservation/audit.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "无效的预约ID");
            request.getRequestDispatcher("/WEB-INF/views/admin/reservation/audit.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("处理预约审核详情时发生错误: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "查询预约详情时发生错误");
            request.getRequestDispatcher("/WEB-INF/views/admin/reservation/audit.jsp").forward(request, response);
        }
    }

    /**
     * 处理预约审核操作
     */
    private void handleAudit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            
            String pathInfo = request.getPathInfo();
            String reservationIdStr = pathInfo.substring("/audit/".length());
            int reservationId = Integer.parseInt(reservationIdStr);

            String action = request.getParameter("action");
            String auditComments = request.getParameter("auditComments");
            
            if (auditComments == null) {
                auditComments = "";
            }

            // 获取当前管理员信息
            HttpSession session = request.getSession();
            Admin admin = (Admin) session.getAttribute("admin");
            
            boolean success = false;
            String message = "";

            if ("approve".equals(action)) {
                success = reservationDao.auditReservation(reservationId, admin.getAdminId(), admin.getName(), "approved", auditComments);
                message = success ? "预约已通过审核" : "审核操作失败";
            } else if ("reject".equals(action)) {
                success = reservationDao.auditReservation(reservationId, admin.getAdminId(), admin.getName(), "rejected", auditComments);
                message = success ? "预约已拒绝" : "审核操作失败";
            } else if ("pending".equals(action)) {
                success = reservationDao.auditReservation(reservationId, admin.getAdminId(), admin.getName(), "pending", auditComments);
                message = success ? "预约已设为待定状态" : "审核操作失败";
            } else {
                message = "无效的审核操作";
            }

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/reservation/list?message=" + 
                    java.net.URLEncoder.encode(message, "UTF-8"));
            } else {
                request.setAttribute("error", message);
                handleAuditDetail(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/reservation/list");
        } catch (Exception e) {
            System.err.println("处理预约审核时发生错误: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "审核操作失败");
            response.sendRedirect(request.getContextPath() + "/admin/reservation/list");
            handleAuditList(request, response);
        }
    }

    /**
     * 处理预约撤销操作
     */
    private void handleRevoke(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        try {
            request.setCharacterEncoding("UTF-8");
            
            String reservationIdStr = request.getParameter("reservationId");
            String newStatus = request.getParameter("newStatus");
            String comment = request.getParameter("comment");
            
            if (reservationIdStr == null || newStatus == null || comment == null) {
                response.getWriter().write("{\"success\":false,\"message\":\"参数不完整\"}");
                return;
            }
            
            // 验证新状态
            if (!"rejected".equals(newStatus) && !"pending".equals(newStatus)) {
                response.getWriter().write("{\"success\":false,\"message\":\"无效的状态\"}");
                return;
            }
            
            long reservationId = Long.parseLong(reservationIdStr);

            // 获取当前管理员信息
            HttpSession session = request.getSession();
            Admin admin = (Admin) session.getAttribute("admin");
            
            boolean success = reservationDao.revokeReservation(reservationId, admin.getAdminId(), 
                    admin.getName(), newStatus, comment);

            if (success) {
                String statusText = "rejected".equals(newStatus) ? "已拒绝" : "待定";
                response.getWriter().write("{\"success\":true,\"message\":\"预约已撤销为" + statusText + "状态\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"撤销操作失败，请检查预约状态\"}");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false,\"message\":\"无效的预约ID\"}");
        } catch (Exception e) {
            System.err.println("处理预约撤销时发生错误: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("{\"success\":false,\"message\":\"系统错误，请稍后重试\"}");
        }
    }

    /**
     * 处理预约状态修改操作
     */
    private void handleChangeStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        try {
            request.setCharacterEncoding("UTF-8");
            
            String reservationIdStr = request.getParameter("reservationId");
            String newStatus = request.getParameter("newStatus");
            String comment = request.getParameter("comment");
            
            if (reservationIdStr == null || newStatus == null || comment == null) {
                response.getWriter().write("{\"success\":false,\"message\":\"参数不完整\"}");
                return;
            }
            
            // 验证新状态
            if (!"pending".equals(newStatus) && !"approved".equals(newStatus) && !"rejected".equals(newStatus)) {
                response.getWriter().write("{\"success\":false,\"message\":\"无效的状态\"}");
                return;
            }
            
            long reservationId = Long.parseLong(reservationIdStr);

            // 获取当前管理员信息
            HttpSession session = request.getSession();
            Admin admin = (Admin) session.getAttribute("admin");
            
            boolean success = reservationDao.changeReservationStatus(reservationId, admin.getAdminId(), 
                    admin.getName(), newStatus, comment);

            if (success) {
                String statusText = getStatusDisplayName(newStatus);
                response.getWriter().write("{\"success\":true,\"message\":\"预约状态已修改为" + statusText + "\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"状态修改失败\"}");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false,\"message\":\"无效的预约ID\"}");
        } catch (Exception e) {
            System.err.println("处理预约状态修改时发生错误: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("{\"success\":false,\"message\":\"系统错误，请稍后重试\"}");
        }
    }

    /**
     * 获取状态显示名称
     */
    private String getStatusDisplayName(String status) {
        switch (status) {
            case "pending": return "待审核";
            case "approved": return "已通过";
            case "rejected": return "已拒绝";
            default: return status;
        }
    }

    /**
     * 处理统计页面
     */
    private void handleStatistics(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 统计页面实现
        request.getRequestDispatcher("/WEB-INF/views/admin/reservation/statistics.jsp").forward(request, response);
    }
}
