-- 手机端校园预约系统数据库 - MySQL 8.4兼容版
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 删除所有表（如果存在）
DROP TABLE IF EXISTS companions;
DROP TABLE IF EXISTS reservations; 
DROP TABLE IF EXISTS user_sessions;
DROP TABLE IF EXISTS data_access_logs;
DROP TABLE IF EXISTS access_logs;
DROP TABLE IF EXISTS operation_logs;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS departments;

-- 删除存储过程
DROP PROCEDURE IF EXISTS GetUserReservationsByUsername;
DROP PROCEDURE IF EXISTS CleanExpiredPassCodes;
DROP PROCEDURE IF EXISTS CleanOldLogs;

-- ==========================================
-- 1. 部门表
-- ==========================================
CREATE TABLE departments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    department_code VARCHAR(50) NOT NULL UNIQUE,
    department_name VARCHAR(200) NOT NULL,
    department_type VARCHAR(50) NOT NULL COMMENT '部门类型',
    parent_id BIGINT DEFAULT NULL,
    status VARCHAR(20) DEFAULT 'active',
    contact_person VARCHAR(100) DEFAULT NULL,
    contact_phone VARCHAR(20) DEFAULT NULL,
    description TEXT,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_dept_parent (parent_id),
    INDEX idx_dept_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 2. 用户表
