package com.example.demo.model;

/**
 * 统一API响应格式
 */
public class ApiResponse {
    private boolean success;
    private String message;
    private Object data;
    
    public ApiResponse() {}
    
    public ApiResponse(boolean success, String message, Object data) {
        this.success = success;
        this.message = message;
        this.data = data;
    }
    
    // 成功响应方法
    public static ApiResponse success(String message) {
        return new ApiResponse(true, message, null);
    }
    
    public static ApiResponse success(String message, Object data) {
        return new ApiResponse(true, message, data);
    }
    
    public static ApiResponse success(Object data) {
        return new ApiResponse(true, "操作成功", data);
    }
    
    // 错误响应方法
    public static ApiResponse error(String message) {
        return new ApiResponse(false, message, null);
    }
    
    public static ApiResponse error(String message, Object data) {
        return new ApiResponse(false, message, data);
    }
    
    // Getters and Setters
    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public Object getData() { return data; }
    public void setData(Object data) { this.data = data; }
    
    @Override
    public String toString() {
        return "ApiResponse{" +
                "success=" + success +
                ", message='" + message + '\'' +
                ", data=" + data +
                '}';
    }
}
