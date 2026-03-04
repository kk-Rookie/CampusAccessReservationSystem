package com.example.passcode.controller;

import com.example.passcode.dao.DepartmentDao;
import com.example.passcode.model.Department;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * 部门管理控制器
 * 处理部门的增删改查操作
 */
@WebServlet("/admin/department/*")
public class DepartmentServlet extends HttpServlet {

    private DepartmentDao departmentDao = new DepartmentDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 检查登录状态
        if (!checkLogin(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
            // 部门列表页面
            handleList(request, response);
        } else if (pathInfo.equals("/add")) {
            // 添加部门页面
            handleAddPage(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            // 编辑部门页面
            handleEditPage(request, response);
        } else if (pathInfo.startsWith("/view/")) {
            // 部门详情页面
            handleViewPage(request, response);
        } else if (pathInfo.startsWith("/detail/")) {
            // 部门详情API（JSON响应）
            handleDetailApi(request, response);
        } else if (pathInfo.startsWith("/delete/")) {
            // 删除部门
            handleDelete(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/department/list");
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
                response.sendRedirect(request.getContextPath() + "/admin/department/list");
            }
            return;
        }

        if (pathInfo.equals("/add")) {
            // 处理添加部门表单
            handleAddSubmit(request, response);
        } else if (pathInfo.equals("/edit")) {
            // 处理编辑部门表单
            handleEditSubmit(request, response);
        } else if ("delete".equals(action)) {
            // 处理Ajax删除请求
            handleDeleteApi(request, response);
        } else if ("toggleStatus".equals(action)) {
            // 处理Ajax状态切换请求
            handleToggleStatusApi(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/department/list");
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
     * 处理部门列表页面
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 获取查询参数
            String keyword = request.getParameter("keyword");
            String type = request.getParameter("type");
            String departmentName = request.getParameter("departmentName");
            String departmentCode = request.getParameter("departmentCode");
            
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

            List<Department> departments;
            int totalCount;

            // 支持多种搜索方式
            if ((departmentName != null && !departmentName.trim().isEmpty()) || 
                (departmentCode != null && !departmentCode.trim().isEmpty())) {
                // 按部门名称和代码搜索
                departments = departmentDao.searchDepartmentsByNameAndCode(
                    departmentName != null ? departmentName.trim() : "",
                    departmentCode != null ? departmentCode.trim() : ""
                );
                totalCount = departments.size(); // 对于这种查询，暂时使用结果集大小
                request.setAttribute("departmentName", departmentName);
                request.setAttribute("departmentCode", departmentCode);
            } else if (keyword != null && !keyword.trim().isEmpty()) {
                // 关键词搜索（分页）
                departments = departmentDao.searchDepartmentsByPage(keyword.trim(), page, pageSize);
                totalCount = departmentDao.getSearchDepartmentCount(keyword.trim());
                request.setAttribute("keyword", keyword.trim());
            } else if (type != null && !type.isEmpty()) {
                // 按类型搜索
                departments = departmentDao.getDepartmentsByType(type);
                totalCount = departments.size(); // 对于这种查询，暂时使用结果集大小
                request.setAttribute("type", type);
            } else {
                // 获取所有部门（分页）
                departments = departmentDao.getDepartmentsByPage(page, pageSize);
                totalCount = departmentDao.getTotalDepartmentCount();
            }

            // 计算总页数
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);

            // 设置请求属性
            request.setAttribute("departments", departments);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("totalPages", totalPages);

        } catch (Exception e) {
            System.err.println("获取部门列表时发生错误: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "获取部门列表失败");
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/department/list.jsp").forward(request, response);
    }

    /**
     * 显示添加部门页面
     */
    private void handleAddPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/admin/department/add.jsp").forward(request, response);
    }

    /**
     * 处理添加部门表单提交
     */
    private void handleAddSubmit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String deptName = request.getParameter("deptName");
        String deptType = request.getParameter("deptType");

        // 参数验证
        if (deptName == null || deptName.trim().isEmpty() ||
                deptType == null || deptType.trim().isEmpty()) {
            request.setAttribute("error", "部门名称和类型不能为空");
            request.getRequestDispatcher("/WEB-INF/views/admin/department/add.jsp").forward(request, response);
            return;
        }

        // 验证部门类型是否有效
        if (!isValidDeptType(deptType)) {
            request.setAttribute("error", "部门类型无效");
            request.setAttribute("deptName", deptName);
            request.getRequestDispatcher("/WEB-INF/views/admin/department/add.jsp").forward(request, response);
            return;
        }

        Department department = new Department();
        department.setDeptName(deptName.trim());
        department.setDeptType(deptType);

        try {
            int result = departmentDao.addDepartment(department);
            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/department/list?message=addSuccess");
            } else if (result == -1) {
                request.setAttribute("error", "部门名称已存在");
                request.setAttribute("department", department);
                request.getRequestDispatcher("/WEB-INF/views/admin/department/add.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "添加部门失败");
                request.setAttribute("department", department);
                request.getRequestDispatcher("/WEB-INF/views/admin/department/add.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.err.println("添加部门时发生错误: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "添加部门时系统发生错误");
            request.setAttribute("department", department);
            request.getRequestDispatcher("/WEB-INF/views/admin/department/add.jsp").forward(request, response);
        }
    }

    /**
     * 显示编辑部门页面
     */
    private void handleEditPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int deptId = Integer.parseInt(request.getPathInfo().substring(6));
            Department department = departmentDao.getDepartmentById(deptId);
            if (department == null) {
                response.sendRedirect(request.getContextPath() + "/admin/department/list?error=notFound");
                return;
            }
            request.setAttribute("department", department);
            request.getRequestDispatcher("/WEB-INF/views/admin/department/edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/department/list?error=invalidId");
        } catch (Exception e) {
            System.err.println("获取部门信息时发生错误: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/department/list?error=systemError");
        }
    }

