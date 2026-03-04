package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.model.ApiResponse;
import com.example.demo.service.UserService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.BufferedReader;
import java.util.Map;

/**
 * 用户信息控制器 - 处理用户相关的HTTP请求
 */
@WebServlet("/api/user/*")
public class UserController extends HttpServlet {
    
    private UserService userService = new UserService();
    private ObjectMapper objectMapper = new ObjectMapper();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        setResponseHeaders(request, response);
        String pathInfo = request.getPathInfo();
        
        try {
            if ("/stats".equals(pathInfo)) {
                getUserStats(request, response);
            } else if ("/statistics".equals(pathInfo)) {
                getUserStats(request, response); // 统一使用getUserStats
            } else if ("/profile".equals(pathInfo)) {
                getUserProfile(request, response);
            } else {
                writeResponse(response, ApiResponse.error("接口不存在"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            writeResponse(response, ApiResponse.error("服务器内部错误: " + e.getMessage()));
        }
    }
    
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        setResponseHeaders(request, response);
        String pathInfo = request.getPathInfo();
        
        try {
            if ("/profile".equals(pathInfo)) {
                updateUserProfile(request, response);
            } else {
                writeResponse(response, ApiResponse.error("接口不存在"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            writeResponse(response, ApiResponse.error("服务器内部错误: " + e.getMessage()));
        }
    }
    
    /**
     * 获取用户统计信息
     */
    private void getUserStats(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            writeResponse(response, ApiResponse.error("用户未登录"));
            return;
        }
        
        String username = (String) session.getAttribute("username");
        
        try {
            Map<String, Object> stats = userService.getUserStatistics(username);
            writeResponse(response, ApiResponse.success("获取统计信息成功", stats));
        } catch (Exception e) {
            e.printStackTrace();
            writeResponse(response, ApiResponse.error("获取用户统计信息失败：" + e.getMessage()));
        }
    }
    
    /**
     * 获取用户个人信息
     */
    private void getUserProfile(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            writeResponse(response, ApiResponse.error("用户未登录"));
            return;
        }
        
        String username = (String) session.getAttribute("username");
        
        try {
            User user = userService.getUserProfile(username);
            if (user == null) {
                writeResponse(response, ApiResponse.error("用户信息不存在"));
                return;
            }
            
            writeResponse(response, ApiResponse.success("获取用户信息成功", user));
        } catch (Exception e) {
            e.printStackTrace();
            writeResponse(response, ApiResponse.error("获取用户信息失败：" + e.getMessage()));
        }
    }
    
    /**
     * 更新用户个人信息
     */
    private void updateUserProfile(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            writeResponse(response, ApiResponse.error("用户未登录"));
            return;
        }
        
        String username = (String) session.getAttribute("username");
        
        try {
            // 读取请求体
            String requestBody = readRequestBody(request);
            if (requestBody == null || requestBody.trim().isEmpty()) {
                writeResponse(response, ApiResponse.error("请求体不能为空"));
                return;
            }
            
            // 解析JSON
            Map<String, Object> updateData = objectMapper.readValue(
                requestBody, 
                new TypeReference<Map<String, Object>>() {}
            );
            
            // 构建更新的用户对象
            User updatedUser = new User();
            if (updateData.containsKey("realName")) {
                updatedUser.setRealName((String) updateData.get("realName"));
            }
            if (updateData.containsKey("email")) {
                updatedUser.setEmail((String) updateData.get("email"));
            }
            if (updateData.containsKey("phone")) {
                updatedUser.setPhoneData((String) updateData.get("phone"));
            }
            
            boolean success = userService.updateUserProfile(username, updatedUser);
            if (success) {
                writeResponse(response, ApiResponse.success("用户信息更新成功", null));
            } else {
                writeResponse(response, ApiResponse.error("用户信息更新失败"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            writeResponse(response, ApiResponse.error("更新用户信息失败：" + e.getMessage()));
        }
    }
    
    /**
     * 读取请求体内容
     */
    private String readRequestBody(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        return sb.toString();
    }
    
    /**
     * 设置响应头
     */
    private void setResponseHeaders(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // CORS 头部
        String origin = request.getHeader("Origin");
        if (origin != null) {
            response.setHeader("Access-Control-Allow-Origin", origin);
        }
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization, X-Requested-With");
        response.setHeader("Access-Control-Allow-Credentials", "true");
        
        // 缓存控制
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
    }
    
    /**
     * 处理 OPTIONS 请求（CORS 预检）
     */
    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        setResponseHeaders(request, response);
        response.setStatus(HttpServletResponse.SC_OK);
    }
    
    /**
     * 写入响应数据
     */
    private void writeResponse(HttpServletResponse response, ApiResponse apiResponse) throws IOException {
        try {
            String jsonResponse = objectMapper.writeValueAsString(apiResponse);
            byte[] responseBytes = jsonResponse.getBytes("UTF-8");
            response.setContentLength(responseBytes.length);
            response.getOutputStream().write(responseBytes);
            response.getOutputStream().flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            String errorJson = "{\"success\":false,\"message\":\"响应写入失败\",\"data\":null}";
            byte[] errorBytes = errorJson.getBytes("UTF-8");
            response.setContentLength(errorBytes.length);
            response.getOutputStream().write(errorBytes);
            response.getOutputStream().flush();
        }
    }
}