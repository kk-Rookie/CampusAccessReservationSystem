package com.example.demo.model;

import com.example.demo.util.CryptoUtils;
import com.example.demo.util.SM3Util;
import java.util.Date;

/**
 * 随行人员实体类
 */
public class Companion {
    private Long id;
    private Long reservationId;
    private String name;
    
    // 敏感数据（加密存储）
    private String idCardEncrypted;
    private String phoneEncrypted;
    private String idCardHash;
    private String phoneHash;
    
    // 关系信息
    private String relationship;
    private String remark;
    
    // 时间戳
    private Date createTime;
    
    // 数据完整性
    private String dataIntegrity;
    
    public Companion() {
        this.createTime = new Date();
    }
    
    public Companion(Long reservationId, String name) {
        this();
        this.reservationId = reservationId;
        this.name = name;
    }
    
    // 便捷方法：设置敏感数据（自动加密和哈希）
    public void setIdCard(String idCard) {
        if (idCard != null && !idCard.trim().isEmpty()) {
            this.idCardEncrypted = CryptoUtils.encryptSM4(idCard);
            this.idCardHash = SM3Util.hash(idCard);
        }
    }
    
    public void setPhone(String phone) {
        if (phone != null && !phone.trim().isEmpty()) {
            this.phoneEncrypted = CryptoUtils.encryptSM4(phone);
            this.phoneHash = SM3Util.hash(phone);
        }
    }
    
    // 便捷方法：获取解密后的敏感数据
    public String getIdCard() {
        return idCardEncrypted != null ? CryptoUtils.decryptSM4(idCardEncrypted) : null;
    }
    
    public String getPhone() {
        return phoneEncrypted != null ? CryptoUtils.decryptSM4(phoneEncrypted) : null;
    }
    
    // 便捷方法：获取脱敏数据
    public String getNameMasked() {
        return CryptoUtils.maskName(name);
    }
    
    public String getIdCardMasked() {
        String idCard = getIdCard();
        return idCard != null ? CryptoUtils.maskIdCard(idCard) : null;
    }
    
    public String getPhoneMasked() {
        String phone = getPhone();
        return phone != null ? CryptoUtils.maskPhone(phone) : null;
    }
    
    // 生成数据完整性校验
    public void generateDataIntegrity() {
        this.dataIntegrity = CryptoUtils.generateDataIntegrity(
            String.valueOf(id), String.valueOf(reservationId), name, 
            idCardHash, phoneHash, relationship
        );
    }
    
    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Long getReservationId() { return reservationId; }
    public void setReservationId(Long reservationId) { this.reservationId = reservationId; }
    
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
    
    public String getRelationship() { return relationship; }
    public void setRelationship(String relationship) { this.relationship = relationship; }
    
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
    
    public String getDataIntegrity() { return dataIntegrity; }
    public void setDataIntegrity(String dataIntegrity) { this.dataIntegrity = dataIntegrity; }
    
    @Override
    public String toString() {
        return "Companion{" +
                "id=" + id +
                ", reservationId=" + reservationId +
                ", name='" + getNameMasked() + '\'' +
                ", relationship='" + relationship + '\'' +
                '}';
    }
}