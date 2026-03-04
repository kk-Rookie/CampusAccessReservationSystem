<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="管理员管理" />
<c:set var="currentPage" value="admin" />
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
                <li class="breadcrumb-item active">管理员管理</li>
            </ol>
        </nav>
    </div>

    <div class="page-content-body">
        <!-- 操作按钮 -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div></div>
            <a href="${pageContext.request.contextPath}/admin/manager/add" class="btn btn-outline-primary" target="_blank">
                <i class="bi bi-plus-circle me-2"></i>添加管理员
            </a>
        </div>

        <!-- 统计卡片 -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-icon"><i class="bi bi-people-fill"></i></div>
                    <div class="stats-content">
                        <div class="stats-number">${totalManagers != null ? totalManagers : 0}</div>
                        <div class="stats-label">总管理员</div>
                    </div>
                </div>
            </div>


        <!-- 搜索筛选器 -->
        <div class="card-custom mb-4">
            <div class="card-header-custom">
                <h5 class="mb-0">
                    <i class="bi bi-search me-2"></i>搜索管理员
                </h5>
            </div>
            <div class="card-body-custom">
                <form method="get" action="${pageContext.request.contextPath}/admin/manager/list">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="form-label">姓名</label>
                            <input type="text" class="form-control" name="name" value="${param.name}" placeholder="请输入姓名">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">用户名</label>
                            <input type="text" class="form-control" name="username" value="${param.username}" placeholder="请输入用户名">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">状态</label>
                            <select class="form-select" name="status">
                                <option value="">全部</option>
                                <option value="active" ${param.status == 'active' ? 'selected' : ''}>启用</option>
                                <option value="locked" ${param.status == 'locked' ? 'selected' : ''}>锁定</option>
                                <option value="disabled" ${param.status == 'disabled' ? 'selected' : ''}>禁用</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">角色</label>
                            <select class="form-select" name="role">
                                <option value="">全部</option>
                                <option value="sys_admin" ${param.role == 'sys_admin' ? 'selected' : ''}>系统管理员</option>
                                <option value="school_admin" ${param.role == 'school_admin' ? 'selected' : ''}>学校管理员</option>
                                <option value="dept_admin" ${param.role == 'dept_admin' ? 'selected' : ''}>部门管理员</option>
                                <option value="audit_admin" ${param.role == 'audit_admin' ? 'selected' : ''}>审计管理员</option>
                            </select>
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" class="btn btn-outline-primary w-100">
                                <i class="bi bi-search me-2"></i>搜索
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- 批量操作 -->
        <div class="card-custom mb-4">
            <div class="card-body-custom">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="batch-operations">
                        <button type="button" class="btn-outline-primary btn-sm me-2" onclick="selectAll()">
                            <i class="bi bi-check2-all me-2"></i>全选
                        </button>
                        <button type="button" class="btn-outline-warning btn-sm me-2" onclick="batchDisable()">
                            <i class="bi bi-toggle-off me-2"></i>批量禁用
                        </button>
                        <button type="button" class="btn-outline-success btn-sm me-2" onclick="batchEnable()">
                            <i class="bi bi-toggle-on me-2"></i>批量启用
                        </button>
                        <button type="button" class="btn-outline-danger btn-sm" onclick="batchDelete()">
                            <i class="bi bi-trash me-2"></i>批量删除
                        </button>
                    </div>
                    <div class="table-info">
                        <span class="text-muted">共 ${totalCount != null ? totalCount : 0} 条记录</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 管理员列表 -->
        <div class="card-custom">
            <div class="card-header-custom">
                <h5 class="mb-0">
                    <i class="bi bi-list-ul me-2"></i>管理员列表
                </h5>
            </div>
            <div class="card-body-custom p-0">
                <div class="table-responsive">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th width="50">
                                    <input type="checkbox" id="selectAllCheck" onchange="toggleSelectAll()" class="form-check-input dark-input">
                                </th>
                                <th width="80">头像</th>
                                <th width="120">姓名</th>
                                <th width="120">用户名</th>
                                <th width="100">角色</th>
                                <th width="120">电话</th>
                                <th width="150">邮箱</th>
                                <th width="100">状态</th>
                                <th width="120">最后登录</th>
                                <th width="150">操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="manager" items="${managers}">
                                <tr>
                                    <td>
                                        <input type="checkbox" class="form-check-input dark-input row-checkbox" name="selectedManagers" value="${manager.adminId}">
                                    </td>
                                    <td>
                                        <div class="avatar-sm">
                                            <i class="bi bi-person-circle text-muted" style="font-size: 2rem;"></i>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="manager-name">
                                            <strong>${manager.name}</strong>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="text-muted">${manager.loginName}</span>
                                    </td>
                                    <td>
                                        <span class="badge-outline">
                                            <c:choose>
                                                <c:when test="${manager.role == 'sys_admin'}">系统管理员</c:when>
                                                <c:when test="${manager.role == 'school_admin'}">学校管理员</c:when>
                                                <c:when test="${manager.role == 'dept_admin'}">部门管理员</c:when>
                                                <c:when test="${manager.role == 'audit_admin'}">审计管理员</c:when>
                                                <c:otherwise>${manager.role}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="text-muted">${manager.phone != null ? manager.phone : '-'}</span>
                                    </td>
                                    <td>
                                        <span class="text-muted">${manager.email != null ? manager.email : '-'}</span>
                                    </td>
                                    <td>
                                        <span class="badge-success" style="display: inline-block; min-width: 48px; text-align: center;">
                                            <c:choose>
                                                <c:when test="${manager.status == 'active'}">启用</c:when>
                                                <c:when test="${manager.status == 'locked'}">锁定</c:when>
                                                <c:when test="${manager.status == 'disabled'}">禁用</c:when>
                                                <c:otherwise>${manager.status}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="text-muted">从未登录</span>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="javascript:void(0);" class="btn btn-outline-info btn-sm me-1" title="详情" onclick="viewManager('${manager.adminId}')">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/manager/edit/${manager.adminId}" class="btn btn-outline-primary btn-sm me-1" title="编辑" target="_blank">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <c:if test="${manager.status == 'active'}">
                                                <a href="javascript:void(0);" class="btn btn-outline-warning btn-sm me-1" title="禁用" onclick="toggleManagerStatus('${manager.adminId}', '${manager.status}')">
                                                    <i class="bi bi-pause-circle"></i>
                                                </a>
                                            </c:if>
                                            <c:if test="${manager.status != 'active'}">
                                                <a href="javascript:void(0);" class="btn btn-outline-success btn-sm me-1" title="启用" onclick="toggleManagerStatus('${manager.adminId}', '${manager.status}')">
                                                    <i class="bi bi-play-circle"></i>
                                                </a>
                                            </c:if>
                                            <a href="javascript:void(0);" class="btn btn-outline-danger btn-sm" title="删除" onclick="deleteManager('${manager.adminId}', '${manager.name}')">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty managers}">
                                <tr>
                                    <td colspan="10" class="text-center py-4">
                                        <div class="empty-state">
                                            <i class="bi bi-people display-1 text-muted"></i>
                                            <p class="text-light-muted mt-2">暂无管理员数据</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- 分页 -->
        <c:if test="${not empty managers}">
            <nav aria-label="管理员列表分页" class="mt-4">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage - 1}&name=${param.name}&username=${param.username}&status=${param.status}&role=${param.role}">
                            <i class="bi bi-chevron-left"></i>
                        </a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="page">
                        <li class="page-item ${page == currentPage ? 'active' : ''}">
                            <a class="page-link" href="?page=${page}&name=${param.name}&username=${param.username}&status=${param.status}&role=${param.role}">
                                ${page}
                            </a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage + 1}&name=${param.name}&username=${param.username}&status=${param.status}&role=${param.role}">
                            <i class="bi bi-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
        </c:if>

        <!-- 管理员详情弹窗 -->
        <div class="modal fade" id="managerDetailModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="bi bi-person-circle me-2"></i>管理员详情
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body" id="managerDetailContent">
                        <!-- 详情内容将通过AJAX加载 -->
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-outline-light" data-bs-dismiss="modal">关闭</button>
                    </div>
                </div>
            </div>
        </div>
    </div> <!-- 关闭 page-content-body -->
