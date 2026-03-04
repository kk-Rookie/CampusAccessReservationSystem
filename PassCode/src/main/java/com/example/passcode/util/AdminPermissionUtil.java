package com.example.passcode.util;

import com.example.passcode.model.Admin;

/**
 * 管理员权限工具类
 * 提供统一的权限检查方法
 */
public class AdminPermissionUtil {
    
    // 角色常量
    public static final String ROLE_SYSTEM_ADMIN = "sys_admin";       // 系统管理员
    public static final String ROLE_SCHOOL_ADMIN = "school_admin";    // 学校管理员  
    public static final String ROLE_DEPT_ADMIN = "dept_admin";        // 部门管理员
    public static final String ROLE_AUDIT_ADMIN = "audit_admin";      // 审核管理员
    public static final String ROLE_ADMIN = "admin";                  // 普通管理员
    
    /**
     * 判断是否是系统管理员
     * 系统管理员拥有最高权限，可以管理所有数据
     */
    public static boolean isSystemAdmin(Admin admin) {
        return admin != null && ROLE_SYSTEM_ADMIN.equals(admin.getRole());
    }
    
    /**
     * 判断是否是学校管理员
     * 学校管理员可以查看和管理所有部门的数据
     */
    public static boolean isSchoolAdmin(Admin admin) {
        return admin != null && ROLE_SCHOOL_ADMIN.equals(admin.getRole());
    }
    
    /**
     * 判断是否是部门管理员
     * 部门管理员只能管理自己部门的数据
     */
    public static boolean isDepartmentAdmin(Admin admin) {
        return admin != null && ROLE_DEPT_ADMIN.equals(admin.getRole());
    }
    
    /**
     * 判断是否是审核管理员
     * 审核管理员可以审核所有部门的预约申请
     */
    public static boolean isAuditAdmin(Admin admin) {
        return admin != null && ROLE_AUDIT_ADMIN.equals(admin.getRole());
    }
    
    /**
     * 判断是否是普通管理员
     */
    public static boolean isGeneralAdmin(Admin admin) {
        return admin != null && ROLE_ADMIN.equals(admin.getRole());
    }
    
    /**
     * 判断管理员是否可以查看所有部门的数据
     */
    public static boolean canViewAllDepartments(Admin admin) {
        return isSystemAdmin(admin) || isSchoolAdmin(admin) || isAuditAdmin(admin);
    }
    
    /**
     * 判断管理员是否只能查看自己部门的数据
     */
    public static boolean canOnlyViewOwnDepartment(Admin admin) {
        return isDepartmentAdmin(admin) || isGeneralAdmin(admin);
    }
    
    /**
     * 获取管理员可以访问的部门ID（基于预约的organization字段）
     * @param admin 管理员对象
     * @param requestedDeptId 请求的部门ID（null表示查看所有）
     * @return 实际可以访问的部门ID（null表示可以访问所有）
     */
    public static Integer getAccessibleDepartmentId(Admin admin, Integer requestedDeptId) {
        if (admin == null) {
            return null;
        }
        
        // 超级管理员（系统管理员）可以访问所有部门
        if (isSystemAdmin(admin)) {
            return requestedDeptId; // 返回请求的部门ID，null表示所有部门
        }
        
        // 学校管理员、审核管理员可以访问所有部门
        if (isSchoolAdmin(admin) || isAuditAdmin(admin)) {
            return requestedDeptId;
        }
        
        // 部门管理员和普通管理员只能访问自己的部门
        if (isDepartmentAdmin(admin) || isGeneralAdmin(admin)) {
            return admin.getDeptId(); // 强制返回自己的部门ID
        }
        
        // 默认返回自己的部门ID
        return admin.getDeptId();
    }
    
