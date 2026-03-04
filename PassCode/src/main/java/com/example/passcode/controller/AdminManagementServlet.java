package com.example.passcode.controller;

import com.example.passcode.dao.AdminDao;
import com.example.passcode.dao.DepartmentDao;
import com.example.passcode.service.AdminService;
import com.example.passcode.model.Admin;
import com.example.passcode.model.Department;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

/**
 * 管理员管理控制器
 * 处理管理员的增删改查操作
 */
@WebServlet("/admin/manager/*")
public class AdminManagementServlet extends HttpServlet {

    private AdminDao adminDao = new AdminDao();
    private AdminService adminService = new AdminService();
    private DepartmentDao departmentDao = new DepartmentDao();

    // 登录名验证正则表达式：4-20个字符，只能包含字母、数字和下划线
    private static final Pattern LOGIN_NAME_PATTERN = Pattern.compile("^[a-zA-Z0-9_]{4,20}$");
    // 手机号验证正则表达式：11位数字
    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9]{11}$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 检查登录状态
        if (!checkLogin(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
            // 管理员列表页面
            handleList(request, response);
        } else if (pathInfo.equals("/add")) {
            // 添加管理员页面
            handleAddPage(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            // 编辑管理员页面
            handleEditPage(request, response);
        } else if (pathInfo.startsWith("/view/")) {
            // 管理员详情页面
            handleViewPage(request, response);
        } else if (pathInfo.startsWith("/detail/")) {
            // 管理员详情API（JSON响应）
            handleDetailApi(request, response);
        } else if (pathInfo.startsWith("/delete/")) {
            // 删除管理员
            handleDelete(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/manager/list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 检查登录状态
        if (!checkLogin(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
            // 处理发送到 /list 路径的Ajax请求
            if ("delete".equals(action)) {
                handleDeleteApi(request, response);
            } else if ("toggleStatus".equals(action)) {
                handleToggleStatusApi(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manager/list");
            }
            return;
        }

        if (pathInfo.equals("/add")) {
            // 处理添加管理员表单
            handleAddSubmit(request, response);
        } else if (pathInfo.equals("/edit")) {
            // 处理编辑管理员表单
            handleEditSubmit(request, response);
        } else if ("delete".equals(action)) {
            // 处理Ajax删除请求
            handleDeleteApi(request, response);
        } else if ("toggleStatus".equals(action)) {
            // 处理Ajax状态切换请求
            handleToggleStatusApi(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/manager/list");
        }
    }

    /**
     * 检查用户登录状态
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
     * 处理管理员列表页面
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 获取查询参数
            String keyword = request.getParameter("keyword");
            String deptIdStr = request.getParameter("deptId");
            
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
                    // 限制每页显示数量
                    if (pageSize > 100) pageSize = 100;
                    if (pageSize < 10) pageSize = 10;
                }
            } catch (NumberFormatException e) {
                // 使用默认值
            }

            List<Admin> admins = new ArrayList<>();
            int totalCount;

            if (keyword != null && !keyword.trim().isEmpty()) {
                // 关键词搜索（分页）
                admins = adminDao.searchAdminsByPage(keyword.trim(), page, pageSize);
                totalCount = adminDao.getSearchAdminCount(keyword.trim());
                request.setAttribute("keyword", keyword.trim());
            } else if (deptIdStr != null && !deptIdStr.isEmpty()) {
                try {
                    int deptId = Integer.parseInt(deptIdStr);
                    admins = adminDao.getAdminsByDepartment(deptId);
                    totalCount = admins.size(); // 对于这种查询，暂时使用结果集大小
                    request.setAttribute("deptId", deptId);

                    Department department = departmentDao.getDepartmentById(deptId);
                    if (department != null) {
                        request.setAttribute("deptName", department.getDeptName());
                    }
                } catch (NumberFormatException e) {
                    admins = adminDao.getAdminsByPage(page, pageSize);
                    totalCount = adminDao.getTotalAdminCount();
                }
            } else {
                // 获取所有管理员（分页）
                admins = adminDao.getAdminsByPage(page, pageSize);
                totalCount = adminDao.getTotalAdminCount();
            }

            // 计算总页数
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);

            // 设置管理员列表
            request.setAttribute("managers", admins);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("totalPages", totalPages);
            
        } catch (Exception e) {
            System.err.println("获取管理员列表时发生错误: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "获取管理员列表失败: " + e.getMessage());
            request.setAttribute("managers", new ArrayList<>()); // 确保managers不为null
        }

        // 获取统计数据
        try {
            int totalManagers = adminDao.getTotalAdminCount();
            int activeManagers = adminDao.getActiveAdminCount();
            int inactiveManagers = totalManagers - activeManagers;
            
            request.setAttribute("totalManagers", totalManagers);
            request.setAttribute("activeManagers", activeManagers);
            request.setAttribute("inactiveManagers", inactiveManagers);
        } catch (Exception e) {
            System.err.println("获取统计数据时发生错误: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("totalManagers", 0);
            request.setAttribute("activeManagers", 0);
            request.setAttribute("inactiveManagers", 0);
        }

        // 获取所有部门，用于过滤下拉框
        try {
            List<Department> departments = departmentDao.getAllDepartments();
            request.setAttribute("departments", departments);
        } catch (Exception e) {
            System.err.println("获取部门列表时发生错误: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("departments", new ArrayList<>());
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/manager/list.jsp").forward(request, response);
    }

    /**
     * 显示添加管理员页面
     */
    private void handleAddPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Department> departments = departmentDao.getAllDepartments();
            request.setAttribute("departments", departments);
            request.getRequestDispatcher("/WEB-INF/views/admin/manager/add.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("获取部门列表时发生错误: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/manager/list?error=systemError");
        }
    }

    /**
     * 处理添加管理员表单提交
     */
    private void handleAddSubmit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String loginName = request.getParameter("loginName");
        String password = request.getParameter("password");
        String deptIdStr = request.getParameter("deptId");
        String phone = request.getParameter("phone");

        // 基本参数验证
        if (name == null || name.trim().isEmpty() ||
                loginName == null || loginName.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                deptIdStr == null || deptIdStr.trim().isEmpty()) {

            request.setAttribute("error", "姓名、登录名、密码和部门不能为空");
            loadDepartmentsAndForward(request, response, "/WEB-INF/views/admin/manager/add.jsp");
            return;
        }

        // 登录名格式验证
        if (!LOGIN_NAME_PATTERN.matcher(loginName.trim()).matches()) {
            request.setAttribute("error", "登录名格式不正确（4-20个字符，只能包含字母、数字和下划线）");
            loadDepartmentsAndForward(request, response, "/WEB-INF/views/admin/manager/add.jsp");
            return;
        }

        // 密码长度验证
        if (password.length() < 6) {
            request.setAttribute("error", "密码长度至少6个字符");
            loadDepartmentsAndForward(request, response, "/WEB-INF/views/admin/manager/add.jsp");
            return;
        }

        // 手机号验证（如果提供了手机号）
        if (phone != null && !phone.trim().isEmpty() && !PHONE_PATTERN.matcher(phone.trim()).matches()) {
            request.setAttribute("error", "手机号格式不正确（11位数字）");
            loadDepartmentsAndForward(request, response, "/WEB-INF/views/admin/manager/add.jsp");
            return;
        }

        try {
            int deptId = Integer.parseInt(deptIdStr);

            Admin admin = new Admin();
            admin.setName(name.trim());
            admin.setLoginName(loginName.trim());
            admin.setPassword(password); // DAO层会处理加密
            admin.setDeptId(deptId);
            admin.setPhone(phone != null ? phone.trim() : null);

            int result = adminDao.addAdmin(admin);
            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/manager/list?message=addSuccess");
            } else if (result == -1) {
                request.setAttribute("error", "登录名已存在");
                request.setAttribute("admin", admin);
                loadDepartmentsAndForward(request, response, "/WEB-INF/views/admin/manager/add.jsp");
            } else {
                request.setAttribute("error", "添加管理员失败");
                request.setAttribute("admin", admin);
                loadDepartmentsAndForward(request, response, "/WEB-INF/views/admin/manager/add.jsp");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "部门ID格式不正确");
            loadDepartmentsAndForward(request, response, "/WEB-INF/views/admin/manager/add.jsp");
        } catch (Exception e) {
            System.err.println("添加管理员时发生错误: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "添加管理员时系统发生错误");
            loadDepartmentsAndForward(request, response, "/WEB-INF/views/admin/manager/add.jsp");
        }
    }

    /**
     * 显示编辑管理员页面
     */
   private void handleEditPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            String adminIdStr = pathInfo.substring(6); // 去掉"/edit/"
            int adminId = Integer.parseInt(adminIdStr);
            
            Admin admin = adminDao.getAdminById(adminId);
            
            if (admin == null) {
                response.sendRedirect(request.getContextPath() + "/admin/manager/list?error=notFound");
                return;
            }

            List<Department> departments = departmentDao.getAllDepartments();
            request.setAttribute("departments", departments);
            request.setAttribute("admin_user", admin);
            request.getRequestDispatcher("/WEB-INF/views/admin/manager/edit.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manager/list?error=invalidId");
        } catch (Exception e) {
            System.err.println("获取管理员信息时发生错误: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/manager/list?error=systemError");
        }
    }

    /**
     * 处理编辑管理员表单提交
     */
    private void handleEditSubmit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String adminIdStr = request.getParameter("adminId");
        String name = request.getParameter("name");
        String deptIdStr = request.getParameter("deptId");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        // 基本参数验证
        if (adminIdStr == null || adminIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/manager/list?error=invalidParams");
            return;
        }
        
        if (name == null || name.trim().isEmpty() || deptIdStr == null || deptIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/manager/list?error=invalidParams");
            return;
        }

        // 手机号验证（如果提供了手机号）
        if (phone != null && !phone.trim().isEmpty() && !PHONE_PATTERN.matcher(phone.trim()).matches()) {
            request.setAttribute("error", "手机号格式不正确（11位数字）");
            try {
                int adminId = Integer.parseInt(adminIdStr);
                Admin admin = adminDao.getAdminById(adminId);
                request.setAttribute("admin", admin);
                loadDepartmentsAndForward(request, response, "/WEB-INF/views/admin/manager/edit.jsp");
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/admin/manager/list?error=systemError");
            }
            return;
        }

        // 密码验证（如果提供了密码）
        if (password != null && !password.trim().isEmpty() && password.length() < 6) {
            request.setAttribute("error", "密码长度至少6个字符");
            try {
                int adminId = Integer.parseInt(adminIdStr);
                Admin admin = adminDao.getAdminById(adminId);
                request.setAttribute("admin", admin);
                loadDepartmentsAndForward(request, response, "/WEB-INF/views/admin/manager/edit.jsp");
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/admin/manager/list?error=systemError");
            }
            return;
        }

        try {
            int adminId = Integer.parseInt(adminIdStr);
            int deptId = Integer.parseInt(deptIdStr);
            
            Admin admin = new Admin();
            admin.setAdminId(adminId);
            admin.setName(name.trim());
            admin.setDeptId(deptId);
            admin.setPhone(phone != null ? phone.trim() : null);

            boolean success = adminDao.updateAdmin(admin);

            // 如果提供了密码，则更新密码
            if (password != null && !password.trim().isEmpty()) {
                adminDao.updateAdminPassword(adminId, password);
            }

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/manager/list?message=updateSuccess");
            } else {
                request.setAttribute("error", "更新管理员信息失败");
                request.setAttribute("admin", admin);
                loadDepartmentsAndForward(request, response, "/WEB-INF/views/admin/manager/edit.jsp");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manager/list?error=invalidId");
        } catch (Exception e) {
            System.err.println("更新管理员时发生错误: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/manager/list?error=systemError");
        }
    }

    /**
     * 处理删除管理员
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int adminId = Integer.parseInt(request.getPathInfo().substring(8));

            // 防止删除当前登录的管理员
            HttpSession session = request.getSession();
            Admin currentAdmin = (Admin) session.getAttribute("admin");
            if (currentAdmin != null && currentAdmin.getAdminId() == adminId) {
                response.sendRedirect(request.getContextPath() + "/admin/manager/list?error=cannotDeleteSelf");
                return;
            }

            boolean success = adminDao.deleteAdmin(adminId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/manager/list?message=deleteSuccess");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manager/list?error=deleteFailure");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manager/list?error=invalidId");
        } catch (Exception e) {
            System.err.println("删除管理员时发生错误: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/manager/list?error=systemError");
        }
    }

    /**
     * 处理管理员详情API请求（返回JSON）
     */
    private void handleDetailApi(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        try {
            String pathInfo = request.getPathInfo();
            String adminIdStr = pathInfo.substring("/detail/".length());
            int adminId = Integer.parseInt(adminIdStr);

            Admin admin = adminDao.getAdminById(adminId);
            if (admin != null) {
                String json = String.format(
                    "{\"success\":true,\"admin\":{\"adminId\":%d,\"name\":\"%s\",\"loginName\":\"%s\",\"email\":\"%s\",\"phone\":\"%s\",\"role\":\"%s\",\"status\":\"%s\"}}",
                    admin.getAdminId(),
                    escapeJson(admin.getName()),
                    escapeJson(admin.getLoginName()),
                    escapeJson(admin.getEmail() != null ? admin.getEmail() : ""),
                    escapeJson(admin.getPhone() != null ? admin.getPhone() : ""),
                    escapeJson(admin.getRole() != null ? admin.getRole() : "admin"),
                    escapeJson(admin.getStatus() != null ? admin.getStatus() : "active")
                );
                response.getWriter().write(json);
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"管理员不存在\"}");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false,\"message\":\"无效的管理员ID\"}");
        } catch (Exception e) {
            System.err.println("获取管理员详情时发生错误: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("{\"success\":false,\"message\":\"系统错误\"}");
        }
    }

    /**
     * 处理Ajax删除请求（返回JSON）
     */
    private void handleDeleteApi(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        try {
            String adminIdStr = request.getParameter("adminId");
            int adminId = Integer.parseInt(adminIdStr);
            
            boolean success = adminDao.deleteAdmin(adminId);
            if (success) {
                response.getWriter().write("{\"success\":true,\"message\":\"删除成功\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"删除失败\"}");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false,\"message\":\"无效的管理员ID\"}");
        } catch (Exception e) {
            System.err.println("删除管理员时发生错误: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("{\"success\":false,\"message\":\"系统错误\"}");
        }
    }

    /**
     * 处理Ajax状态切换请求（返回JSON）
     */
    private void handleToggleStatusApi(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        try {
            String adminIdStr = request.getParameter("adminId");
            String currentStatus = request.getParameter("currentStatus");
            int adminId = Integer.parseInt(adminIdStr);
            
            // 切换状态
            String newStatus;
            if ("active".equals(currentStatus)) {
                newStatus = "disabled";
            } else {
                newStatus = "active";
            }
            
            boolean success = adminService.updateAdminStatus(adminId, newStatus);
            if (success) {
                String statusText = "active".equals(newStatus) ? "启用" : "禁用";
                response.getWriter().write("{\"success\":true,\"message\":\"已" + statusText + "\",\"newStatus\":\"" + newStatus + "\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"状态更新失败\"}");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false,\"message\":\"无效的管理员ID\"}");
        } catch (Exception e) {
            System.err.println("更新管理员状态时发生错误: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("{\"success\":false,\"message\":\"系统错误\"}");
        }
    }

    /**
     * 转义JSON字符串
     */
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                 .replace("\"", "\\\"")
                 .replace("\n", "\\n")
                 .replace("\r", "\\r")
                 .replace("\t", "\\t");
    }

    /**
     * 加载部门列表并转发到指定页面
     */
    private void loadDepartmentsAndForward(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        try {
            List<Department> departments = departmentDao.getAllDepartments();
            request.setAttribute("departments", departments);
        } catch (Exception e) {
            System.err.println("获取部门列表时发生错误: " + e.getMessage());
            e.printStackTrace();
        }
        request.getRequestDispatcher(path).forward(request, response);
    }

    /**
     * 处理管理员详情页面请求
     */
    private void handleViewPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            String adminIdStr = pathInfo.substring("/view/".length());
            int adminId = Integer.parseInt(adminIdStr);

            Admin admin = adminDao.getAdminById(adminId);
            if (admin != null) {
                request.setAttribute("admin", admin);
                request.getRequestDispatcher("/WEB-INF/views/admin/manager/view.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "管理员不存在");
                response.sendRedirect(request.getContextPath() + "/admin/manager/list");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manager/list");
        } catch (Exception e) {
            System.err.println("查看管理员详情时发生错误: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "查看管理员详情时发生错误");
            response.sendRedirect(request.getContextPath() + "/admin/manager/list");
        }
    }
}