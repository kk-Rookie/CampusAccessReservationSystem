package com.example.passcode.dao;

import com.example.passcode.model.Reservation;
import com.example.passcode.model.Department;
import com.example.passcode.util.SM3Util;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 预约数据访问对象
 * 提供预约相关的数据库操作方法
 */
public class ReservationDao extends BaseDao {

    /**
     * 添加预约记录
     * @param reservation 预约对象
     * @return 返回生成的预约ID，失败返回0
     */
    public int addReservation(Reservation reservation) {
        String sql = "INSERT INTO reservations (username, reservation_type, campus, visit_time, organization, " +
                "name, id_card_encrypted, phone_encrypted, id_card_hash, phone_hash, transportation, " +
                "plate_number, visit_department_id, contact_person, visit_reason, status, creator_id, " +
                "data_integrity) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            pstmt.setString(1, reservation.getUsername());
            pstmt.setString(2, reservation.getReservationType());
            pstmt.setString(3, reservation.getCampus());
            pstmt.setTimestamp(4, Timestamp.valueOf(reservation.getVisitTime()));
            pstmt.setString(5, reservation.getOrganization());
            pstmt.setString(6, reservation.getName());
            
            // 加密敏感信息
            String idCard = reservation.getIdCard();
            String phone = reservation.getPhone();
            pstmt.setString(7, "encrypted_" + idCard); // 简化的加密实现
            pstmt.setString(8, "encrypted_" + phone);
            pstmt.setString(9, SM3Util.hash(idCard));
            pstmt.setString(10, SM3Util.hash(phone));
            
            pstmt.setString(11, reservation.getTransportation());
            pstmt.setString(12, reservation.getPlateNumber());
            pstmt.setObject(13, reservation.getVisitDepartmentId());
            pstmt.setString(14, reservation.getContactPerson());
            pstmt.setString(15, reservation.getVisitReason());
            pstmt.setString(16, "pending"); // 默认状态为待审核
            pstmt.setObject(17, reservation.getCreatorId());
            
            // 生成数据完整性校验值
            String integrityData = reservation.getName() + reservation.getPhone() + System.currentTimeMillis();
            pstmt.setString(18, SM3Util.hash(integrityData));

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows == 0) {
                return 0;
            }

            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            } else {
                return 0;
            }

        } catch (SQLException e) {
            System.err.println("添加预约记录时发生错误: " + e.getMessage());
            e.printStackTrace();
            return 0;
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }

    /**
     * 根据条件查询预约记录
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @param campus 校区
     * @param reservationType 预约类型
     * @param departmentId 部门ID
     * @param status 状态
     * @param name 姓名
     * @param limit 限制条数
     * @param offset 偏移量
     * @return 预约记录列表
     */
    public List<Reservation> getReservationsByConditions(Date startDate, Date endDate, 
            String campus, String reservationType, Integer departmentId, String status, 
            String name, Integer limit, Integer offset) {
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT r.id, r.username, r.reservation_type, r.campus, r.visit_time, ");
        sql.append("r.organization, r.name, r.id_card_encrypted, r.phone_encrypted, ");
        sql.append("r.status, r.create_time, r.transportation, ");
        sql.append("r.plate_number, r.contact_person, r.visit_reason, r.visit_department_id, ");
        sql.append("d.id AS department_id, d.department_name AS visit_department_name ");
        sql.append("FROM reservations r ");
        sql.append("LEFT JOIN departments d ON r.visit_department_id = d.id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (startDate != null) {
            sql.append("AND DATE(r.create_time) >= ? ");
            params.add(startDate);
        }
        if (endDate != null) {
            sql.append("AND DATE(r.create_time) <= ? ");
            params.add(endDate);
        }
        if (campus != null && !campus.trim().isEmpty()) {
            sql.append("AND r.campus = ? ");
            params.add(campus);
        }
        if (reservationType != null && !reservationType.trim().isEmpty()) {
            sql.append("AND r.reservation_type = ? ");
            params.add(reservationType);
        }
        if (departmentId != null) {
            sql.append("AND r.visit_department_id = ? ");
            params.add(departmentId);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND r.status = ? ");
            params.add(status);
        }
        if (name != null && !name.trim().isEmpty()) {
            sql.append("AND r.name LIKE ? ");
            params.add("%" + name + "%");
        }

        sql.append("ORDER BY r.create_time DESC ");
        
        if (limit != null && limit > 0) {
            sql.append("LIMIT ? ");
            params.add(limit);
            if (offset != null && offset > 0) {
                sql.append("OFFSET ? ");
                params.add(offset);
            }
        }

        List<Reservation> reservations = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql.toString());
            
            // 设置参数
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            rs = pstmt.executeQuery();
            while (rs.next()) {
                Reservation reservation = new Reservation();
                reservation.setId(rs.getLong("id"));
                reservation.setUsername(rs.getString("username"));
                reservation.setReservationType(rs.getString("reservation_type"));
                reservation.setCampus(rs.getString("campus"));
                
                Timestamp visitTime = rs.getTimestamp("visit_time");
                if (visitTime != null) {
                    reservation.setVisitTime(visitTime.toLocalDateTime());
                }
                
                reservation.setOrganization(rs.getString("organization"));
                reservation.setName(rs.getString("name"));
                
                // 解密身份证和手机号
                String encryptedIdCard = rs.getString("id_card_encrypted");
                String encryptedPhone = rs.getString("phone_encrypted");
                
                if (encryptedIdCard != null && encryptedIdCard.startsWith("encrypted_")) {
                    // 简单的解密（实际项目中应该使用真正的解密算法）
                    reservation.setIdCard(encryptedIdCard.substring(10));
                }
                
                if (encryptedPhone != null && encryptedPhone.startsWith("encrypted_")) {
                    // 简单的解密（实际项目中应该使用真正的解密算法）
                    reservation.setPhone(encryptedPhone.substring(10));
                }
                
                reservation.setStatus(rs.getString("status"));
                reservation.setTransportation(rs.getString("transportation"));
                reservation.setPlateNumber(rs.getString("plate_number"));
                reservation.setContactPerson(rs.getString("contact_person"));
                reservation.setVisitReason(rs.getString("visit_reason"));
                reservation.setVisitDepartmentId(rs.getInt("visit_department_id"));
                reservation.setVisitDepartmentName(rs.getString("visit_department_name"));
                
                Timestamp createTime = rs.getTimestamp("create_time");
                if (createTime != null) {
                    reservation.setCreateTime(createTime.toLocalDateTime());
                }
                
                // 创建部门对象（如果有部门信息）
                if (rs.getString("visit_department_name") != null) {
                    Department dept = new Department();
                    dept.setDeptId(rs.getInt("department_id"));
                    dept.setDeptName(rs.getString("visit_department_name"));
                    reservation.setDepartment(dept);
                }
                
                reservations.add(reservation);
            }

        } catch (SQLException e) {
            System.err.println("查询预约记录时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return reservations;
    }

    /**
     * 根据管理员权限查询预约记录（基于organization字段）
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @param campus 校区
     * @param reservationType 预约类型
     * @param status 状态
     * @param name 姓名
     * @param adminDepartmentName 管理员的部门名称
     * @param isSystemAdmin 是否是系统管理员
     * @param limit 限制条数
     * @param offset 偏移量
     * @return 预约记录列表
     */
    public List<Reservation> getReservationsByPermission(Date startDate, Date endDate, 
            String campus, String reservationType, String status, String name,
            String adminDepartmentName, boolean isSystemAdmin, Integer limit, Integer offset) {
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT r.*, d.department_name as visit_department_name FROM reservations r ");
        sql.append("LEFT JOIN departments d ON r.visit_department_id = d.id ");
        sql.append("WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        
        // 权限过滤：系统管理员可以看所有，其他管理员只能看"无"或自己部门的
        if (!isSystemAdmin) {
            sql.append("AND (r.organization = '无' OR r.organization = ?) ");
            params.add(adminDepartmentName);
        }
        
        // 其他条件过滤
        if (startDate != null) {
            sql.append("AND DATE(r.visit_time) >= ? ");
            params.add(startDate);
        }
        
        if (endDate != null) {
            sql.append("AND DATE(r.visit_time) <= ? ");
            params.add(endDate);
        }
        
        if (campus != null && !campus.trim().isEmpty()) {
            sql.append("AND r.campus = ? ");
            params.add(campus);
        }
        
        if (reservationType != null && !reservationType.trim().isEmpty()) {
            sql.append("AND r.reservation_type = ? ");
            params.add(reservationType);
        }
        
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND r.status = ? ");
            params.add(status);
        }
        
        if (name != null && !name.trim().isEmpty()) {
            sql.append("AND r.name LIKE ? ");
            params.add("%" + name + "%");
        }
        
        sql.append("ORDER BY r.create_time DESC ");
        
        if (limit != null && limit > 0) {
            sql.append("LIMIT ? ");
            params.add(limit);
            
            if (offset != null && offset > 0) {
                sql.append("OFFSET ? ");
                params.add(offset);
            }
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Reservation> reservations = new ArrayList<>();

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql.toString());
            
            // 设置参数
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Reservation reservation = new Reservation();
                reservation.setId(rs.getLong("id"));
                reservation.setUsername(rs.getString("username"));
                reservation.setReservationType(rs.getString("reservation_type"));
                reservation.setCampus(rs.getString("campus"));
                
                Timestamp visitTime = rs.getTimestamp("visit_time");
                if (visitTime != null) {
                    reservation.setVisitTime(visitTime.toLocalDateTime());
                }
                
                reservation.setOrganization(rs.getString("organization"));
                reservation.setName(rs.getString("name"));
                reservation.setIdCard(rs.getString("id_card_encrypted")); // 返回加密后的
                reservation.setPhone(rs.getString("phone_encrypted")); // 返回加密后的
                reservation.setTransportation(rs.getString("transportation"));
                reservation.setPlateNumber(rs.getString("plate_number"));
                reservation.setVisitDepartmentId(rs.getInt("visit_department_id"));
                reservation.setVisitDepartmentName(rs.getString("visit_department_name"));
                reservation.setContactPerson(rs.getString("contact_person"));
                reservation.setVisitReason(rs.getString("visit_reason"));
                reservation.setStatus(rs.getString("status"));
                
                Timestamp createTime = rs.getTimestamp("create_time");
                if (createTime != null) {
                    reservation.setCreateTime(createTime.toLocalDateTime());
                }
                
                Timestamp updateTime = rs.getTimestamp("update_time");
                if (updateTime != null) {
                    reservation.setUpdateTime(updateTime.toLocalDateTime());
                }
                
                reservations.add(reservation);
            }
            
        } catch (SQLException e) {
            System.err.println("查询预约记录时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        
        return reservations;
    }

    /**
     * 审核预约
     * @param reservationId 预约ID
     * @param auditorId 审核人ID
     * @param auditorName 审核人姓名
     * @param auditResult 审核结果：approved, rejected
     * @param auditComment 审核意见
     * @return true表示审核成功，false表示审核失败
     */
    public boolean auditReservation(long reservationId, long auditorId, String auditorName, 
            String auditResult, String auditComment) {
        
        Connection conn = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false); // 开启事务

            // 1. 更新预约状态
            String updateSql = "UPDATE reservations SET status = ?, audit_status = ?, approver_id = ?, approve_time = ?, approve_comment = ? WHERE id = ?";
            pstmt1 = conn.prepareStatement(updateSql);
            pstmt1.setString(1, auditResult);
            pstmt1.setString(2, auditResult);  // 同时更新audit_status字段
            pstmt1.setLong(3, auditorId);
            pstmt1.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            pstmt1.setString(5, auditComment);  // 更新approve_comment字段
            pstmt1.setLong(6, reservationId);

            int updateRows = pstmt1.executeUpdate();
            if (updateRows == 0) {
                conn.rollback();
                return false;
            }

            // 2. 插入审核记录
            String auditSql = "INSERT INTO reservation_audits (reservation_id, auditor_id, auditor_name, " +
                    "audit_result, audit_comment, data_integrity) VALUES (?, ?, ?, ?, ?, ?)";
            pstmt2 = conn.prepareStatement(auditSql);
            pstmt2.setLong(1, reservationId);
            pstmt2.setLong(2, auditorId);
            pstmt2.setString(3, auditorName);
            pstmt2.setString(4, auditResult);
            pstmt2.setString(5, auditComment);
            
            // 生成数据完整性校验值
            String integrityData = reservationId + auditorName + auditResult + System.currentTimeMillis();
            pstmt2.setString(6, SM3Util.hash(integrityData));

            int auditRows = pstmt2.executeUpdate();
            if (auditRows == 0) {
                conn.rollback();
                return false;
            }

            conn.commit(); // 提交事务
            return true;

        } catch (SQLException e) {
            System.err.println("审核预约时发生错误: " + e.getMessage());
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources(pstmt2, pstmt1, conn);
        }
    }

    /**
     * 根据ID获取预约详情
     * @param reservationId 预约ID
     * @return 预约对象，不存在返回null
     */
    public Reservation getReservationById(long reservationId) {
        String sql = "SELECT r.*, d.department_name AS visit_department_name, d.id as dept_id, " +
                "ra.auditor_name, ra.audit_result, ra.audit_comment, ra.audit_time " +
                "FROM reservations r " +
                "LEFT JOIN departments d ON r.visit_department_id = d.id " +
                "LEFT JOIN reservation_audits ra ON r.id = ra.reservation_id " +
                "WHERE r.id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, reservationId);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                Reservation reservation = new Reservation();
                reservation.setId(rs.getLong("id"));
                reservation.setUsername(rs.getString("username"));
                reservation.setReservationType(rs.getString("reservation_type"));
                reservation.setCampus(rs.getString("campus"));
                
                Timestamp visitTime = rs.getTimestamp("visit_time");
                if (visitTime != null) {
                    reservation.setVisitTime(visitTime.toLocalDateTime());
                }
                
                reservation.setOrganization(rs.getString("organization"));
                reservation.setName(rs.getString("name"));
                
                // 解密身份证和手机号
                String encryptedIdCard = rs.getString("id_card_encrypted");
                String encryptedPhone = rs.getString("phone_encrypted");
                
                if (encryptedIdCard != null && encryptedIdCard.startsWith("encrypted_")) {
                    reservation.setIdCard(encryptedIdCard.substring(10));
                }
                
                if (encryptedPhone != null && encryptedPhone.startsWith("encrypted_")) {
                    reservation.setPhone(encryptedPhone.substring(10));
                }
                
                reservation.setStatus(rs.getString("status"));
                reservation.setTransportation(rs.getString("transportation"));
                reservation.setPlateNumber(rs.getString("plate_number"));
                reservation.setContactPerson(rs.getString("contact_person"));
                reservation.setVisitReason(rs.getString("visit_reason"));
                reservation.setVisitDepartmentName(rs.getString("visit_department_name"));
                
                // 创建部门对象
                if (rs.getString("visit_department_name") != null) {
                    Department dept = new Department();
                    dept.setDeptId(rs.getInt("dept_id"));
                    dept.setDeptName(rs.getString("visit_department_name"));
                    reservation.setDepartment(dept);
                }
                
                // 审核信息
                reservation.setAuditorName(rs.getString("auditor_name"));
                reservation.setAuditResult(rs.getString("audit_result"));
                reservation.setAuditComment(rs.getString("audit_comment"));
                
                Timestamp auditTime = rs.getTimestamp("audit_time");
                if (auditTime != null) {
                    reservation.setAuditTime(auditTime.toLocalDateTime());
                }
                
                Timestamp createTime = rs.getTimestamp("create_time");
                if (createTime != null) {
                    reservation.setCreateTime(createTime.toLocalDateTime());
                }
                
                return reservation;
            }

        } catch (SQLException e) {
            System.err.println("查询预约详情时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return null;
    }

    /**
     * 统计预约数据
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @param campus 校区
     * @param departmentId 部门ID
     * @return 统计结果数组 [总数, 待审核, 已通过, 已拒绝]
     */
    public int[] getReservationStatistics(Date startDate, Date endDate, String campus, Integer departmentId) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ");
        sql.append("COUNT(*) as total, ");
        sql.append("SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) as pending, ");
        sql.append("SUM(CASE WHEN status = 'approved' THEN 1 ELSE 0 END) as approved, ");
        sql.append("SUM(CASE WHEN status = 'rejected' THEN 1 ELSE 0 END) as rejected ");
        sql.append("FROM reservations WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (startDate != null) {
            sql.append("AND DATE(create_time) >= ? ");
            params.add(startDate);
        }
        if (endDate != null) {
            sql.append("AND DATE(create_time) <= ? ");
            params.add(endDate);
        }
        if (campus != null && !campus.trim().isEmpty()) {
            sql.append("AND campus = ? ");
            params.add(campus);
        }
        if (departmentId != null) {
            sql.append("AND visit_department_id = ? ");
            params.add(departmentId);
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql.toString());
            
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            rs = pstmt.executeQuery();
            if (rs.next()) {
                return new int[]{
                    rs.getInt("total"),
                    rs.getInt("pending"),
                    rs.getInt("approved"),
                    rs.getInt("rejected")
                };
            }

        } catch (SQLException e) {
            System.err.println("统计预约数据时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return new int[]{0, 0, 0, 0};
    }

    /**
     * 获取总预约数量
     * @return 总预约数量
     */
    public int getTotalReservationCount() {
        String sql = "SELECT COUNT(*) FROM reservations";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.err.println("获取总预约数量时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return 0;
    }

    /**
     * 根据状态获取预约数量
     * @param status 预约状态
     * @return 预约数量
     */
    public int getReservationCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM reservations WHERE status = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.err.println("获取预约状态统计时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return 0;
    }

    /**
     * 获取最近的预约记录
     * @param limit 返回记录数量限制
     * @return 最近的预约记录列表
     */
    public List<Reservation> getRecentReservations(int limit) {
        String sql = "SELECT r.id, r.name, r.id_card_encrypted, r.phone_encrypted, " +
                "r.visit_time, r.status, r.create_time, d.department_name " +
                "FROM reservations r " +
                "LEFT JOIN departments d ON r.visit_department_id = d.id " +
                "ORDER BY r.create_time DESC LIMIT ?";
        
        List<Reservation> reservations = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Reservation reservation = new Reservation();
                reservation.setId(rs.getLong("id"));
                reservation.setName(rs.getString("name"));
                reservation.setVisitTime(rs.getTimestamp("visit_time").toLocalDateTime());
                reservation.setStatus(rs.getString("status"));
                
                // 正确处理时间戳转换
                Timestamp createTime = rs.getTimestamp("create_time");
                if (createTime != null) {
                    reservation.setCreateTime(createTime.toLocalDateTime());
                }
                
                // 创建部门对象
                Department department = new Department();
                department.setDepartmentName(rs.getString("department_name"));
                reservation.setDepartment(department);
                
                reservations.add(reservation);
            }

        } catch (SQLException e) {
            System.err.println("获取最近预约记录时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return reservations;
    }

    /**
     * 获取本月新增预约数量
     * @return 本月新增预约数量
     */
    public int getMonthlyNewReservations() {
        String sql = "SELECT COUNT(*) FROM reservations WHERE YEAR(create_time) = YEAR(CURDATE()) AND MONTH(create_time) = MONTH(CURDATE())";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.err.println("获取本月新增预约数量时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return 0;
    }

    /**
     * 撤销预约（将已通过的预约改为拒绝或待定）
     * @param reservationId 预约ID
     * @param auditorId 操作人ID
     * @param auditorName 操作人姓名
     * @param newStatus 新状态：rejected, pending
     * @param comment 撤销原因
     * @return true表示撤销成功，false表示撤销失败
     */
    public boolean revokeReservation(long reservationId, long auditorId, String auditorName, 
            String newStatus, String comment) {
        
        Connection conn = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false); // 开启事务

            // 1. 检查预约状态是否为已通过
            String checkSql = "SELECT status FROM reservations WHERE id = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setLong(1, reservationId);
            ResultSet rs = checkStmt.executeQuery();
            
            if (!rs.next()) {
                conn.rollback();
                return false; // 预约不存在
            }
            
            String currentStatus = rs.getString("status");
            if (!"approved".equals(currentStatus)) {
                conn.rollback();
                return false; // 只能撤销已通过的预约
            }
            
            rs.close();
            checkStmt.close();

            // 2. 更新预约状态
            String updateSql = "UPDATE reservations SET status = ?, approver_id = ?, approve_time = ?, " +
                    "approve_comment = ?, update_time = CURRENT_TIMESTAMP WHERE id = ?";
            pstmt1 = conn.prepareStatement(updateSql);
            pstmt1.setString(1, newStatus);
            pstmt1.setLong(2, auditorId);
            pstmt1.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            pstmt1.setString(4, comment);
            pstmt1.setLong(5, reservationId);

            int updateRows = pstmt1.executeUpdate();
            if (updateRows == 0) {
                conn.rollback();
                return false;
            }

            // 3. 插入审核记录
            String auditSql = "INSERT INTO reservation_audits (reservation_id, auditor_id, auditor_name, " +
                    "audit_result, audit_comment, data_integrity) VALUES (?, ?, ?, ?, ?, ?)";
            pstmt2 = conn.prepareStatement(auditSql);
            pstmt2.setLong(1, reservationId);
            pstmt2.setLong(2, auditorId);
            pstmt2.setString(3, auditorName);
            pstmt2.setString(4, "revoked_to_" + newStatus);
            pstmt2.setString(5, "撤销操作：" + comment);
            
            // 生成数据完整性校验值
            String integrityData = reservationId + auditorName + "revoked" + System.currentTimeMillis();
            pstmt2.setString(6, SM3Util.hash(integrityData));

            int auditRows = pstmt2.executeUpdate();
            if (auditRows == 0) {
                conn.rollback();
                return false;
            }

            conn.commit(); // 提交事务
            return true;

        } catch (SQLException e) {
            System.err.println("撤销预约时发生错误: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("回滚事务时发生错误: " + ex.getMessage());
                }
            }
            return false;
        } finally {
            closeResources(null, pstmt2, null);
            closeResources(null, pstmt1, null);
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("关闭连接时发生错误: " + e.getMessage());
                }
            }
        }
    }

    /**
     * 修改预约状态（灵活修改任何状态）
     * @param reservationId 预约ID
     * @param auditorId 操作人ID
     * @param auditorName 操作人姓名
     * @param newStatus 新状态：pending, approved, rejected
     * @param comment 修改原因
     * @return true表示修改成功，false表示修改失败
     */
    public boolean changeReservationStatus(long reservationId, long auditorId, String auditorName, 
            String newStatus, String comment) {
        
        Connection conn = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false); // 开启事务

            // 1. 获取当前状态
            String checkSql = "SELECT status FROM reservations WHERE id = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setLong(1, reservationId);
            ResultSet rs = checkStmt.executeQuery();
            
            if (!rs.next()) {
                conn.rollback();
                return false; // 预约不存在
            }
            
            String oldStatus = rs.getString("status");
            rs.close();
            checkStmt.close();

            // 2. 更新预约状态
            String updateSql = "UPDATE reservations SET status = ?, approver_id = ?, approve_time = ?, " +
                    "approve_comment = ?, update_time = CURRENT_TIMESTAMP WHERE id = ?";
            pstmt1 = conn.prepareStatement(updateSql);
            pstmt1.setString(1, newStatus);
            pstmt1.setLong(2, auditorId);
            pstmt1.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            pstmt1.setString(4, comment);
            pstmt1.setLong(5, reservationId);

            int updateRows = pstmt1.executeUpdate();
            if (updateRows == 0) {
                conn.rollback();
                return false;
            }

            // 3. 插入审核记录
            String auditSql = "INSERT INTO reservation_audits (reservation_id, auditor_id, auditor_name, " +
                    "audit_result, audit_comment, data_integrity) VALUES (?, ?, ?, ?, ?, ?)";
            pstmt2 = conn.prepareStatement(auditSql);
            pstmt2.setLong(1, reservationId);
            pstmt2.setLong(2, auditorId);
            pstmt2.setString(3, auditorName);
            pstmt2.setString(4, "changed_from_" + oldStatus + "_to_" + newStatus);
            pstmt2.setString(5, "状态修改：从" + getStatusDisplayName(oldStatus) + "改为" + getStatusDisplayName(newStatus) + "。原因：" + comment);
            
            // 生成数据完整性校验值
            String integrityData = reservationId + auditorName + "status_change" + System.currentTimeMillis();
            pstmt2.setString(6, SM3Util.hash(integrityData));

            int auditRows = pstmt2.executeUpdate();
            if (auditRows == 0) {
                conn.rollback();
                return false;
            }

            conn.commit(); // 提交事务
            return true;

        } catch (SQLException e) {
            System.err.println("修改预约状态时发生错误: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("回滚事务时发生错误: " + ex.getMessage());
                }
            }
            return false;
        } finally {
            closeResources(null, pstmt2, null);
            closeResources(null, pstmt1, null);
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("关闭连接时发生错误: " + e.getMessage());
                }
            }
        }
    }

    /**
     * 获取状态显示名称
     */
    private String getStatusDisplayName(String status) {
        switch (status) {
            case "pending": return "待审核";
            case "approved": return "已通过";
            case "rejected": return "已拒绝";
            default: return status;
        }
    }
}