    /**
     * 检查管理员是否可以查看指定组织的预约
     * @param admin 管理员对象
     * @param reservationOrganization 预约的组织字段
     * @return 是否可以查看
     */
    public static boolean canViewReservationByOrganization(Admin admin, String reservationOrganization) {
        if (admin == null) {
            return false;
        }
        
        // 超级管理员可以查看所有预约
        if (isSystemAdmin(admin)) {
            return true;
        }
        
        // 学校管理员、审核管理员可以查看所有预约
        if (isSchoolAdmin(admin) || isAuditAdmin(admin)) {
            return true;
        }
        
        // 如果预约的组织是"无"，所有管理员都可以查看（普通预约）
        if ("无".equals(reservationOrganization)) {
            return true;
        }
        
        // 如果预约的组织是具体部门名，只有该部门的管理员可以查看
        if (reservationOrganization != null && !reservationOrganization.trim().isEmpty()) {
            // 需要获取管理员的部门名称进行比较
            // 这里需要在调用处提供部门名称映射
            return false; // 默认不允许，需要在具体使用处进行部门名称匹配
        }
        
        return false;
    }
    
    /**
     * 检查管理员是否可以查看指定组织的预约（带部门名称）
     * @param admin 管理员对象
     * @param reservationOrganization 预约的组织字段
     * @param adminDepartmentName 管理员的部门名称
     * @return 是否可以查看
     */
    public static boolean canViewReservationByOrganization(Admin admin, String reservationOrganization, String adminDepartmentName) {
        if (admin == null) {
            return false;
        }
        
        // 超级管理员可以查看所有预约
        if (isSystemAdmin(admin)) {
            return true;
        }
        
        // 学校管理员、审核管理员可以查看所有预约
        if (isSchoolAdmin(admin) || isAuditAdmin(admin)) {
            return true;
        }
        
        // 如果预约的组织是"无"，所有管理员都可以查看（普通预约）
        if ("无".equals(reservationOrganization)) {
            return true;
        }
        
        // 如果预约的组织是具体部门名，只有该部门的管理员可以查看
        if (reservationOrganization != null && !reservationOrganization.trim().isEmpty()) {
            return reservationOrganization.equals(adminDepartmentName);
        }
        
        return false;
    }
    
    /**
     * 检查管理员是否有权限访问指定部门的数据
     */
    public static boolean hasAccessToDepartment(Admin admin, int targetDeptId) {
        if (admin == null) {
            return false;
        }
        
        // 可以查看所有部门的管理员
        if (canViewAllDepartments(admin)) {
            return true;
        }
        
        // 只能查看自己部门的管理员
        if (canOnlyViewOwnDepartment(admin)) {
            return admin.getDeptId() == targetDeptId;
        }
        
        return false;
    }
    
    /**
     * 检查管理员是否有权限进行审核操作
     */
    public static boolean canAuditReservations(Admin admin) {
        return isSystemAdmin(admin) || isSchoolAdmin(admin) || isAuditAdmin(admin) || isDepartmentAdmin(admin);
    }
    
    /**
     * 检查管理员是否有权限管理用户
     */
    public static boolean canManageUsers(Admin admin) {
        return isSystemAdmin(admin) || isSchoolAdmin(admin);
    }
    
    /**
     * 检查管理员是否有权限管理部门
     */
    public static boolean canManageDepartments(Admin admin) {
        return isSystemAdmin(admin) || isSchoolAdmin(admin);
    }
    
    /**
     * 获取权限级别描述
     */
    public static String getPermissionDescription(Admin admin) {
        if (admin == null) {
            return "无权限";
        }
        
        switch (admin.getRole()) {
            case ROLE_SYSTEM_ADMIN:
                return "系统管理员 - 拥有所有权限";
            case ROLE_SCHOOL_ADMIN:
                return "学校管理员 - 可管理所有部门数据";
            case ROLE_DEPT_ADMIN:
                return "部门管理员 - 仅可管理本部门数据";
            case ROLE_AUDIT_ADMIN:
                return "审核管理员 - 可审核所有预约申请";
            case ROLE_ADMIN:
                return "普通管理员 - 基础权限";
            default:
                return "未知角色";
        }
    }
}
