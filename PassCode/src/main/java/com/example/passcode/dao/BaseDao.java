package com.example.passcode.dao;

import java.sql.*;

public class BaseDao {
    // MySQL JDBC 驱动和连接信息
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/kqy";
    private static final String USER = "root";
    private static final String PASS = "mysql@123";

    /**
     * 获取数据库连接
     * @return Connection对象
     * @throws SQLException 连接异常
     */
    protected Connection getConnection() throws SQLException {
        try {
            Class.forName(JDBC_DRIVER);
            Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
            return conn;
        } catch (ClassNotFoundException e) {
            throw new SQLException("❌ 找不到JDBC驱动程序", e);
        }
    }

    /**
     * 关闭数据库资源
     * @param resources 可变参数，自动关闭实现了AutoCloseable接口的资源
     */
    protected void closeResources(AutoCloseable... resources) {
        for (AutoCloseable resource : resources) {
            if (resource != null) {
                try {
                    resource.close();
                } catch (Exception e) {
                    System.err.println("⚠️ 关闭资源时出错: " + e.getMessage());
                }
            }
        }
    }

    /**
     * 判断字符串是否为空或null
     */
    protected boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
}