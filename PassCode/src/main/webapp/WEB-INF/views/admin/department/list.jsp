<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="部门管理" />
<c:set var="currentPage" value="department" />
<c:set var="breadcrumbContent">
    <li class="breadcrumb-item active">部门管理</li>
</c:set>
<%@ include file="../../common/header.jsp" %>

<div class="page-content">
    <!-- 页面头部 -->
    <div class="content-header">
        <h1>${pageTitle}</h1>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="bi bi-house"></i> 首页
                    </a>
                </li>
                ${breadcrumbContent}
            </ol>
        </nav>
    </div>

    <!-- 页面内容 -->
    <div class="page-content-body">
    <!-- 操作按钮 -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div></div>
        <a href="${pageContext.request.contextPath}/admin/department/add" class="btn btn-outline-primary" target="_blank">
            <i class="bi bi-plus-lg me-2"></i>添加部门
        </a>
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
                        <input type="text" class="form-control" name="departmentName" 
                               value="${param.departmentName}" placeholder="请输入部门名称">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">部门代码</label>
                        <input type="text" class="form-control" name="departmentCode" 
                               value="${param.departmentCode}" placeholder="请输入部门代码">
                    </div>
                    <div class="col-md-4 d-flex align-items-end">
                        <button type="submit" class="btn btn-outline-primary w-100">
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
            <div class="stats-card stats-primary">
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
            <div class="stats-card stats-success">
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
            <div class="stats-card stats-info">
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
            <div class="stats-card stats-warning">
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
                                                #${department.deptId}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="department-info">
                                                <div class="fw-bold">${department.deptName}</div>
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
                                                <c:when test="${department.status == 'active'}">
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
                                                <button type="button" class="btn btn-outline-info btn-sm" 
                                                        onclick="viewDepartment('${department.deptId}')" title="查看详情">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <a href="${pageContext.request.contextPath}/admin/department/edit/${department.deptId}" 
                                                   class="btn btn-outline-primary btn-sm" title="编辑" target="_blank">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <button type="button" class="btn btn-outline-warning btn-sm" 
                                                        onclick="toggleDepartmentStatus('${department.deptId}', '${department.status}')" 
                                                        title="${department.status == 'active' ? '停用' : '启用'}">
                                                    <i class="bi bi-${department.status == 'active' ? 'pause' : 'play'}"></i>
                                                </button>
                                                <button type="button" class="btn btn-outline-danger btn-sm" 
                                                        onclick="deleteDepartment('${department.deptId}')" title="删除">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- 分页控件 -->
                    <c:if test="${totalPages > 1}">
                        <div class="pagination-container">
                            <nav aria-label="部门分页">
                                <ul class="pagination justify-content-center">
                                    <!-- 上一页 -->
                                    <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="?page=${currentPage - 1}&pageSize=${pageSize}">
                                            <i class="bi bi-chevron-left"></i>
                                        </a>
                                    </li>

                                    <!-- 页码 -->
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <c:if test="${i == currentPage || (i >= currentPage - 2 && i <= currentPage + 2) || i == 1 || i == totalPages}">
                                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                <a class="page-link" href="?page=${i}&pageSize=${pageSize}">${i}</a>
                                            </li>
                                        </c:if>
                                        <c:if test="${(i == currentPage - 3 && i > 1) || (i == currentPage + 3 && i < totalPages)}">
                                            <li class="page-item disabled">
                                                <span class="page-link">...</span>
                                            </li>
                                        </c:if>
                                    </c:forEach>

                                    <!-- 下一页 -->
                                    <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="?page=${currentPage + 1}&pageSize=${pageSize}">
                                            <i class="bi bi-chevron-right"></i>
                                        </a>
                                    </li>
                                </ul>
                            </nav>

                            <!-- 分页信息 -->
                            <div class="pagination-info">
                                <span class="text-muted">
                                    显示第 ${(currentPage - 1) * pageSize + 1} 到 ${(currentPage - 1) * pageSize + departments.size()} 条，
                                    共 ${totalCount} 条记录，第 ${currentPage} / ${totalPages} 页
                                </span>
                            </div>
                        </div>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="bi bi-building"></i>
                        <h5>暂无部门</h5>
                        <p class="text-light-muted">还没有添加任何部门信息</p>
                        <a href="${pageContext.request.contextPath}/admin/department/add" class="btn btn-outline-primary" target="_blank">
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
    window.open(contextPath + '/admin/department/view/' + departmentId, '_blank');
}

