package com.example.passcode.dao;

import com.example.passcode.model.SystemAudit;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 系统审计数据访问对象（使用operation_logs表）
 */
public class SystemAuditDao extends BaseDao {

    /**
     * 分页查询系统审计记录
     */
    public List<SystemAudit> getSystemAudits(int page, int pageSize, String auditType, 
                                            String moduleName, String adminName, 
                                            String startDate, String endDate) {
        List<SystemAudit> audits = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT * FROM operation_logs WHERE 1=1"
        );
        
        List<Object> params = new ArrayList<>();
        
        // 添加查询条件
        if (auditType != null && !auditType.isEmpty()) {
            sql.append(" AND operation_type = ?");
            params.add(auditType);
        }
        
        if (moduleName != null && !moduleName.isEmpty()) {
            sql.append(" AND operation_module = ?");
            params.add(moduleName);
        }
        
        if (adminName != null && !adminName.isEmpty()) {
            sql.append(" AND user_name LIKE ?");
            params.add("%" + adminName + "%");
        }
        
        if (startDate != null && !startDate.isEmpty()) {
            sql.append(" AND DATE(operation_time) >= ?");
            params.add(startDate);
        }
        
        if (endDate != null && !endDate.isEmpty()) {
            sql.append(" AND DATE(operation_time) <= ?");
            params.add(endDate);
        }
        
        // 排序和分页
        sql.append(" ORDER BY operation_time DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            // 设置参数
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    SystemAudit audit = mapResultSetToAudit(rs);
                    audits.add(audit);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("查询系统审计记录失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return audits;
    }

    /**
     * 获取系统审计记录总数
     */
    public int getTotalCount(String auditType, String moduleName, String adminName, 
                           String startDate, String endDate) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM operation_logs WHERE 1=1"
        );
        
        List<Object> params = new ArrayList<>();
        
        // 添加查询条件
        if (auditType != null && !auditType.isEmpty()) {
            sql.append(" AND operation_type = ?");
            params.add(auditType);
        }
        
        if (moduleName != null && !moduleName.isEmpty()) {
            sql.append(" AND operation_module = ?");
            params.add(moduleName);
        }
        
        if (adminName != null && !adminName.isEmpty()) {
            sql.append(" AND user_name LIKE ?");
            params.add("%" + adminName + "%");
        }
        
        if (startDate != null && !startDate.isEmpty()) {
            sql.append(" AND DATE(operation_time) >= ?");
            params.add(startDate);
        }
        
        if (endDate != null && !endDate.isEmpty()) {
            sql.append(" AND DATE(operation_time) <= ?");
            params.add(endDate);
        }
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            // 设置参数
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("获取系统审计记录总数失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }

    /**
     * 根据ID查询系统审计记录
     */
    public SystemAudit getSystemAuditById(Long id) {
        String sql = "SELECT * FROM operation_logs WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAudit(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("查询系统审计记录详情失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }

    /**
     * 添加系统审计记录
     */
    public boolean addSystemAudit(SystemAudit audit) {
        String sql = "INSERT INTO operation_logs (operation_type, operation_module, operation_description, " +
                    "user_name, user_id_card_hash, user_phone_hash, ip_address, user_agent, device_info, " +
                    "session_id, target_table, target_record_id, operation_data, data_before, data_after, " +
                    "operation_result, error_message, response_time, risk_level, risk_factors, " +
                    "operation_time, log_hash) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, audit.getOperationType());
            stmt.setString(2, audit.getOperationModule());
            stmt.setString(3, audit.getOperationDescription());
            stmt.setString(4, audit.getUserName());
            stmt.setString(5, audit.getUserIdCardHash());
            stmt.setString(6, audit.getUserPhoneHash());
            stmt.setString(7, audit.getIpAddress());
            stmt.setString(8, audit.getUserAgent());
            stmt.setString(9, audit.getDeviceInfo());
            stmt.setString(10, audit.getSessionId());
            stmt.setString(11, audit.getTargetTable());
            if (audit.getTargetRecordId() != null) {
                stmt.setLong(12, audit.getTargetRecordId());
            } else {
                stmt.setNull(12, Types.BIGINT);
            }
            stmt.setString(13, audit.getOperationData());
            stmt.setString(14, audit.getDataBefore());
            stmt.setString(15, audit.getDataAfter());
            stmt.setString(16, audit.getOperationResult());
            stmt.setString(17, audit.getErrorMessage());
            if (audit.getResponseTime() != null) {
                stmt.setInt(18, audit.getResponseTime());
            } else {
                stmt.setNull(18, Types.INTEGER);
            }
            stmt.setString(19, audit.getRiskLevel());
            stmt.setString(20, audit.getRiskFactors());
            stmt.setTimestamp(21, audit.getOperationTime());
            stmt.setString(22, audit.getLogHash());
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("添加系统审计记录失败: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 将ResultSet映射为SystemAudit对象
     */
    private SystemAudit mapResultSetToAudit(ResultSet rs) throws SQLException {
        SystemAudit audit = new SystemAudit();
        
        audit.setId(rs.getLong("id"));
        audit.setOperationType(rs.getString("operation_type"));
        audit.setOperationModule(rs.getString("operation_module"));
        audit.setOperationDescription(rs.getString("operation_description"));
        audit.setUserName(rs.getString("user_name"));
        audit.setUserIdCardHash(rs.getString("user_id_card_hash"));
        audit.setUserPhoneHash(rs.getString("user_phone_hash"));
        audit.setIpAddress(rs.getString("ip_address"));
        audit.setUserAgent(rs.getString("user_agent"));
        audit.setDeviceInfo(rs.getString("device_info"));
        audit.setSessionId(rs.getString("session_id"));
        audit.setTargetTable(rs.getString("target_table"));
        Long targetRecordId = rs.getLong("target_record_id");
        if (!rs.wasNull()) {
            audit.setTargetRecordId(targetRecordId);
        }
        audit.setOperationData(rs.getString("operation_data"));
        audit.setDataBefore(rs.getString("data_before"));
        audit.setDataAfter(rs.getString("data_after"));
        audit.setOperationResult(rs.getString("operation_result"));
        audit.setErrorMessage(rs.getString("error_message"));
        Integer responseTime = rs.getInt("response_time");
        if (!rs.wasNull()) {
            audit.setResponseTime(responseTime);
        }
        audit.setRiskLevel(rs.getString("risk_level"));
        audit.setRiskFactors(rs.getString("risk_factors"));
        audit.setOperationTime(rs.getTimestamp("operation_time"));
        audit.setLogHash(rs.getString("log_hash"));
        
        return audit;
    }

    /**
     * 获取不同操作类型的统计数量
     */
    public List<String> getDistinctOperationTypes() {
        List<String> types = new ArrayList<>();
        String sql = "SELECT DISTINCT operation_type FROM operation_logs WHERE operation_type IS NOT NULL ORDER BY operation_type";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                types.add(rs.getString("operation_type"));
            }
            
        } catch (SQLException e) {
            System.err.println("获取操作类型失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return types;
    }

    /**
     * 获取不同模块名称
     */
    public List<String> getDistinctModuleNames() {
        List<String> modules = new ArrayList<>();
        String sql = "SELECT DISTINCT operation_module FROM operation_logs WHERE operation_module IS NOT NULL ORDER BY operation_module";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                modules.add(rs.getString("operation_module"));
            }
            
        } catch (SQLException e) {
            System.err.println("获取模块名称失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return modules;
    }
}
