package com.example.demo.controller;

import com.example.demo.dao.UserDao;
import com.example.demo.model.User;
import com.example.demo.model.ApiResponse;
import com.example.demo.util.SM3Util;
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
import java.util.HashMap;
import java.util.Map;

/**
 * 用户认证控制器
 */
@WebServlet("/api/auth/*")
public class AuthController extends HttpServlet {

    private UserDao userDao = new UserDao();
    private ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String pathInfo = request.getPathInfo();

        try {
            switch (pathInfo) {
                case "/login":
                    handleLogin(request, response);
                    break;
                case "/register":
                    handleRegister(request, response);
                    break;
                case "/logout":
                    handleLogout(request, response);
                    break;
                case "/check":
                    checkLoginStatus(request, response);
                    break;
                default:
                    writeResponse(response, ApiResponse.error("接口不存在"), 404);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            writeResponse(response, ApiResponse.error("系统错误：" + e.getMessage()), 500);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if ("/check".equals(pathInfo)) {
            checkLoginStatus(request, response);
        } else {
            writeResponse(response, ApiResponse.error("方法不支持"), 405);
        }
    }

    /**
     * 从请求中获取参数，支持JSON和表单数据
     */
    private Map<String, String> getRequestParams(HttpServletRequest request) throws IOException {
        Map<String, String> params = new HashMap<>();

        String contentType = request.getContentType();
        if (contentType != null && contentType.toLowerCase().contains("application/json")) {
            // 处理JSON请求
            BufferedReader reader = request.getReader();
            StringBuilder jsonBody = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonBody.append(line);
            }

            if (jsonBody.length() > 0) {
                try {
                    Map<String, Object> jsonMap = objectMapper.readValue(
                            jsonBody.toString(),
                            new TypeReference<Map<String, Object>>() {}
                    );
                    for (Map.Entry<String, Object> entry : jsonMap.entrySet()) {
                        if (entry.getValue() != null) {
                            params.put(entry.getKey(), entry.getValue().toString());
                        }
                    }
                } catch (Exception e) {
                    System.err.println("解析JSON失败: " + e.getMessage());
                }
            }
        } else {
            // 处理表单数据
            try {
                if (request.getParameter("username") != null) {
                    params.put("username", request.getParameter("username"));
                }
                if (request.getParameter("password") != null) {
                    params.put("password", request.getParameter("password"));
                }
                if (request.getParameter("name") != null) {
                    params.put("name", request.getParameter("name"));
                }
                if (request.getParameter("email") != null) {
                    params.put("email", request.getParameter("email"));
                }
                if (request.getParameter("phone") != null) {
                    params.put("phone", request.getParameter("phone"));
                }
                if (request.getParameter("rememberMe") != null) {
                    params.put("rememberMe", request.getParameter("rememberMe"));
                }
            } catch (Exception e) {
                System.err.println("获取表单参数失败: " + e.getMessage());
            }
        }

        return params;
    }

    /**
     * 处理用户登录
     */
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Map<String, String> params = getRequestParams(request);
        String username = params.get("username");
        String password = params.get("password");
        String rememberMe = params.get("rememberMe");

        if (username == null || username.trim().isEmpty()) {
            writeResponse(response, ApiResponse.error("用户名不能为空"), 400);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            writeResponse(response, ApiResponse.error("密码不能为空"), 400);
            return;
        }