</div> <!-- 关闭 page-content -->
</div>
<!-- 保留原有 JS 逻辑和样式，确保功能不变 -->
<script>
// 交互逻辑
$(function() {
    // 全选
    $('#selectAllCheck, #btnSelectAll').on('click', function() {
        const checked = $('#selectAllCheck').prop('checked') || $(this).is('#btnSelectAll');
        $('.row-checkbox').prop('checked', checked);
        updateBatchBtns();
    });
    // 单选
    $(document).on('change', '.row-checkbox', updateBatchBtns);
    function updateBatchBtns() {
        const checked = $('.row-checkbox:checked').length;
        $('#btnBatchEnable, #btnBatchDisable, #btnBatchDelete').prop('disabled', checked === 0);
    }
    // 批量操作
    $('#btnBatchEnable').click(() => batchOp('enable'));
    $('#btnBatchDisable').click(() => batchOp('disable'));
    $('#btnBatchDelete').click(() => batchOp('delete'));
    function batchOp(action) {
        const ids = $('.row-checkbox:checked').map((_, el) => el.value).get();
        if (!ids.length) return;
        if (!confirm(`确定要${action == 'delete' ? '删除' : (action == 'enable' ? '启用' : '禁用')}选中管理员吗？`)) return;
        // TODO: 后端批量接口
        alert('模拟批量' + action + ': ' + ids.join(','));
    }
});
// 详情弹窗
function viewManager(id) {
    var contextPath = '${pageContext.request.contextPath}';
    window.open(contextPath + '/admin/manager/view/' + id, '_blank');
}

