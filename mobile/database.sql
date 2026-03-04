-- ==========================================
-- 手机端校园预约系统数据库表结构（修复版）
-- 包含：核心业务表 + 审计日志表
-- ==========================================

-- 删除所有表和视图（如果存在）
DROP VIEW IF EXISTS v_today_reservation_stats CASCADE;
DROP VIEW IF EXISTS v_reservation_overview CASCADE;
DROP TABLE IF EXISTS data_access_logs CASCADE;
DROP TABLE IF EXISTS access_logs CASCADE;
DROP TABLE IF EXISTS operation_logs CASCADE;
DROP TABLE IF EXISTS companions CASCADE;
DROP TABLE IF EXISTS reservations CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

-- ==========================================
-- 1. 部门表
-- ==========================================
CREATE TABLE departments (
    id BIGSERIAL PRIMARY KEY,
    department_code VARCHAR(50) UNIQUE NOT NULL,
    department_name VARCHAR(200) NOT NULL,
    department_type VARCHAR(50) NOT NULL,          -- 部门类型：行政部门、学院等
    parent_id BIGINT,                             -- 上级部门ID（支持层级结构）
    status VARCHAR(20) DEFAULT 'active',          -- active, inactive
    contact_person VARCHAR(100),                  -- 联系人
    contact_phone VARCHAR(20),                    -- 联系电话
    description TEXT,                             -- 部门描述
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (parent_id) REFERENCES departments(id)
);

