<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="预约审核" />
<%@ include file="../../common/header.jsp" %>

<div class="page-content">
    <div class="content-header">
        <h2>预约审核管理</h2>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/admin/reservation/list" class="btn btn-outline-light">
                返回列表
            </a>
        </div>
    </div>

    <!-- 错误消息 -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show">
            ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- 成功消息 -->
    <c:if test="${not empty param.message}">
        <div class="alert alert-success alert-dismissible fade show">
            ${param.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- 统计卡片 -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="stats-card stats-warning">
                <div class="stats-icon">
                    <i class="bi bi-clock"></i>
                </div>
                <div class="stats-content">
                    <div class="stats-number">${pendingCount}</div>
                    <div class="stats-label">待审核</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stats-card stats-success">
                <div class="stats-icon">
                    <i class="bi bi-check-circle"></i>
                </div>
                <div class="stats-content">
                    <div class="stats-number">${approvedCount}</div>
                    <div class="stats-label">已通过</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stats-card stats-danger">
                <div class="stats-icon">
                    <i class="bi bi-x-circle"></i>
                </div>
                <div class="stats-content">
                    <div class="stats-number">${rejectedCount}</div>
                    <div class="stats-label">已拒绝</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stats-card stats-primary">
                <div class="stats-icon">
                    <i class="bi bi-list"></i>
                </div>
                <div class="stats-content">
                    <div class="stats-number">${totalCount}</div>
                    <div class="stats-label">当前列表</div>
                </div>
            </div>
        </div>
    </div>

    <!-- 筛选标签 -->
    <div class="card-custom mb-4">
        <div class="card-header-custom">
            <h5 class="mb-0">审核状态筛选</h5>
        </div>
        <div class="card-body-custom">
            <div class="btn-group" role="group">
                <a href="${pageContext.request.contextPath}/admin/reservation/audit?status=pending" 
                   class="btn ${currentStatus == 'pending' ? 'btn-outline-primary' : 'btn-outline-secondary'}">
                    待审核 (${pendingCount})
                </a>
                <a href="${pageContext.request.contextPath}/admin/reservation/audit?status=approved" 
                   class="btn ${currentStatus == 'approved' ? 'btn-outline-primary' : 'btn-outline-secondary'}">
                    已通过 (${approvedCount})
                </a>
                <a href="${pageContext.request.contextPath}/admin/reservation/audit?status=rejected" 
                   class="btn ${currentStatus == 'rejected' ? 'btn-outline-primary' : 'btn-outline-secondary'}">
                    已拒绝 (${rejectedCount})
                </a>
            </div>
        </div>
    </div>

    <!-- 预约列表 -->
    <div class="card-custom">
        <div class="card-header-custom">
            <h5 class="mb-0">
                <c:choose>
                    <c:when test="${currentStatus == 'pending'}">待审核预约</c:when>
                    <c:when test="${currentStatus == 'approved'}">已通过预约</c:when>
                    <c:when test="${currentStatus == 'rejected'}">已拒绝预约</c:when>
                    <c:otherwise>预约记录</c:otherwise>
                </c:choose>
            </h5>
        </div>
        <div class="card-body-custom">
            <c:choose>
                <c:when test="${empty reservations}">
                    <div class="text-center py-5">
                        <i class="bi bi-inbox display-1 text-muted"></i>
                        <h5 class="mt-3 text-muted">暂无
                            <c:choose>
                                <c:when test="${currentStatus == 'pending'}">待审核</c:when>
                                <c:when test="${currentStatus == 'approved'}">已通过</c:when>
                                <c:when test="${currentStatus == 'rejected'}">已拒绝</c:when>
                                <c:otherwise></c:otherwise>
                            </c:choose>
                            的预约记录
                        </h5>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-dark table-striped">
                            <thead>
                                <tr>
                                    <th>预约ID</th>
                                    <th>申请人</th>
                                    <th>联系方式</th>
                                    <th>预约类型</th>
                                    <th>校区</th>
                                    <th>预约时间</th>
                                    <th>申请时间</th>
                                    <th>状态</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="reservation" items="${reservations}">
                                    <tr>
                                        <td>#${reservation.reservationId}</td>
                                        <td>
                                            <div class="fw-bold">${reservation.name}</div>
                                            <small class="text-muted">${reservation.idNumber}</small>
                                        </td>
                                        <td>
                                            <div>${reservation.phone}</div>
                                            <small class="text-muted">${reservation.idNumber}</small>
                                        </td>
                                        <td>
                                            <span class="badge bg-info">${reservation.reservationType}</span>
                                        </td>
                                        <td>${reservation.campus}</td>
                                        <td>
                                            <div>
                                                ${reservation.reservationDate != null ? reservation.reservationDate : '未设置'}
                                            </div>
                                            <small class="text-muted">
                                                ${reservation.reservationTime != null ? reservation.reservationTime : ''}
                                            </small>
                                        </td>
                                        <td>
                                            <div>
                                                ${reservation.applicationTime != null ? reservation.applicationTime : '未设置'}
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${reservation.status == 'pending'}">
                                                    <span class="badge bg-warning">待审核</span>
                                                </c:when>
                                                <c:when test="${reservation.status == 'approved'}">
                                                    <span class="badge bg-success">已通过</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">已拒绝</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="btn-group-sm">
                                                <a href="${pageContext.request.contextPath}/admin/reservation/view/${reservation.reservationId}" 
                                                   class="btn btn-sm btn-outline-info" target="_blank">
                                                    查看详情
                                                </a>
                                                <c:if test="${reservation.status == 'pending'}">
                                                    <a href="${pageContext.request.contextPath}/admin/reservation/audit/${reservation.reservationId}" 
                                                       class="btn btn-sm btn-outline-primary" target="_blank">
                                                        审核
                                                    </a>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<style>
body {

    min-height: 100vh;
}

.content-header {
    margin-bottom: 2rem;
}

.content-header h2 {

    font-weight: 600;
}

/* 卡片样式 */
.card-custom {
    background: white;
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 1rem;
    backdrop-filter: blur(20px);
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
}

.card-header-custom {
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    padding: 1.5rem;
    border-radius: 1rem 1rem 0 0;
}

.card-header-custom h5 {
   ;
    font-weight: 600;
    margin: 0;
}

.card-body-custom {
    padding: 2rem;
}

/* 统计卡片样式 */
.stats-card {
    background: white;
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 1rem;
    padding: 1.5rem;
    backdrop-filter: blur(20px);
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    gap: 1rem;
}

.stats-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
    border-color: rgba(255, 255, 255, 0.2);
}

