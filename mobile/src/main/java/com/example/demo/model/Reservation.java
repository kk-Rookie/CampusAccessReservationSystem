package com.example.demo.model;

import com.example.demo.util.CryptoUtils;
import com.example.demo.util.SM3Util;
import java.util.Date;
import java.util.List;

/**
 * 预约实体类 - 修复版：使用username关联
 */
public class Reservation {
    private Long id;
    
    // 📝 修改：使用username关联用户，删除userId字段
    private String username;  // 关联用户账号（11位数字）
    
    // 基本预约信息
    private String reservationType;  // public, business
    private String campus;           // main, east
    private Date visitTime;
    private String organization;
    private String name;
    
    // 敏感数据（加密存储）
    private String idCardEncrypted;
    private String phoneEncrypted;
    private String idCardHash;
    private String phoneHash;
    
    // 交通信息
    private String transportation;
    private String plateNumber;
    
    // 公务预约字段
    private Long visitDepartmentId;
    private String contactPerson;
    private String visitReason;
    
    // 审核状态
    private String status = "pending";
    private Long approverId;
    private Date approveTime;
    private String approveComment;
    
    // 通行码相关
    private String passCodeEncrypted;
    private String passCodeHash;
    private Date passCodeExpireTime;
    private String qrCodeData;
    
    // 权限控制
    private Long creatorId;
    private String visibleToDepartments;
    
    // 时间戳
    private Date createTime;
    private Date updateTime;
    
    // 数据完整性
    private String dataIntegrity;
    private Integer version = 1;
    
    // 关联数据（不存储在数据库）
    private List<Companion> companions;
    private String departmentName;
    private String creatorRealName; // 创建者真实姓名

    public Reservation() {
        this.createTime = new Date();
        this.updateTime = new Date();
        // 设置默认状态
        if ("public".equals(this.reservationType)) {
            this.status = "approved"; // 社会公众预约自动通过
        } else {
            this.status = "pending";  // 公务预约需要审核
        }
    }
    
    // 🔧 新增：username 的 getter/setter
    public String getUsername() { 
        return username; 
    }
    
    public void setUsername(String username) { 
        this.username = username; 
    }
    
    // ✅ 修复：安全的身份证设置方法
    public void setIdCard(String idCard) {
        System.out.println("设置身份证: " + (idCard != null ? idCard.substring(0, Math.min(6, idCard.length())) + "****" : "null"));
        
        if (idCard != null && !idCard.trim().isEmpty()) {
            try {
                // 先生成哈希（绝对不能失败）
                this.idCardHash = SM3Util.hash(idCard);
                System.out.println("身份证哈希生成成功");
                
                // 再尝试加密（允许失败）
                String encrypted = CryptoUtils.encryptSM4(idCard);
                this.idCardEncrypted = encrypted != null ? encrypted : "";
                System.out.println("身份证加密结果: " + (encrypted != null ? "成功" : "失败，使用空字符串"));
                
            } catch (Exception e) {
                System.err.println("身份证处理异常: " + e.getMessage());
                // 确保至少有哈希值
                this.idCardHash = SM3Util.hash(idCard);
                this.idCardEncrypted = "";
            }
        } else {
            this.idCardHash = "";
            this.idCardEncrypted = "";
        }
    }
    
    // ✅ 修复：安全的手机号设置方法
    public void setPhone(String phone) {
        System.out.println("设置手机号: " + (phone != null ? phone.substring(0, Math.min(3, phone.length())) + "****" : "null"));
        
        if (phone != null && !phone.trim().isEmpty()) {
            try {
                // 先生成哈希（绝对不能失败）
                this.phoneHash = SM3Util.hash(phone);
                System.out.println("手机号哈希生成成功");
                
                // 再尝试加密（允许失败）
                String encrypted = CryptoUtils.encryptSM4(phone);
                this.phoneEncrypted = encrypted != null ? encrypted : "";
                System.out.println("手机号加密结果: " + (encrypted != null ? "成功" : "失败，使用空字符串"));
                
            } catch (Exception e) {
                System.err.println("手机号处理异常: " + e.getMessage());
                // 确保至少有哈希值
                this.phoneHash = SM3Util.hash(phone);
                this.phoneEncrypted = "";
            }
        } else {
            this.phoneHash = "";
            this.phoneEncrypted = "";
        }
    }
    
    // ✅ 修复：安全的通行码设置方法
    public void setPassCode(String passCode) {
        if (passCode != null && !passCode.trim().isEmpty()) {
            try {
                this.passCodeHash = SM3Util.hash(passCode);
                String encrypted = CryptoUtils.encryptSM4(passCode);
                this.passCodeEncrypted = encrypted != null ? encrypted : "";
            } catch (Exception e) {
                System.err.println("通行码处理异常: " + e.getMessage());
                this.passCodeHash = SM3Util.hash(passCode);
                this.passCodeEncrypted = "";
            }
        } else {
            this.passCodeHash = "";
            this.passCodeEncrypted = "";
        }
    }
    
