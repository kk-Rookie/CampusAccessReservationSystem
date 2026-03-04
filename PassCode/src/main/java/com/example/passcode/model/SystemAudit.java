package com.example.passcode.model;

import java.sql.Timestamp;

/**
 * 系统审计实体类（映射到operation_logs表）
 */
public class SystemAudit {
    private Long id;
    private String operationType;     // operation_type：操作类型
    private String operationModule;   // operation_module：操作模块
    private String operationDescription; // operation_description：操作描述
    private String userName;          // user_name：用户名（这里是管理员名）
    private String userIdCardHash;    // user_id_card_hash：身份证哈希
    private String userPhoneHash;     // user_phone_hash：手机号哈希
    private String ipAddress;         // ip_address：IP地址
    private String userAgent;         // user_agent：用户代理
    private String deviceInfo;        // device_info：设备信息
    private String sessionId;         // session_id：会话ID
    private String targetTable;       // target_table：目标表名
    private Long targetRecordId;      // target_record_id：目标记录ID
    private String operationData;     // operation_data：操作数据
    private String dataBefore;        // data_before：操作前数据
    private String dataAfter;         // data_after：操作后数据
    private String operationResult;   // operation_result：操作结果
    private String errorMessage;      // error_message：错误信息
    private Integer responseTime;     // response_time：响应时间
    private String riskLevel;         // risk_level：风险级别
    private String riskFactors;       // risk_factors：风险因素
    private Timestamp operationTime;  // operation_time：操作时间
    private String logHash;           // log_hash：日志哈希

    // 默认构造方法
    public SystemAudit() {}

    // 带参数的构造方法
    public SystemAudit(String operationType, String operationModule, String userName,
                       String operationDescription, String ipAddress) {
        this.operationType = operationType;
        this.operationModule = operationModule;
        this.userName = userName;
        this.operationDescription = operationDescription;
        this.ipAddress = ipAddress;
        this.operationTime = new Timestamp(System.currentTimeMillis());
        this.operationResult = "success";
        this.logHash = generateLogHash();
    }

    // Getter 和 Setter 方法
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getOperationType() {
        return operationType;
    }

    public void setOperationType(String operationType) {
        this.operationType = operationType;
    }

    public String getOperationModule() {
        return operationModule;
    }

    public void setOperationModule(String operationModule) {
        this.operationModule = operationModule;
    }

    public String getOperationDescription() {
        return operationDescription;
    }

    public void setOperationDescription(String operationDescription) {
        this.operationDescription = operationDescription;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserIdCardHash() {
        return userIdCardHash;
    }

    public void setUserIdCardHash(String userIdCardHash) {
        this.userIdCardHash = userIdCardHash;
    }

    public String getUserPhoneHash() {
        return userPhoneHash;
    }

    public void setUserPhoneHash(String userPhoneHash) {
        this.userPhoneHash = userPhoneHash;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }

    public String getDeviceInfo() {
        return deviceInfo;
    }

    public void setDeviceInfo(String deviceInfo) {
        this.deviceInfo = deviceInfo;
    }

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }

    public String getTargetTable() {
        return targetTable;
    }

    public void setTargetTable(String targetTable) {
        this.targetTable = targetTable;
    }

    public Long getTargetRecordId() {
        return targetRecordId;
    }

    public void setTargetRecordId(Long targetRecordId) {
        this.targetRecordId = targetRecordId;
    }

    public String getOperationData() {
        return operationData;
    }

    public void setOperationData(String operationData) {
        this.operationData = operationData;
    }

    public String getDataBefore() {
        return dataBefore;
    }

    public void setDataBefore(String dataBefore) {
        this.dataBefore = dataBefore;
    }

    public String getDataAfter() {
        return dataAfter;
    }

    public void setDataAfter(String dataAfter) {
        this.dataAfter = dataAfter;
    }

    public String getOperationResult() {
        return operationResult;
    }

    public void setOperationResult(String operationResult) {
        this.operationResult = operationResult;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public Integer getResponseTime() {
        return responseTime;
    }

    public void setResponseTime(Integer responseTime) {
        this.responseTime = responseTime;
    }

    public String getRiskLevel() {
        return riskLevel;
    }

    public void setRiskLevel(String riskLevel) {
        this.riskLevel = riskLevel;
    }

    public String getRiskFactors() {
        return riskFactors;
    }

    public void setRiskFactors(String riskFactors) {
        this.riskFactors = riskFactors;
    }

    public Timestamp getOperationTime() {
        return operationTime;
    }

    public void setOperationTime(Timestamp operationTime) {
        this.operationTime = operationTime;
    }

    public String getLogHash() {
        return logHash;
    }

    public void setLogHash(String logHash) {
        this.logHash = logHash;
    }

    // 便捷方法 - 兼容原有代码
    public String getAuditType() {
        return operationType;
    }

    public void setAuditType(String auditType) {
        this.operationType = auditType;
    }

    public String getModuleName() {
        return operationModule;
    }

    public void setModuleName(String moduleName) {
        this.operationModule = moduleName;
    }

    public String getAdminName() {
        return userName;
    }

    public void setAdminName(String adminName) {
        this.userName = adminName;
    }

    public Timestamp getAuditTime() {
        return operationTime;
    }

    public void setAuditTime(Timestamp auditTime) {
        this.operationTime = auditTime;
    }

    public String getBeforeData() {
        return dataBefore;
    }

    public void setBeforeData(String beforeData) {
        this.dataBefore = beforeData;
    }

    public String getAfterData() {
        return dataAfter;
    }

    public void setAfterData(String afterData) {
        this.dataAfter = afterData;
    }

    // 生成日志哈希
    private String generateLogHash() {
        return "log_" + System.currentTimeMillis();
    }

    @Override
    public String toString() {
        return "SystemAudit{" +
                "id=" + id +
                ", operationType='" + operationType + '\'' +
                ", operationModule='" + operationModule + '\'' +
                ", userName='" + userName + '\'' +
                ", operationDescription='" + operationDescription + '\'' +
                ", operationTime=" + operationTime +
                ", operationResult='" + operationResult + '\'' +
                '}';
    }
}
