package com.example.demo.model;

import java.util.Date;

/**
 * 部门实体类
 */
public class Department {
    private Long id;
    private String departmentCode;
    private String departmentName;
    private String departmentType;
    private Long parentId;
    private String status;
    private String contactPerson;
    private String contactPhone;
    private String description;
    private Date createTime;
    private Date updateTime;
    
    public Department() {
        this.createTime = new Date();
        this.updateTime = new Date();
        this.status = "active";
    }
    
    public Department(String departmentCode, String departmentName, String departmentType) {
        this();
        this.departmentCode = departmentCode;
        this.departmentName = departmentName;
        this.departmentType = departmentType;
    }
    
    // Getter 和 Setter 方法
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getDepartmentCode() { return departmentCode; }
    public void setDepartmentCode(String departmentCode) { this.departmentCode = departmentCode; }
    
    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }
    
    public String getDepartmentType() { return departmentType; }
    public void setDepartmentType(String departmentType) { this.departmentType = departmentType; }
    
    public Long getParentId() { return parentId; }
    public void setParentId(Long parentId) { this.parentId = parentId; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getContactPerson() { return contactPerson; }
    public void setContactPerson(String contactPerson) { this.contactPerson = contactPerson; }
    
    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
    
    public Date getUpdateTime() { return updateTime; }
    public void setUpdateTime(Date updateTime) { this.updateTime = updateTime; }
    
    @Override
    public String toString() {
        return "Department{" +
                "id=" + id +
                ", departmentCode='" + departmentCode + '\'' +
                ", departmentName='" + departmentName + '\'' +
                ", departmentType='" + departmentType + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}