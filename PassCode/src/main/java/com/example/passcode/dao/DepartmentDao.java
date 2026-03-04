package com.example.passcode.dao;

import com.example.passcode.model.Department;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 部门数据访问对象
 * 提供部门相关的数据库操作方法
 */
public class DepartmentDao extends BaseDao {

    /**
     * 添加部门
     * @param department 部门对象
     * @return 返回生成的部门ID，-1表示部门名已存在，0表示插入失败
     */
    public int addDepartment(Department department) {
        // 适配新数据库结构：使用 department_name 和 department_type
        String sql = "INSERT INTO departments (department_name, department_type, department_code, status) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();

            // 检查部门名是否已存在
            String checkSql = "SELECT COUNT(*) FROM departments WHERE department_name = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setString(1, department.getDeptName());
            rs = pstmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                return -1; // 部门名已存在
            }

            // 插入新部门
            pstmt.close();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, department.getDeptName());
            pstmt.setString(2, department.getDeptType());
            // 自动生成部门代码
            pstmt.setString(3, generateDepartmentCode(department.getDeptName()));
            pstmt.setString(4, "active");

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows == 0) {
                return 0; // 插入失败
            }

            // 获取生成的部门ID
            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            } else {
                return 0;
            }

        } catch (SQLException e) {
            System.err.println("添加部门时发生错误: " + e.getMessage());
            e.printStackTrace();
            return 0;
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }

    /**
     * 更新部门信息
     * @param department 部门对象
     * @return true表示更新成功，false表示更新失败
     */
    public boolean updateDepartment(Department department) {
        // 适配新数据库结构
        String sql = "UPDATE departments SET department_name = ?, department_type = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();

            // 检查部门名是否已被其他部门使用
            String checkSql = "SELECT COUNT(*) FROM departments WHERE department_name = ? AND id != ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setString(1, department.getDeptName());
            pstmt.setInt(2, department.getDeptId());
            rs = pstmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                return false; // 部门名已存在
            }

            // 更新部门
            pstmt.close();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, department.getDeptName());
            pstmt.setString(2, department.getDeptType());
            pstmt.setInt(3, department.getDeptId());

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("更新部门时发生错误: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }

    /**
     * 删除部门
     * @param deptId 部门ID
     * @return true表示删除成功，false表示删除失败（该部门下有管理员时无法删除）
     */
    public boolean deleteDepartment(int deptId) {
        // 适配新数据库结构
        String sql = "DELETE FROM departments WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();

            // 检查该部门是否有管理员（检查admins表）
            String checkSql = "SELECT COUNT(*) FROM admins WHERE dept_id = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, deptId);
            rs = pstmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                return false; // 该部门有管理员，不能删除
            }

            // 检查该部门是否有预约记录
            pstmt.close();
            rs.close();
            String checkReservationSql = "SELECT COUNT(*) FROM reservations WHERE visit_department_id = ?";
            pstmt = conn.prepareStatement(checkReservationSql);
            pstmt.setInt(1, deptId);
            rs = pstmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                return false; // 该部门有预约记录，不能删除
            }

            // 删除部门
            pstmt.close();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, deptId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("删除部门时发生错误: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }

    /**
     * 更新部门状态
     * @param deptId 部门ID
     * @param status 新状态
     * @return 更新是否成功
     */
    public boolean updateDepartmentStatus(int deptId, String status) {
        String sql = "UPDATE departments SET status = ?, update_time = CURRENT_TIMESTAMP WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setLong(2, deptId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("更新部门状态时发生错误: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, pstmt, conn);
        }
    }

    /**
     * 根据ID获取部门信息（用于Ajax请求）
     * @param deptId 部门ID
     * @return 部门对象，如果不存在返回null
     */
    public Department getDepartmentById(int deptId) {
        String sql = "SELECT id, department_name, department_type, department_code, status, description, create_time FROM departments WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, deptId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Department department = new Department();
                department.setId(rs.getLong("id"));
                department.setDeptId(rs.getInt("id")); // 兼容旧字段
                department.setDeptName(rs.getString("department_name"));
                department.setDepartmentName(rs.getString("department_name"));
                department.setDeptType(rs.getString("department_type"));
                department.setDepartmentType(rs.getString("department_type"));
                department.setDepartmentCode(rs.getString("department_code"));
                department.setStatus(rs.getString("status"));
                department.setDescription(rs.getString("description"));
                department.setCreateTime(rs.getTimestamp("create_time"));
                return department;
            }

        } catch (SQLException e) {
            System.err.println("根据ID获取部门信息时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return null;
    }

    /**
     * 获取所有部门
     * @return 部门列表
     */
    public List<Department> getAllDepartments() {
        String sql = "SELECT id, department_code, department_name, department_type, status, description, create_time FROM departments ORDER BY id";
        List<Department> departments = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                Department department = new Department();
                // 设置新字段
                department.setId(rs.getLong("id"));
                department.setDepartmentCode(rs.getString("department_code"));
                department.setDepartmentName(rs.getString("department_name"));
                department.setDepartmentType(rs.getString("department_type"));
                department.setStatus(rs.getString("status"));
                department.setDescription(rs.getString("description"));
                department.setCreateTime(rs.getTimestamp("create_time"));
                
                // 设置兼容字段
                department.setDeptId(rs.getInt("id"));
                department.setDeptName(rs.getString("department_name"));
                department.setDeptType(rs.getString("department_type"));
                
                departments.add(department);
            }

        } catch (SQLException e) {
            System.err.println("获取所有部门时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return departments;
    }

    /**
     * 根据部门类型查询部门
     * @param deptType 部门类型
     * @return 部门列表
     */
    public List<Department> getDepartmentsByType(String deptType) {
        String sql = "SELECT id, department_name, department_type FROM departments WHERE department_type = ? ORDER BY id";
        List<Department> departments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, deptType);

            rs = pstmt.executeQuery();
            while (rs.next()) {
                Department department = new Department();
                department.setDeptId(rs.getInt("id"));
                department.setDeptName(rs.getString("department_name"));
                department.setDeptType(rs.getString("department_type"));
                departments.add(department);
            }

        } catch (SQLException e) {
            System.err.println("按类型查询部门时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return departments;
    }

    /**
     * 根据部门名称模糊查询
     * @param keyword 查询关键词
     * @return 部门列表
     */
    public List<Department> searchDepartments(String keyword) {
        String sql = "SELECT id, department_name, department_type FROM departments WHERE department_name LIKE ? ORDER BY id";
        List<Department> departments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");

            rs = pstmt.executeQuery();
            while (rs.next()) {
                Department department = new Department();
                department.setDeptId(rs.getInt("id"));
                department.setDeptName(rs.getString("department_name"));
                department.setDeptType(rs.getString("department_type"));
                departments.add(department);
            }

        } catch (SQLException e) {
            System.err.println("搜索部门时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return departments;
    }

    /**
     * 按部门名称和代码搜索部门
     * @param departmentName 部门名称
     * @param departmentCode 部门代码
     * @return 部门列表
     */
    public List<Department> searchDepartmentsByNameAndCode(String departmentName, String departmentCode) {
        StringBuilder sqlBuilder = new StringBuilder("SELECT id, department_name, department_type, department_code FROM departments WHERE 1=1");
        List<String> params = new ArrayList<>();
        
        if (departmentName != null && !departmentName.trim().isEmpty()) {
            sqlBuilder.append(" AND department_name LIKE ?");
            params.add("%" + departmentName.trim() + "%");
        }
        
        if (departmentCode != null && !departmentCode.trim().isEmpty()) {
            sqlBuilder.append(" AND department_code LIKE ?");
            params.add("%" + departmentCode.trim() + "%");
        }
        
        sqlBuilder.append(" ORDER BY id");
        
        List<Department> departments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sqlBuilder.toString());
            
            // 设置参数
            for (int i = 0; i < params.size(); i++) {
                pstmt.setString(i + 1, params.get(i));
            }

            rs = pstmt.executeQuery();
            while (rs.next()) {
                Department department = new Department();
                department.setDeptId(rs.getInt("id"));
                department.setDeptName(rs.getString("department_name"));
                department.setDeptType(rs.getString("department_type"));
                // 设置部门代码
                department.setDepartmentCode(rs.getString("department_code"));
                departments.add(department);
            }

        } catch (SQLException e) {
            System.err.println("按名称和代码搜索部门时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return departments;
    }

    /**
     * 统计部门总数
     * @return 部门数量
     */
    public int getDepartmentCount() {
        String sql = "SELECT COUNT(*) FROM departments";
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
            System.err.println("统计部门数量时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return 0;
    }

    /**
     * 生成部门代码
     * @param deptName 部门名称
     * @return 生成的部门代码
     */
    private String generateDepartmentCode(String deptName) {
        if (deptName == null || deptName.trim().isEmpty()) {
            return "DEPT_" + System.currentTimeMillis();
        }
        
        // 简单的代码生成逻辑：取部门名称的首字母 + 时间戳后4位
        StringBuilder code = new StringBuilder();
        for (char c : deptName.toCharArray()) {
            if (Character.isLetter(c)) {
                code.append(Character.toUpperCase(c));
                if (code.length() >= 3) break;
            }
        }
        
        if (code.length() == 0) {
            code.append("DEPT");
        }
        
        // 添加时间戳后4位确保唯一性
        String timestamp = String.valueOf(System.currentTimeMillis());
        code.append("_").append(timestamp.substring(timestamp.length() - 4));
        
        return code.toString();
    }

    /**
     * 获取活跃部门数量
     * @return 活跃部门数量
     */
    public int getActiveDepartmentCount() {
        String sql = "SELECT COUNT(*) FROM departments WHERE status = 'active'";
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
            System.err.println("获取活跃部门数量时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return 0;
    }

    /**
     * 根据ID查找部门
     * @param deptId 部门ID
     * @return 部门对象，未找到返回null
     */
    public Department findById(int deptId) {
        String sql = "SELECT * FROM departments WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, deptId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToDepartment(rs);
            }

        } catch (SQLException e) {
            System.err.println("根据ID查找部门时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return null;
    }

    /**
     * 根据部门名称查找部门
     * @param deptName 部门名称
     * @return 部门对象，未找到返回null
     */
    public Department findByName(String deptName) {
        String sql = "SELECT * FROM departments WHERE department_name = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, deptName);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToDepartment(rs);
            }

        } catch (SQLException e) {
            System.err.println("根据名称查找部门时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return null;
    }

    /**
     * 查找所有部门
     * @return 部门列表
     */
    public List<Department> findAll() {
        String sql = "SELECT * FROM departments ORDER BY id DESC";
        List<Department> departments = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                departments.add(mapResultSetToDepartment(rs));
            }

        } catch (SQLException e) {
            System.err.println("查找所有部门时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return departments;
    }

    /**
     * 根据部门类型查找部门
     * @param deptType 部门类型
     * @return 部门列表
     */
    public List<Department> findByType(String deptType) {
        String sql = "SELECT * FROM departments WHERE department_type = ? ORDER BY id DESC";
        List<Department> departments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, deptType);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                departments.add(mapResultSetToDepartment(rs));
            }

        } catch (SQLException e) {
            System.err.println("根据类型查找部门时发生错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }

        return departments;
    }

    /**
     * 删除部门
     * @param deptId 部门ID
     * @return 删除是否成功
     */
    public boolean delete(int deptId) {
        return deleteDepartment(deptId);
    }

    /**
     * 更新部门
     * @param department 部门对象
     * @return 更新是否成功
     */
    public boolean update(Department department) {
        return updateDepartment(department);
    }

    /**
     * 分页查询所有部门
     * @param page 页码（从1开始）
     * @param pageSize 每页大小
     * @return 部门列表
     */
    public List<Department> getDepartmentsByPage(int page, int pageSize) {
        List<Department> departments = new ArrayList<>();
        String sql = "SELECT id, department_name, department_type, department_code, status, create_time " +
                     "FROM departments ORDER BY create_time DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, pageSize);
            pstmt.setInt(2, (page - 1) * pageSize);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    departments.add(mapResultSetToDepartment(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("分页查询部门列表失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return departments;
    }
    
    /**
     * 获取部门总数
     * @return 部门总数
     */
    public int getTotalDepartmentCount() {
        String sql = "SELECT COUNT(*) FROM departments";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("获取部门总数失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * 按关键词搜索部门（分页）
     * @param keyword 搜索关键词
     * @param page 页码（从1开始）
     * @param pageSize 每页大小
     * @return 部门列表
     */
    public List<Department> searchDepartmentsByPage(String keyword, int page, int pageSize) {
        List<Department> departments = new ArrayList<>();
        String sql = "SELECT id, department_name, department_type, department_code, status, create_time " +
                     "FROM departments WHERE department_name LIKE ? OR department_code LIKE ? " +
                     "ORDER BY create_time DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setInt(3, pageSize);
            pstmt.setInt(4, (page - 1) * pageSize);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    departments.add(mapResultSetToDepartment(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("分页搜索部门失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return departments;
    }
    
    /**
     * 获取搜索结果总数
     * @param keyword 搜索关键词
     * @return 搜索结果总数
     */
    public int getSearchDepartmentCount(String keyword) {
        String sql = "SELECT COUNT(*) FROM departments WHERE department_name LIKE ? OR department_code LIKE ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            
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
     * 将ResultSet映射为Department对象
     * @param rs ResultSet对象
     * @return Department对象
     * @throws SQLException SQL异常
     */
    private Department mapResultSetToDepartment(ResultSet rs) throws SQLException {
        Department department = new Department();
        department.setDeptId(rs.getInt("id"));
        department.setDeptName(rs.getString("department_name"));
        department.setDeptType(rs.getString("department_type"));
        department.setDepartmentCode(rs.getString("department_code"));
        department.setStatus(rs.getString("status"));
        
        // 处理时间字段 - 使用Date类型
        Timestamp createTime = rs.getTimestamp("create_time");
        if (createTime != null) {
            department.setCreateTime(new java.util.Date(createTime.getTime()));
        }
        
        return department;
    }
}