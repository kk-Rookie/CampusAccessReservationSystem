<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="部门管理" />
<%@ include file="../../common/header.jsp" %>

<div class="page-content">
    <div class="content-header">
        <h2><i class="bi bi-building me-2"></i>部门管理</h2>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/admin/department/add" class="btn-gradient-primary">
                <i class="bi bi-plus-lg me-2"></i>添加部门
            </a>
        </div>
    </div>

    <!-- 搜索筛选器 -->
    <div class="card-custom mb-4">
        <div class="card-header-custom">
            <h5 class="mb-0">
                <i class="bi bi-search me-2"></i>搜索部门
            </h5>
        </div>
        <div class="card-body-custom">
            <form method="get" action="${pageContext.request.contextPath}/admin/department/list">
                <div class="row">
                    <div class="col-md-4">
                        <label class="form-label">部门名称</label>
                        <input type="text" class="form-control dark-input" name="departmentName" value="${param.departmentName != null ? param.departmentName : ''}" placeholder="请输入部门名称">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">部门代码</label>
                        <input type="text" class="form-control dark-input" name="departmentCode" value="${param.departmentCode != null ? param.departmentCode : ''}" placeholder="请输入部门代码">
                    </div>
                    <div class="col-md-4 d-flex align-items-end">
                        <button type="submit" class="btn-gradient-primary w-100">
                            <i class="bi bi-search me-2"></i>搜索
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- 统计信息 -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="stats-card gradient-primary">
                <div class="stats-icon">
                    <i class="bi bi-building"></i>
                </div>
                <div class="stats-content">
                    <div class="stats-number">${totalDepartments}</div>
                    <div class="stats-label">总部门数</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stats-card gradient-success">
                <div class="stats-icon">
                    <i class="bi bi-check-circle"></i>
                </div>
                <div class="stats-content">
                    <div class="stats-number">${activeDepartments}</div>
                    <div class="stats-label">活跃部门</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stats-card gradient-info">
                <div class="stats-icon">
                    <i class="bi bi-people"></i>
                </div>
                <div class="stats-content">
                    <div class="stats-number">${totalMembers}</div>
                    <div class="stats-label">总人数</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stats-card gradient-warning">
                <div class="stats-icon">
                    <i class="bi bi-calendar-check"></i>
                </div>
                <div class="stats-content">
                    <div class="stats-number">${monthlyReservations}</div>
                    <div class="stats-label">本月预约</div>
                </div>
            </div>
        </div>
    </div>

    <!-- 部门列表 -->
    <div class="card-custom">
        <div class="card-header-custom">
            <h5 class="mb-0">
                <i class="bi bi-list-ul me-2"></i>部门列表
            </h5>
        </div>
        <div class="card-body-custom p-0">
            <c:choose>
                <c:when test="${not empty departments}">
                    <div class="table-responsive">
                        <table class="table-custom">
                            <thead>
                                <tr>
                                    <th>部门ID</th>
                                    <th>部门名称</th>
                                    <th>部门代码</th>
                                    <th>描述</th>
                                    <th>创建时间</th>
                                    <th>状态</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="department" items="${departments}">
                                    <tr>
                                        <td>
                                            <span class="font-monospace text-primary">
                                                #${department.departmentId}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="department-info">
                                                <div class="fw-bold">${department.departmentName}</div>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge-outline">
                                                ${department.departmentCode}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="description-text">
                                                <c:choose>
                                                    <c:when test="${not empty department.description}">
                                                        ${department.description}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-light-muted">暂无描述</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="datetime-info">
                                                <c:if test="${not empty department.createTime}">
                                                    <div>
                                                        <fmt:formatDate value="${department.createTime}" pattern="yyyy-MM-dd" />
                                                    </div>
                                                    <div class="text-light-muted small">
                                                        <fmt:formatDate value="${department.createTime}" pattern="HH:mm" />
                                                    </div>
                                                </c:if>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${department.status == 'ACTIVE'}">
                                                    <span class="badge-success">
                                                        <i class="bi bi-check-circle me-1"></i>正常
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-secondary">
                                                        <i class="bi bi-pause-circle me-1"></i>停用
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <button type="button" class="btn-sm btn-gradient-info" 
                                                        onclick="viewDepartment('${department.departmentId}')" title="查看详情">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <a href="${pageContext.request.contextPath}/admin/department/edit/${department.departmentId}" 
                                                   class="btn-sm btn-gradient-primary" title="编辑">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <button type="button" class="btn-sm btn-gradient-warning" 
                                                        onclick="toggleDepartmentStatus('${department.departmentId}', '${department.status}')" 
                                                        title="${department.status == 'ACTIVE' ? '停用' : '启用'}">
                                                    <i class="bi bi-${department.status == 'ACTIVE' ? 'pause' : 'play'}"></i>
                                                </button>
                                                <button type="button" class="btn-sm btn-gradient-danger" 
                                                        onclick="deleteDepartment('${department.departmentId}')" title="删除">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="bi bi-building"></i>
                        <h5>暂无部门</h5>
                        <p class="text-light-muted">还没有添加任何部门信息</p>
                        <a href="${pageContext.request.contextPath}/admin/department/add" class="btn-gradient-primary">
                            <i class="bi bi-plus-lg me-2"></i>添加第一个部门
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- 部门详情模态框 -->
<div class="modal fade" id="departmentDetailModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content bg-dark">
            <div class="modal-header border-secondary">
                <h5 class="modal-title text-white">
                    <i class="bi bi-building me-2"></i>部门详情
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="departmentDetailContent">
                <!-- 部门详情内容将在这里动态加载 -->
            </div>
            <div class="modal-footer border-secondary">
                <button type="button" class="btn-gradient-secondary" data-bs-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>

