package com.example.demo.dao;

import com.example.demo.model.Reservation;
import com.example.demo.model.Companion;
import com.example.demo.util.SM3Util;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.HashSet;
import java.util.Set;

/**
 * 预约数据访问类
 */
public class ReservationDao extends BaseDao {
    
    /**
     * 创建新预约
     */
    public Long createReservation(Reservation reservation) throws SQLException {
        String sql = "INSERT INTO reservations (username, reservation_type, campus, visit_time, organization, name, " +
                    "id_card_encrypted, phone_encrypted, id_card_hash, phone_hash, transportation, plate_number, " +
                    "visit_department_id, contact_person, visit_reason, status, pass_code_encrypted, " +
                    "pass_code_hash, pass_code_expire_time, qr_code_data, creator_id, visible_to_departments, " +
                    "create_time, update_time, data_integrity, version) " +
                    "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        
        // 生成数据完整性校验
        reservation.generateDataIntegrity();
        
        Long id = executeUpdateWithGeneratedKey(sql,
            reservation.getUsername(),
            reservation.getReservationType(),
            reservation.getCampus(),
            reservation.getVisitTime(),
            reservation.getOrganization(),
            reservation.getName(),
            reservation.getIdCardEncrypted(),
            reservation.getPhoneEncrypted(),
            reservation.getIdCardHash(),
            reservation.getPhoneHash(),
            reservation.getTransportation(),
            reservation.getPlateNumber(),
            reservation.getVisitDepartmentId(),
            reservation.getContactPerson(),
            reservation.getVisitReason(),
            reservation.getStatus(),
            reservation.getPassCodeEncrypted(),
            reservation.getPassCodeHash(),
            reservation.getPassCodeExpireTime(),
            reservation.getQrCodeData(),
            reservation.getCreatorId(),
            reservation.getVisibleToDepartments(),
            reservation.getCreateTime(),
            reservation.getUpdateTime(),
            reservation.getDataIntegrity(),
            reservation.getVersion()
        );
        
        // 记录数据访问日志
        logDataAccess("reservations", id, "insert", 
                     "id_card_encrypted,phone_encrypted", 
                     reservation.getName(), reservation.getIdCardHash(), 
                     "", true);
        
        return id;
    }
    
    /**
     * 添加随行人员
     */
    public Long addCompanion(Companion companion) throws SQLException {
        String sql = "INSERT INTO companions (reservation_id, name, id_card_encrypted, phone_encrypted, " +
                    "id_card_hash, phone_hash, relationship, remark, create_time, data_integrity) " +
                    "VALUES (?,?,?,?,?,?,?,?,?,?)";
        
        // 生成数据完整性校验
        companion.generateDataIntegrity();
        
        return executeUpdateWithGeneratedKey(sql,
            companion.getReservationId(),
            companion.getName(),
            companion.getIdCardEncrypted(),
            companion.getPhoneEncrypted(),
            companion.getIdCardHash(),
            companion.getPhoneHash(),
            companion.getRelationship(),
            companion.getRemark(),
            companion.getCreateTime(),
            companion.getDataIntegrity()
        );
    }
    
    /**
     * 更新通行码
     */
    public int updatePassCode(Long reservationId, String passCode, java.util.Date expireTime) throws SQLException {
        // 使用CryptoUtils中的方法来加密和哈希
        String passCodeEncrypted = com.example.demo.util.CryptoUtils.encryptSM4(passCode);
        String passCodeHash = SM3Util.hash(passCode);
        
        String sql = "UPDATE reservations SET pass_code_encrypted = ?, pass_code_hash = ?, " +
                    "pass_code_expire_time = ?, update_time = ?, version = version + 1 WHERE id = ?";
        
        return executeUpdate(sql, passCodeEncrypted, passCodeHash, expireTime, 
                           new java.util.Date(), reservationId);
    }
    
