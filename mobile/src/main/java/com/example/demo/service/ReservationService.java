package com.example.demo.service;

import com.example.demo.dao.ReservationDao;
import com.example.demo.model.Reservation;
import com.example.demo.model.Companion;
import com.example.demo.util.CryptoUtils;

import com.example.demo.util.SM3Util;

import java.sql.SQLException;
import java.util.*;

/**
 * 预约服务类 - 业务逻辑层
 */
public class ReservationService {
    
    private ReservationDao reservationDao = new ReservationDao();
    
    /**
     * 创建预约
     */
    public Long createReservation(Reservation reservation, List<Companion> companions) throws SQLException {
        System.out.println("=== 开始创建预约 ===");
        
        // ✅ 首先测试加密功能
        System.out.println("测试加密功能...");
        boolean cryptoWorking = CryptoUtils.testCrypto();
        if (!cryptoWorking) {
            throw new SQLException("加密功能异常，无法创建预约");
        }
        
        try {
            // 步骤1: 数据验证
            System.out.println("步骤1: 验证预约数据");
            if (!reservation.validateReservationData()) {
                throw new SQLException("预约数据验证失败");
            }
            
            // 验证随行人员（如果有）
            if (companions != null) {
                for (Companion companion : companions) {
                    if (!validateCompanion(companion)) {
                        throw new SQLException("随行人员信息验证失败: " + companion.getName());
                    }
                }
            }
            
            // 设置基本信息
            reservation.setCreateTime(new Date());
            reservation.setUpdateTime(new Date());
            reservation.setStatus("pending"); // 默认待审核
            
            // 社会公众预约自动审核
            if ("public".equals(reservation.getReservationType())) {
                reservation.setStatus("approved");
            }
            
            // 创建预约记录
            Long reservationId = reservationDao.createReservation(reservation);
            
            if (reservationId != null) {
                // 如果是社会公众预约，自动生成通行码
                if ("public".equals(reservation.getReservationType())) {
                    generatePassCode(reservationId, reservation.getName(), reservation.getIdCard());
                }
                
                // 添加随行人员
                if (companions != null && !companions.isEmpty()) {
                    for (Companion companion : companions) {
                        companion.setReservationId(reservationId);
                        reservationDao.addCompanion(companion);
                    }
                }
            }
            
            return reservationId;
            
        } catch (Exception e) {
            System.err.println("创建预约失败: " + e.getMessage());
            e.printStackTrace();
            throw new SQLException("创建预约失败: " + e.getMessage(), e);
        }
    }
    
    /**
     * 验证预约数据
     */
    private boolean validateReservation(Reservation reservation) {
        if (reservation == null) {
            System.out.println("验证失败：预约对象为空");
            return false;
        }
        
        // 验证预约类型
        if (reservation.getReservationType() == null || 
            (!reservation.getReservationType().equals("public") && 
             !reservation.getReservationType().equals("business"))) {
            System.out.println("验证失败：预约类型无效 - " + reservation.getReservationType());
            return false;
        }
        
        // 验证校区
        if (reservation.getCampus() == null || reservation.getCampus().trim().isEmpty()) {
            System.out.println("验证失败：校区不能为空");
            return false;
        }
        
        // 验证访问时间
        if (reservation.getVisitTime() == null) {
            System.out.println("验证失败：访问时间不能为空");
            return false;
        }
        
        // 访问时间不能是过去时间
        if (reservation.getVisitTime().before(new Date())) {
            System.out.println("验证失败：访问时间不能是过去时间");
            return false;
        }
        
        // 验证机构
        if (reservation.getOrganization() == null || reservation.getOrganization().trim().isEmpty()) {
            System.out.println("验证失败：机构不能为空");
            return false;
        }
        
        // 验证姓名
        if (reservation.getName() == null || reservation.getName().trim().isEmpty()) {
            System.out.println("验证失败：姓名不能为空");
            return false;
        }
        
        // 验证身份证号
        if (!isValidIdCard(reservation.getIdCard())) {
            System.out.println("验证失败：身份证号格式无效 - " + reservation.getIdCard());
            return false;
        }
        
        // 验证手机号
        if (!isValidPhone(reservation.getPhone())) {
            System.out.println("验证失败：手机号格式无效 - " + reservation.getPhone());
            return false;
        }
        
        // 验证交通方式
        if (reservation.getTransportation() == null || reservation.getTransportation().trim().isEmpty()) {
            System.out.println("验证失败：交通方式不能为空");
            return false;
        }
        
        // 如果是自驾，必须填写车牌号
        if ("car".equals(reservation.getTransportation())) {
            if (reservation.getPlateNumber() == null || reservation.getPlateNumber().trim().isEmpty()) {
                System.out.println("验证失败：自驾必须填写车牌号");
                return false;
            }
        }
        
        // 验证公务预约特有字段
        if ("business".equals(reservation.getReservationType())) {
            if (reservation.getVisitDepartmentId() == null) {
                System.out.println("验证失败：公务预约必须选择访问部门");
                return false;
            }
            
            if (reservation.getContactPerson() == null || reservation.getContactPerson().trim().isEmpty()) {
                System.out.println("验证失败：公务预约必须填写联系人");
                return false;
            }
            
            if (reservation.getVisitReason() == null || reservation.getVisitReason().trim().isEmpty()) {
                System.out.println("验证失败：公务预约必须填写访问事由");
                return false;
            }
        }
        
        System.out.println("预约数据验证通过");
        return true;
    }
    
