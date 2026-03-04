<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="预约详情" />
<c:set var="currentPage" value="reservation" />
<%@ include file="../../common/header.jsp" %>

<style>

</style>

<div class="page-content">
    <div class="content-header">
        <h2><i class="bi bi-eye me-2"></i>预约详情</h2>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/admin/reservation/list" class="btn-gradient-outline">
                <i class="bi bi-arrow-left me-2"></i>返回列表
            </a>
            <c:if test="${reservation.status == 'PENDING'}">
                <a href="${pageContext.request.contextPath}/admin/reservation/audit/${reservation.reservationId}" 
                   class="btn-gradient-primary">
                    <i class="bi bi-check-square me-2"></i>立即审核
                </a>
            </c:if>
        </div>
    </div>

    <!-- 预约概览卡片 -->
    <div class="card-custom mb-4">
        <div class="card-header-custom">
            <div class="d-flex justify-content-between align-items-center">
                <h5 class="mb-0">
                    <i class="bi bi-info-circle me-2"></i>预约概览
                </h5>
                <div class="status-display">
                    <c:choose>
                        <c:when test="${reservation.status == 'PENDING'}">
                            <span class="badge-warning badge-lg">
                                <i class="bi bi-clock me-1"></i>待审核
                            </span>
                        </c:when>
                        <c:when test="${reservation.status == 'APPROVED'}">
                            <span class="badge-success badge-lg">
                                <i class="bi bi-check-circle me-1"></i>已通过
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge-danger badge-lg">
                                <i class="bi bi-x-circle me-1"></i>已拒绝
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        <div class="card-body-custom">
            <div class="overview-grid">
                <div class="overview-item">
                    <div class="overview-icon gradient-primary">
                        <i class="bi bi-hash"></i>
                    </div>
                    <div class="overview-content">
                        <div class="overview-label">预约编号</div>
                        <div class="overview-value">#${reservation.reservationId}</div>
                    </div>
                </div>
                <div class="overview-item">
                    <div class="overview-icon gradient-info">
                        <i class="bi bi-person"></i>
                    </div>
                    <div class="overview-content">
                        <div class="overview-label">申请人</div>
                        <div class="overview-value">${reservation.name}</div>
                    </div>
                </div>
                <div class="overview-item">
                    <div class="overview-icon gradient-success">
                        <i class="bi bi-calendar3"></i>
                    </div>
                    <div class="overview-content">
                        <div class="overview-label">预约日期</div>
                        <div class="overview-value">
                            <fmt:formatDate value="${reservation.reservationDate}" pattern="yyyy年MM月dd日" />
                        </div>
                    </div>
                </div>
                <div class="overview-item">
                    <div class="overview-icon gradient-warning">
                        <i class="bi bi-clock"></i>
                    </div>
                    <div class="overview-content">
                        <div class="overview-label">预约时间</div>
                        <div class="overview-value">
                            <fmt:formatDate value="${reservation.reservationTime}" pattern="HH:mm" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- 申请人详细信息 -->
        <div class="col-lg-6 mb-4">
            <div class="card-custom h-100">
                <div class="card-header-custom">
                    <h5 class="mb-0">
                        <i class="bi bi-person-badge me-2"></i>申请人信息
                    </h5>
                </div>
                <div class="card-body-custom">
                    <div class="detail-list">
                        <div class="detail-item">
                            <div class="detail-icon">
                                <i class="bi bi-person text-primary"></i>
                            </div>
                            <div class="detail-content">
                                <label class="detail-label">姓名</label>
                                <div class="detail-value">${reservation.name}</div>
                            </div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-icon">
                                <i class="bi bi-card-text text-info"></i>
                            </div>
                            <div class="detail-content">
                                <label class="detail-label">学号/工号</label>
                                <div class="detail-value">${reservation.idNumber}</div>
                            </div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-icon">
                                <i class="bi bi-telephone text-success"></i>
                            </div>
                            <div class="detail-content">
                                <label class="detail-label">联系电话</label>
                                <div class="detail-value">${reservation.phone}</div>
                            </div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-icon">
                                <i class="bi bi-building text-warning"></i>
                            </div>
                            <div class="detail-content">
                                <label class="detail-label">所属部门</label>
                                <div class="detail-value">
                                    <span class="badge-outline">
                                        ${reservation.department.departmentName}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 预约详细信息 -->
        <div class="col-lg-6 mb-4">
            <div class="card-custom h-100">
                <div class="card-header-custom">
                    <h5 class="mb-0">
                        <i class="bi bi-calendar-event me-2"></i>预约信息
                    </h5>
                </div>
                <div class="card-body-custom">
                    <div class="detail-list">
                        <div class="detail-item">
                            <div class="detail-icon">
                                <i class="bi bi-calendar3 text-primary"></i>
                            </div>
                            <div class="detail-content">
                                <label class="detail-label">预约日期</label>
                                <div class="detail-value">
                                    <fmt:formatDate value="${reservation.reservationDate}" pattern="yyyy年MM月dd日 EEEE" />
                                </div>
                            </div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-icon">
                                <i class="bi bi-clock text-info"></i>
                            </div>
                            <div class="detail-content">
                                <label class="detail-label">预约时间</label>
                                <div class="detail-value">
                                    <fmt:formatDate value="${reservation.reservationTime}" pattern="HH:mm" />
                                </div>
                            </div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-icon">
                                <i class="bi bi-arrow-repeat text-success"></i>
                            </div>
                            <div class="detail-content">
                                <label class="detail-label">出入类型</label>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${reservation.entryType == 'IN'}">
                                            <span class="badge-success">
                                                <i class="bi bi-arrow-down-circle me-1"></i>入校
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-warning">
                                                <i class="bi bi-arrow-up-circle me-1"></i>出校
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-icon">
                                <i class="bi bi-calendar-plus text-warning"></i>
                            </div>
                            <div class="detail-content">
                                <label class="detail-label">申请时间</label>
                                <div class="detail-value">
                                    <fmt:formatDate value="${reservation.applicationTime}" pattern="yyyy-MM-dd HH:mm:ss" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 预约事由 -->
    <c:if test="${not empty reservation.reason}">
        <div class="card-custom mb-4">
            <div class="card-header-custom">
                <h5 class="mb-0">
                    <i class="bi bi-chat-quote me-2"></i>预约事由
                </h5>
            </div>
            <div class="card-body-custom">
                <div class="reason-display">
                    ${reservation.reason}
                </div>
            </div>
        </div>
    </c:if>

    <!-- 审核信息 -->
    <c:if test="${not empty reservation.auditTime}">
        <div class="card-custom mb-4">
            <div class="card-header-custom">
                <h5 class="mb-0">
                    <i class="bi bi-check2-square me-2"></i>审核信息
                </h5>
            </div>
            <div class="card-body-custom">
                <div class="audit-info-display">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="detail-item">
                                <div class="detail-icon">
                                    <i class="bi bi-person-check text-primary"></i>
                                </div>
                                <div class="detail-content">
                                    <label class="detail-label">审核人</label>
                                    <div class="detail-value">${reservation.auditBy}</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="detail-item">
                                <div class="detail-icon">
                                    <i class="bi bi-calendar-check text-info"></i>
                                </div>
                                <div class="detail-content">
                                    <label class="detail-label">审核时间</label>
                                    <div class="detail-value">
                                        <fmt:formatDate value="${reservation.auditTime}" pattern="yyyy-MM-dd HH:mm:ss" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <c:if test="${not empty reservation.auditComment}">
                        <div class="audit-comment-display">
                            <label class="detail-label">
                                <i class="bi bi-chat-text me-1"></i>审核意见
                            </label>
                            <div class="audit-comment-content">
                                ${reservation.auditComment}
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </c:if>

    <!-- 操作按钮区域 -->
    <div class="action-footer">
        <div class="d-flex justify-content-between">
            <div>
                <a href="${pageContext.request.contextPath}/admin/reservation/list" class="btn-gradient-outline">
                    <i class="bi bi-arrow-left me-2"></i>返回列表
                </a>
            </div>
            <div class="action-group">
                <c:if test="${reservation.status == 'PENDING'}">
                    <a href="${pageContext.request.contextPath}/admin/reservation/audit/${reservation.reservationId}" 
                       class="btn-gradient-primary">
                        <i class="bi bi-check-square me-2"></i>立即审核
                    </a>
                </c:if>
                <button type="button" class="btn-gradient-info" onclick="printDetails()">
                    <i class="bi bi-printer me-2"></i>打印详情
                </button>
                <button type="button" class="btn-gradient-secondary" onclick="exportToPDF()">
                    <i class="bi bi-file-earmark-pdf me-2"></i>导出PDF
                </button>
            </div>
        </div>
    </div>
</div>

<script>
function printDetails() {
    window.print();
}

function exportToPDF() {
    // 这里可以实现PDF导出功能
    const url = `${pageContext.request.contextPath}/admin/reservation/export/${reservation.reservationId}?format=pdf`;
    window.open(url, '_blank');
}

// 打印样式
const printStyles = `
    <style>
        @media print {
            .sidebar, .header-actions, .action-footer { display: none !important; }
            .page-content { margin-left: 0 !important; padding: 20px !important; }
            .card-custom { border: 1px solid #000 !important; margin-bottom: 20px !important; }
         }
            body { background: white !important; color: #000 !important; }
            * { background: transparent !important; }
        }
    </style>
`;
document.head.insertAdjacentHTML('beforeend', printStyles);
</script>

