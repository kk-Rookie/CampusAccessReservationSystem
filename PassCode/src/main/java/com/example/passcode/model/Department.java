package com.example.passcode.model;

/**
 * 部门实体类
 * 对应数据库departments表
 */
public class Department {
    private Long id;                    // 部门ID（主键）对应数据库id字段
    private String departmentCode;      // 部门代码，对应数据库department_code字段
    private String departmentName;      // 部门名称，对应数据库department_name字段
    private String departmentType;      // 部门类型，对应数据库department_type字段
    private String status;              // 状态，对应数据库status字段
    private String description;         // 描述，对应数据库description字段
    private java.util.Date createTime;  // 创建时间，对应数据库create_time字段

    // 旧字段兼容性getter/setter（保持向后兼容）
    private int deptId;          // 部门编号（主键）- 兼容旧代码
    private String deptName;     // 部门名称 - 兼容旧代码
    private String deptType;     // 部门类型 - 兼容旧代码

    // 无参构造函数
    public Department() {}

    // 全参构造函数
    public Department(Long id, String departmentCode, String departmentName, String departmentType) {
        this.id = id;
        this.departmentCode = departmentCode;
        this.departmentName = departmentName;
        this.departmentType = departmentType;
    }

    // 兼容旧代码的构造函数
    public Department(int deptId, String deptName, String deptType) {
        this.id = (long) deptId;
        this.departmentName = deptName;
        this.departmentType = deptType;
        // 同时设置兼容字段
        this.deptId = deptId;
        this.deptName = deptName;
        this.deptType = deptType;
    }

    // 部分参数构造函数（不包含ID，用于新增）
    public Department(String deptName, String deptType) {
        this.departmentName = deptName;
        this.departmentType = deptType;
        // 同时设置兼容字段
        this.deptName = deptName;
        this.deptType = deptType;
    }

    // Getter和Setter方法
    
    // 新字段的getter/setter
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
        this.deptId = id != null ? id.intValue() : 0; // 保持兼容性
    }

    public String getDepartmentCode() {
        return departmentCode;
    }

    public void setDepartmentCode(String departmentCode) {
        this.departmentCode = departmentCode;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
        this.deptName = departmentName; // 保持兼容性
    }

    public String getDepartmentType() {
        return departmentType;
    }

    public void setDepartmentType(String departmentType) {
        this.departmentType = departmentType;
        this.deptType = departmentType; // 保持兼容性
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public java.util.Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(java.util.Date createTime) {
        this.createTime = createTime;
    }

    // 兼容旧代码的getter/setter
    public int getDeptId() {
        return deptId;
    }

    public void setDeptId(int deptId) {
        this.deptId = deptId;
        this.id = (long) deptId; // 保持同步
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
        this.departmentName = deptName; // 保持同步
    }

    public String getDeptType() {
        return deptType;
    }

    public void setDeptType(String deptType) {
        this.deptType = deptType;
        this.departmentType = deptType; // 保持同步
    }

    // 重写toString方法，便于调试和日志输出
    @Override
    public String toString() {
        return "Department{" +
                "deptId=" + deptId +
                ", deptName='" + deptName + '\'' +
                ", deptType='" + deptType + '\'' +
                '}';
    }

    // 重写equals和hashCode方法，便于对象比较
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Department that = (Department) o;
        return deptId == that.deptId;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(deptId);
    }

    // JSP页面兼容性方法
    public Long getDepartmentId() {
        return (long) this.deptId;
    }

    public void setDepartmentId(Long departmentId) {
        this.deptId = departmentId != null ? departmentId.intValue() : 0;
        this.id = departmentId; // 保持同步
    }
}