-- ==========================================
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(11) NOT NULL UNIQUE COMMENT '11位数字用户名',
    phone VARCHAR(20) NOT NULL UNIQUE,
    password_hash VARCHAR(128) NOT NULL,
    phone_encrypted TEXT NOT NULL,
    phone_hash VARCHAR(64) NOT NULL,
    real_name VARCHAR(100),
    id_card_encrypted TEXT,
    id_card_hash VARCHAR(64),
    status VARCHAR(20) DEFAULT 'active',
    role VARCHAR(20) DEFAULT 'user',
    email VARCHAR(100),
    avatar_url VARCHAR(200),
    login_attempts INT DEFAULT 0,
    last_login_time TIMESTAMP NULL,
    last_login_ip VARCHAR(50),
    password_expire_time TIMESTAMP NULL,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    data_integrity VARCHAR(64) NOT NULL,
    
    INDEX idx_username (username),
    INDEX idx_phone_hash (phone_hash),
    INDEX idx_status (status),
    CONSTRAINT chk_username_format CHECK (username REGEXP '^[0-9]{11}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 3. 预约表
-- ==========================================
CREATE TABLE reservations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(11) DEFAULT NULL COMMENT '关联用户账号',
    reservation_type VARCHAR(20) NOT NULL DEFAULT 'public',
    campus VARCHAR(20) NOT NULL,
    visit_time TIMESTAMP NOT NULL,
    organization VARCHAR(100) DEFAULT NULL,
    name VARCHAR(50) NOT NULL,
    id_card_encrypted TEXT DEFAULT NULL,
    phone_encrypted TEXT DEFAULT NULL,
    id_card_hash VARCHAR(64) NOT NULL,
    phone_hash VARCHAR(64) NOT NULL,
    transportation VARCHAR(20) DEFAULT NULL,
    plate_number VARCHAR(20) DEFAULT NULL,
    visit_department_id BIGINT DEFAULT NULL,
    contact_person VARCHAR(50) DEFAULT NULL,
    visit_reason TEXT DEFAULT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    approver_id BIGINT DEFAULT NULL,
    approve_time TIMESTAMP NULL,
    approve_comment TEXT DEFAULT NULL,
    pass_code_encrypted TEXT DEFAULT NULL,
    pass_code_hash VARCHAR(64) DEFAULT NULL,
    pass_code_expire_time TIMESTAMP NULL,
    qr_code_data TEXT DEFAULT NULL,
    creator_id BIGINT DEFAULT NULL,
    visible_to_departments TEXT DEFAULT NULL,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    data_integrity VARCHAR(64) DEFAULT NULL,
    version INT DEFAULT 1,
    
    INDEX idx_username (username),
    INDEX idx_type (reservation_type),
    INDEX idx_campus (campus),
    INDEX idx_status (status),
    INDEX idx_visit_time (visit_time),
    INDEX idx_id_card_hash (id_card_hash),
    INDEX idx_phone_hash (phone_hash),
    INDEX idx_department (visit_department_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 4. 随行人员表
-- ==========================================
CREATE TABLE companions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    reservation_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    id_card_encrypted TEXT NOT NULL,
    phone_encrypted TEXT NOT NULL,
    id_card_hash VARCHAR(64) NOT NULL,
    phone_hash VARCHAR(64) NOT NULL,
    relationship VARCHAR(50) DEFAULT NULL,
    remark TEXT DEFAULT NULL,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_integrity VARCHAR(64) NOT NULL,
    
    INDEX idx_reservation_id (reservation_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 5. 用户会话表
-- ==========================================
CREATE TABLE user_sessions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    session_id VARCHAR(128) NOT NULL UNIQUE,
    username VARCHAR(11) NOT NULL,
    status VARCHAR(20) DEFAULT 'active',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expire_time TIMESTAMP NOT NULL,
    last_access_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    ip_address VARCHAR(50) NOT NULL,
    user_agent TEXT,
    device_info VARCHAR(200),
    is_suspicious BOOLEAN DEFAULT FALSE,
    
    INDEX idx_session_id (session_id),
    INDEX idx_username (username),
    INDEX idx_expire_time (expire_time),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 6. 操作日志表
-- ==========================================
CREATE TABLE operation_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    operation_type VARCHAR(50) NOT NULL,
    operation_module VARCHAR(50) NOT NULL,
    operation_description TEXT DEFAULT NULL,
    user_name VARCHAR(100) DEFAULT NULL,
    user_id_card_hash VARCHAR(64) DEFAULT NULL,
    user_phone_hash VARCHAR(64) DEFAULT NULL,
    ip_address VARCHAR(50) NOT NULL,
    user_agent TEXT DEFAULT NULL,
    device_info VARCHAR(200) DEFAULT NULL,
    session_id VARCHAR(128) DEFAULT NULL,
    target_table VARCHAR(50) DEFAULT NULL,
    target_record_id BIGINT DEFAULT NULL,
    operation_data TEXT DEFAULT NULL,
    data_before TEXT DEFAULT NULL,
    data_after TEXT DEFAULT NULL,
    operation_result VARCHAR(20) NOT NULL,
    error_message TEXT DEFAULT NULL,
    response_time INT DEFAULT NULL,
    risk_level VARCHAR(20) DEFAULT 'low',
    risk_factors TEXT DEFAULT NULL,
    operation_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    log_hash VARCHAR(64) NOT NULL,
    
    INDEX idx_time (operation_time),
    INDEX idx_type (operation_type),
    INDEX idx_user_id_card (user_id_card_hash),
    INDEX idx_ip (ip_address),
    INDEX idx_result (operation_result)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 7. 访问日志表
-- ==========================================
CREATE TABLE access_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    request_url VARCHAR(500) NOT NULL,
    request_method VARCHAR(10) NOT NULL,
    request_params TEXT DEFAULT NULL,
    request_headers TEXT DEFAULT NULL,
    user_name VARCHAR(100) DEFAULT NULL,
    user_id_card_hash VARCHAR(64) DEFAULT NULL,
    user_phone_hash VARCHAR(64) DEFAULT NULL,
    session_id VARCHAR(128) DEFAULT NULL,
    ip_address VARCHAR(50) NOT NULL,
    user_agent TEXT DEFAULT NULL,
    referer VARCHAR(500) DEFAULT NULL,
    response_status INT DEFAULT NULL,
    response_size INT DEFAULT NULL,
    response_time INT DEFAULT NULL,
    page_name VARCHAR(100) DEFAULT NULL,
    action_type VARCHAR(50) DEFAULT NULL,
    is_suspicious BOOLEAN DEFAULT FALSE,
    security_alerts TEXT DEFAULT NULL,
    access_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    log_hash VARCHAR(64) NOT NULL,
    
    INDEX idx_time (access_time),
    INDEX idx_url (request_url(255)),
    INDEX idx_user_id_card (user_id_card_hash),
    INDEX idx_ip (ip_address),
    INDEX idx_status (response_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 8. 数据访问日志表
-- ==========================================
CREATE TABLE data_access_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    record_id BIGINT DEFAULT NULL,
    access_type VARCHAR(20) NOT NULL,
    accessed_fields TEXT DEFAULT NULL,
    sensitive_data_accessed BOOLEAN DEFAULT FALSE,
    sensitive_fields TEXT DEFAULT NULL,
    encryption_status VARCHAR(20) DEFAULT NULL,
    user_name VARCHAR(100) DEFAULT NULL,
    user_id_card_hash VARCHAR(64) DEFAULT NULL,
    user_phone_hash VARCHAR(64) DEFAULT NULL,
    business_purpose VARCHAR(200) DEFAULT NULL,
    operation_context TEXT DEFAULT NULL,
    authorization_level VARCHAR(50) DEFAULT NULL,
    ip_address VARCHAR(50) DEFAULT NULL,
    old_values TEXT DEFAULT NULL,
    new_values TEXT DEFAULT NULL,
    compliance_status VARCHAR(20) DEFAULT 'compliant',
    compliance_notes TEXT DEFAULT NULL,
    access_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    log_hash VARCHAR(64) NOT NULL,
    
    INDEX idx_time (access_time),
    INDEX idx_table (table_name),
    INDEX idx_sensitive (sensitive_data_accessed),
    INDEX idx_user_id_card (user_id_card_hash)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 添加外键约束
-- ==========================================
SET FOREIGN_KEY_CHECKS = 1;

ALTER TABLE departments 
ADD CONSTRAINT fk_dept_parent 
FOREIGN KEY (parent_id) REFERENCES departments(id) ON DELETE SET NULL;

ALTER TABLE reservations 
ADD CONSTRAINT fk_reservation_username 
FOREIGN KEY (username) REFERENCES users(username) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE reservations 
ADD CONSTRAINT fk_reservation_department 
FOREIGN KEY (visit_department_id) REFERENCES departments(id) ON DELETE SET NULL;

ALTER TABLE companions 
ADD CONSTRAINT fk_companion_reservation 
FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE CASCADE;

ALTER TABLE user_sessions 
ADD CONSTRAINT fk_session_username 
FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE ON UPDATE CASCADE;

-- ==========================================
-- 插入基础数据
-- ==========================================
INSERT INTO departments (department_code, department_name, department_type, contact_person, contact_phone) VALUES
('ROOT', '根部门', '虚拟部门', '系统管理员', '000-0000'),
('ADMIN', '行政办公室', '行政部门', '办公室主任', '021-1001'),
('ACADEMIC', '教务处', '行政部门', '教务处长', '021-1002'),
('STUDENT', '学生处', '行政部门', '学生处长', '021-1003'),
('SECURITY', '保卫处', '行政部门', '保卫处长', '021-1004'),
('CS', '计算机学院', '学院', '计算机学院院长', '021-2001'),
('EE', '电子工程学院', '学院', '电子工程学院院长', '021-2002'),
('MATH', '数学学院', '学院', '数学学院院长', '021-2003');

INSERT INTO users (username, phone, password_hash, phone_encrypted, phone_hash, real_name, status, role, data_integrity) VALUES
('20241001001', '13800138000', '207cf410532f92a47dee245ce9b11ff71f578ebd763eb3bbea44ebd043d018fb', 'encrypted_phone_1', 'phone_hash_1', '张三', 'active', 'user', 'integrity_1'),
('20241001002', '13800138001', '207cf410532f92a47dee245ce9b11ff71f578ebd763eb3bbea44ebd043d018fb', 'encrypted_phone_2', 'phone_hash_2', '李四', 'active', 'user', 'integrity_2'),
('20241001003', '13800138002', 'c1b9e2b7a78fe93e8a33b90b2c6e0b6a3d4c5a8e7b9d2c3e4f5a6b7c8d9e0f1a2', 'encrypted_phone_3', 'phone_hash_3', '薛世卓', 'active', 'user', 'integrity_3'),
('20241001004', '13912345678', 'c1b9e2b7a78fe93e8a33b90b2c6e0b6a3d4c5a8e7b9d2c3e4f5a6b7c8d9e0f1a2', 'encrypted_phone_4', 'phone_hash_4', '王五', 'active', 'user', 'integrity_4'),
('20241001005', '15900000000', 'c1b9e2b7a78fe93e8a33b90b2c6e0b6a3d4c5a8e7b9d2c3e4f5a6b7c8d9e0f1a2', 'encrypted_phone_5', 'phone_hash_5', '赵六', 'active', 'user', 'integrity_5');
-- ==========================================
-- 创建存储过程
-- ==========================================
DELIMITER $$

CREATE PROCEDURE GetUserReservationsByUsername(
    IN p_username VARCHAR(11)
)
BEGIN
    SELECT 
        r.id,
        r.reservation_type,
        r.campus,
        r.visit_time,
        r.organization,
        r.name,
        r.status,
        r.create_time,
        d.department_name AS visit_department_name,
        u.real_name AS creator_real_name
    FROM reservations r
    LEFT JOIN departments d ON r.visit_department_id = d.id
    LEFT JOIN users u ON r.username = u.username
    WHERE r.username = p_username
    ORDER BY r.create_time DESC;
END$$

DELIMITER ;

-- ==========================================
-- 验证安装
-- ==========================================
SELECT '✅ 数据库创建完成！' AS status;
SELECT COUNT(*) AS user_count FROM users;
SELECT COUNT(*) AS department_count FROM departments;