// 删除管理员
function deleteManager(id, name) {
    if (!confirm('确定要删除管理员 ' + name + ' 吗？')) return;
    
    const formData = new FormData();
    formData.append('action', 'delete');
    formData.append('adminId', id);
    
    fetch('${pageContext.request.contextPath}/admin/manager/list', {
        method: 'POST',
        body: formData
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        if (data.success) {
            alert(data.message);
            location.reload(); // 刷新页面
        } else {
            alert('删除失败: ' + data.message);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('删除时发生错误');
    });
}

// 切换管理员状态
function toggleManagerStatus(id, currentStatus) {
    const statusText = currentStatus === 'active' ? '禁用' : '启用';
    if (!confirm('确定要' + statusText + '该管理员吗？')) return;
    
    const formData = new FormData();
    formData.append('action', 'toggleStatus');
    formData.append('adminId', id);
    formData.append('currentStatus', currentStatus);
    
    fetch('${pageContext.request.contextPath}/admin/manager/list', {
        method: 'POST',
        body: formData
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        if (data.success) {
            alert(data.message);
            location.reload(); // 刷新页面
        } else {
            alert('状态切换失败: ' + data.message);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('状态切换时发生错误');
    });
}
</script>

<style>
    .page-content {
        background-color: #f9fff9;
    }

    .content-header {
        background-color: white;
        padding: 1.5rem;
        border-radius: 16px;
        box-shadow: 0 4px 12px rgba(0, 128, 0, 0.08);
        margin-bottom: 1.5rem;
        border-bottom: 2px solid #d5ffd5;
    }
    .breadcrumb {
        background: #e8f5e9;
        padding: 10px 15px;
        border-radius: 12px;
        margin: 0;
    }

    .breadcrumb-item a {
        color: #388E3C;
        text-decoration: none;
        transition: all 0.3s;
    }

    .breadcrumb-item a:hover {
        color: #2E7D32;
        text-decoration: underline;
    }

    .breadcrumb-item.active {
        color: #689F38;
        font-weight: 500;
    }

    /* 操作按钮区 */
    .d-flex.justify-content-between {
        padding: 0 0.5rem;
    }

    .btn-outline-primary {
        border-color: #28a745;
        color: #28a745;
        border-radius: 12px;
        transition: all 0.3s ease;
    }

    .btn-outline-primary:hover {
        background: #28a745;
        color: white;
    }

    /* 统计卡片 */
    .stats-card {
        background: white;
        border-radius: 16px;
        box-shadow: 0 6px 15px rgba(0, 128, 0, 0.08);
        padding: 1.5rem;
        text-align: center;
        transition: all 0.3s ease;
        margin-bottom: 1.5rem;
        border: 1px solid #e0f7e0;
    }

    .stats-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 25px rgba(0, 128, 0, 0.15);
    }

    .stats-icon {
        width: 60px;
        height: 60px;
        background: linear-gradient(135deg, #88ff88, #66ff66);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 1rem;
        color: white;
        font-size: 1.8rem;
    }

    .stats-number {
        font-size: 1.8rem;
        font-weight: 700;
        color: #005000;
        margin-bottom: 0.5rem;
    }

    .stats-label {
        color: #006600;
        font-size: 0.9rem;
        font-weight: 500;
        text-transform: uppercase;
    }

    /* 搜索筛选器 */
    .card-custom {
        background: white;
        border-radius: 16px;
        box-shadow: 0 6px 15px rgba(0, 128, 0, 0.08);
        margin-bottom: 1.5rem;
        overflow: hidden;
    }
</style>
