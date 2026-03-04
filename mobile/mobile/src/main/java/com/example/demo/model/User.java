package com.example.demo.model;

import com.example.demo.util.CryptoUtils;
import com.example.demo.util.SM3Util;
import java.util.Date;

/**
 * 用户实体类 - 修复版
 */
public class User {
    private Long id;
    private String username;
    private String phone; // 脱敏显示的手机号
    
    // 敏感数据（加密存储）
    private String passwordHash;
    private String phoneEncrypted;
    private String phoneHash;
    
    // 用户信息
    private String realName;
    private String idCardEncrypted;
    private String idCardHash;
    
    // 账户状态
    private String status;
    private String email;
    private String avatarUrl;
    
    // 安全信息
    private int loginAttempts;
    private Date lastLoginTime;
    private String lastLoginIp;
    private Date passwordExpireTime; // 📝 添加这个字段
    
    // 时间戳
    private Date createTime;
    private Date updateTime;
    private String dataIntegrity;
    
    // 构造函数
    public User() {
        this.status = "active";
        this.loginAttempts = 0;
    }
    
    public User(String username, String phone, String password) {
        this();
        this.username = username;
        this.setPhoneData(phone);
        this.setPassword(password);
    }
    
    // 密码设置（自动加密）
    public void setPassword(String password) {
        if (password != null && !password.trim().isEmpty()) {
            this.passwordHash = SM3Util.hash(password);
        }
    }
    
    // 手机号设置（自动加密和哈希）
    public void setPhoneData(String phone) {
        if (phone != null && !phone.trim().isEmpty()) {
            try {
                this.phone = phone.substring(0, 3) + "****" + phone.substring(7); // 脱敏显示
                this.phoneEncrypted = CryptoUtils.encryptSM4(phone);
                this.phoneHash = SM3Util.hash(phone);
            } catch (Exception e) {
                System.err.println("手机号处理失败: " + e.getMessage());
                this.phone = phone; // 降级处理
                this.phoneHash = SM3Util.hash(phone);
                this.phoneEncrypted = ""; // 设置为空字符串
            }
        }
    }
    
    // 身份证设置（自动加密和哈希）
    public void setIdCard(String idCard) {
        if (idCard != null && !idCard.trim().isEmpty()) {
            try {
                this.idCardEncrypted = CryptoUtils.encryptSM4(idCard);
                this.idCardHash = SM3Util.hash(idCard);
            } catch (Exception e) {
                System.err.println("身份证处理失败: " + e.getMessage());
                this.idCardHash = SM3Util.hash(idCard);
                this.idCardEncrypted = ""; // 设置为空字符串
            }
        }
    }
    
    // 验证密码
    public boolean verifyPassword(String inputPassword) {
        if (inputPassword == null || this.passwordHash == null) {
            return false;
        }
        return SM3Util.hash(inputPassword).equals(this.passwordHash);
    }
    
    // 获取解密的手机号
    public String getDecryptedPhone() {
        if (phoneEncrypted != null && !phoneEncrypted.isEmpty()) {
            try {
                return CryptoUtils.decryptSM4(phoneEncrypted);
            } catch (Exception e) {
                System.err.println("手机号解密失败: " + e.getMessage());
                return null;
            }
        }
        return null;
    }
    
    // 获取解密的身份证
    public String getDecryptedIdCard() {
        if (idCardEncrypted != null && !idCardEncrypted.isEmpty()) {
            try {
                return CryptoUtils.decryptSM4(idCardEncrypted);
            } catch (Exception e) {
                System.err.println("身份证解密失败: " + e.getMessage());
                return null;
            }
        }
        return null;
    }
    
    // 📝 所有的 Getter 和 Setter 方法
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    
    // 📝 添加缺失的方法
    public String getPhoneEncrypted() { return phoneEncrypted; }
    public void setPhoneEncrypted(String phoneEncrypted) { this.phoneEncrypted = phoneEncrypted; }
    
    public String getPhoneHash() { return phoneHash; }
    public void setPhoneHash(String phoneHash) { this.phoneHash = phoneHash; }
    
    public String getRealName() { return realName; }
    public void setRealName(String realName) { this.realName = realName; }
    
    // 📝 添加缺失的方法
    public String getIdCardEncrypted() { return idCardEncrypted; }
    public void setIdCardEncrypted(String idCardEncrypted) { this.idCardEncrypted = idCardEncrypted; }
    
    public String getIdCardHash() { return idCardHash; }
    public void setIdCardHash(String idCardHash) { this.idCardHash = idCardHash; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }
    
    public int getLoginAttempts() { return loginAttempts; }
    public void setLoginAttempts(int loginAttempts) { this.loginAttempts = loginAttempts; }
    
    public Date getLastLoginTime() { return lastLoginTime; }
    public void setLastLoginTime(Date lastLoginTime) { this.lastLoginTime = lastLoginTime; }
    
    public String getLastLoginIp() { return lastLoginIp; }
    public void setLastLoginIp(String lastLoginIp) { this.lastLoginIp = lastLoginIp; }
    
    // 📝 添加缺失的方法
    public Date getPasswordExpireTime() { return passwordExpireTime; }
    public void setPasswordExpireTime(Date passwordExpireTime) { this.passwordExpireTime = passwordExpireTime; }
    
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
    
    public Date getUpdateTime() { return updateTime; }
    public void setUpdateTime(Date updateTime) { this.updateTime = updateTime; }
    
    public String getDataIntegrity() { return dataIntegrity; }
    public void setDataIntegrity(String dataIntegrity) { this.dataIntegrity = dataIntegrity; }
    
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", phone='" + phone + '\'' +
                ", realName='" + realName + '\'' +
                ", status='" + status + '\'' +
                ", createTime=" + createTime +
                '}';
    }
    
    /**
     * 清除敏感数据，用于API返回
     */
    public void clearSensitiveData() {
        this.passwordHash = null;
        this.phoneEncrypted = null;
        this.phoneHash = null;
        this.idCardEncrypted = null;
        this.idCardHash = null;
        this.dataIntegrity = null;
        this.lastLoginIp = null;
    }
}