function buildDepartmentDetailHtml(department) {
    return '<div class="row">' +
               '<div class="col-md-6">' +
                   '<div class="detail-item">' +
                       '<label class="detail-label">部门ID</label>' +
                       '<div class="detail-value">#' + department.deptId + '</div>' +
                   '</div>' +
                   '<div class="detail-item">' +
                       '<label class="detail-label">部门名称</label>' +
                       '<div class="detail-value">' + department.deptName + '</div>' +
                   '</div>' +
               '</div>' +
               '<div class="col-md-6">' +
                   '<div class="detail-item">' +
                       '<label class="detail-label">部门代码</label>' +
                       '<div class="detail-value">' + department.departmentCode + '</div>' +
                   '</div>' +
                   '<div class="detail-item">' +
                       '<label class="detail-label">状态</label>' +
                       '<div class="detail-value">' + (department.status === 'active' ? '<span class="badge bg-success">活跃</span>' : '<span class="badge bg-danger">停用</span>') + '</div>' +
                   '</div>' +
               '</div>' +
           '</div>' +
           (department.description ? '<div class="row mt-3"><div class="col-12"><div class="detail-item"><label class="detail-label">部门描述</label><div class="detail-value">' + department.description + '</div></div></div></div>' : '');
}

// 切换部门状态
function toggleDepartmentStatus(departmentId, currentStatus) {
    var contextPath = '${pageContext.request.contextPath}';
    const newStatus = currentStatus === 'active' ? 'inactive' : 'active';
    const actionText = newStatus === 'active' ? '启用' : '停用';
    
    if (confirm('确定要' + actionText + '这个部门吗？')) {
        const formData = new FormData();
        formData.append('action', 'toggleStatus');
        formData.append('deptId', departmentId);
        formData.append('currentStatus', currentStatus);
        
        fetch(contextPath + '/admin/department/list', {
            method: 'POST',
            body: formData
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
        const formData = new FormData();
        formData.append('action', 'delete');
        formData.append('deptId', departmentId);
        
        fetch(contextPath + '/admin/department/list', {
            method: 'POST',
            body: formData
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
    <style>
        body {
            background: linear-gradient(to bottom, #f0fff0, #e0ffe5);
            color: #333;
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding-bottom: 30px;
        }

        /* 页面容器 */
        .page-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }



        .content-header h1 {
            margin: 0 0 10px 0;
            font-size: 2rem;
        }

        .breadcrumb {
            background: #e8f5e9;
            padding: 10px 15px;
            border-radius: 12px;
            margin: 0;
        }

        .breadcrumb-item a {

        }

        .breadcrumb-item a:hover {
            color: #2E7D32;

        }

        .breadcrumb-item.active {
            color: #689F38;
            font-weight: 500;
        }

        /* 操作按钮 */
        .btn-outline-primary {
            background: transparent;
            border: 2px solid #4CAF50;
            color: #4CAF50;
            padding: 12px 20px;
            border-radius: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            transition: all 0.3s;
            box-shadow: 0 4px 10px rgba(76, 175, 80, 0.1);
        }

        .btn-outline-primary:hover {
            background: #4CAF50;
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(76, 175, 80, 0.2);
        }

        .btn-outline-primary i {
            margin-right: 8px;
            font-size: 1.1em;
        }

        /* 卡片样式 */
        .card-custom {
            background: white;
            border-radius: 16px;
            box-shadow: 0 8px 30px rgba(46, 163, 85, 0.15);
            margin-bottom: 25px;
            overflow: hidden;
        }

        .card-header-custom {
            background: #e8f5e9;
            padding: 20px;
            border-bottom: 1px solid rgba(76, 175, 80, 0.2);
        }

        .card-header-custom h5 {
            margin: 0;
            font-weight: 600;
            color: #2E7D32;
            display: flex;
            align-items: center;
        }

        .card-header-custom h5 i {
            color: #4CAF50;
            margin-right: 10px;
            font-size: 1.2em;
        }

        .card-body-custom {
            padding: 25px;
        }

        /* 统计卡片 */
        .stats-card {
            background: white;
            border: 2px solid #e0f7e9;
            border-radius: 16px;
            padding: 20px;
            text-align: center;
            height: 100%;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(60, 179, 113, 0.1);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(60, 179, 113, 0.15);
            border-color: #81C784;
        }

        .stats-icon {
            width: 60px;
            height: 60px;
            background: rgba(76, 175, 80, 0.15);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
            font-size: 1.8rem;
        }

        .stats-icon i {
            color: #4CAF50;
        }

        .stats-number {
            font-size: 1.8rem;
            font-weight: 700;
            color: #2E7D32;
            margin-bottom: 5px;
        }

        .stats-label {
            color: #689F38;
            font-size: 0.95rem;
            font-weight: 500;
        }

        /* 调整不同统计卡片的颜色 */
        .stats-success .stats-icon i {
            color: #66BB6A;
        }

        .stats-info .stats-icon i {
            color: #4DB6AC;
        }

        .stats-warning .stats-icon i {
            color: #FFB74D;
        }

        /* 表单样式 */
        .form-label {
            color: #2E7D32;
            font-weight: 500;
            margin-bottom: 8px;
        }

        .form-control, .form-select {
            border: 2px solid #e0f7e9;
            border-radius: 12px;
            padding: 12px 15px;
            font-size: 1rem;
            transition: all 0.3s;
        }

        .form-control:focus, .form-select:focus {
            border-color: #4CAF50;
            box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.2);
            outline: none;
        }

        /* 表格样式 */
        .table-custom {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(46, 163, 85, 0.1);
        }

        .table-custom th {
            background: #e8f5e9;
            color: #2E7D32;
            padding: 16px 15px;
            font-weight: 600;
            text-align: left;
            border-bottom: 2px solid #d0e7d4;
        }

        .table-custom td {
            padding: 15px;
            border-bottom: 1px solid #e0f7e9;
            transition: all 0.3s;
        }

        .table-custom tr:last-child td {
            border-bottom: none;
        }

        .table-custom tbody tr:hover td {
            background: rgba(224, 255, 229, 0.25);
        }

        .table-custom tbody tr:hover {
            transform: translateY(-1px);
        }

        /* 徽章样式 */
        .badge-outline {
            background: rgba(76, 175, 80, 0.1);
            border: 1px solid #4CAF50;
            color: #2E7D32;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .badge-success {
            background: rgba(76, 175, 80, 0.15);
            color: #2E7D32;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
            border: 1px solid #4CAF50;
        }

        .badge-secondary {
            background: rgba(189, 189, 189, 0.15);
            color: #757575;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
            border: 1px solid #e0e0e0;
        }

        /* 部门信息 */
        .department-info .fw-bold {
            color: #2E7D32;
            font-weight: 600;
        }

        .description-text {
            color: #555;
            font-size: 0.95rem;
        }

        .text-light-muted {
            color: #a5d6a7;
            font-style: italic;
        }

        /* 时间信息 */
        .datetime-info div:first-child {
            font-weight: 500;
        }

        /* 操作按钮组 */
        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn {
            border-radius: 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
            width: 36px;
            height: 36px;
            padding: 0;
        }

        .btn-sm {
            width: 36px;
            height: 36px;
            border-radius: 10px;
        }

        .btn-outline-info {
            border: 2px solid #29B6F6;
            color: #29B6F6;
        }

        .btn-outline-info:hover {
            background: #29B6F6;
            color: white;
        }

        .btn-outline-primary {
            border: 2px solid #4CAF50;
            color: #4CAF50;
        }

        .btn-outline-primary:hover {
            background: #4CAF50;
            color: white;
        }

        .btn-outline-warning {
            border: 2px solid #FFCA28;
            color: #FFA000;
        }

        .btn-outline-warning:hover {
            background: #FFCA28;
            color: white;
        }

        .btn-outline-danger {
            border: 2px solid #EF5350;
            color: #EF5350;
        }

        .btn-outline-danger:hover {
            background: #EF5350;
            color: white;
        }

        /* 分页样式 */
        .pagination-container {
            margin-top: 25px;
            padding: 20px;
            background: white;
            border-radius: 16px;
            box-shadow: 0 5px 25px rgba(46, 163, 85, 0.1);
        }

        .pagination {
            justify-content: center;
            margin-bottom: 15px;
        }

        .page-item .page-link {
            border: 2px solid #e0f7e9;
            color: #2E7D32;
            margin: 0 5px;
            border-radius: 12px !important;
            transition: all 0.2s;
            min-width: 45px;
            text-align: center;
        }

        .page-item .page-link:hover {
            background: rgba(76, 175, 80, 0.1);
            border-color: #4CAF50;
        }

        .page-item.active .page-link {
            background: #4CAF50;
            border-color: #4CAF50;
            color: white;
        }

        .pagination-info {
            text-align: center;
            color: #689F38;
            font-size: 0.95rem;
        }

        /* 空状态 */
        .empty-state {
            text-align: center;
            padding: 60px 30px;
            background: white;
            border-radius: 16px;
            box-shadow: 0 8px 30px rgba(46, 163, 85, 0.1);
        }

        .empty-state i {
            font-size: 5rem;
            color: rgba(76, 175, 80, 0.2);
            margin-bottom: 25px;
        }

        .empty-state h5 {
            color: #2E7D32;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #78909C;
            margin-bottom: 25px;
            max-width: 500px;
            margin-left: auto;
            margin-right: auto;
        }

        /* 响应式调整 */
        @media (max-width: 992px) {
            .content-header {
                padding: 15px;
            }

            .stats-card {
                padding: 15px;
            }
        }

        @media (max-width: 768px) {
            .card-body-custom {
                padding: 15px;
            }

            .action-buttons {
                flex-wrap: wrap;
            }

            .table-custom th,
            .table-custom td {
                padding: 12px;
            }

            .empty-state {
                padding: 40px 20px;
            }
        }
    </style>
    </div> <!-- 关闭 page-content-body -->
</div> <!-- 关闭 page-content -->
