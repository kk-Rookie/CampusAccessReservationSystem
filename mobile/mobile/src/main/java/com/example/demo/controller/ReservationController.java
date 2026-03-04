package com.example.demo.controller;

import com.example.demo.model.Reservation;
import com.example.demo.model.Companion;
import com.example.demo.model.ApiResponse;
import com.example.demo.service.ReservationService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 预约控制器 - 处理所有预约相关的HTTP请求
 */
@WebServlet("/api/reservation/*")
public class ReservationController extends HttpServlet {
    
    private ReservationService reservationService = new ReservationService(); // 修正：应该是Service不是Controller
    private ObjectMapper objectMapper = new ObjectMapper();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        setResponseHeaders(request, response);
        String pathInfo = request.getPathInfo();
        
        try {
            if ("/create".equals(pathInfo)) {
                createReservation(request, response);
            } else {
                writeResponse(response, ApiResponse.error("接口不存在"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            writeResponse(response, ApiResponse.error("服务器内部错误: " + e.getMessage()));
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        setResponseHeaders(request, response);
        String pathInfo = request.getPathInfo();
        
        try {
            if ("/list".equals(pathInfo)) {
                getReservationList(request, response);
            } else if ("/my".equals(pathInfo)) {
                getMyReservations(request, response);
            } else if (pathInfo != null && pathInfo.startsWith("/detail/")) {
                getReservationDetail(request, response);
            } else {
                writeResponse(response, ApiResponse.error("接口不存在"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            writeResponse(response, ApiResponse.error("服务器内部错误: " + e.getMessage()));
        }
    }
    
    /**
     * 创建预约
     */
    private void createReservation(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
    
        System.out.println("=== 收到创建预约请求 ===");
    
        try {
            // 读取请求体
            String requestBody = readRequestBody(request);
            System.out.println("请求体: " + requestBody);
            
            if (requestBody == null || requestBody.trim().isEmpty()) {
                writeResponse(response, ApiResponse.error("请求体不能为空"));
                return;
            }
            
            JsonNode jsonNode = objectMapper.readTree(requestBody);
            
            // 构建预约对象
            Reservation reservation = new Reservation();
            
            // ✅ 安全设置基本信息
            String reservationType = getJsonText(jsonNode, "reservationType");
            if (reservationType == null || reservationType.trim().isEmpty()) {
                writeResponse(response, ApiResponse.error("预约类型不能为空"));
                return;
            }
            reservation.setReservationType(reservationType);
            
            String campus = getJsonText(jsonNode, "campus");
            if (campus == null || campus.trim().isEmpty()) {
                writeResponse(response, ApiResponse.error("校区不能为空"));
                return;
            }
            reservation.setCampus(campus);
            
            String name = getJsonText(jsonNode, "name");
            if (name == null || name.trim().isEmpty()) {
                writeResponse(response, ApiResponse.error("姓名不能为空"));
                return;
            }
            reservation.setName(name);
            
            String idCard = getJsonText(jsonNode, "idCard");
            if (idCard == null || idCard.trim().isEmpty()) {
                writeResponse(response, ApiResponse.error("身份证号不能为空"));
                return;
            }
            reservation.setIdCard(idCard); // 这里会自动加密和哈希
            
            String phone = getJsonText(jsonNode, "phone");
            if (phone == null || phone.trim().isEmpty()) {
                writeResponse(response, ApiResponse.error("手机号不能为空"));
                return;
            }
            reservation.setPhone(phone); // 这里会自动加密和哈希
            
            // 设置用户名 - 首先从请求体获取
            String username = getJsonText(jsonNode, "username");
            
            // 如果请求体没有用户名，尝试从会话中获取
            if (username == null || username.trim().isEmpty()) {
                jakarta.servlet.http.HttpSession session = request.getSession(false);
                if (session != null) {
                    username = (String) session.getAttribute("username");
                    System.out.println("从会话中获取用户名: " + username);
                }
            }
            
            reservation.setUsername(username);
            System.out.println("设置预约的用户名为: " + username);
            
            // 解析时间
            String visitTimeStr = getJsonText(jsonNode, "visitTime");
            if (visitTimeStr != null) {
                try {
                    if (visitTimeStr.matches("\\d+")) {
                        reservation.setVisitTime(new Date(Long.parseLong(visitTimeStr)));
                    } else {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                        reservation.setVisitTime(sdf.parse(visitTimeStr));
                    }
                } catch (Exception e) {
                    writeResponse(response, ApiResponse.error("访问时间格式错误"));
                    return;
                }
            } else {
                writeResponse(response, ApiResponse.error("访问时间不能为空"));
                return;
            }
            
            // 设置其他字段
            reservation.setOrganization(getJsonText(jsonNode, "organization"));
            reservation.setTransportation(getJsonText(jsonNode, "transportation"));
            reservation.setPlateNumber(getJsonText(jsonNode, "plateNumber"));
            
            // 公务预约特有字段
            if ("business".equals(reservationType)) {
                if (jsonNode.has("visitDepartmentId") && !jsonNode.get("visitDepartmentId").isNull()) {
                    reservation.setVisitDepartmentId(jsonNode.get("visitDepartmentId").asLong());
                }
                reservation.setContactPerson(getJsonText(jsonNode, "contactPerson"));
                reservation.setVisitReason(getJsonText(jsonNode, "visitReason"));
            }
            
            // 解析随行人员
            List<Companion> companions = new ArrayList<>();
            if (jsonNode.has("companions") && jsonNode.get("companions").isArray()) {
                for (JsonNode companionNode : jsonNode.get("companions")) {
                    Companion companion = new Companion();
                    companion.setName(getJsonText(companionNode, "name"));
                    companion.setIdCard(getJsonText(companionNode, "idCard"));
                    companion.setPhone(getJsonText(companionNode, "phone"));
                    companion.setRelationship(getJsonText(companionNode, "relationship"));
                    companion.setRemark(getJsonText(companionNode, "remark"));
                    companions.add(companion);
                }
            }
            
            System.out.println("预约对象构建完成: " + reservation);
            
            // 调用业务逻辑
            Long reservationId = reservationService.createReservation(reservation, companions);
            
            if (reservationId != null) {
                Map<String, Object> result = new HashMap<>();
                result.put("reservationId", reservationId);
                result.put("status", reservation.getStatus());
                
                String message;
                if ("public".equals(reservation.getReservationType())) {
                    message = "预约申请提交成功，已自动审核通过";
                    
                    // 返回通行码信息
                    if (reservation.getPassCode() != null) {
                        result.put("passCode", reservation.getPassCode());
                        result.put("passCodeExpireTime", reservation.getPassCodeExpireTime());
                    }
                } else {
                    message = "预约申请提交成功，请等待审核";
                }
                
                writeResponse(response, ApiResponse.success(message, result));
            } else {
                writeResponse(response, ApiResponse.error("预约申请失败"));
            }
            
        } catch (Exception e) {
            System.err.println("创建预约异常: " + e.getMessage());
            e.printStackTrace();
            writeResponse(response, ApiResponse.error("服务器内部错误: " + e.getMessage()));
        }
    }
    
    /**
     * 查询预约列表
     */
    private void getReservationList(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        String name = request.getParameter("name");
        String idCard = request.getParameter("idCard");
        String phone = request.getParameter("phone");
        
        
        List<Reservation> reservations = reservationService.getUserReservations(name, idCard, phone);
        writeResponse(response, ApiResponse.success(reservations));
    }
    
    /**
     * 获取我的预约 - 根据用户名获取预约信息
     */
    private void getMyReservations(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        // 从会话或请求参数中获取用户名
        String username = request.getParameter("username");
        
        // 如果参数中没有用户名，尝试从会话中获取
        if (username == null || username.trim().isEmpty()) {
            jakarta.servlet.http.HttpSession session = request.getSession(false);
            if (session != null) {
                username = (String) session.getAttribute("username");
            }
        }
        
        if (username == null || username.trim().isEmpty()) {
            writeResponse(response, ApiResponse.error("用户未登录或用户名为空"));
            return;
        }
        
        try {
            // 调用ReservationService的getReservationsByUsername方法
            List<Reservation> reservations = reservationService.getReservationsByUsername(username);
            
            if (reservations != null) {
                writeResponse(response, ApiResponse.success("获取预约列表成功", reservations));
            } else {
                writeResponse(response, ApiResponse.success("暂无预约记录", new ArrayList<>()));
            }
        } catch (Exception e) {
            System.err.println("获取用户预约失败: " + e.getMessage());
            e.printStackTrace();
            writeResponse(response, ApiResponse.error("获取预约信息失败: " + e.getMessage()));
        }
    }
    
    /**
     * 查询预约详情
     */
    private void getReservationDetail(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        String pathInfo = request.getPathInfo();
        String idStr = pathInfo.substring("/detail/".length());
        Long id = Long.parseLong(idStr);
        
       
        Reservation reservation = reservationService.getReservationById(id);
        
        if (reservation != null) {
            Map<String, Object> result = new HashMap<>();
            result.put("reservation", reservation);
            result.put("isPassCodeValid", reservationService.isPassCodeValid(id));
            
            writeResponse(response, ApiResponse.success(result));
        } else {
            writeResponse(response, ApiResponse.error("预约记录不存在"));
        }
    }
    
    /**
     * 设置响应头
     */
    private void setResponseHeaders(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
    }
    
    /**
     * 写入响应
     */
    private void writeResponse(HttpServletResponse response, ApiResponse apiResponse) 
            throws IOException {
        // 设置响应内容长度以避免分块传输问题
        String jsonResponse = objectMapper.writeValueAsString(apiResponse);
        byte[] responseBytes = jsonResponse.getBytes("UTF-8");
        response.setContentLength(responseBytes.length);
        
        // 确保响应设置了正确的状态码
        if (!apiResponse.isSuccess()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } else {
            response.setStatus(HttpServletResponse.SC_OK);
        }
        
        // 写入响应数据
        response.getOutputStream().write(responseBytes);
        response.getOutputStream().flush();
    }
    
    /**
     * 安全地从JSON节点中获取文本值
     */
    private String getJsonText(JsonNode node, String fieldName) {
        JsonNode fieldNode = node.get(fieldName);
        if (fieldNode == null || fieldNode.isNull()) {
            return null;
        }
        return fieldNode.asText();
    }
    
    /**
     * 读取请求体内容
     */
    private String readRequestBody(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        String line;
        try (java.io.BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        return sb.toString();
    }
    
    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        setResponseHeaders(request, response);
        response.setStatus(HttpServletResponse.SC_OK);
    }
}