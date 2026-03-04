<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="预约管理" />
<c:set var="currentPage" value="reservation" />
<c:set var="breadcrumbContent">
    <li class="breadcrumb-item active">预约管理</li>
</c:set>
<%@ include file="../../common/header.jsp" %>


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
        <a href="${pageContext.request.contextPath}/admin/reservation/statistics" class="btn-gradient-info">
            <i class="bi bi-graph-up me-2"></i>查看统计
        </a>
    </div>

    <!-- 搜索筛选器 -->
    <div class="card-custom mb-4">
        <div class="card-header-custom">
            <h5 class="mb-0">
                <i class="bi bi-funnel me-2"></i>筛选条件
            </h5>
        </div>
        <div class="card-body-custom">
            <form method="get" action="${pageContext.request.contextPath}/admin/reservation/list">
                <!-- 第一行：基本信息筛选 -->
                <div class="row mb-3">
                    <div class="col-lg-3 col-md-6">
                        <div class="filter-group">
                            <label class="form-label">
                                <i class="bi bi-person me-1"></i>申请人姓名
                            </label>
                            <input type="text" class="form-control dark-input" name="name" 
                                   value="${param.name}" placeholder="输入姓名搜索">
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="filter-group">
                            <label class="form-label">
                                <i class="bi bi-credit-card me-1"></i>学号/工号
                            </label>
                            <input type="text" class="form-control dark-input" name="idNumber" 
                                   value="${param.idNumber}" placeholder="输入学号或工号">
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="filter-group">
                            <label class="form-label">
                                <i class="bi bi-building me-1"></i>所属部门
                            </label>
                            <select class="form-select dark-select" name="departmentId">
                                <option value="">全部部门</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.departmentId}" 
                                            ${param.departmentId == dept.departmentId ? 'selected' : ''}>
                                        ${dept.departmentName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="filter-group">
                            <label class="form-label">
                                <i class="bi bi-check-circle me-1"></i>审核状态
                            </label>
                            <select class="form-select dark-select" name="status">
                                <option value="">全部状态</option>
                                <option value="PENDING" ${param.status eq 'PENDING' ? 'selected' : ''}>待审核</option>
                                <option value="APPROVED" ${param.status eq 'APPROVED' ? 'selected' : ''}>已通过</option>
                                <option value="REJECTED" ${param.status eq 'REJECTED' ? 'selected' : ''}>已拒绝</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                <!-- 第二行：时间筛选和操作 -->
                <div class="row align-items-end">
                    <div class="col-lg-3 col-md-6">
                        <div class="filter-group">
                            <label class="form-label">
                                <i class="bi bi-calendar me-1"></i>申请日期
                            </label>
                            <input type="date" class="form-control" name="applicationDate" 
                                   value="${param.applicationDate}">
                        </div>
                    </div>
                    <div class="col-lg-9 col-md-6">
                        <div class="filter-actions d-flex gap-2 justify-content-end">
                            <button type="submit" class="btn-gradient-primary">
                                <i class="bi bi-search me-2"></i>搜索
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/reservation/list" 
                               class="btn-outline-light">
                                <i class="bi bi-arrow-clockwise me-2"></i>重置
                            </a>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- 统计信息卡片 -->
    <div class="row mb-4">
        <div class="col-lg-3 col-md-6">
            <div class="stats-card stats-card-primary">
                <div class="stats-icon">
                    <i class="bi bi-hourglass-split"></i>
                </div>
                <div class="stats-content">
                    <div class="stats-number">${pendingCount != null ? pendingCount : '0'}</div>
                    <div class="stats-label">待审核</div>
                </div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6">
            <div class="stats-card stats-card-success">
                <div class="stats-icon">
                    <i class="bi bi-check-circle"></i>
                </div>
                <div class="stats-content">
                    <div class="stats-number">${approvedCount != null ? approvedCount : '0'}</div>
                    <div class="stats-label">已通过</div>
                </div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6">
            <div class="stats-card stats-card-danger">
                <div class="stats-icon">
                    <i class="bi bi-x-circle"></i>
                </div>
                <div class="stats-content">
                    <div class="stats-number">${rejectedCount != null ? rejectedCount : '0'}</div>
                    <div class="stats-label">已拒绝</div>
                </div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6">
            <div class="stats-card stats-card-info">
                <div class="stats-icon">
                    <i class="bi bi-files"></i>
                </div>
                <div class="stats-content">
                    <div class="stats-number">${totalElements}</div>
                    <div class="stats-label">总记录</div>
                </div>
            </div>
        </div>
    </div>

    <!-- 操作工具栏 -->
    <div class="toolbar-card mb-4">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div class="toolbar-left">
                <div class="batch-selection">
                    <button type="button" class="btn-outline-light btn-sm" id="selectAllBtn">
                        <i class="bi bi-check-square me-1"></i>全选
                    </button>
                    <span class="selection-count text-light-muted ms-2">
                        已选择 <span id="selectedCount">0</span> 项
                    </span>
                </div>
            </div>
            <div class="toolbar-right">
                <div class="d-flex gap-2 flex-wrap">
                    <button type="button" class="btn-gradient-success btn-sm" onclick="batchApprove()" disabled id="batchApproveBtn">
                        <i class="bi bi-check-lg me-1"></i>批量通过
                    </button>
                    <button type="button" class="btn-gradient-danger btn-sm" onclick="batchReject()" disabled id="batchRejectBtn">
                        <i class="bi bi-x-lg me-1"></i>批量拒绝
                    </button>
                    <div class="divider"></div>
                    <a href="${pageContext.request.contextPath}/admin/reservation/statistics" class="btn-gradient-info btn-sm">
                        <i class="bi bi-graph-up me-1"></i>统计分析
                    </a>


                </div>
            </div>
        </div>
    </div>

    <!-- 预约列表 -->
    <div class="card-custom">
        <div class="card-header-custom">
            <h5 class="mb-0">
                <i class="bi bi-list-ul me-2"></i>预约列表
            </h5>
        </div>
        <div class="card-body-custom p-0">
            <c:choose>
                <c:when test="${not empty reservations.content}">
                    <div class="table-responsive">
                        <table class="table-custom">
                            <thead>
                                <tr>
                                    <th>预约编号</th>
                                    <th>申请人</th>
                                    <th>联系方式</th>
                                    <th>所属部门</th>
                                    <th>预约日期</th>
                                    <th>预约类型</th>
                                    <th>状态</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="reservation" items="${reservations.content}">
                                    <tr>
                                        <td>
                                            <span class="font-monospace text-primary">#${reservation.id}</span>
                                        </td>
                                        <td>
                                            <div class="fw-bold">${reservation.name != null ? reservation.name : '未填写'}</div>
                                        </td>
                                        <td>
                                            <span>${reservation.phone != null ? reservation.phone : '未填写'}</span>
                                        </td>
                                        <td>
                                            <span class="badge-outline">
                                                ${reservation.visitDepartmentName != null ? reservation.visitDepartmentName : (reservation.department != null ? reservation.department.departmentName : '未指定')}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="datetime-info">
                                                <c:if test="${not empty reservation.visitTime}">
                                                    <div>
                                                        ${reservation.visitTime}
                                                    </div>
                                                </c:if>
                                                <c:if test="${empty reservation.visitTime}">
                                                    <span class="text-light-muted">未设置</span>
                                                </c:if>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge-outline">
                                                ${reservation.reservationType != null ? reservation.reservationType : '未指定'}
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${reservation.status == 'pending'}">
                                                    <span class="badge-warning"><i class="bi bi-clock me-1"></i>待审核</span>
                                                </c:when>
                                                <c:when test="${reservation.status == 'approved'}">
                                                    <span class="badge-success"><i class="bi bi-check-circle me-1"></i>已通过</span>
                                                </c:when>
                                                <c:when test="${reservation.status == 'rejected'}">
                                                    <span class="badge-danger"><i class="bi bi-x-circle me-1"></i>已拒绝</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-secondary"><i class="bi bi-question-circle me-1"></i>${reservation.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/admin/reservation/view/${reservation.id}" class="btn-sm btn-gradient-info" title="查看详情" target="_blank"><i class="bi bi-eye"></i></a>
                                                
                                                <c:if test="${reservation.status == 'pending'}">
                                                    <a href="${pageContext.request.contextPath}/admin/reservation/audit/${reservation.id}" class="btn-sm btn-gradient-primary" title="审核"><i class="bi bi-check-square"></i></a>
                                                </c:if>
                                                
                                                <c:if test="${reservation.status == 'approved'}">
                                                    <button type="button" class="btn-sm btn-gradient-warning" onclick="showRevokeModal('${reservation.id}')" title="撤销预约">
                                                        <i class="bi bi-arrow-counterclockwise"></i>
                                                    </button>
                                                </c:if>
                                                
                                                <c:if test="${reservation.status != 'pending'}">
                                                    <button type="button" class="btn-sm btn-gradient-secondary" onclick="showChangeStatusModal('${reservation.id}')" title="修改状态">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </button>
                                                </c:if>
                                                
                                                <a href="${pageContext.request.contextPath}/admin/reservation/edit/${reservation.id}" class="btn-sm btn-gradient-warning" title="编辑"><i class="bi bi-pencil"></i></a>
                                                <button type="button" class="btn-sm btn-gradient-danger" onclick="deleteReservation('${reservation.id}')" title="删除"><i class="bi bi-trash"></i></button>
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
                        <i class="bi bi-inbox"></i>
                        <h5>暂无预约记录</h5>
                        <p class="text-light-muted">没有找到符合条件的预约记录</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- 分页导航 -->
    <c:if test="${not empty reservations.content and reservations.totalPages > 1}">
        <nav class="mt-4">
            <ul class="pagination-custom">
                <c:if test="${reservations.hasPrevious()}">
                    <li>
                        <a href="?page=${reservations.number - 1}&${queryString}" class="pagination-link">
                            <i class="bi bi-chevron-left"></i>
                        </a>
                    </li>
                </c:if>
                
                <c:forEach begin="0" end="${reservations.totalPages - 1}" var="i">
                    <c:if test="${i >= reservations.number - 2 and i <= reservations.number + 2}">
                        <li>
                            <a href="?page=${i}&${queryString}" 
                               class="pagination-link ${i == reservations.number ? 'active' : ''}">
                                ${i + 1}
                            </a>
                        </li>
                    </c:if>
                </c:forEach>
                
                <c:if test="${reservations.hasNext()}">
                    <li>
                        <a href="?page=${reservations.number + 1}&${queryString}" class="pagination-link">
                            <i class="bi bi-chevron-right"></i>
                        </a>
                    </li>
                </c:if>
            </ul>
        </nav>
    </c:if>

    <!-- 撤销预约模态框 -->
    <div class="modal fade" id="revokeModal" tabindex="-1" aria-labelledby="revokeModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content bg-dark">
                <div class="modal-header border-secondary">
                    <h5 class="modal-title text-white" id="revokeModalLabel">
                        <i class="bi bi-arrow-counterclockwise me-2"></i>撤销预约
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="revokeStatus" class="form-label text-white">撤销到状态</label>
                        <select class="form-select dark-select" id="revokeStatus">
                            <option value="rejected">已拒绝</option>
                            <option value="pending">待审核</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="revokeComment" class="form-label text-white">撤销原因</label>
                        <textarea class="form-control dark-input" id="revokeComment" rows="3" placeholder="请输入撤销原因..."></textarea>
                    </div>
                </div>
                <div class="modal-footer border-secondary">
                    <button type="button" class="btn-gradient-outline" data-bs-dismiss="modal">取消</button>
                    <button type="button" class="btn-gradient-warning" onclick="confirmRevoke()">确认撤销</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 修改状态模态框 -->
    <div class="modal fade" id="changeStatusModal" tabindex="-1" aria-labelledby="changeStatusModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content bg-dark">
                <div class="modal-header border-secondary">
                    <h5 class="modal-title text-white" id="changeStatusModalLabel">
                        <i class="bi bi-pencil-square me-2"></i>修改预约状态
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="newStatus" class="form-label text-white">新状态</label>
                        <select class="form-select dark-select" id="newStatus">
                            <option value="pending">待审核</option>
                            <option value="approved">已通过</option>
                            <option value="rejected">已拒绝</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="changeStatusComment" class="form-label text-white">修改原因</label>
                        <textarea class="form-control dark-input" id="changeStatusComment" rows="3" placeholder="请输入修改原因..."></textarea>
                    </div>
                </div>
                <div class="modal-footer border-secondary">
                    <button type="button" class="btn-gradient-outline" data-bs-dismiss="modal">取消</button>
                    <button type="button" class="btn-gradient-primary" onclick="confirmChangeStatus()">确认修改</button>
                </div>
            </div>
        </div>
    </div>

    <script>
$(document).ready(function() {
    updateSelectionCount();
    
    // 全选/反选功能
    $('#selectAll, #selectAllBtn').on('change click', function() {
        const isChecked = $('#selectAll').prop('checked') || $(this).attr('id') === 'selectAllBtn';
        $('.row-checkbox').prop('checked', isChecked);
        $('#selectAll').prop('checked', isChecked);
        updateSelectionCount();
        updateBatchButtons();
    });
    
    // 单个复选框变化
    $(document).on('change', '.row-checkbox', function() {
        updateSelectionCount();
        updateBatchButtons();
        updateSelectAllState();
    });
    
    // 防止addEventListener错误的安全检查
    const elementsToCheck = ['selectAll', 'selectAllBtn', 'batchApproveBtn', 'batchRejectBtn'];
    elementsToCheck.forEach(function(elementId) {
        const element = document.getElementById(elementId);
        if (element && typeof element.addEventListener === 'function') {
            // 元素存在且支持addEventListener
            console.log('Element ' + elementId + ' is ready');
        } else if (element) {
            // 元素存在但不支持addEventListener，使用jQuery替代
            console.warn('Element ' + elementId + ' does not support addEventListener, using jQuery instead');
        } else {
            // 元素不存在
            console.warn('Element ' + elementId + ' not found');
        }
    });
});

// 更新选择计数
function updateSelectionCount() {
    const selectedCount = $('.row-checkbox:checked').length;
    $('#selectedCount').text(selectedCount);
}

// 更新批量操作按钮状态
function updateBatchButtons() {
    const selectedCount = $('.row-checkbox:checked').length;
    const hasSelection = selectedCount > 0;
    
    $('#batchApproveBtn, #batchRejectBtn').prop('disabled', !hasSelection);
    
    if (hasSelection) {
        $('#batchApproveBtn, #batchRejectBtn').removeClass('btn-outline-secondary').addClass('btn-gradient-success');
    } else {
        $('#batchApproveBtn, #batchRejectBtn').removeClass('btn-gradient-success').addClass('btn-outline-secondary');
    }
}

// 更新全选状态
function updateSelectAllState() {
    const totalCheckboxes = $('.row-checkbox').length;
    const checkedCheckboxes = $('.row-checkbox:checked').length;
    
    if (checkedCheckboxes === 0) {
        $('#selectAll').prop('indeterminate', false).prop('checked', false);
    } else if (checkedCheckboxes === totalCheckboxes) {
        $('#selectAll').prop('indeterminate', false).prop('checked', true);
    } else {
        $('#selectAll').prop('indeterminate', true).prop('checked', false);
    }
}

// 批量审核操作
function batchApprove() {
    const selectedIds = getSelectedIds();
    if (selectedIds.length === 0) {
        showAlert('请选择要批量通过的预约记录', 'warning');
        return;
    }
    
    // 使用更美观的确认对话框
    if (confirm('确定要批量通过选中的 ' + selectedIds.length + ' 条预约记录吗？')) {
        batchAudit(selectedIds, 'approved');
    }
}

function batchReject() {
    const selectedIds = getSelectedIds();
    if (selectedIds.length === 0) {
        showAlert('请选择要批量拒绝的预约记录', 'warning');
        return;
    }
    
    if (confirm('确定要批量拒绝选中的 ' + selectedIds.length + ' 条预约记录吗？')) {
        batchAudit(selectedIds, 'rejected');
    }
}

function getSelectedIds() {
    const checkboxes = document.querySelectorAll('.row-checkbox:checked');
    return Array.from(checkboxes).map(cb => cb.value);
}

function batchAudit(ids, status) {
    const contextPath = '${pageContext.request.contextPath}';
    
    // 显示加载状态
    showAlert('正在处理批量审核操作...', 'info');
    
    fetch(contextPath + '/admin/reservation/batch-audit', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            reservationIds: ids,
            status: status
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showAlert('批量审核操作成功', 'success');
            setTimeout(() => location.reload(), 1500);
        } else {
            showAlert(data.message || '批量审核操作失败', 'danger');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showAlert('操作失败，请稍后重试', 'danger');
    });
}