    /**
     * 处理编辑部门表单提交
     */
    private void handleEditSubmit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String deptIdStr = request.getParameter("deptId");
        String deptName = request.getParameter("deptName");
        String deptType = request.getParameter("deptType");

        // 参数验证
        if (deptIdStr == null || deptName == null || deptName.trim().isEmpty() ||
                deptType == null || deptType.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/department/list?error=invalidParams");
            return;
        }

        // 验证部门类型是否有效
        if (!isValidDeptType(deptType)) {
            request.setAttribute("error", "部门类型无效");
            response.sendRedirect(request.getContextPath() + "/admin/department/list?error=invalidType");
            return;
        }

        try {
            int deptId = Integer.parseInt(deptIdStr);
            Department department = new Department();
            department.setDeptId(deptId);
            department.setDeptName(deptName.trim());
            department.setDeptType(deptType);

            boolean success = departmentDao.updateDepartment(department);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/department/list?message=updateSuccess");
            } else {
                request.setAttribute("error", "更新部门失败，可能是部门名称已被使用");
                request.setAttribute("department", department);
                request.getRequestDispatcher("/WEB-INF/views/admin/department/edit.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/department/list?error=invalidId");
        } catch (Exception e) {
            System.err.println("更新部门时发生错误: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/department/list?error=systemError");
        }
    }

    /**
     * 处理删除部门
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int deptId = Integer.parseInt(request.getPathInfo().substring(8));
            boolean success = departmentDao.deleteDepartment(deptId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/department/list?message=deleteSuccess");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/department/list?error=deleteFailure");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/department/list?error=invalidId");
        } catch (Exception e) {
            System.err.println("删除部门时发生错误: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/department/list?error=systemError");
        }
    }

    /**
     * 处理部门详情API请求（返回JSON）
     */
    private void handleDetailApi(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        try {
            String pathInfo = request.getPathInfo();
            String deptIdStr = pathInfo.substring("/detail/".length());
            int deptId = Integer.parseInt(deptIdStr);

            Department department = departmentDao.getDepartmentById(deptId);
            if (department != null) {
                String json = String.format(
                    "{\"success\":true,\"department\":{\"deptId\":%d,\"deptName\":\"%s\",\"departmentCode\":\"%s\",\"status\":\"%s\",\"description\":\"%s\"}}",
                    department.getDeptId(),
                    escapeJson(department.getDeptName()),
                    escapeJson(department.getDepartmentCode() != null ? department.getDepartmentCode() : ""),
                    escapeJson(department.getStatus() != null ? department.getStatus() : "active"),
                    escapeJson(department.getDescription() != null ? department.getDescription() : "")
                );
                response.getWriter().write(json);
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"部门不存在\"}");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false,\"message\":\"无效的部门ID\"}");
        } catch (Exception e) {
            System.err.println("获取部门详情时发生错误: " + e.getMessage());
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
            String deptIdStr = request.getParameter("deptId");
            int deptId = Integer.parseInt(deptIdStr);
            
            boolean success = departmentDao.deleteDepartment(deptId);
            if (success) {
                response.getWriter().write("{\"success\":true,\"message\":\"删除成功\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"删除失败\"}");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false,\"message\":\"无效的部门ID\"}");
        } catch (Exception e) {
            System.err.println("删除部门时发生错误: " + e.getMessage());
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
            String deptIdStr = request.getParameter("deptId");
            String currentStatus = request.getParameter("currentStatus");
            int deptId = Integer.parseInt(deptIdStr);
            
            // 切换状态
            String newStatus = "active".equals(currentStatus) ? "inactive" : "active";
            
            // 更新状态（需要在DAO中添加updateStatus方法）
            boolean success = departmentDao.updateDepartmentStatus(deptId, newStatus);
            if (success) {
                String statusText = "active".equals(newStatus) ? "启用" : "停用";
                response.getWriter().write("{\"success\":true,\"message\":\"已" + statusText + "\",\"newStatus\":\"" + newStatus + "\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"状态更新失败\"}");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false,\"message\":\"无效的部门ID\"}");
        } catch (Exception e) {
            System.err.println("更新部门状态时发生错误: " + e.getMessage());
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
     * 验证部门类型是否有效
     */
    private boolean isValidDeptType(String deptType) {
        return "行政部门".equals(deptType) || "直属部门".equals(deptType) || "学院".equals(deptType);
    }

    /**
     * 处理部门详情页面请求
     */
    private void handleViewPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            String deptIdStr = pathInfo.substring("/view/".length());
            int deptId = Integer.parseInt(deptIdStr);

            Department department = departmentDao.getDepartmentById(deptId);
            if (department != null) {
                request.setAttribute("department", department);
                request.getRequestDispatcher("/WEB-INF/views/admin/department/view.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "部门不存在");
                response.sendRedirect(request.getContextPath() + "/admin/department/list");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/department/list");
        } catch (Exception e) {
            System.err.println("查看部门详情时发生错误: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "查看部门详情时发生错误");
            response.sendRedirect(request.getContextPath() + "/admin/department/list");
        }
    }
}