    // ✅ 修复：安全的数据获取方法
    public String getIdCard() {
        if (idCardEncrypted == null || idCardEncrypted.isEmpty()) {
            return null;
        }
        try {
            return CryptoUtils.decryptSM4(idCardEncrypted);
        } catch (Exception e) {
            System.err.println("身份证解密失败: " + e.getMessage());
            return null;
        }
    }
    
    public String getPhone() {
        if (phoneEncrypted == null || phoneEncrypted.isEmpty()) {
            return null;
        }
        try {
            return CryptoUtils.decryptSM4(phoneEncrypted);
        } catch (Exception e) {
            System.err.println("手机号解密失败: " + e.getMessage());
            return null;
        }
    }
    
    public String getPassCode() {
        if (passCodeEncrypted == null || passCodeEncrypted.isEmpty()) {
            return null;
        }
        try {
            return CryptoUtils.decryptSM4(passCodeEncrypted);
        } catch (Exception e) {
            System.err.println("通行码解密失败: " + e.getMessage());
            return null;
        }
    }
    
    // ✅ 修复：脱敏方法（防止空指针）
    public String getNameMasked() {
        if (name == null) return null;
        return CryptoUtils.maskName(name);
    }
    
    public String getIdCardMasked() {
        String idCard = getIdCard();
        if (idCard == null) return "****";
        return CryptoUtils.maskIdCard(idCard);
    }
    
    public String getPhoneMasked() {
        String phone = getPhone();
        if (phone == null) return "****";
        return CryptoUtils.maskPhone(phone);
    }
    
    // ✅ 修复：数据验证方法
    public boolean validateReservationData() {
        System.out.println("开始验证预约数据...");
        
        // 基本字段验证
        if (reservationType == null || reservationType.trim().isEmpty()) {
            System.err.println("预约类型不能为空");
            return false;
        }
        
        if (campus == null || campus.trim().isEmpty()) {
            System.err.println("校区不能为空");
            return false;
        }
        
        if (visitTime == null) {
            System.err.println("访问时间不能为空");
            return false;
        }
        
        if (name == null || name.trim().isEmpty()) {
            System.err.println("姓名不能为空");
            return false;
        }
        
        // ✅ 修复：验证身份证格式和哈希
        String actualIdCard = getIdCard(); // 获取解密后的身份证
        if (!CryptoUtils.isValidIdCard(actualIdCard)) {
            System.err.println("验证失败：身份证号格式无效 - " + actualIdCard);
            return false;
        }
        
        if (idCardHash == null || idCardHash.trim().isEmpty()) {
            System.err.println("身份证哈希值缺失");
            return false;
        }
        
        // ✅ 修复：验证手机号格式和哈希
        String actualPhone = getPhone(); // 获取解密后的手机号
        if (!CryptoUtils.isValidPhone(actualPhone)) {
            System.err.println("验证失败：手机号格式无效 - " + actualPhone);
            return false;
        }
        
        if (phoneHash == null || phoneHash.trim().isEmpty()) {
            System.err.println("手机号哈希值缺失");
            return false;
        }
        
        // 公务预约特殊验证
        if ("business".equals(reservationType)) {
            if (visitDepartmentId == null) {
                System.err.println("公务预约必须指定访问部门");
                return false;
            }
            if (contactPerson == null || contactPerson.trim().isEmpty()) {
                System.err.println("公务预约必须指定联系人");
                return false;
            }
        }
        
        System.out.println("预约数据验证通过");
        return true;
    }
    
    // ✅ 自动设置状态
    public void setReservationType(String reservationType) {
        this.reservationType = reservationType;
        // 根据预约类型自动设置状态
        if ("public".equals(reservationType)) {
            this.status = "approved"; // 社会公众预约自动通过
        } else if ("business".equals(reservationType)) {
            this.status = "pending";  // 公务预约需要审核
        }
    }
    
    // 生成数据完整性校验（安全版本）
    public void generateDataIntegrity() {
        try {
            this.dataIntegrity = CryptoUtils.generateDataIntegrity(
                String.valueOf(id != null ? id : 0), 
                reservationType != null ? reservationType : "", 
                campus != null ? campus : "", 
                name != null ? name : "", 
                idCardHash != null ? idCardHash : "", 
                phoneHash != null ? phoneHash : "", 
                status != null ? status : "", 
                String.valueOf(version != null ? version : 1)
            );
        } catch (Exception e) {
            System.err.println("生成数据完整性校验失败: " + e.getMessage());
            this.dataIntegrity = "";
        }
    }
    
    // 验证数据完整性（安全版本）
    public boolean validateDataIntegrity() {
        try {
            String expectedIntegrity = CryptoUtils.generateDataIntegrity(
                String.valueOf(id != null ? id : 0), 
                reservationType != null ? reservationType : "", 
                campus != null ? campus : "", 
                name != null ? name : "", 
                idCardHash != null ? idCardHash : "", 
                phoneHash != null ? phoneHash : "", 
                status != null ? status : "", 
                String.valueOf(version != null ? version : 1)
            );
            return expectedIntegrity.equals(dataIntegrity);
        } catch (Exception e) {
            System.err.println("验证数据完整性失败: " + e.getMessage());
            return false;
        }
    }
    
