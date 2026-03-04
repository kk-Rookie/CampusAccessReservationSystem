package com.example.demo.controller;

import com.example.demo.model.ApiResponse;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * 测试控制器 - 用于诊断和修复 ERR_INCOMPLETE_CHUNKED_ENCODING 错误
 */
@WebServlet("/api/test/*")
public class TestController extends HttpServlet {

    private ObjectMapper objectMapper = new ObjectMapper();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        setResponseHeaders(request, response);
        String pathInfo = request.getPathInfo();
        
        try {
            if ("/echo".equals(pathInfo)) {
                echoRequest(request, response);
            } else if ("/fixed-output".equals(pathInfo)) {
                fixedOutput(request, response);
            } else if ("/error-test".equals(pathInfo)) {
                errorTest(request, response);
            } else {
                Map<String, Object> info = new HashMap<>();
                info.put("availablePaths", new String[] {"/echo", "/fixed-output", "/error-test"});
                info.put("description", "这是一个测试API，用于诊断和修复ERR_INCOMPLETE_CHUNKED_ENCODING错误");
                
                writeResponse(response, ApiResponse.success("测试API", info));
            }
        } catch (Exception e) {
            e.printStackTrace();
            writeResponse(response, ApiResponse.error("测试API错误: " + e.getMessage()));
        }
    }
    
    /**
     * 回显请求信息
     */
    private void echoRequest(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        Map<String, Object> info = new HashMap<>();
        
        // 请求信息
        info.put("method", request.getMethod());
        info.put("requestURI", request.getRequestURI());
        info.put("queryString", request.getQueryString());
        info.put("remoteAddr", request.getRemoteAddr());
        
        // 请求头
        Map<String, String> headers = new HashMap<>();
        java.util.Enumeration<String> headerNames = request.getHeaderNames();
        while (headerNames.hasMoreElements()) {
            String headerName = headerNames.nextElement();
            headers.put(headerName, request.getHeader(headerName));
        }
        info.put("headers", headers);
        
        // 请求参数
        Map<String, String[]> parameters = request.getParameterMap();
        info.put("parameters", parameters);
        
        // 会话信息
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        if (session != null) {
            Map<String, Object> sessionInfo = new HashMap<>();
            sessionInfo.put("id", session.getId());
            sessionInfo.put("creationTime", new java.util.Date(session.getCreationTime()));
            sessionInfo.put("lastAccessedTime", new java.util.Date(session.getLastAccessedTime()));
            
            java.util.Enumeration<String> attributeNames = session.getAttributeNames();
            Map<String, Object> attributes = new HashMap<>();
            while (attributeNames.hasMoreElements()) {
                String attributeName = attributeNames.nextElement();
                Object attributeValue = session.getAttribute(attributeName);
                if (attributeValue != null) {
                    if (attributeValue instanceof String 
                        || attributeValue instanceof Number 
                        || attributeValue instanceof Boolean) {
                        attributes.put(attributeName, attributeValue);
                    } else {
                        attributes.put(attributeName, attributeValue.toString());
                    }
                } else {
                    attributes.put(attributeName, null);
                }
            }
            sessionInfo.put("attributes", attributes);
            info.put("session", sessionInfo);
        } else {
            info.put("session", null);
        }
        
        writeResponse(response, ApiResponse.success("请求信息", info));
    }
    
    /**
     * 固定大小输出
     */
    private void fixedOutput(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        int size = 1024; // 默认大小
        String sizeParam = request.getParameter("size");
        if (sizeParam != null && !sizeParam.trim().isEmpty()) {
            try {
                size = Integer.parseInt(sizeParam);
            } catch (NumberFormatException e) {
                // 忽略解析错误，使用默认值
            }
        }
        
        // 限制大小范围
        if (size < 0) size = 0;
        if (size > 1024*1024) size = 1024*1024; // 最大1MB
        
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < size; i++) {
            sb.append('X');
            if (i > 0 && i % 80 == 0) sb.append('\n');
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("size", size);
        result.put("data", sb.toString());
        
        writeResponse(response, ApiResponse.success("固定大小输出", result));
    }
    
    /**
     * 模拟错误情况
     */
    private void errorTest(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String type = request.getParameter("type");
        if ("exception".equals(type)) {
            throw new RuntimeException("测试异常");
        } else if ("stream-close".equals(type)) {
            // 模拟流被意外关闭的情况
            try {
                response.setContentLength(-1); // 强制使用分块编码
                response.getWriter().write("{\"success\":false,\"message\":\"这个响应会被中断\",\"data\":");
                response.getWriter().flush();
                // 这里模拟未完成的JSON响应
                response.getWriter().close();
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if ("invalid-json".equals(type)) {
            // 返回不完整的JSON
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":false,\"message\":\"不完整的JSON\",");
            response.getWriter().flush();
            return;
        } else {
            Map<String, Object> result = new HashMap<>();
            result.put("availableTypes", new String[] {"exception", "stream-close", "invalid-json"});
            writeResponse(response, ApiResponse.success("错误测试", result));
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
}