        try {
            // 查找用户
            User user = userDao.findByUsername(username.trim());
            if (user == null) {
                writeResponse(response, ApiResponse.error("用户名或密码错误"), 401);
                return;
            }

            // 验证密码
            String hashedPassword = SM3Util.hash(password);
            if (!hashedPassword.equals(user.getPasswordHash())) {
                writeResponse(response, ApiResponse.error("用户名或密码错误"), 401);
                return;
            }

            // 登录成功，创建会话
            HttpSession session = request.getSession(true);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("name", user.getRealName());

            // 设置会话超时时间
            if ("true".equals(rememberMe)) {
                session.setMaxInactiveInterval(30 * 24 * 60 * 60); // 30天
            } else {
                session.setMaxInactiveInterval(24 * 60 * 60); // 24小时
            }

            // 返回用户信息
            Map<String, Object> userData = new HashMap<>();
            userData.put("id", user.getId());
            userData.put("username", user.getUsername());
            userData.put("name", user.getRealName());
            userData.put("email", user.getEmail());
            userData.put("phone", user.getPhone());

            writeResponse(response, ApiResponse.success("登录成功", userData), 200);

        } catch (Exception e) {
            e.printStackTrace();
            writeResponse(response, ApiResponse.error("登录失败：" + e.getMessage()), 500);
        }
    }

    /**
     * 处理用户注册
     */
    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Map<String, String> params = getRequestParams(request);
        String username = params.get("username");
        String password = params.get("password");
        String name = params.get("name");
        String email = params.get("email");
        String phone = params.get("phone");

        // 验证必填字段
        if (username == null || username.trim().isEmpty()) {
            writeResponse(response, ApiResponse.error("用户名不能为空"), 400);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            writeResponse(response, ApiResponse.error("密码不能为空"), 400);
            return;
        }

        if (name == null || name.trim().isEmpty()) {
            writeResponse(response, ApiResponse.error("姓名不能为空"), 400);
            return;
        }

        if (phone == null || phone.trim().isEmpty()) {
            writeResponse(response, ApiResponse.error("手机号不能为空"), 400);
            return;
        }

        try {
            // 检查用户名是否已存在
            if (userDao.findByUsername(username.trim()) != null) {
                writeResponse(response, ApiResponse.error("用户名已存在"), 409);
                return;
            }

            // 检查手机号是否已存在
            if (userDao.findByPhone(phone.trim()) != null) {
                writeResponse(response, ApiResponse.error("手机号已被注册"), 409);
                return;
            }

            // 创建新用户
            User user = new User();
            user.setUsername(username.trim());
            user.setPassword(password);  // setPassword方法内部会自动调用SM3Util.hash
            user.setRealName(name.trim());
            user.setEmail(email != null ? email.trim() : "");
            user.setPhoneData(phone.trim());  // 使用setPhoneData方法处理手机号加密

            // 保存用户
            boolean success = userDao.save(user);
            if (success) {
                // 注册成功 - 不自动登录，让用户手动登录以确保安全性
                User savedUser = userDao.findByUsername(username.trim());
                
                // 但是为了跳转到profile页面，我们需要临时创建session
                HttpSession session = request.getSession(true);
                session.setAttribute("userId", savedUser.getId());
                session.setAttribute("username", savedUser.getUsername());
                session.setAttribute("name", savedUser.getRealName());
                session.setMaxInactiveInterval(24 * 60 * 60); // 24小时

                Map<String, Object> userData = new HashMap<>();
                userData.put("id", savedUser.getId());
                userData.put("username", savedUser.getUsername());
                userData.put("name", savedUser.getRealName());
                userData.put("email", savedUser.getEmail());
                userData.put("phone", savedUser.getPhone());
                // 添加跳转标识
                userData.put("redirectTo", "/mobile/pages/profile/index.jsp");

                writeResponse(response, ApiResponse.success("注册成功", userData), 201);
            } else {
                writeResponse(response, ApiResponse.error("注册失败，请稍后重试"), 500);
            }

        } catch (Exception e) {
            e.printStackTrace();
            writeResponse(response, ApiResponse.error("注册失败：" + e.getMessage()), 500);
        }
    }

    /**
     * 处理用户登出
     */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            writeResponse(response, ApiResponse.success("退出成功", null), 200);
        } catch (Exception e) {
            e.printStackTrace();
            writeResponse(response, ApiResponse.error("退出失败：" + e.getMessage()), 500);
        }
    }

    /**
     * 检查登录状态
     */
    private void checkLoginStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("userId") != null) {
                Map<String, Object> userData = new HashMap<>();
                userData.put("id", session.getAttribute("userId"));
                userData.put("username", session.getAttribute("username"));
                userData.put("name", session.getAttribute("name"));
                userData.put("loggedIn", true);

                writeResponse(response, ApiResponse.success("已登录", userData), 200);
            } else {
                Map<String, Object> userData = new HashMap<>();
                userData.put("loggedIn", false);
                writeResponse(response, ApiResponse.success("未登录", userData), 200);
            }
        } catch (Exception e) {
            e.printStackTrace();
            writeResponse(response, ApiResponse.error("检查登录状态失败：" + e.getMessage()), 500);
        }
    }

    /**
     * 写入响应数据
     */
    private void writeResponse(HttpServletResponse response, ApiResponse apiResponse, int statusCode)
            throws IOException {
        response.setStatus(statusCode);
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");

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