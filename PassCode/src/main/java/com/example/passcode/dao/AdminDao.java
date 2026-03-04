package com.example.passcode.dao;

import com.example.passcode.model.Admin;
import com.example.passcode.util.SM3Util;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class AdminDao extends BaseDao {

    public int addAdmin(Admin admin) {
        String sql = "INSERT INTO admins (admin_name, password_hash, real_name, email, phone, department_id, role, data_integrity) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();

            // 检查登录名是否已存在
            String checkSql = "SELECT COUNT(*) FROM admins WHERE admin_name = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setString(1, admin.getLoginName());
            rs = pstmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                return -1; // 登录名已存在
            }

            // 插入新管理员
            pstmt.close();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, admin.getLoginName());
            // 对密码进行SM3加密
            pstmt.setString(2, SM3Util.hash(admin.getPassword()));
            pstmt.setString(3, admin.getName());
            pstmt.setString(4, admin.getEmail());
            pstmt.setString(5, admin.getPhone());
            pstmt.setInt(6, admin.getDeptId());
            pstmt.setString(7, admin.getRole() != null ? admin.getRole() : "dept_admin");
            // 生成数据完整性校验值
            pstmt.setString(8, SM3Util.hash(admin.getLoginName() + admin.getName() + System.currentTimeMillis()));

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows == 0) {
                return 0; // 插入失败
            }

            // 获取生成的管理员ID
            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            } else {
                return 0;
            }

        } catch (SQLException e) {
            System.err.println("添加管理员时发生错误: " + e.getMessage());
            e.printStackTrace();
            return 0;
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }

    /**
     * 更新管理员信息(不包括密码)
     * @param admin 管理员对象
     * @return true表示更新成功，false表示更新失败
     */
    public boolean updateAdmin(Admin admin) {
        String sql = "UPDATE admins SET real_name = ?, department_id = ?, phone = ?, email = ?, role = ? WHERE admin_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, admin.getName());
            pstmt.setInt(2, admin.getDeptId());
            pstmt.setString(3, admin.getPhone());
            pstmt.setString(4, admin.getEmail());
            pstmt.setString(5, admin.getRole());
            pstmt.setInt(6, admin.getAdminId());

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("更新管理员信息时发生错误: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(pstmt, conn);
        }
    }

    /**
     * 更新管理员密码
     * @param adminId 管理员ID
     * @param newPassword 新密码
     * @return true表示更新成功，false表示更新失败
     */
    public boolean updateAdminPassword(int adminId, String newPassword) {
        String sql = "UPDATE admins SET password_hash = ? WHERE admin_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            // 对新密码进行SM3加密
            pstmt.setString(1, SM3Util.hash(newPassword));
            pstmt.setInt(2, adminId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("更新管理员密码时发生错误: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(pstmt, conn);
        }
    }

    /**
     * 删除管理员
     * @param adminId 管理员ID
     * @return true表示删除成功，false表示删除失败
     */
    public boolean deleteAdmin(int adminId) {
        String sql = "DELETE FROM admins WHERE admin_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, adminId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("删除管理员时发生错误: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(pstmt, conn);
        }
    }

    /**
     * 根据ID查询管理员
     * @param adminId 管理员ID
     * @return 管理员对象，若不存在返回null
     */
    public Admin getAdminById(int adminId) {
        String sql = "SELECT a.admin_id, a.admin_name, a.real_name, a.email, a.phone, " +
                    "a.department_id, a.role, a.status, a.last_login_time, a.create_time, " +
                    "d.department_name " +
                    "FROM admins a " +
                    "LEFT JOIN departments d ON a.department_id = d.id " +
                    "WHERE a.admin_id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, adminId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Admin admin = new Admin();
                admin.setAdminId(rs.getInt("admin_id"));
                admin.setLoginName(rs.getString("admin_name"));
                admin.setName(rs.getString("real_name"));
                admin.setEmail(rs.getString("email"));
                admin.setPhone(rs.getString("phone"));
                admin.setDeptId(rs.getInt("department_id"));
                admin.setDeptName(rs.getString("department_name"));
                admin.setRole(rs.getString("role"));
                admin.setStatus(rs.getString("status"));
                return admin;
            }

        } catch (SQLException e) {
            System.err.println("根据ID获取管理员信息时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return null;
    }

    /**
     * 管理员登录验证
     * @param loginName 登录名
     * @param password 密码
     * @return 管理员对象，验证失败返回null
     */
    public Admin login(String loginName, String password) {
        System.out.println("=== AdminDao.login() 开始 ===");
        System.out.println("输入参数 - 登录名: [" + loginName + "], 密码长度: " + password.length());

        String sql = "SELECT a.admin_id, a.admin_name, a.real_name, a.email, a.phone, a.department_id, a.role, a.status, a.password_hash, d.department_name " +
                "FROM admins a LEFT JOIN departments d ON a.department_id = d.id " +
                "WHERE a.admin_name = ? AND a.status = 'active'";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            System.out.println("✅ 数据库连接成功");

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, loginName);
            System.out.println("🔍 执行SQL: " + sql);
            System.out.println("🔍 查询参数: " + loginName);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                System.out.println("✅ 找到用户记录");
                System.out.println("用户ID: " + rs.getInt("admin_id"));
                System.out.println("用户姓名: " + rs.getString("real_name"));
                System.out.println("登录名: " + rs.getString("admin_name"));

                // 使用SM3加密比较密码
                String storedPasswordHash = rs.getString("password_hash");
                String inputPasswordHash = SM3Util.hash(password);
                System.out.println("数据库中的密码哈希: " + storedPasswordHash);
                System.out.println("输入密码的哈希: " + inputPasswordHash);
                System.out.println("密码比较结果: " + inputPasswordHash.equals(storedPasswordHash));

                if (inputPasswordHash.equals(storedPasswordHash)) {
                    System.out.println("✅ 密码验证成功，创建Admin对象");
                    Admin admin = new Admin();
                    admin.setAdminId(rs.getInt("admin_id"));
                    admin.setLoginName(rs.getString("admin_name"));
                    admin.setName(rs.getString("real_name"));
                    admin.setEmail(rs.getString("email"));
                    admin.setPhone(rs.getString("phone"));
                    admin.setDeptId(rs.getInt("department_id"));
                    admin.setRole(rs.getString("role"));
                    admin.setStatus(rs.getString("status"));
                    admin.setDeptName(rs.getString("department_name"));
                    System.out.println("=== AdminDao.login() 成功结束 ===");
                    return admin;
                } else {
                    System.out.println("❌ 密码验证失败");
                }
            } else {
                System.out.println("❌ 未找到用户记录");
                // 检查数据库中实际有什么数据
                System.out.println("🔍 检查数据库中的所有登录名:");
                String checkSql = "SELECT admin_name FROM admins";
                try (PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                     ResultSet checkRs = checkStmt.executeQuery()) {
                    while (checkRs.next()) {
                        System.out.println("  - " + checkRs.getString("admin_name"));
                    }
                }
            }
            System.out.println("=== AdminDao.login() 失败结束 ===");
            return null;

        } catch (SQLException e) {
            System.err.println("❌ 管理员登录验证时发生错误: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }
    /**
     * 获取所有管理员
     * @return 管理员列表
     */
    public List<Admin> getAllAdmins() {
        String sql = "SELECT a.admin_id, a.real_name, a.admin_name, a.email, a.phone, a.department_id, a.role, a.status, d.department_name " +
                "FROM admins a LEFT JOIN departments d ON a.department_id = d.id " +
                "ORDER BY a.admin_id";
        List<Admin> admins = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                Admin admin = new Admin();
                admin.setAdminId(rs.getInt("admin_id"));
                admin.setName(rs.getString("real_name"));
                admin.setLoginName(rs.getString("admin_name"));
                admin.setEmail(rs.getString("email"));
                admin.setPhone(rs.getString("phone"));
                admin.setDeptId(rs.getInt("department_id"));
                admin.setRole(rs.getString("role"));
                admin.setStatus(rs.getString("status"));
                admin.setDeptName(rs.getString("department_name"));
                admins.add(admin);
            }

        } catch (SQLException e) {
            System.err.println("获取所有管理员时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return admins;
    }

    /**
     * 根据部门ID查询管理员
     * @param deptId 部门ID
     * @return 管理员列表
     */
    public List<Admin> getAdminsByDepartment(int deptId) {
        String sql = "SELECT a.admin_id, a.real_name, a.admin_name, a.email, a.phone, a.department_id, a.role, a.status, d.department_name " +
                "FROM admins a LEFT JOIN departments d ON a.department_id = d.id " +
                "WHERE a.department_id = ? ORDER BY a.admin_id";
        List<Admin> admins = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, deptId);

            rs = pstmt.executeQuery();
            while (rs.next()) {
                Admin admin = new Admin();
                admin.setAdminId(rs.getInt("admin_id"));
                admin.setName(rs.getString("real_name"));
                admin.setLoginName(rs.getString("admin_name"));
                admin.setEmail(rs.getString("email"));
                admin.setPhone(rs.getString("phone"));
                admin.setDeptId(rs.getInt("department_id"));
                admin.setRole(rs.getString("role"));
                admin.setStatus(rs.getString("status"));
                admin.setDeptName(rs.getString("department_name"));
                admins.add(admin);
            }

        } catch (SQLException e) {
            System.err.println("按部门查询管理员时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return admins;
    }

    /**
     * 验证管理员登录
     * @param loginName 登录名
     * @param password 密码
     * @return 验证成功返回管理员对象，失败返回null
     */
    public Admin validateAdmin(String loginName, String password) {
        String sql = "SELECT a.admin_id, a.admin_name, a.real_name, a.email, a.phone, " +
                    "a.department_id, a.role, a.status, d.department_name " +
                    "FROM admins a " +
                    "LEFT JOIN departments d ON a.department_id = d.id " +
                    "WHERE a.admin_name = ? AND a.password_hash = ? AND a.status = 'active'";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, loginName);
            pstmt.setString(2, SM3Util.hash(password)); // 对输入密码进行SM3加密后比较
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Admin admin = new Admin();
                admin.setAdminId(rs.getInt("admin_id"));
                admin.setLoginName(rs.getString("admin_name"));
                admin.setName(rs.getString("real_name"));
                admin.setEmail(rs.getString("email"));
                admin.setPhone(rs.getString("phone"));
                admin.setDeptId(rs.getInt("department_id"));
                admin.setDeptName(rs.getString("department_name"));
                admin.setRole(rs.getString("role"));
                admin.setStatus(rs.getString("status"));
                return admin;
            }

        } catch (SQLException e) {
            System.err.println("验证管理员登录时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return null;
    }

    /**
     * 重置管理员密码
     * @param adminId 管理员ID
     * @param newPassword 新密码
     * @return 重置是否成功
     */
    public boolean resetPassword(int adminId, String newPassword) {
        String sql = "UPDATE admins SET password_hash = ?, update_time = CURRENT_TIMESTAMP WHERE admin_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, SM3Util.hash(newPassword));
            pstmt.setInt(2, adminId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("重置密码时发生错误: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, pstmt, conn);
        }
    }

    /**
     * 根据条件搜索管理员
     * @param keyword 关键词（姓名或登录名）
     * @param role 角色筛选
     * @param status 状态筛选
     * @return 管理员列表
     */
    public List<Admin> searchAdmins(String keyword, String role, String status) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT a.admin_id, a.admin_name, a.real_name, a.email, a.phone, ");
        sql.append("a.department_id, a.role, a.status, a.last_login_time, a.create_time, ");
        sql.append("d.department_name ");
        sql.append("FROM admins a ");
        sql.append("LEFT JOIN departments d ON a.department_id = d.id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // 添加关键词搜索条件
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (a.real_name LIKE ? OR a.admin_name LIKE ?) ");
            String likeKeyword = "%" + keyword.trim() + "%";
            params.add(likeKeyword);
            params.add(likeKeyword);
        }

        // 添加角色筛选条件
        if (role != null && !role.trim().isEmpty()) {
            sql.append("AND a.role = ? ");
            params.add(role);
        }

        // 添加状态筛选条件
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND a.status = ? ");
            params.add(status);
        }

        sql.append("ORDER BY a.create_time DESC");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Admin> admins = new ArrayList<>();

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql.toString());
            
            // 设置参数
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Admin admin = new Admin();
                admin.setAdminId(rs.getInt("admin_id"));
                admin.setLoginName(rs.getString("admin_name"));
                admin.setName(rs.getString("real_name"));
                admin.setEmail(rs.getString("email"));
                admin.setPhone(rs.getString("phone"));
                admin.setDeptId(rs.getInt("department_id"));
                admin.setDeptName(rs.getString("department_name"));
                admin.setRole(rs.getString("role"));
                admin.setStatus(rs.getString("status"));
                admins.add(admin);
            }

        } catch (SQLException e) {
            System.err.println("搜索管理员时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return admins;
    }

    /**
     * 分页查询所有管理员
     * @param page 页码（从1开始）
     * @param pageSize 每页大小
     * @return 管理员列表
     */
    public List<Admin> getAdminsByPage(int page, int pageSize) {
        List<Admin> admins = new ArrayList<>();
        String sql = "SELECT a.admin_id, a.admin_name, a.password_hash, a.real_name, a.email, a.phone, a.department_id, a.role, a.status, a.create_time, d.department_name " +
                     "FROM admins a LEFT JOIN departments d ON a.department_id = d.id " +
                     "ORDER BY a.create_time DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, pageSize);
            pstmt.setInt(2, (page - 1) * pageSize);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Admin admin = new Admin();
                    admin.setAdminId(rs.getInt("admin_id"));
                    admin.setLoginName(rs.getString("admin_name"));
                    admin.setName(rs.getString("real_name"));
                    admin.setEmail(rs.getString("email"));
                    admin.setPhone(rs.getString("phone"));
                    admin.setDeptId(rs.getInt("department_id"));
                    admin.setRole(rs.getString("role"));
                    admin.setStatus(rs.getString("status"));
                    admin.setDeptName(rs.getString("department_name"));
                    admins.add(admin);
                }
            }
        } catch (SQLException e) {
            System.err.println("分页查询管理员列表失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return admins;
    }
    
    /**
     * 获取管理员总数
     * @return 管理员总数
     */
    public int getTotalAdminCount() {
        String sql = "SELECT COUNT(*) FROM admins";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("获取管理员总数失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * 按关键词搜索管理员（分页）
     * @param keyword 搜索关键词
     * @param page 页码（从1开始）
     * @param pageSize 每页大小
     * @return 管理员列表
     */
    public List<Admin> searchAdminsByPage(String keyword, int page, int pageSize) {
        List<Admin> admins = new ArrayList<>();
        String sql = "SELECT a.admin_id, a.admin_name, a.password_hash, a.real_name, a.email, a.phone, a.department_id, a.role, a.status, a.create_time, d.department_name " +
                     "FROM admins a LEFT JOIN departments d ON a.department_id = d.id " +
                     "WHERE a.admin_name LIKE ? OR a.real_name LIKE ? OR a.email LIKE ? " +
                     "ORDER BY a.create_time DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            pstmt.setInt(4, pageSize);
            pstmt.setInt(5, (page - 1) * pageSize);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Admin admin = new Admin();
                    admin.setAdminId(rs.getInt("admin_id"));
                    admin.setLoginName(rs.getString("admin_name"));
                    admin.setName(rs.getString("real_name"));
                    admin.setEmail(rs.getString("email"));
                    admin.setPhone(rs.getString("phone"));
                    admin.setDeptId(rs.getInt("department_id"));
                    admin.setRole(rs.getString("role"));
                    admin.setStatus(rs.getString("status"));
                    admin.setDeptName(rs.getString("department_name"));
                    admins.add(admin);
                }
            }
        } catch (SQLException e) {
            System.err.println("分页搜索管理员失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return admins;
    }
    
    /**
     * 获取搜索结果总数
     * @param keyword 搜索关键词
     * @return 搜索结果总数
     */
    public int getSearchAdminCount(String keyword) {
        String sql = "SELECT COUNT(*) FROM admins WHERE admin_name LIKE ? OR real_name LIKE ? OR email LIKE ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("获取搜索结果总数失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }

    /**
     * 检查登录名是否已存在
     * @param loginName 登录名
     * @param excludeAdminId 排除的管理员ID（用于更新时检查）
     * @return true表示已存在，false表示不存在
     */
    public boolean isLoginNameExists(String loginName, int excludeAdminId) {
        String sql = "SELECT COUNT(*) FROM admins WHERE admin_name = ? AND admin_id != ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, loginName);
            pstmt.setInt(2, excludeAdminId);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.err.println("检查登录名时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return false;
    }

    /**
     * 获取活跃管理员数量
     * @return 活跃管理员数量
     */
    public int getActiveAdminCount() {
        String sql = "SELECT COUNT(*) FROM admins WHERE status = 'active'";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.err.println("获取活跃管理员数量时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return 0;
    }

    /**
     * 根据ID查找管理员
     * @param adminId 管理员ID
     * @return 管理员对象，未找到返回null
     */
    public Admin findById(int adminId) {
        String sql = "SELECT * FROM admins WHERE admin_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, adminId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToAdmin(rs);
            }

        } catch (SQLException e) {
            System.err.println("根据ID查找管理员时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return null;
    }

    /**
     * 根据登录名查找管理员
     * @param loginName 登录名
     * @return 管理员对象，未找到返回null
     */
    public Admin findByLoginName(String loginName) {
        String sql = "SELECT * FROM admins WHERE admin_name = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, loginName);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToAdmin(rs);
            }

        } catch (SQLException e) {
            System.err.println("根据登录名查找管理员时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return null;
    }

    /**
     * 查找所有管理员
     * @return 管理员列表
     */
    public List<Admin> findAll() {
        String sql = "SELECT * FROM admins ORDER BY admin_id DESC";
        List<Admin> admins = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                admins.add(mapResultSetToAdmin(rs));
            }

        } catch (SQLException e) {
            System.err.println("查找所有管理员时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return admins;
    }

    /**
     * 根据部门ID查找管理员
     * @param deptId 部门ID
     * @return 管理员列表
     */
    public List<Admin> findByDepartment(int deptId) {
        String sql = "SELECT * FROM admins WHERE department_id = ? ORDER BY admin_id DESC";
        List<Admin> admins = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, deptId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                admins.add(mapResultSetToAdmin(rs));
            }

        } catch (SQLException e) {
            System.err.println("根据部门查找管理员时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return admins;
    }

    /**
     * 根据角色查找管理员
     * @param role 角色
     * @return 管理员列表
     */
    public List<Admin> findByRole(String role) {
        String sql = "SELECT * FROM admins WHERE role = ? ORDER BY admin_id DESC";
        List<Admin> admins = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, role);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                admins.add(mapResultSetToAdmin(rs));
            }

        } catch (SQLException e) {
            System.err.println("根据角色查找管理员时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return admins;
    }

    /**
     * 更新密码
     * @param adminId 管理员ID
     * @param passwordHash 密码哈希
     * @return 更新是否成功
     */
    public boolean updatePassword(int adminId, String passwordHash) {
        String sql = "UPDATE admins SET password_hash = ? WHERE admin_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, passwordHash);
            pstmt.setInt(2, adminId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("更新密码时发生错误: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, pstmt, conn);
        }
    }

    /**
     * 更新状态
     * @param adminId 管理员ID
     * @param status 状态
     * @return 更新是否成功
     */
    public boolean updateStatus(int adminId, String status) {
        String sql = "UPDATE admins SET status = ? WHERE admin_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, adminId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("更新状态时发生错误: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, pstmt, conn);
        }
    }

    /**
     * 更新管理员状态
     * @param adminId 管理员ID
     * @param status 新状态
     * @return 更新是否成功
     */
    public boolean updateAdminStatus(int adminId, String status) {
        String sql = "UPDATE admins SET status = ?, update_time = CURRENT_TIMESTAMP WHERE admin_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, adminId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("更新管理员状态时发生错误: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, pstmt, conn);
        }
    }

    /**
     * 将ResultSet映射为Admin对象
     * @param rs ResultSet对象
     * @return Admin对象
     * @throws SQLException SQL异常
     */
    private Admin mapResultSetToAdmin(ResultSet rs) throws SQLException {
        Admin admin = new Admin();
        admin.setAdminId(rs.getInt("id"));
        admin.setLoginName(rs.getString("admin_name"));
        admin.setSm3(rs.getString("password_hash"));
        admin.setName(rs.getString("real_name"));
        admin.setEmail(rs.getString("email"));
        admin.setPhone(rs.getString("phone"));
        admin.setDeptId(rs.getInt("department_id"));
        admin.setRole(rs.getString("role"));
        admin.setStatus(rs.getString("status"));
        
        return admin;
    }
}