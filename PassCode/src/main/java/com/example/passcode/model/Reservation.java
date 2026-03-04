package com.example.passcode.model;

import java.time.LocalDateTime;

/**
 * 预约实体类
 * 对应数据库中的reservations表
 */
public class Reservation {
    private Long id;
    private String username;
    private String reservationType;
    private String campus;
    private LocalDateTime visitTime;
    private String organization;
    private String name;
    private String idCard;
    private String phone;
    private String transportation;
    private String plateNumber;
    private Integer visitDepartmentId;
    private String visitDepartmentName;
    private String contactPerson;
    private String visitReason;
    private String status;
    private Long approverId;
    private LocalDateTime approveTime;
    private String approveComment;
    private Long creatorId;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    
    // 审核相关字段
    private String auditorName;
    private String auditResult;
    private String auditComment;
    private LocalDateTime auditTime;
    
    // JSP页面需要的额外字段映射
    private Department department; // 部门对象

    // 构造方法
    public Reservation() {}

    public Reservation(String username, String reservationType, String campus, 
                      LocalDateTime visitTime, String name, String phone) {
        this.username = username;
        this.reservationType = reservationType;
        this.campus = campus;
        this.visitTime = visitTime;
        this.name = name;
        this.phone = phone;
        this.status = "pending";
        this.createTime = LocalDateTime.now();
    }

    // Getter和Setter方法
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getReservationType() {
        return reservationType;
    }

    public void setReservationType(String reservationType) {
        this.reservationType = reservationType;
    }

    public String getCampus() {
        return campus;
    }

    public void setCampus(String campus) {
        this.campus = campus;
    }

    public LocalDateTime getVisitTime() {
        return visitTime;
    }

    public void setVisitTime(LocalDateTime visitTime) {
        this.visitTime = visitTime;
    }

    public String getOrganization() {
        return organization;
    }

    public void setOrganization(String organization) {
        this.organization = organization;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getIdCard() {
        return idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getTransportation() {
        return transportation;
    }

    public void setTransportation(String transportation) {
        this.transportation = transportation;
    }

    public String getPlateNumber() {
        return plateNumber;
    }

    public void setPlateNumber(String plateNumber) {
        this.plateNumber = plateNumber;
    }

    public Integer getVisitDepartmentId() {
        return visitDepartmentId;
    }

    public void setVisitDepartmentId(Integer visitDepartmentId) {
        this.visitDepartmentId = visitDepartmentId;
    }

    public String getVisitDepartmentName() {
        return visitDepartmentName;
    }

    public void setVisitDepartmentName(String visitDepartmentName) {
        this.visitDepartmentName = visitDepartmentName;
    }

    public String getContactPerson() {
        return contactPerson;
    }

    public void setContactPerson(String contactPerson) {
        this.contactPerson = contactPerson;
    }

    public String getVisitReason() {
        return visitReason;
    }

    public void setVisitReason(String visitReason) {
        this.visitReason = visitReason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Long getApproverId() {
        return approverId;
    }

    public void setApproverId(Long approverId) {
        this.approverId = approverId;
    }

    public LocalDateTime getApproveTime() {
        return approveTime;
    }

    public void setApproveTime(LocalDateTime approveTime) {
        this.approveTime = approveTime;
    }

    public String getApproveComment() {
        return approveComment;
    }

    public void setApproveComment(String approveComment) {
        this.approveComment = approveComment;
    }

    public Long getCreatorId() {
        return creatorId;
    }

    public void setCreatorId(Long creatorId) {
        this.creatorId = creatorId;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    public LocalDateTime getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(LocalDateTime updateTime) {
        this.updateTime = updateTime;
    }

    public String getAuditorName() {
        return auditorName;
    }

    public void setAuditorName(String auditorName) {
        this.auditorName = auditorName;
    }

    public String getAuditResult() {
        return auditResult;
    }

    public void setAuditResult(String auditResult) {
        this.auditResult = auditResult;
    }

    public String getAuditComment() {
        return auditComment;
    }

    public void setAuditComment(String auditComment) {
        this.auditComment = auditComment;
    }

    public LocalDateTime getAuditTime() {
        return auditTime;
    }

    public void setAuditTime(LocalDateTime auditTime) {
        this.auditTime = auditTime;
    }

    public Department getDepartment() {
        if (this.department == null && this.visitDepartmentName != null) {
            // 创建临时部门对象
            Department dept = new Department();
            dept.setDeptName(this.visitDepartmentName);
            dept.setDeptId(this.visitDepartmentId != null ? this.visitDepartmentId : 0);
            return dept;
        }
        return this.department;
    }
    
    public void setDepartment(Department department) {
        this.department = department;
    }

    // 便捷方法
    public boolean isPending() {
        return "pending".equals(status);
    }

    public boolean isApproved() {
        return "approved".equals(status);
    }

    public boolean isRejected() {
        return "rejected".equals(status);
    }

    public String getStatusText() {
        switch (status) {
            case "pending": return "待审核";
            case "approved": return "已通过";
            case "rejected": return "已拒绝";
            case "expired": return "已过期";
            default: return "未知状态";
        }
    }

    public String getReservationTypeText() {
        switch (reservationType) {
            case "public": return "公务预约";
            case "visitor": return "访客预约";
            case "emergency": return "紧急预约";
            default: return "其他";
        }
    }

    // JSP字段映射方法 - 为了兼容JSP页面中的字段引用
    public Long getReservationId() {
        return this.id;
    }
    
    public String getIdNumber() {
        return this.idCard; // 映射身份证号到学号/工号
    }
    
    public java.util.Date getReservationDate() {
        if (this.visitTime != null) {
            return java.sql.Timestamp.valueOf(this.visitTime);
        }
        return null;
    }
    
    public java.util.Date getReservationTime() {
        if (this.visitTime != null) {
            return java.sql.Timestamp.valueOf(this.visitTime);
        }
        return null;
    }
    
    public String getEntryType() {
        // 根据预约类型推断出入类型
        if ("visitor".equals(this.reservationType)) {
            return "IN";
        }
        return "OUT";
    }
    
    public java.util.Date getApplicationTime() {
        if (this.createTime != null) {
            return java.sql.Timestamp.valueOf(this.createTime);
        }
        return null;
    }
    
    // 审核相关的JSP字段映射
    public String getAuditBy() {
        return this.auditorName;
    }
    
    public String getReason() {
        return this.visitReason;
    }

    @Override
    public String toString() {
        return "Reservation{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", reservationType='" + reservationType + '\'' +
                ", campus='" + campus + '\'' +
                ", visitTime=" + visitTime +
                ", organization='" + organization + '\'' +
                ", name='" + name + '\'' +
                ", status='" + status + '\'' +
                ", createTime=" + createTime +
                '}';
    }
}