-- ==========================================
-- 2. 预约表（核心业务表）
-- ==========================================
CREATE TABLE reservations (
    id BIGSERIAL PRIMARY KEY,
    
    -- 基本预约信息
    reservation_type VARCHAR(20) NOT NULL DEFAULT 'public',
    campus VARCHAR(20) NOT NULL,
    visit_time TIMESTAMP NOT NULL,
    organization VARCHAR(100),
    name VARCHAR(50) NOT NULL,
    
    -- 加密存储的敏感数据
    id_card_encrypted TEXT,
    phone_encrypted TEXT,
    id_card_hash VARCHAR(64) NOT NULL,
    phone_hash VARCHAR(64) NOT NULL,
    
    -- 交通信息
    transportation VARCHAR(20),
    plate_number VARCHAR(20),
    
    -- 公务预约字段
    visit_department_id BIGINT,
    contact_person VARCHAR(50),
    visit_reason TEXT,
    
    -- 审核状态
    status VARCHAR(20) DEFAULT 'pending',
    approver_id BIGINT,
    approve_time TIMESTAMP,
    approve_comment TEXT,
    
    -- 通行码相关
    pass_code_encrypted TEXT,
    pass_code_hash VARCHAR(64),
    pass_code_expire_time TIMESTAMP,
    qr_code_data TEXT,
    
    -- 权限控制
    creator_id BIGINT,
    visible_to_departments TEXT,
    
    -- 时间戳
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 数据完整性
    data_integrity VARCHAR(64),
    version INTEGER DEFAULT 1,
    
    -- 外键约束
    FOREIGN KEY (visit_department_id) REFERENCES departments(id)
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_reservations_type ON reservations(reservation_type);
CREATE INDEX IF NOT EXISTS idx_reservations_campus ON reservations(campus);
CREATE INDEX IF NOT EXISTS idx_reservations_status ON reservations(status);
CREATE INDEX IF NOT EXISTS idx_reservations_visit_time ON reservations(visit_time);
CREATE INDEX IF NOT EXISTS idx_reservations_id_card_hash ON reservations(id_card_hash);
CREATE INDEX IF NOT EXISTS idx_reservations_phone_hash ON reservations(phone_hash);
CREATE INDEX IF NOT EXISTS idx_reservations_create_time ON reservations(create_time);
CREATE INDEX IF NOT EXISTS idx_reservations_name ON reservations(name);

-- ==========================================
-- 3. 随行人员表
-- ==========================================
CREATE TABLE companions (
    id BIGSERIAL PRIMARY KEY,
    reservation_id BIGINT NOT NULL,              -- 关联预约ID
    name VARCHAR(100) NOT NULL,                  -- 随行人员姓名
    
    -- 敏感数据加密存储
    id_card_encrypted TEXT NOT NULL,             -- SM4加密的身份证号
    phone_encrypted TEXT NOT NULL,               -- SM4加密的手机号
    id_card_hash VARCHAR(64) NOT NULL,           -- SM3哈希值
    phone_hash VARCHAR(64) NOT NULL,             -- SM3哈希值
    
    -- 关系说明
    relationship VARCHAR(50),                    -- 与主预约人的关系
    remark TEXT,                                 -- 备注信息
    
    -- 时间戳
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 数据完整性保护
    data_integrity VARCHAR(64) NOT NULL,         -- 数据完整性校验值
    
    -- 外键约束（级联删除）
    FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE CASCADE
);

-- ==========================================
-- 4. 操作日志表（审计用）
-- ==========================================
CREATE TABLE operation_logs (
    id BIGSERIAL PRIMARY KEY,
    
    -- 操作基本信息
    operation_type VARCHAR(50) NOT NULL,         -- 操作类型：create_reservation, view_reservation, generate_qrcode, query_reservation等
    operation_module VARCHAR(50) NOT NULL,       -- 操作模块：reservation, qrcode, query, companion
    operation_description TEXT,                  -- 操作描述
    
    -- 用户信息（手机端用户）
    user_name VARCHAR(100),                      -- 用户姓名
    user_id_card_hash VARCHAR(64),               -- 用户身份证哈希（用于关联和查询）
    user_phone_hash VARCHAR(64),                -- 用户手机号哈希（用于关联和查询）
    
    -- 网络和设备信息
    ip_address VARCHAR(50) NOT NULL,             -- 客户端IP地址
    user_agent TEXT,                             -- 浏览器UserAgent
    device_info VARCHAR(200),                    -- 设备信息
    session_id VARCHAR(128),                     -- 会话ID（如果有）
    
    -- 业务数据（敏感信息已脱敏）
    target_table VARCHAR(50),                    -- 涉及的数据表名
    target_record_id BIGINT,                     -- 涉及的记录ID
    operation_data TEXT,                         -- 操作数据（脱敏后）
    data_before TEXT,                            -- 操作前数据（脱敏后）
    data_after TEXT,                             -- 操作后数据（脱敏后）
    
    -- 操作结果
    operation_result VARCHAR(20) NOT NULL,       -- success=成功, failure=失败, error=错误
    error_message TEXT,                          -- 错误信息
    response_time INTEGER,                       -- 响应时间（毫秒）
    
    -- 风险评估
    risk_level VARCHAR(20) DEFAULT 'low',        -- low=低风险, medium=中风险, high=高风险
    risk_factors TEXT,                           -- 风险因素描述
    
    -- 时间信息
    operation_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 审计完整性保护
    log_hash VARCHAR(64) NOT NULL                -- 日志完整性校验（SM3哈希）
);

-- ==========================================
-- 5. 访问日志表（页面访问审计）
-- ==========================================
CREATE TABLE access_logs (
    id BIGSERIAL PRIMARY KEY,
    
    -- HTTP请求信息
    request_url VARCHAR(500) NOT NULL,           -- 请求URL
    request_method VARCHAR(10) NOT NULL,         -- HTTP方法：GET, POST, PUT, DELETE
    request_params TEXT,                         -- 请求参数（敏感参数已脱敏）
    request_headers TEXT,                        -- 重要请求头信息
    
    -- 用户信息
    user_name VARCHAR(100),                      -- 用户姓名
    user_id_card_hash VARCHAR(64),               -- 身份证哈希
    user_phone_hash VARCHAR(64),                -- 手机号哈希
    session_id VARCHAR(128),                     -- 会话ID
    
    -- 网络信息
    ip_address VARCHAR(50) NOT NULL,             -- 客户端IP
    user_agent TEXT,                             -- 浏览器信息
    referer VARCHAR(500),                        -- 来源页面
    
    -- 响应信息
    response_status INTEGER,                     -- HTTP状态码
    response_size INTEGER,                       -- 响应大小（字节）
    response_time INTEGER,                       -- 响应时间（毫秒）
    
    -- 业务上下文
    page_name VARCHAR(100),                      -- 页面名称
    action_type VARCHAR(50),                     -- 动作类型：view, submit, query等
    
    -- 安全相关
    is_suspicious BOOLEAN DEFAULT FALSE,         -- 是否可疑访问
    security_alerts TEXT,                        -- 安全告警信息
    
    -- 时间信息
    access_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 审计完整性
    log_hash VARCHAR(64) NOT NULL                -- 日志哈希值
);

-- ==========================================
-- 6. 数据访问日志表（敏感数据访问审计）
-- ==========================================
CREATE TABLE data_access_logs (
    id BIGSERIAL PRIMARY KEY,
    
    -- 数据访问信息
    table_name VARCHAR(50) NOT NULL,             -- 访问的表名
    record_id BIGINT,                            -- 访问的记录ID
    access_type VARCHAR(20) NOT NULL,            -- 访问类型：select, insert, update, delete
    accessed_fields TEXT,                        -- 访问的字段列表
    
    -- 敏感数据标记
    sensitive_data_accessed BOOLEAN DEFAULT FALSE, -- 是否访问了敏感数据
    sensitive_fields TEXT,                       -- 访问的敏感字段列表
    encryption_status VARCHAR(20),               -- 加密状态：encrypted, decrypted, plaintext
    
    -- 用户信息
    user_name VARCHAR(100),                      -- 操作用户姓名
    user_id_card_hash VARCHAR(64),               -- 用户身份证哈希
    user_phone_hash VARCHAR(64),                -- 用户手机号哈希
    
    -- 业务上下文
    business_purpose VARCHAR(200),               -- 访问目的：预约创建、信息查询、通行码生成等
    operation_context TEXT,                     -- 操作上下文描述
    authorization_level VARCHAR(50),            -- 授权级别
    
    -- 网络信息
    ip_address VARCHAR(50),                      -- 访问IP
    
    -- 数据变更（仅对update/delete记录）
    old_values TEXT,                            -- 修改前的值（脱敏）
    new_values TEXT,                            -- 修改后的值（脱敏）
    
    -- 合规性标记
    compliance_status VARCHAR(20) DEFAULT 'compliant', -- compliant=合规, violation=违规, review=待审查
    compliance_notes TEXT,                      -- 合规性说明
    
    -- 时间信息
    access_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 审计完整性
    log_hash VARCHAR(64) NOT NULL               -- 数据访问日志的完整性哈希
);

-- ==========================================
-- 创建索引（提高查询性能）
-- ==========================================

-- 预约表索引
CREATE INDEX IF NOT EXISTS idx_reservations_name ON reservations(name);
CREATE INDEX IF NOT EXISTS idx_reservations_id_card_hash ON reservations(id_card_hash);
CREATE INDEX IF NOT EXISTS idx_reservations_phone_hash ON reservations(phone_hash);
CREATE INDEX IF NOT EXISTS idx_reservations_status ON reservations(status);
CREATE INDEX IF NOT EXISTS idx_reservations_create_time ON reservations(create_time);
CREATE INDEX IF NOT EXISTS idx_reservations_visit_time ON reservations(visit_time);
CREATE INDEX IF NOT EXISTS idx_reservations_campus ON reservations(campus);
CREATE INDEX IF NOT EXISTS idx_reservations_type ON reservations(reservation_type);

-- 随行人员表索引
CREATE INDEX IF NOT EXISTS idx_companions_reservation_id ON companions(reservation_id);
CREATE INDEX IF NOT EXISTS idx_companions_id_card_hash ON companions(id_card_hash);
CREATE INDEX IF NOT EXISTS idx_companions_phone_hash ON companions(phone_hash);

-- 部门表索引
CREATE INDEX IF NOT EXISTS idx_departments_status ON departments(status);
CREATE INDEX IF NOT EXISTS idx_departments_type ON departments(department_type);
CREATE INDEX IF NOT EXISTS idx_departments_code ON departments(department_code);

-- 操作日志索引
CREATE INDEX IF NOT EXISTS idx_operation_logs_time ON operation_logs(operation_time);
CREATE INDEX IF NOT EXISTS idx_operation_logs_type ON operation_logs(operation_type);
CREATE INDEX IF NOT EXISTS idx_operation_logs_user_id_card ON operation_logs(user_id_card_hash);
CREATE INDEX IF NOT EXISTS idx_operation_logs_user_phone ON operation_logs(user_phone_hash);
CREATE INDEX IF NOT EXISTS idx_operation_logs_ip ON operation_logs(ip_address);
CREATE INDEX IF NOT EXISTS idx_operation_logs_result ON operation_logs(operation_result);

-- 访问日志索引
CREATE INDEX IF NOT EXISTS idx_access_logs_time ON access_logs(access_time);
CREATE INDEX IF NOT EXISTS idx_access_logs_url ON access_logs(request_url);
CREATE INDEX IF NOT EXISTS idx_access_logs_user_id_card ON access_logs(user_id_card_hash);
CREATE INDEX IF NOT EXISTS idx_access_logs_ip ON access_logs(ip_address);
CREATE INDEX IF NOT EXISTS idx_access_logs_status ON access_logs(response_status);

-- 数据访问日志索引
CREATE INDEX IF NOT EXISTS idx_data_access_time ON data_access_logs(access_time);
CREATE INDEX IF NOT EXISTS idx_data_access_table ON data_access_logs(table_name);
CREATE INDEX IF NOT EXISTS idx_data_access_sensitive ON data_access_logs(sensitive_data_accessed);
CREATE INDEX IF NOT EXISTS idx_data_access_user_id_card ON data_access_logs(user_id_card_hash);
CREATE INDEX IF NOT EXISTS idx_data_access_compliance ON data_access_logs(compliance_status);

-- ==========================================
-- 插入基础数据
-- ==========================================

-- 插入部门基础数据
INSERT INTO departments (department_code, department_name, department_type, contact_person, contact_phone) VALUES
('ROOT', '根部门', '虚拟部门', '系统管理员', '000-0000'),
('ADMIN', '行政办公室', '行政部门', '办公室主任', '021-1001'),
('ACADEMIC', '教务处', '行政部门', '教务处长', '021-1002'),
('STUDENT', '学生处', '行政部门', '学生处长', '021-1003'),
('SECURITY', '保卫处', '行政部门', '保卫处长', '021-1004'),
('FINANCE', '财务处', '行政部门', '财务处长', '021-1005'),
('HR', '人事处', '行政部门', '人事处长', '021-1006'),
('CS', '计算机学院', '学院', '计算机学院院长', '021-2001'),
('EE', '电子工程学院', '学院', '电子工程学院院长', '021-2002'),
('MATH', '数学学院', '学院', '数学学院院长', '021-2003'),
('PHYSICS', '物理学院', '学院', '物理学院院长', '021-2004'),
('CHEMISTRY', '化学学院', '学院', '化学学院院长', '021-2005'),
('BIOLOGY', '生物学院', '学院', '生物学院院长', '021-2006'),
('LITERATURE', '文学院', '学院', '文学院院长', '021-2007'),
('LAW', '法学院', '学院', '法学院院长', '021-2008'),
('BUSINESS', '商学院', '学院', '商学院院长', '021-2009'),
('MEDICINE', '医学院', '学院', '医学院院长', '021-2010');

-- ==========================================
-- 创建视图（便于查询）- PostgreSQL兼容版
-- ==========================================

-- 删除现有视图
DROP VIEW IF EXISTS v_today_reservation_stats CASCADE;
DROP VIEW IF EXISTS v_reservation_overview CASCADE;

-- 预约概览视图（脱敏显示）
CREATE OR REPLACE VIEW v_reservation_overview AS
SELECT 
    r.id,
    r.reservation_type,
    r.campus,
    r.visit_time,
    r.organization,
    r.name,
    -- 脱敏显示身份证和手机号
    CONCAT(SUBSTRING(r.name, 1, 1), '**') AS masked_name,
    'ID:****' AS masked_id_card,
    'PHONE:****' AS masked_phone,
    r.transportation,
    r.plate_number,
    d.department_name AS visit_department_name,
    r.contact_person,
    r.status,
    r.create_time,
    r.pass_code_expire_time,
    CASE 
        WHEN r.pass_code_expire_time > NOW() AND r.status = 'approved' THEN '有效'
        WHEN r.status = 'approved' THEN '已过期'
        WHEN r.status = 'pending' THEN '待审核'
        ELSE '无效'
    END AS pass_code_status
FROM reservations r
LEFT JOIN departments d ON r.visit_department_id = d.id;

-- 今日预约统计视图（PostgreSQL兼容版）
CREATE OR REPLACE VIEW v_today_reservation_stats AS
SELECT 
    campus,
    reservation_type,
    status,
    COUNT(*) AS count
FROM reservations 
WHERE create_time::DATE = CURRENT_DATE    -- 修复：使用PostgreSQL语法
GROUP BY campus, reservation_type, status;

-- 额外创建一些实用的视图

-- 本周预约统计视图
CREATE OR REPLACE VIEW v_week_reservation_stats AS
SELECT 
    campus,
    reservation_type,
    status,
    COUNT(*) AS count,
    DATE_TRUNC('week', create_time) AS week_start
FROM reservations 
WHERE create_time >= DATE_TRUNC('week', CURRENT_DATE)
GROUP BY campus, reservation_type, status, DATE_TRUNC('week', create_time);

-- 各部门预约统计视图
CREATE OR REPLACE VIEW v_department_reservation_stats AS
SELECT 
    d.department_name,
    d.department_code,
    COUNT(*) AS total_reservations,
    COUNT(CASE WHEN r.status = 'approved' THEN 1 END) AS approved_count,
    COUNT(CASE WHEN r.status = 'pending' THEN 1 END) AS pending_count,
    COUNT(CASE WHEN r.status = 'rejected' THEN 1 END) AS rejected_count
FROM departments d
LEFT JOIN reservations r ON d.id = r.visit_department_id
WHERE d.status = 'active'
GROUP BY d.id, d.department_name, d.department_code
ORDER BY total_reservations DESC;

-- ==========================================
-- 数据保留策略（日志清理）
-- ==========================================

-- 创建日志清理函数（保留6个月的日志）
DROP FUNCTION IF EXISTS clean_old_logs();

CREATE OR REPLACE FUNCTION clean_old_logs() RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER := 0;
    temp_count INTEGER := 0;
    cutoff_date TIMESTAMP;
BEGIN
    -- 计算6个月前的日期
    cutoff_date := NOW() - INTERVAL '6 months';
    
    -- 清理操作日志
    DELETE FROM operation_logs WHERE operation_time < cutoff_date;
    GET DIAGNOSTICS temp_count = ROW_COUNT;
    deleted_count := deleted_count + temp_count;
    
    -- 清理访问日志
    DELETE FROM access_logs WHERE access_time < cutoff_date;
    GET DIAGNOSTICS temp_count = ROW_COUNT;
    deleted_count := deleted_count + temp_count;
    
    -- 清理数据访问日志
    DELETE FROM data_access_logs WHERE access_time < cutoff_date;
    GET DIAGNOSTICS temp_count = ROW_COUNT;
    deleted_count := deleted_count + temp_count;
    
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- 创建定期清理任务提醒注释
-- 建议在crontab中设置定期执行：SELECT clean_old_logs();

COMMENT ON FUNCTION clean_old_logs() IS '清理6个月前的审计日志，符合等保三级要求';

-- ==========================================
-- 表注释
-- ==========================================

COMMENT ON TABLE departments IS '部门信息表 - 存储学校各部门信息，用于公务预约时选择访问部门';
COMMENT ON TABLE reservations IS '预约信息表 - 核心业务表，存储所有预约信息，敏感数据SM4加密存储';
COMMENT ON TABLE companions IS '随行人员表 - 存储预约的随行人员信息，关联预约表';
COMMENT ON TABLE operation_logs IS '操作日志表 - 记录用户所有重要操作，满足等保三级审计要求';
COMMENT ON TABLE access_logs IS '访问日志表 - 记录页面访问情况，用于安全审计';
COMMENT ON TABLE data_access_logs IS '数据访问日志表 - 记录敏感数据访问情况，确保数据安全';

-- ==========================================
-- 完成提示
-- ==========================================

-- 数据库表创建完成
SELECT 'Hand-mobile campus reservation system database setup completed!' AS status;
SELECT 'Tables created: departments, reservations, companions, operation_logs, access_logs, data_access_logs' AS tables;
SELECT 'Indexes and views created successfully' AS indexes;
SELECT 'Basic department data inserted' AS data;
SELECT 'Ready for mobile reservation system!' AS ready;