    /**
     * 验证随行人员数据
     */
    private boolean validateCompanion(Companion companion) {
        if (companion == null) {
            return false;
        }
        
        if (companion.getName() == null || companion.getName().trim().isEmpty()) {
            System.out.println("随行人员验证失败：姓名不能为空");
            return false;
        }
        
        if (!isValidIdCard(companion.getIdCard())) {
            System.out.println("随行人员验证失败：身份证号格式无效 - " + companion.getIdCard());
            return false;
        }
        
        if (!isValidPhone(companion.getPhone())) {
            System.out.println("随行人员验证失败：手机号格式无效 - " + companion.getPhone());
            return false;
        }
        
        return true;
    }
    
    /**
     * 验证身份证号格式
     */
    private boolean isValidIdCard(String idCard) {
        if (idCard == null || idCard.trim().isEmpty()) {
            return false;
        }
        
        // 简单的身份证号验证：18位数字或17位数字+X
        String regex = "^[1-9]\\d{5}(18|19|20)\\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$";
        return idCard.matches(regex);
    }
    
    /**
     * 验证手机号格式
     */
    private boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        
        // 简单的手机号验证：11位数字，以1开头
        String regex = "^1[3-9]\\d{9}$";
        return phone.matches(regex);
    }
    
    /**
     * 生成通行码
     */
    private void generatePassCode(Long reservationId, String name, String idCard) throws SQLException {
        try {
            long timestamp = System.currentTimeMillis();
            String passCode = CryptoUtils.generatePassCode(name, idCard, timestamp);
            
            // 设置过期时间（24小时后）
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.HOUR_OF_DAY, 24);
            Date expireTime = calendar.getTime();
            
            reservationDao.updatePassCode(reservationId, passCode, expireTime);
            
            System.out.println("通行码生成成功: " + passCode);
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("生成通行码失败: " + e.getMessage());
        }
    }
    
    /**
     * 根据ID获取预约信息
     */
    public Reservation getReservationById(Long reservationId) throws SQLException {
        try {
            return reservationDao.findById(reservationId);
        } catch (Exception e) {
            e.printStackTrace();
            // 如果数据库查询失败，返回null
            return null;
        }
    }
    
    /**
     * 生成通行码（公开方法）
     */
    public String generatePassCode(Long reservationId) throws SQLException {
        try {
            Reservation reservation = reservationDao.findById(reservationId);
            if (reservation == null) {
                throw new SQLException("预约记录不存在");
            }
            
            long timestamp = System.currentTimeMillis();
            String passCode = CryptoUtils.generatePassCode(reservation.getName(), reservation.getIdCard(), timestamp);
            
            // 设置过期时间（24小时后）
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.HOUR_OF_DAY, 24);
            Date expireTime = calendar.getTime();
            
            reservationDao.updatePassCode(reservationId, passCode, expireTime);
            
            return passCode;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("生成通行码失败: " + e.getMessage());
        }
    }
    
    /**
     * 检查通行码是否有效
     */
    public boolean isPassCodeValid(Long reservationId) throws SQLException {
        try {
            Reservation reservation = reservationDao.findById(reservationId);
            
            if (reservation == null || !"approved".equals(reservation.getStatus())) {
                return false;
            }
            
            if (reservation.getPassCode() == null || reservation.getPassCode().trim().isEmpty()) {
                return false;
            }
            
            if (reservation.getPassCodeExpireTime() == null) {
                return false;
            }
            
            return new Date().before(reservation.getPassCodeExpireTime());
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 验证通行码
     */
    public boolean validatePassCode(Long reservationId, String passCode) throws SQLException {
        try {
            Reservation reservation = reservationDao.findById(reservationId);
            
            if (reservation == null || !"approved".equals(reservation.getStatus())) {
                return false;
            }
            
            // 验证通行码是否匹配
            if (!passCode.equals(reservation.getPassCode())) {
                return false;
            }
            
            // 检查是否过期
            return isPassCodeValid(reservationId);
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 获取用户预约列表
     */
    public List<Reservation> getUserReservations(String name, String idCard, String phone) throws SQLException {
        try {
            return reservationDao.findReservationsByUser(name, idCard, phone);
        } catch (Exception e) {
            e.printStackTrace();
            // 如果数据库查询失败，返回空列表
            return new ArrayList<>();
        }
    }
    
    /**
     * 🆕 根据username获取预约列表
     */
    public List<Reservation> getReservationsByUsername(String username) throws SQLException {
        System.out.println("🔍 查询用户预约，username: " + username);
        try {
            return reservationDao.getReservationsByUsername(username);
        } catch (Exception e) {
            System.err.println("❌ 查询用户预约失败: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}