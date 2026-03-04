package com.example.demo.dao;

import com.example.demo.model.Department;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 部门数据访问类
 */
public class DepartmentDao extends BaseDao {
    
    /**
     * 获取所有活跃部门
     */
    public List<Department> findAllActive() throws SQLException {
        String sql = "SELECT * FROM departments WHERE status = 'active' ORDER BY department_type, department_name";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Department> departments = new ArrayList<>();
        
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                departments.add(mapResultSetToDepartment(rs));
            }
            
            return departments;
            
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }
    
    /**
     * 根据ID查找部门
     */
    public Department findById(Long id) throws SQLException {
        String sql = "SELECT * FROM departments WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, id);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToDepartment(rs);
            }
            return null;
            
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }
    
    /**
     * 根据部门代码查找部门
     */
    public Department findByCode(String departmentCode) throws SQLException {
        String sql = "SELECT * FROM departments WHERE department_code = ? AND status = 'active'";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, departmentCode);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToDepartment(rs);
            }
            return null;
            
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }
    
    /**
     * 根据类型获取部门列表
     */
    public List<Department> findByType(String departmentType) throws SQLException {
        String sql = "SELECT * FROM departments WHERE department_type = ? AND status = 'active' ORDER BY department_name";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Department> departments = new ArrayList<>();
        
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, departmentType);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                departments.add(mapResultSetToDepartment(rs));
            }
            
            return departments;
            
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }
    
    /**
     * 获取学院列表（用于公务预约）
     */
    public List<Department> findColleges() throws SQLException {
        return findByType("学院");
    }
    
    /**
     * 获取行政部门列表（用于公务预约）
     */
    public List<Department> findAdministrativeDepartments() throws SQLException {
        return findByType("行政部门");
    }
    
    /**
     * 添加新部门
     */
    public Long insert(Department department) throws SQLException {
        String sql = "INSERT INTO departments (department_code, department_name, department_type, " +
                    "parent_id, status, contact_person, contact_phone, description, create_time, update_time) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        return executeUpdateWithGeneratedKey(sql,
            department.getDepartmentCode(),
            department.getDepartmentName(),
            department.getDepartmentType(),
            department.getParentId(),
            department.getStatus(),
            department.getContactPerson(),
            department.getContactPhone(),
            department.getDescription(),
            department.getCreateTime(),
            department.getUpdateTime()
        );
    }
    
    /**
     * 更新部门信息
     */
    public int update(Department department) throws SQLException {
        String sql = "UPDATE departments SET department_name = ?, department_type = ?, " +
                    "parent_id = ?, status = ?, contact_person = ?, contact_phone = ?, " +
                    "description = ?, update_time = ? WHERE id = ?";
        
        return executeUpdate(sql,
            department.getDepartmentName(),
            department.getDepartmentType(),
            department.getParentId(),
            department.getStatus(),
            department.getContactPerson(),
            department.getContactPhone(),
            department.getDescription(),
            new java.util.Date(),
            department.getId()
        );
    }
    
    /**
     * 删除部门（软删除）
     */
    public int delete(Long id) throws SQLException {
        String sql = "UPDATE departments SET status = 'inactive', update_time = ? WHERE id = ?";
        return executeUpdate(sql, new java.util.Date(), id);
    }
    
    /**
     * 将ResultSet映射为Department对象
     */
    private Department mapResultSetToDepartment(ResultSet rs) throws SQLException {
        Department department = new Department();
        department.setId(rs.getLong("id"));
        department.setDepartmentCode(rs.getString("department_code"));
        department.setDepartmentName(rs.getString("department_name"));
        department.setDepartmentType(rs.getString("department_type"));
        
        Long parentId = rs.getLong("parent_id");
        if (!rs.wasNull()) {
            department.setParentId(parentId);
        }
        
        department.setStatus(rs.getString("status"));
        department.setContactPerson(rs.getString("contact_person"));
        department.setContactPhone(rs.getString("contact_phone"));
        department.setDescription(rs.getString("description"));
        
        Timestamp createTime = rs.getTimestamp("create_time");
        if (createTime != null) {
            department.setCreateTime(new java.util.Date(createTime.getTime()));
        }
        
        Timestamp updateTime = rs.getTimestamp("update_time");
        if (updateTime != null) {
            department.setUpdateTime(new java.util.Date(updateTime.getTime()));
        }
        
        return department;
    }
}