.stats-card.stats-primary {
    background: white;
    border: 1px solid #4f46e5;
}

.stats-card.stats-success {
    background: white;
    border: 1px solid #10b981;
}

.stats-card.stats-warning {
    background: white;
    border: 1px solid #f59e0b;
}

.stats-card.stats-danger {
    background: white;
    border: 1px solid #ef4444;
}

.stats-icon {
    width: 3rem;
    height: 3rem;
    border-radius: 0.75rem;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.25rem;
    color: white;
}

.stats-card.stats-primary .stats-icon {
    background: #4f46e5;
}

.stats-card.stats-success .stats-icon {
    background: #10b981;
}

.stats-card.stats-warning .stats-icon {
    background: #f59e0b;
}

.stats-card.stats-danger .stats-icon {
    background: #ef4444;
}

.stats-content .stats-number {
   ;
    font-size: 1.5rem;
    font-weight: 700;
    margin-bottom: 0.25rem;
}

.stats-content .stats-label {
    color: #94a3b8;
    font-size: 0.875rem;
    font-weight: 500;
}

/* 按钮样式 */
.btn-outline-primary {
    background: transparent;
    border: 1px solid #4f46e5;

    padding: 0.75rem 1.5rem;
    border-radius: 0.5rem;
    font-weight: 500;
    transition: all 0.3s ease;
    display: inline-flex;
    align-items: center;
    text-decoration: none;
}

.btn-outline-primary:hover {

    transform: translateY(-2px);
}

.btn-outline-secondary {
    background: transparent;
    border: 1px solid #6b7280;
    color: #6b7280;
    padding: 0.75rem 1.5rem;
    border-radius: 0.5rem;
    font-weight: 500;
    transition: all 0.3s ease;
    display: inline-flex;
    align-items: center;
    text-decoration: none;
}

.btn-outline-secondary:hover {
    background: seagreen;
    color: white;
    transform: translateY(-2px);
}

.btn-outline-light {
    background: transparent;
    border: 1px solid rgba(255, 255, 255, 0.3);
   ;
    padding: 0.75rem 1.5rem;
    border-radius: 0.5rem;
    font-weight: 500;
    transition: all 0.3s ease;
    display: inline-flex;
    align-items: center;
    text-decoration: none;
}

.btn-outline-light:hover {
    background: lightgreen;
    border-color: rgba(255, 255, 255, 0.5);
   ;
    transform: translateY(-2px);
}

.btn-outline-info {
    background: transparent;
    border: 1px solid #06b6d4;
    color: #06b6d4;
    padding: 0.5rem 1rem;
    border-radius: 0.5rem;
    font-weight: 500;
    transition: all 0.3s ease;
    display: inline-flex;
    align-items: center;
    text-decoration: none;
}

.btn-outline-info:hover {
    background: #06b6d4;
    color: white;
    transform: translateY(-2px);
}

/* 表格样式 */
.table-dark {
    background: white;
   ;
}

.table-dark th {
    background: white;
    border-color: rgba(255, 255, 255, 0.1);
   ;
}

.table-dark td {
    border-color: rgba(255, 255, 255, 0.1);
    color: #cbd5e1;
}

.table-striped tbody tr:nth-of-type(odd) {
    background: lightgreen;
}

/* 徽章样式 */
.badge {
    font-size: 0.75rem;
    padding: 0.375rem 0.5rem;
    border-radius: 0.375rem;
    font-weight: 500;
}

.badge.bg-success {
    background: #10b981 !important;
}

.badge.bg-warning {
    background: #f59e0b !important;
}

.badge.bg-danger {
    background: #ef4444 !important;
}

.badge.bg-info {
    background: #06b6d4 !important;
}

/* 警告框样式 */
.alert {
    border: none;
    border-radius: 0.75rem;
    padding: 1rem 1.5rem;
}

.alert-success {
    background: rgba(16, 185, 129, 0.2);
    border: 1px solid rgba(16, 185, 129, 0.3);
    color: #6ee7b7;
}

.alert-danger {
    background: rgba(239, 68, 68, 0.2);
    border: 1px solid rgba(239, 68, 68, 0.3);
    color: #fca5a5;
}

/* 其他文本颜色 */
.text-muted {
    color: #94a3b8 !important;
}

.text-light {
    !important;
}

/* 响应式设计 */
@media (max-width: 768px) {
    .card-body-custom {
        padding: 1.5rem;
    }
    
    .stats-card {
        padding: 1rem;
    }
    
    .btn-outline-primary,
    .btn-outline-secondary,
    .btn-outline-light,
    .btn-outline-info {
        padding: 0.5rem 1rem;
        font-size: 0.875rem;
    }
}
</style>

