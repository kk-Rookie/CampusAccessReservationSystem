package com.example.demo.controller;

import com.example.demo.model.Reservation;
import com.example.demo.model.Companion;
import com.example.demo.service.ReservationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 预约页面控制器 - 传统JavaWeb方式处理预约相关页面请求
 */
@WebServlet(urlPatterns = {
    "/pages/reservation/my-reservations", 
    "/pages/reservation/create-reservation",
    "/pages/reservation/reservation-detail"
})
public class ReservationPageController extends HttpServlet {
    
    private ReservationService reservationService = new ReservationService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String servletPath = request.getServletPath();
        
        try {
            if ("/pages/reservation/my-reservations".equals(servletPath)) {
                showMyReservations(request, response);
            } else if ("/pages/reservation/reservation-detail".equals(servletPath)) {
                showReservationDetail(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "系统错误: " + e.getMessage());
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String servletPath = request.getServletPath();
        
        try {
            if ("/pages/reservation/create-reservation".equals(servletPath)) {
                createReservation(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "系统错误: " + e.getMessage());
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 显示我的预约页面
     */
    private void showMyReservations(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        System.out.println("=== 收到我的预约页面请求 ===");
        System.out.println("请求路径: " + request.getServletPath());
        System.out.println("会话ID: " + request.getRequestedSessionId());
        
        HttpSession session = request.getSession(false);
        System.out.println("会话对象: " + session);
        if (session != null) {
            System.out.println("会话中的用户名: " + session.getAttribute("username"));
            System.out.println("会话中的用户ID: " + session.getAttribute("userId"));
        }
        
        if (session == null || session.getAttribute("username") == null) {
            // 未登录，重定向到登录页面
            System.out.println("❌ 用户未登录，重定向到登录页面");
            response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp");
            return;
        }
        
        String username = (String) session.getAttribute("username");
        System.out.println("✅ 用户已登录: " + username);
        
        // 获取用户的预约列表
        List<Reservation> reservations = reservationService.getReservationsByUsername(username);
        System.out.println("📋 查询到预约数量: " + (reservations != null ? reservations.size() : 0));
        
        // 为每个预约添加格式化的日期字符串
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        if (reservations != null) {
            for (Reservation reservation : reservations) {
                if (reservation.getVisitTime() != null) {
                    String formattedVisitTime = dateFormat.format(reservation.getVisitTime());
                    request.setAttribute("visitTime_" + reservation.getId(), formattedVisitTime);
                }
                if (reservation.getPassCodeExpireTime() != null) {
                    String formattedExpireTime = dateFormat.format(reservation.getPassCodeExpireTime());
                    request.setAttribute("expireTime_" + reservation.getId(), formattedExpireTime);
                }
            }
        }
        
        // 设置属性并转发到JSP页面
        request.setAttribute("reservations", reservations);
        request.setAttribute("username", username);
        
        System.out.println("🔄 转发到JSP页面: /pages/reservation/my-reservations-simple.jsp");
        request.getRequestDispatcher("/pages/reservation/my-reservations-simple.jsp").forward(request, response);
    }
    
    /**
     * 显示预约详情页面
     */
    private void showReservationDetail(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "预约ID不能为空");
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            return;
        }
        
        try {
            Long reservationId = Long.parseLong(idStr);
            Reservation reservation = reservationService.getReservationById(reservationId);
            
            if (reservation == null) {
                request.setAttribute("errorMessage", "预约记录不存在");
                request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
                return;
            }
            
            // 检查通行码是否有效
            boolean isPassCodeValid = reservationService.isPassCodeValid(reservationId);
            
            request.setAttribute("reservation", reservation);
            request.setAttribute("isPassCodeValid", isPassCodeValid);
            request.getRequestDispatcher("/pages/reservation/reservation-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "无效的预约ID");
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 创建预约
     */
    private void createReservation(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        // 获取当前登录用户
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp");
            return;
        }
        String username = (String) session.getAttribute("username");
        
        try {
            // 构建预约对象
            Reservation reservation = new Reservation();
            
            // 设置用户名
            reservation.setUsername(username);
            
            // 获取基本信息
            String reservationType = request.getParameter("reservationType");
            if (reservationType == null || reservationType.trim().isEmpty()) {
                request.setAttribute("errorMessage", "预约类型不能为空");
                request.getRequestDispatcher("/pages/reservation/reserve.jsp").forward(request, response);
                return;
            }
            reservation.setReservationType(reservationType);
            
            String campus = request.getParameter("campus");
            if (campus == null || campus.trim().isEmpty()) {
                request.setAttribute("errorMessage", "校区不能为空");
                request.getRequestDispatcher("/pages/reservation/reserve.jsp").forward(request, response);
                return;
            }
            reservation.setCampus(campus);
            
            String name = request.getParameter("name");
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("errorMessage", "姓名不能为空");
                request.getRequestDispatcher("/pages/reservation/reserve.jsp").forward(request, response);
                return;
            }
            reservation.setName(name);
            
            String idCard = request.getParameter("idCard");
            if (idCard == null || idCard.trim().isEmpty()) {
                request.setAttribute("errorMessage", "身份证号不能为空");
                request.getRequestDispatcher("/pages/reservation/reserve.jsp").forward(request, response);
                return;
            }
            reservation.setIdCard(idCard);
            
            String phone = request.getParameter("phone");
            if (phone == null || phone.trim().isEmpty()) {
                request.setAttribute("errorMessage", "手机号不能为空");
                request.getRequestDispatcher("/pages/reservation/reserve.jsp").forward(request, response);
                return;
            }
            reservation.setPhone(phone);
            
            // 解析访问时间
            String visitTimeStr = request.getParameter("visitTime");
            if (visitTimeStr != null && !visitTimeStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                    reservation.setVisitTime(sdf.parse(visitTimeStr));
                } catch (Exception e) {
                    request.setAttribute("errorMessage", "访问时间格式错误");
                    request.getRequestDispatcher("/pages/reservation/reserve.jsp").forward(request, response);
                    return;
                }
            } else {
                request.setAttribute("errorMessage", "访问时间不能为空");
                request.getRequestDispatcher("/pages/reservation/reserve.jsp").forward(request, response);
                return;
            }
            
            // 设置其他字段
            reservation.setOrganization(request.getParameter("organization"));
            reservation.setTransportation(request.getParameter("transportation"));
            reservation.setPlateNumber(request.getParameter("plateNumber"));
            
            // 公务预约特有字段
            if ("business".equals(reservationType)) {
                String visitDepartmentIdStr = request.getParameter("visitDepartmentId");
                if (visitDepartmentIdStr != null && !visitDepartmentIdStr.trim().isEmpty()) {
                    try {
                        reservation.setVisitDepartmentId(Long.parseLong(visitDepartmentIdStr));
                    } catch (NumberFormatException e) {
                        // 忽略格式错误，使用默认值null
                    }
                }
                reservation.setContactPerson(request.getParameter("contactPerson"));
                reservation.setVisitReason(request.getParameter("visitReason"));
            }
            
            // 处理随行人员（简化处理，这里假设只有一个随行人员的字段）
            List<Companion> companions = new ArrayList<>();
            String companionName = request.getParameter("companionName");
            String companionIdCard = request.getParameter("companionIdCard");
            String companionPhone = request.getParameter("companionPhone");
            
            if (companionName != null && !companionName.trim().isEmpty()) {
                Companion companion = new Companion();
                companion.setName(companionName);
                companion.setIdCard(companionIdCard);
                companion.setPhone(companionPhone);
                companion.setRelationship(request.getParameter("companionRelationship"));
                companion.setRemark(request.getParameter("companionRemark"));
                companions.add(companion);
            }
            
            // 调用业务逻辑创建预约
            Long reservationId = reservationService.createReservation(reservation, companions);
            
            if (reservationId != null) {
                String message;
                if ("public".equals(reservation.getReservationType())) {
                    message = "预约申请提交成功，已自动审核通过！";
                } else {
                    message = "预约申请提交成功，请等待审核！";
                }
                
                request.setAttribute("successMessage", message);
                request.setAttribute("reservationId", reservationId);
                request.setAttribute("reservation", reservation);
                
                // 转发到成功页面
                request.getRequestDispatcher("/pages/reservation/create-success.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "预约申请失败，请稍后重试");
                request.getRequestDispatcher("/pages/reservation/reserve.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("创建预约异常: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "系统错误: " + e.getMessage());
            request.getRequestDispatcher("/pages/reservation/reserve.jsp").forward(request, response);
        }
    }
}