    /**
     * 根据ID查找预约
     */
    public Reservation findById(Long id) throws SQLException {
        String sql = "SELECT r.*, d.department_name FROM reservations r " +
                    "LEFT JOIN departments d ON r.visit_department_id = d.id WHERE r.id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, id);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToReservation(rs);
            }
            return null;
            
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }
    
    /**
     * 根据身份证哈希查找用户的所有预约
     */
    public List<Reservation> findByIdCardHash(String idCardHash) throws SQLException {
        String sql = "SELECT r.*, d.department_name FROM reservations r " +
                    "LEFT JOIN departments d ON r.visit_department_id = d.id " +
                    "WHERE r.id_card_hash = ? ORDER BY r.create_time DESC";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Reservation> reservations = new ArrayList<>();
        
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, idCardHash);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
            
            return reservations;
            
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }
    
    /**
     * 根据手机号哈希查找用户的所有预约
     */
    public List<Reservation> findByPhoneHash(String phoneHash) throws SQLException {
        String sql = "SELECT r.*, d.department_name FROM reservations r " +
                    "LEFT JOIN departments d ON r.visit_department_id = d.id " +
                    "WHERE r.phone_hash = ? ORDER BY r.create_time DESC";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Reservation> reservations = new ArrayList<>();
        
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, phoneHash);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
            
            return reservations;
            
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }
    
    /**
     * 根据姓名查找预约
     */
    private List<Reservation> findByName(String name) throws SQLException {
        String sql = "SELECT r.*, d.department_name FROM reservations r " +
                    "LEFT JOIN departments d ON r.visit_department_id = d.id " +
                    "WHERE r.name = ? ORDER BY r.create_time DESC";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Reservation> reservations = new ArrayList<>();
        
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
            
            return reservations;
            
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }
    
    /**
     * 根据用户信息查找预约 - 多条件查询
     */
    public List<Reservation> findReservationsByUser(String name, String idCard, String phone) throws SQLException {
        List<Reservation> allReservations = new ArrayList<>();
        
        // 按姓名查询
        if (name != null && !name.trim().isEmpty()) {
            allReservations.addAll(findByName(name));
        }
        
        // 按身份证哈希查询
        if (idCard != null && !idCard.trim().isEmpty()) {
            String idCardHash = SM3Util.hash(idCard);
            allReservations.addAll(findByIdCardHash(idCardHash));
        }
        
        // 按手机号哈希查询
        if (phone != null && !phone.trim().isEmpty()) {
            String phoneHash = SM3Util.hash(phone);
            allReservations.addAll(findByPhoneHash(phoneHash));
        }
        
        // 去重（基于ID）
        Set<Long> seenIds = new HashSet<>();
        List<Reservation> uniqueReservations = new ArrayList<>();
        for (Reservation reservation : allReservations) {
            if (reservation.getId() != null && !seenIds.contains(reservation.getId())) {
                seenIds.add(reservation.getId());
                uniqueReservations.add(reservation);
            }
        }
        
        return uniqueReservations;
    }
    
    /**
     * 根据通行码哈希查找预约
     */
    public Reservation findByPassCodeHash(String passCodeHash) throws SQLException {
        String sql = "SELECT r.*, d.department_name FROM reservations r " +
                    "LEFT JOIN departments d ON r.visit_department_id = d.id " +
                    "WHERE r.pass_code_hash = ? AND r.status = 'approved' " +
                    "AND r.pass_code_expire_time > CURRENT_TIMESTAMP";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, passCodeHash);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToReservation(rs);
            }
            return null;
            
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }
    
    /**
     * 更新预约状态
     */
    public int updateStatus(Long id, String status, String approveComment) throws SQLException {
        String sql = "UPDATE reservations SET status = ?, approve_comment = ?, " +
                    "approve_time = ?, update_time = ?, version = version + 1 WHERE id = ?";
        
        return executeUpdate(sql, status, approveComment, new java.util.Date(), 
                           new java.util.Date(), id);
    }
    
    /**
     * 获取今日有效的通行码数量
     */
    public int getTodayValidPassCodeCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservations WHERE status = 'approved' " +
                    "AND DATE(visit_time) = CURRENT_DATE AND pass_code_expire_time > CURRENT_TIMESTAMP";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
            
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }
    
    /**
     * 🆕 根据username获取预约列表
     */
    public List<Reservation> getReservationsByUsername(String username) throws SQLException {
        System.out.println("🔍 查询用户预约，username: " + username);
        String sql = "SELECT r.*, d.department_name FROM reservations r " +
                    "LEFT JOIN departments d ON r.visit_department_id = d.id " +
                    "WHERE r.username = ? ORDER BY r.create_time DESC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Reservation> reservations = new ArrayList<>();
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
            System.out.println("✅ 成功查询到 " + reservations.size() + " 条预约");
            return reservations;
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }
    
    /**
     * 将ResultSet映射为Reservation对象
     */
    private Reservation mapResultSetToReservation(ResultSet rs) throws SQLException {
        Reservation reservation = new Reservation();
        
        reservation.setId(rs.getLong("id"));
        reservation.setReservationType(rs.getString("reservation_type"));
        reservation.setCampus(rs.getString("campus"));
        
        Timestamp visitTime = rs.getTimestamp("visit_time");
        if (visitTime != null) {
            reservation.setVisitTime(new java.util.Date(visitTime.getTime()));
        }
        
        reservation.setOrganization(rs.getString("organization"));
        reservation.setName(rs.getString("name"));
        reservation.setIdCardEncrypted(rs.getString("id_card_encrypted"));
        reservation.setPhoneEncrypted(rs.getString("phone_encrypted"));
        reservation.setIdCardHash(rs.getString("id_card_hash"));
        reservation.setPhoneHash(rs.getString("phone_hash"));
        reservation.setTransportation(rs.getString("transportation"));
        reservation.setPlateNumber(rs.getString("plate_number"));
        
        Long visitDepartmentId = rs.getLong("visit_department_id");
        if (!rs.wasNull()) {
            reservation.setVisitDepartmentId(visitDepartmentId);
        }
        
        reservation.setContactPerson(rs.getString("contact_person"));
        reservation.setVisitReason(rs.getString("visit_reason"));
        reservation.setStatus(rs.getString("status"));
        
        Long approverId = rs.getLong("approver_id");
        if (!rs.wasNull()) {
            reservation.setApproverId(approverId);
        }
        
        Timestamp approveTime = rs.getTimestamp("approve_time");
        if (approveTime != null) {
            reservation.setApproveTime(new java.util.Date(approveTime.getTime()));
        }
        
        reservation.setApproveComment(rs.getString("approve_comment"));
        reservation.setPassCodeEncrypted(rs.getString("pass_code_encrypted"));
        reservation.setPassCodeHash(rs.getString("pass_code_hash"));
        
        Timestamp passCodeExpireTime = rs.getTimestamp("pass_code_expire_time");
        if (passCodeExpireTime != null) {
            reservation.setPassCodeExpireTime(new java.util.Date(passCodeExpireTime.getTime()));
        }
        
        reservation.setQrCodeData(rs.getString("qr_code_data"));
        
        Long creatorId = rs.getLong("creator_id");
        if (!rs.wasNull()) {
            reservation.setCreatorId(creatorId);
        }
        
        reservation.setVisibleToDepartments(rs.getString("visible_to_departments"));
        
        Timestamp createTime = rs.getTimestamp("create_time");
        if (createTime != null) {
            reservation.setCreateTime(new java.util.Date(createTime.getTime()));
        }
        
        Timestamp updateTime = rs.getTimestamp("update_time");
        if (updateTime != null) {
            reservation.setUpdateTime(new java.util.Date(updateTime.getTime()));
        }
        
        reservation.setDataIntegrity(rs.getString("data_integrity"));
        reservation.setVersion(rs.getInt("version"));
        
        // 获取部门名称（如果有）
        reservation.setDepartmentName(rs.getString("department_name"));
        
        return reservation;
    }
    
    /**
     * 根据username查找用户的所有预约
     */
    public List<Reservation> findByUsername(String username) throws SQLException {
        String sql = "SELECT r.*, d.department_name FROM reservations r " +
                    "LEFT JOIN departments d ON r.visit_department_id = d.id " +
                    "WHERE r.username = ? ORDER BY r.create_time DESC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Reservation> reservations = new ArrayList<>();
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
            return reservations;
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }
    
    /**
     * 统计用户的预约总数
     */
    public int countByUsername(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservations WHERE username = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }
    
    /**
     * 统计用户指定状态的预约数
     */
    public int countByUsernameAndStatus(String username, String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservations WHERE username = ? AND status = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, status);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }
}