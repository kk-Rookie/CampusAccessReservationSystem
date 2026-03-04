package com.example.demo.dao;

import java.sql.*;

/**
 * 数据访问基础类 - MySQL版本
 */
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
            System.out.println("✅ MySQL数据库连接成功！");
            
            // ✅ 修复：返回连接对象
            return conn;
            
        } catch (ClassNotFoundException e) {
            System.err.println("❌ 找不到JDBC驱动程序: " + e.getMessage());
            throw new SQLException("❌ 找不到JDBC驱动程序", e);
        } catch (SQLException e) {
            System.err.println("❌ MySQL数据库连接失败: " + e.getMessage());
            throw e;
        }
    }

    /**
     * 关闭资源的方法
     */
    protected void closeResources(AutoCloseable... resources) {
        for (AutoCloseable resource : resources) {
            if (resource != null) {
                try {
                    resource.close();
                } catch (Exception e) {
                    System.err.println("关闭资源失败: " + e.getMessage());
                    e.printStackTrace();
                }
            }
        }
    }
    
    /**
     * 执行更新操作并返回生成的主键
     */
    protected Long executeUpdateWithGeneratedKey(String sql, Object... params) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            System.out.println("🔧 执行SQL: " + sql);
            System.out.println("📝 参数: " + java.util.Arrays.toString(params));
            
            conn = getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            // 设置参数
            for (int i = 0; i < params.length; i++) {
                setPreparedStatementParameter(pstmt, i + 1, params[i]);
            }
            
            int affectedRows = pstmt.executeUpdate();
            System.out.println("✅ 影响行数: " + affectedRows);
            
            if (affectedRows == 0) {
                throw new SQLException("插入失败，没有行被影响");
            }
            
            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                Long generatedId = rs.getLong(1);
                System.out.println("🆔 生成的ID: " + generatedId);
                return generatedId;
            } else {
                throw new SQLException("插入失败，没有获取到生成的ID");
            }
            
        } catch (SQLException e) {
            System.err.println("❌ SQL执行失败: " + e.getMessage());
            System.err.println("📝 SQL语句: " + sql);
            throw e;
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }
    
    /**
     * 执行更新操作
     */
    protected int executeUpdate(String sql, Object... params) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            System.out.println("🔧 执行SQL: " + sql);
            System.out.println("📝 参数: " + java.util.Arrays.toString(params));
            
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            
            // 设置参数
            for (int i = 0; i < params.length; i++) {
                setPreparedStatementParameter(pstmt, i + 1, params[i]);
            }
            
            int affectedRows = pstmt.executeUpdate();
            System.out.println("✅ 影响行数: " + affectedRows);
            
            return affectedRows;
            
        } catch (SQLException e) {
            System.err.println("❌ SQL执行失败: " + e.getMessage());
            System.err.println("📝 SQL语句: " + sql);
            throw e;
        } finally {
            closeResources(pstmt, conn);
        }
    }
    
    /**
     * 执行查询操作
     */
    protected ResultSet executeQuery(String sql, Object... params) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            System.out.println("🔍 执行查询SQL: " + sql);
            System.out.println("📝 参数: " + java.util.Arrays.toString(params));
            
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            
            // 设置参数
            for (int i = 0; i < params.length; i++) {
                setPreparedStatementParameter(pstmt, i + 1, params[i]);
            }
            
            rs = pstmt.executeQuery();
            return rs;
            
        } catch (SQLException e) {
            System.err.println("❌ 查询失败: " + e.getMessage());
            System.err.println("📝 SQL语句: " + sql);
            closeResources(rs, pstmt, conn);
            throw e;
        }
    }
    
    /**
     * 设置PreparedStatement参数
     */
    protected void setPreparedStatementParameter(PreparedStatement pstmt, int parameterIndex, Object value) throws SQLException {
        if (value == null) {
            pstmt.setNull(parameterIndex, Types.NULL);
        } else if (value instanceof String) {
            pstmt.setString(parameterIndex, (String) value);
        } else if (value instanceof Integer) {
            pstmt.setInt(parameterIndex, (Integer) value);
        } else if (value instanceof Long) {
            pstmt.setLong(parameterIndex, (Long) value);
        } else if (value instanceof java.util.Date) {
            pstmt.setTimestamp(parameterIndex, new Timestamp(((java.util.Date) value).getTime()));
        } else if (value instanceof Timestamp) {
            pstmt.setTimestamp(parameterIndex, (Timestamp) value);
        } else if (value instanceof Boolean) {
            pstmt.setBoolean(parameterIndex, (Boolean) value);
        } else if (value instanceof Double) {
            pstmt.setDouble(parameterIndex, (Double) value);
        } else if (value instanceof Float) {
            pstmt.setFloat(parameterIndex, (Float) value);
        } else {
            pstmt.setObject(parameterIndex, value);
        }
    }
    
    /**
     * 测试数据库连接
     */
    public boolean testConnection() {
        Connection conn = null;
        try {
            conn = getConnection();
            if (conn != null && !conn.isClosed()) {
                System.out.println("✅ 数据库连接测试成功！");
                return true;
            }
        } catch (SQLException e) {
            System.err.println("❌ 数据库连接测试失败: " + e.getMessage());
            return false;
        } finally {
            closeResources(conn);
        }
        return false;
    }
    
    /**
     * 获取数据库元信息
     */
    public void showDatabaseInfo() {
        Connection conn = null;
        try {
            conn = getConnection();
            DatabaseMetaData metaData = conn.getMetaData();
            
            System.out.println("📊 数据库信息:");
            System.out.println("  数据库产品: " + metaData.getDatabaseProductName());
            System.out.println("  数据库版本: " + metaData.getDatabaseProductVersion());
            System.out.println("  驱动名称: " + metaData.getDriverName());
            System.out.println("  驱动版本: " + metaData.getDriverVersion());
            System.out.println("  URL: " + metaData.getURL());
            System.out.println("  用户名: " + metaData.getUserName());
            
        } catch (SQLException e) {
            System.err.println("❌ 获取数据库信息失败: " + e.getMessage());
        } finally {
            closeResources(conn);
        }
    }
    
    /**
     * 检查表是否存在
     */
    public boolean tableExists(String tableName) {
        Connection conn = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            DatabaseMetaData metaData = conn.getMetaData();
            rs = metaData.getTables(null, null, tableName, new String[]{"TABLE"});
            
            boolean exists = rs.next();
            System.out.println("🔍 表 " + tableName + (exists ? " 存在" : " 不存在"));
            return exists;
            
        } catch (SQLException e) {
            System.err.println("❌ 检查表存在性失败: " + e.getMessage());
            return false;
        } finally {
            closeResources(rs, conn);
        }
    }
    
    /**
     * 记录数据访问日志（简化版本）
     */
    protected void logDataAccess(String tableName, Long recordId, String accessType, 
                                String accessedFields, String userName, String userIdCardHash, 
                                String ipAddress, boolean sensitiveDataAccessed) {
        // 简化版本，记录到控制台
        System.out.println("📋 数据访问日志:");
        System.out.println("  表名: " + tableName);
        System.out.println("  记录ID: " + recordId);
        System.out.println("  操作类型: " + accessType);
        System.out.println("  访问字段: " + accessedFields);
        System.out.println("  用户: " + userName);
        System.out.println("  IP: " + ipAddress);
        System.out.println("  敏感数据: " + (sensitiveDataAccessed ? "是" : "否"));
        System.out.println("  时间: " + new java.util.Date());
    }
}