    // ✅ 重写toString方法，避免敏感信息泄露
    @Override
    public String toString() {
        return "Reservation{" +
                "id=" + id +
                ", username='" + username + '\'' +  // 📝 修改：显示username而非userId
                ", reservationType='" + reservationType + '\'' +
                ", campus='" + campus + '\'' +
                ", name='" + getNameMasked() + '\'' +
                ", status='" + status + '\'' +
                ", visitTime=" + visitTime +
                ", hasIdCard=" + (idCardHash != null && !idCardHash.isEmpty()) +
                ", hasPhone=" + (phoneHash != null && !phoneHash.isEmpty()) +
                '}';
    }
    
    // ✅ 所有其他的Getter和Setter保持不变
    
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getReservationType() { return reservationType; }
    // setReservationType() 方法已经在上面重写
    
    public String getCampus() { return campus; }
    public void setCampus(String campus) { this.campus = campus; }
    
    public Date getVisitTime() { return visitTime; }
    public void setVisitTime(Date visitTime) { this.visitTime = visitTime; }
    
    public String getOrganization() { return organization; }
    public void setOrganization(String organization) { this.organization = organization; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getIdCardEncrypted() { return idCardEncrypted; }
    public void setIdCardEncrypted(String idCardEncrypted) { this.idCardEncrypted = idCardEncrypted; }
    
    public String getPhoneEncrypted() { return phoneEncrypted; }
    public void setPhoneEncrypted(String phoneEncrypted) { this.phoneEncrypted = phoneEncrypted; }
    
    public String getIdCardHash() { return idCardHash; }
    public void setIdCardHash(String idCardHash) { this.idCardHash = idCardHash; }
    
    public String getPhoneHash() { return phoneHash; }
    public void setPhoneHash(String phoneHash) { this.phoneHash = phoneHash; }
    
    public String getTransportation() { return transportation; }
    public void setTransportation(String transportation) { this.transportation = transportation; }
    
    public String getPlateNumber() { return plateNumber; }
    public void setPlateNumber(String plateNumber) { this.plateNumber = plateNumber; }
    
    public Long getVisitDepartmentId() { return visitDepartmentId; }
    public void setVisitDepartmentId(Long visitDepartmentId) { this.visitDepartmentId = visitDepartmentId; }
    
    public String getContactPerson() { return contactPerson; }
    public void setContactPerson(String contactPerson) { this.contactPerson = contactPerson; }
    
    public String getVisitReason() { return visitReason; }
    public void setVisitReason(String visitReason) { this.visitReason = visitReason; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Long getApproverId() { return approverId; }
    public void setApproverId(Long approverId) { this.approverId = approverId; }
    
    public Date getApproveTime() { return approveTime; }
    public void setApproveTime(Date approveTime) { this.approveTime = approveTime; }
    
    public String getApproveComment() { return approveComment; }
    public void setApproveComment(String approveComment) { this.approveComment = approveComment; }
    
    public String getPassCodeEncrypted() { return passCodeEncrypted; }
    public void setPassCodeEncrypted(String passCodeEncrypted) { this.passCodeEncrypted = passCodeEncrypted; }
    
    public String getPassCodeHash() { return passCodeHash; }
    public void setPassCodeHash(String passCodeHash) { this.passCodeHash = passCodeHash; }
    
    public Date getPassCodeExpireTime() { return passCodeExpireTime; }
    public void setPassCodeExpireTime(Date passCodeExpireTime) { this.passCodeExpireTime = passCodeExpireTime; }
    
    public String getQrCodeData() { return qrCodeData; }
    public void setQrCodeData(String qrCodeData) { this.qrCodeData = qrCodeData; }
    
    public Long getCreatorId() { return creatorId; }
    public void setCreatorId(Long creatorId) { this.creatorId = creatorId; }
    
    public String getVisibleToDepartments() { return visibleToDepartments; }
    public void setVisibleToDepartments(String visibleToDepartments) { this.visibleToDepartments = visibleToDepartments; }
    
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
    
    public Date getUpdateTime() { return updateTime; }
    public void setUpdateTime(Date updateTime) { this.updateTime = updateTime; }
    
    public String getDataIntegrity() { return dataIntegrity; }
    public void setDataIntegrity(String dataIntegrity) { this.dataIntegrity = dataIntegrity; }
    
    public Integer getVersion() { return version; }
    public void setVersion(Integer version) { this.version = version; }
    
    public List<Companion> getCompanions() { return companions; }
    public void setCompanions(List<Companion> companions) { this.companions = companions; }
    
    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }
    
    // 📝 新增：创建者真实姓名的getter/setter
    public String getCreatorRealName() { return creatorRealName; }
    public void setCreatorRealName(String creatorRealName) { this.creatorRealName = creatorRealName; }
}