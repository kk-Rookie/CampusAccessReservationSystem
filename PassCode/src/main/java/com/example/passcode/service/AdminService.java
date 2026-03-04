package com.example.passcode.service;

import com.example.passcode.dao.AdminDao;
import com.example.passcode.model.Admin;
import java.util.List;

/**
 * 管理员业务逻辑服务类
 * 处理管理员相关的业务逻辑
 */
public class AdminService {
    
    private AdminDao adminDao = new AdminDao();
    
    /**
     * 获取所有管理员列表
     * @return 管理员列表
     */
    public List<Admin> getAllAdmins() {
        return adminDao.getAllAdmins();
    }
    
    /**
     * 根据ID获取管理员信息
     * @param adminId 管理员ID
     * @return 管理员对象
     */
    public Admin getAdminById(int adminId) {
        return adminDao.getAdminById(adminId);
    }
    
    /**
     * 添加管理员
     * @param admin 管理员对象
     * @return 新管理员的ID，失败返回0，已存在返回-1
     */
    public int addAdmin(Admin admin) {
        // 参数验证
        if (admin == null || admin.getLoginName() == null || admin.getLoginName().trim().isEmpty()) {
            throw new IllegalArgumentException("管理员登录名不能为空");
        }
        if (admin.getName() == null || admin.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("管理员姓名不能为空");
        }
        if (admin.getPassword() == null || admin.getPassword().trim().isEmpty()) {
            throw new IllegalArgumentException("密码不能为空");
        }
        
        return adminDao.addAdmin(admin);
    }
    
    /**
     * 更新管理员信息
     * @param admin 管理员对象
     * @return 更新是否成功
     */
    public boolean updateAdmin(Admin admin) {
        // 参数验证
        if (admin == null || admin.getAdminId() <= 0) {
            throw new IllegalArgumentException("无效的管理员ID");
        }
        if (admin.getName() == null || admin.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("管理员姓名不能为空");
        }
        
        return adminDao.updateAdmin(admin);
    }
    
    /**
     * 删除管理员
     * @param adminId 管理员ID
     * @return 删除是否成功
     */
    public boolean deleteAdmin(int adminId) {
        if (adminId <= 0) {
            throw new IllegalArgumentException("无效的管理员ID");
        }
        
        return adminDao.deleteAdmin(adminId);
    }
    
    /**
     * 更新管理员状态
     * @param adminId 管理员ID
     * @param status 新状态
     * @return 更新是否成功
     */
    public boolean updateAdminStatus(int adminId, String status) {
        // 参数验证
        if (adminId <= 0) {
            throw new IllegalArgumentException("无效的管理员ID");
        }
        if (status == null || (!status.equals("active") && !status.equals("disabled") && !status.equals("locked"))) {
            throw new IllegalArgumentException("无效的状态值");
        }
        
        return adminDao.updateAdminStatus(adminId, status);
    }
    
    /**
     * 管理员登录验证
     * @param loginName 登录名
     * @param password 密码
     * @return 登录成功返回管理员对象，失败返回null
     */
    public Admin login(String loginName, String password) {
        if (loginName == null || loginName.trim().isEmpty()) {
            throw new IllegalArgumentException("登录名不能为空");
        }
        if (password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("密码不能为空");
        }
        
        return adminDao.validateAdmin(loginName, password);
    }
    
    /**
     * 重置密码
     * @param adminId 管理员ID
     * @param newPassword 新密码
     * @return 重置是否成功
     */
    public boolean resetPassword(int adminId, String newPassword) {
        if (adminId <= 0) {
            throw new IllegalArgumentException("无效的管理员ID");
        }
        if (newPassword == null || newPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("新密码不能为空");
        }
        
        return adminDao.resetPassword(adminId, newPassword);
    }
    
    /**
     * 根据条件搜索管理员
     * @param keyword 关键词
     * @param role 角色
     * @param status 状态
     * @return 管理员列表
     */
    public List<Admin> searchAdmins(String keyword, String role, String status) {
        return adminDao.searchAdmins(keyword, role, status);
    }
}