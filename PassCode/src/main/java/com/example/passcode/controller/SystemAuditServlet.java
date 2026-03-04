package com.example.passcode.controller;

import com.example.passcode.dao.SystemAuditDao;
import com.example.passcode.model.SystemAudit;
import com.example.passcode.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * 系统审计控制器
 */
@WebServlet("/admin/audit/*")
public class SystemAuditServlet extends HttpServlet {

    private SystemAuditDao systemAuditDao = new SystemAuditDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 检查登录状态
        if (!checkLogin(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
            // 审计列表页面
            handleList(request, response);
        } else if (pathInfo.startsWith("/view/")) {
            // 审计详情页面
            handleView(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/audit/list");
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
        if (pathInfo != null && pathInfo.equals("/search")) {
            handleList(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/audit/list");
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
     * 处理审计列表页面
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 获取当前登录的管理员信息
            HttpSession session = request.getSession();
            Admin currentAdmin = (Admin) session.getAttribute("admin");
            
            // 获取查询参数
            String auditType = request.getParameter("auditType");
            String moduleName = request.getParameter("moduleName");
            String adminName = request.getParameter("adminName");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            
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

            // 查询审计记录
            List<SystemAudit> audits = systemAuditDao.getSystemAudits(
                page, pageSize, auditType, moduleName, adminName, startDate, endDate);
            
            // 获取总记录数
            int totalCount = systemAuditDao.getTotalCount(
                auditType, moduleName, adminName, startDate, endDate);
            
            // 计算总页数
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);

            // 设置请求属性
            request.setAttribute("audits", audits);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("totalPages", totalPages);
            
            // 保留查询条件
            request.setAttribute("auditType", auditType);
            request.setAttribute("moduleName", moduleName);
            request.setAttribute("adminName", adminName);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            
            // 获取审计类型和模块名称列表供筛选使用
            try {
                List<String> auditTypes = systemAuditDao.getDistinctOperationTypes();
                List<String> moduleNames = systemAuditDao.getDistinctModuleNames();
                request.setAttribute("auditTypes", auditTypes);
                request.setAttribute("moduleNames", moduleNames);
            } catch (Exception e) {
                System.err.println("获取筛选选项失败: " + e.getMessage());
            }
            
            // 设置当前管理员信息
            request.setAttribute("currentAdmin", currentAdmin);

            request.getRequestDispatcher("/WEB-INF/views/admin/audit/list.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("处理审计列表时发生错误: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "查询审计记录时发生错误");
            request.getRequestDispatcher("/WEB-INF/views/admin/audit/list.jsp").forward(request, response);
        }
    }

    /**
     * 处理审计详情查看
     */
    private void handleView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            String auditIdStr = pathInfo.substring("/view/".length());
            Long auditId = Long.parseLong(auditIdStr);

            SystemAudit audit = systemAuditDao.getSystemAuditById(auditId);
            if (audit == null) {
                request.setAttribute("error", "审计记录不存在");
                response.sendRedirect(request.getContextPath() + "/admin/audit/list");
                return;
            }

            request.setAttribute("audit", audit);
            request.getRequestDispatcher("/WEB-INF/views/admin/audit/view.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/audit/list");
        } catch (Exception e) {
            System.err.println("查看审计详情时发生错误: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "查看审计详情时发生错误");
            response.sendRedirect(request.getContextPath() + "/admin/audit/list");
        }
    }
}