<script>
// 查看部门详情
function viewDepartment(departmentId) {
    var contextPath = '${pageContext.request.contextPath}';
    fetch(contextPath + '/admin/department/detail/' + departmentId)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                const department = data.department;
                const content = buildDepartmentDetailHtml(department);
                document.getElementById('departmentDetailContent').innerHTML = content;
                new bootstrap.Modal(document.getElementById('departmentDetailModal')).show();
            } else {
                showAlert(data.message || '获取部门详情失败', 'danger');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showAlert('获取部门详情失败，请稍后重试', 'danger');
        });
}

function buildDepartmentDetailHtml(department) {
    return '<div class="row">' +
               '<div class="col-md-6">' +
                   '<div class="detail-item">' +
                       '<label class="detail-label">部门ID</label>' +
                       '<div class="detail-value">#' + department.departmentId + '</div>' +
                   '</div>' +
                   '<div class="detail-item">' +
                       '<label class="detail-label">部门名称</label>' +
                       '<div class="detail-value">' + department.departmentName + '</div>' +
                   '</div>' +
               '</div>' +
               '<div class="col-md-6">' +
                   '<div class="detail-item">' +
                       '<label class="detail-label">部门代码</label>' +
                       '<div class="detail-value">' + department.departmentCode + '</div>' +
                   '</div>' +
                   '<div class="detail-item">' +
                       '<label class="detail-label">状态</label>' +
                       '<div class="detail-value">' + (department.status === 'ACTIVE' ? '<span class="badge bg-success">活跃</span>' : '<span class="badge bg-danger">停用</span>') + '</div>' +
                   '</div>' +
               '</div>' +
           '</div>' +
           (department.description ? '<div class="row mt-3"><div class="col-12"><div class="detail-item"><label class="detail-label">部门描述</label><div class="detail-value">' + department.description + '</div></div></div></div>' : '');
}

// 切换部门状态
function toggleDepartmentStatus(departmentId, currentStatus) {
    var contextPath = '${pageContext.request.contextPath}';
    const newStatus = currentStatus === 'ACTIVE' ? 'INACTIVE' : 'ACTIVE';
    const actionText = newStatus === 'ACTIVE' ? '启用' : '停用';
    
    if (confirm('确定要' + actionText + '这个部门吗？')) {
        fetch(contextPath + '/admin/department/toggle-status/' + departmentId, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ status: newStatus })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showAlert('部门' + actionText + '成功', 'success');
                setTimeout(() => location.reload(), 1000);
            } else {
                showAlert(data.message || '部门' + actionText + '失败', 'danger');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showAlert('部门' + actionText + '失败，请稍后重试', 'danger');
        });
    }
}

// 删除部门
function deleteDepartment(departmentId) {
    var contextPath = '${pageContext.request.contextPath}';
    if (confirm('确定要删除这个部门吗？此操作不可撤销，该部门下的所有预约记录也将受到影响。')) {
        fetch(contextPath + '/admin/department/delete/' + departmentId, {
            method: 'DELETE'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showAlert('删除成功', 'success');
                setTimeout(() => location.reload(), 1000);
            } else {
                showAlert(data.message || '删除失败', 'danger');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showAlert('删除失败，请稍后重试', 'danger');
        });
    }
}

function showAlert(message, type) {
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-' + type + ' alert-dismissible fade show position-fixed';
    alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
    alertDiv.innerHTML = 
        message +
        '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
    document.body.appendChild(alertDiv);
    
    setTimeout(() => {
        if (alertDiv.parentNode) {
            alertDiv.remove();
        }
    }, 3000);
}
</script>
