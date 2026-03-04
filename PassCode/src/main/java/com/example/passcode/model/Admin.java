
package com.example.passcode.model;

/**
 * 管理员实体类
 * 对应数据库admins表
 */
public class Admin {
    private int adminId;         // 管理员ID（主键）
    private String name;         // 姓名
    private String loginName;    // 登录名
    private String password;     // 明文密码
    private String sm3;          // SM3加密后的密码
    private int deptId;          // 所在部门ID（外键）
    private String deptName;     // 所在部门名称（冗余字段，方便显示，不对应数据库字段）
    private String phone;        // 联系电话
    private String email;        // 邮箱
    private String role;         // 角色：sys_admin, school_admin, dept_admin, audit_admin
    private String status;       // 状态：active, locked, disabled

    // 无参构造函数
    public Admin() {}

    // 全参构造函数
    public Admin(int adminId, String name, String loginName, String password,
                 String sm3, int deptId, String phone) {
        this.adminId = adminId;
        this.name = name;
        this.loginName = loginName;
        this.password = password;
        this.sm3 = sm3;
        this.deptId = deptId;
        this.phone = phone;
    }

    // 用于新增的构造函数（不包含ID）
    public Admin(String name, String loginName, String password, int deptId, String phone) {
        this.name = name;
        this.loginName = loginName;
        this.password = password;
        this.deptId = deptId;
        this.phone = phone;
    }

    // Getter和Setter方法
    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    // 为了兼容其他代码，添加getId方法
    public int getId() {
        return adminId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLoginName() {
        return loginName;
    }

    public void setLoginName(String loginName) {
        this.loginName = loginName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getSm3() {
        return sm3;
    }

    public void setSm3(String sm3) {
        this.sm3 = sm3;
    }

    public int getDeptId() {
        return deptId;
    }

    public void setDeptId(int deptId) {
        this.deptId = deptId;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // 重写toString方法，注意不输出密码信息
    @Override
    public String toString() {
        return "Admin{" +
                "adminId=" + adminId +
                ", name='" + name + '\'' +
                ", loginName='" + loginName + '\'' +
                ", deptId=" + deptId +
                ", deptName='" + deptName + '\'' +
                ", phone='" + phone + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                ", status='" + status + '\'' +
                '}';
    }

    // 重写equals和hashCode方法
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Admin admin = (Admin) o;
        return adminId == admin.adminId;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(adminId);
    }
}