function editReservation(id) {
    const contextPath = '${pageContext.request.contextPath}';
    window.location.href = contextPath + '/admin/reservation/edit/' + id;
}

function deleteReservation(id) {
    if (confirm('确定要删除这条预约记录吗？此操作不可撤销。')) {
        const contextPath = '${pageContext.request.contextPath}';
        
        fetch(contextPath + '/admin/reservation/delete/' + id, {
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


let currentReservationId = null;

// 显示撤销模态框
function showRevokeModal(reservationId) {
    currentReservationId = reservationId;
    document.getElementById('revokeStatus').value = 'rejected';
    document.getElementById('revokeComment').value = '';
    new bootstrap.Modal(document.getElementById('revokeModal')).show();
}

// 显示修改状态模态框
function showChangeStatusModal(reservationId) {
    currentReservationId = reservationId;
    document.getElementById('newStatus').value = 'pending';
    document.getElementById('changeStatusComment').value = '';
    new bootstrap.Modal(document.getElementById('changeStatusModal')).show();
}

// 确认撤销
function confirmRevoke() {
    const newStatus = document.getElementById('revokeStatus').value;
    const comment = document.getElementById('revokeComment').value.trim();
    
    if (!comment) {
        showAlert('请输入撤销原因', 'warning');
        return;
    }
    
    const formData = new FormData();
    formData.append('action', 'revoke');
    formData.append('reservationId', currentReservationId);
    formData.append('newStatus', newStatus);
    formData.append('comment', comment);
    
    fetch('${pageContext.request.contextPath}/admin/reservation/list', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showAlert(data.message, 'success');
            setTimeout(() => location.reload(), 1000);
        } else {
            showAlert(data.message || '撤销失败', 'danger');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showAlert('撤销失败，请稍后重试', 'danger');
    });
    
    bootstrap.Modal.getInstance(document.getElementById('revokeModal')).hide();
}

// 确认修改状态
function confirmChangeStatus() {
    const newStatus = document.getElementById('newStatus').value;
    const comment = document.getElementById('changeStatusComment').value.trim();
    
    if (!comment) {
        showAlert('请输入修改原因', 'warning');
        return;
    }
    
    const formData = new FormData();
    formData.append('action', 'changeStatus');
    formData.append('reservationId', currentReservationId);
    formData.append('newStatus', newStatus);
    formData.append('comment', comment);
    
    fetch('${pageContext.request.contextPath}/admin/reservation/list', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showAlert(data.message, 'success');
            setTimeout(() => location.reload(), 1000);
        } else {
            showAlert(data.message || '修改失败', 'danger');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showAlert('修改失败，请稍后重试', 'danger');
    });
    
    bootstrap.Modal.getInstance(document.getElementById('changeStatusModal')).hide();
}
</script>

    </div> <!-- 关闭 page-content-body -->
</div> <!-- 关闭 page-content -->
