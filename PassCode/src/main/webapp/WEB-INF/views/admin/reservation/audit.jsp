<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="预约审核" />
<%@ include file="../../common/header.jsp" %>

<div class="page-content">
    <div class="content-header">
        <h2><i class="bi bi-check-square me-2"></i>预约审核</h2>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/admin/reservation/list" class="btn btn-outline-light">
                <i class="bi bi-arrow-left me-2"></i>返回列表
            </a>
        </div>
    </div>

    <!-- 预约详情卡片 -->
    <div class="card-custom mb-4">
        <div class="card-header-custom">
            <div class="d-flex justify-content-between align-items-center">
                <h5 class="mb-0">
                    <i class="bi bi-file-text me-2"></i>预约详情 
                    <span class="text-primary">#${reservation.reservationId}</span>
                </h5>
                <div class="status-badge">
                    <c:choose>
                        <c:when test="${reservation.status == 'pending'}">
                            <span class="badge-warning">
                                <i class="bi bi-clock me-1"></i>待审核
                            </span>
                        </c:when>
                        <c:when test="${reservation.status == 'approved'}">
                            <span class="badge-success">
                                <i class="bi bi-check-circle me-1"></i>已通过
                            </span>
                        </c:when>
                        <c:when test="${reservation.status == 'rejected'}">
                            <span class="badge-danger">
                                <i class="bi bi-x-circle me-1"></i>已拒绝
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge-secondary">
                                <i class="bi bi-question-circle me-1"></i>${reservation.status}
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        <div class="card-body-custom">
            <div class="row">
                <!-- 申请人信息 -->
                <div class="col-md-6">
                    <div class="info-section">
                        <h6 class="section-title">
                            <i class="bi bi-person me-2"></i>申请人信息
                        </h6>
                        <div class="info-grid">
                            <div class="info-item">
                                <label class="info-label">姓名</label>
                                <div class="info-value">${reservation.name}</div>
                            </div>
                            <div class="info-item">
                                <label class="info-label">学号/工号</label>
                                <div class="info-value">${reservation.idNumber}</div>
                            </div>
                            <div class="info-item">
                                <label class="info-label">联系电话</label>
                                <div class="info-value">
                                    <i class="bi bi-telephone me-1"></i>${reservation.phone}
                                </div>
                            </div>
                            <div class="info-item">
                                <label class="info-label">所属部门</label>
                                <div class="info-value">
                                    <span class="badge-outline">
                                        ${reservation.department.departmentName}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 预约信息 -->
                <div class="col-md-6">
                    <div class="info-section">
                        <h6 class="section-title">
                            <i class="bi bi-calendar-event me-2"></i>预约信息
                        </h6>
                        <div class="info-grid">
                            <div class="info-item">
                                <label class="info-label">预约日期</label>
                                <div class="info-value">
                                    <i class="bi bi-calendar3 me-1"></i>
                                    <fmt:formatDate value="${reservation.reservationDate}" pattern="yyyy年MM月dd日" />
                                </div>
                            </div>
                            <div class="info-item">
                                <label class="info-label">预约时间</label>
                                <div class="info-value">
                                    <i class="bi bi-clock me-1"></i>
                                    <fmt:formatDate value="${reservation.reservationTime}" pattern="HH:mm" />
                                </div>
                            </div>
                            <div class="info-item">
                                <label class="info-label">出入类型</label>
                                <div class="info-value">
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
                            <div class="info-item">
                                <label class="info-label">申请时间</label>
                                <div class="info-value">
                                    <i class="bi bi-calendar-plus me-1"></i>
                                    <fmt:formatDate value="${reservation.applicationTime}" pattern="yyyy-MM-dd HH:mm" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 预约事由 -->
            <c:if test="${not empty reservation.reason}">
                <div class="info-section mt-4">
                    <h6 class="section-title">
                        <i class="bi bi-chat-quote me-2"></i>预约事由
                    </h6>
                    <div class="reason-content">
                        ${reservation.reason}
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <!-- 审核历史 -->
    <c:if test="${not empty reservation.auditTime}">
        <div class="card-custom mb-4">
            <div class="card-header-custom">
                <h5 class="mb-0">
                    <i class="bi bi-clock-history me-2"></i>审核历史
                </h5>
            </div>
            <div class="card-body-custom">
                <div class="audit-history">
                    <div class="audit-record">
                        <div class="audit-info">                        <div class="audit-status">
                            <c:choose>
                                <c:when test="${reservation.status == 'approved'}">
                                    <span class="badge-success">
                                        <i class="bi bi-check-circle me-1"></i>审核通过
                                    </span>
                                </c:when>
                                <c:when test="${reservation.status == 'rejected'}">
                                    <span class="badge-danger">
                                        <i class="bi bi-x-circle me-1"></i>审核拒绝
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-secondary">
                                        <i class="bi bi-question-circle me-1"></i>${reservation.status}
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                            <div class="audit-time">
                                <i class="bi bi-calendar-check me-1"></i>
                                <fmt:formatDate value="${reservation.auditTime}" pattern="yyyy-MM-dd HH:mm:ss" />
                            </div>
                            <div class="audit-admin">
                                <i class="bi bi-person-badge me-1"></i>
                                审核人：${reservation.auditBy}
                            </div>
                        </div>
                        <c:if test="${not empty reservation.auditComment}">
                            <div class="audit-comment">
                                <strong>审核意见：</strong>${reservation.auditComment}
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </c:if>

    <!-- 审核操作 -->
    <c:if test="${reservation.status == 'pending'}">
        <div class="card-custom">
            <div class="card-header-custom">
                <h5 class="mb-0">
                    <i class="bi bi-gear me-2"></i>审核操作
                </h5>
            </div>
            <div class="card-body-custom">
                <form id="auditForm" method="post" action="${pageContext.request.contextPath}/admin/reservation/audit/${reservation.reservationId}">
                    <div class="row">
                        <div class="col-12 mb-3">
                            <label class="form-label">审核意见</label>
                            <textarea class="form-control" name="auditComments" rows="4" 
                                      placeholder="请输入审核意见..."></textarea>
                        </div>
                    </div>
                    
                    <div class="audit-actions">
                        <button type="submit" class="btn btn-outline-success" data-action="approve">
                            <i class="bi bi-check-lg me-2"></i>通过申请
                        </button>
                        <button type="submit" class="btn btn-outline-warning" data-action="pending">
                            <i class="bi bi-clock me-2"></i>设为待定
                        </button>
                        <button type="submit" class="btn btn-outline-danger" data-action="reject">
                            <i class="bi bi-x-lg me-2"></i>拒绝申请
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/reservation/list" class="btn btn-outline-light">
                            <i class="bi bi-arrow-left me-2"></i>返回列表
                        </a>
                    </div>
                    
                    <input type="hidden" name="action" id="auditAction">
                </form>
            </div>
        </div>
    </c:if>

    <!-- 已审核状态的操作按钮 -->
    <c:if test="${reservation.status != 'pending'}">
        <div class="text-center">
            <a href="${pageContext.request.contextPath}/admin/reservation/list" class="btn btn-outline-primary">
                <i class="bi bi-arrow-left me-2"></i>返回预约列表
            </a>
        </div>
    </c:if>
</div>

<script>
function auditReservation(action) {
    let statusText = '';
    switch(action) {
        case 'approve':
            statusText = '通过';
            break;
        case 'reject':
            statusText = '拒绝';
            break;
        case 'pending':
            statusText = '设为待定';
            break;
        default:
            statusText = '处理';
    }
    
    const comment = document.querySelector('textarea[name="auditComments"]').value.trim();
    
    if (action === 'reject' && !comment) {
        showAlert('拒绝申请时必须填写审核意见', 'warning');
        return;
    }
    
    if (confirm(`确定要${statusText}这个预约申请吗？`)) {
        // 禁用所有按钮防止重复提交
        const submitButtons = document.querySelectorAll('button[data-action]');
        submitButtons.forEach(btn => {
            btn.disabled = true;
            const icon = btn.querySelector('i');
            if (icon) {
                icon.className = 'bi bi-hourglass-split me-2';
            }
            const textNode = btn.childNodes[btn.childNodes.length - 1];
            if (textNode && textNode.nodeType === Node.TEXT_NODE) {
                textNode.textContent = '处理中...';
            }
        });
        
        // 设置action并提交表单
        document.getElementById('auditAction').value = action;
        document.getElementById('auditForm').submit();
    }
}

function showAlert(message, type) {
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
    alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    document.body.appendChild(alertDiv);
    
    setTimeout(() => {
        if (alertDiv.parentNode) {
            alertDiv.remove();
        }
    }, 3000);
}

// 防止表单重复提交和处理审核按钮点击
document.addEventListener('DOMContentLoaded', function() {
    const auditForm = document.getElementById('auditForm');
    if (auditForm) {
        // 为每个审核按钮添加点击事件监听器
        const auditButtons = auditForm.querySelectorAll('button[data-action]');
        auditButtons.forEach(button => {
            button.addEventListener('click', function(e) {
                e.preventDefault();
                const action = this.getAttribute('data-action');
                auditReservation(action);
            });
        });
        
        // 表单提交时的处理
        auditForm.addEventListener('submit', function(e) {
            e.preventDefault(); // 阻止默认提交，由auditReservation函数处理
        });
    }
});
</script>

<style>

body {

    min-height: 100vh;
}

.page-content {

    padding: 2rem;
}

/* 页面头部样式 */
.content-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 2rem;
    padding: 1.5rem 0;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.content-header h2 {
   ;
    font-weight: 600;
    margin: 0;
    display: flex;
    align-items: center;
}

.header-actions {
    display: flex;
    gap: 1rem;
}

/* 卡片样式 */
.card-custom {
    background: white;
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 1rem;
    backdrop-filter: blur(20px);
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
    margin-bottom: 2rem;
}

.card-header-custom {
    padding: 1.5rem 2rem;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    background: white;
    border-radius: 1rem 1rem 0 0;
}

.card-header-custom h5 {
   ;
    margin: 0;
    font-weight: 600;
}

.card-body-custom {
    padding: 2rem;
}

/* 信息区域样式 */
.info-section {
    background: white;
    border: 1px solid lightgreen;
    border-radius: 0.75rem;
    padding: 1.5rem;
    margin-bottom: 1.5rem;
}

.section-title {
    color: #a5b4fc;
    font-weight: 600;
    margin-bottom: 1.5rem;
    display: flex;
    align-items: center;
    font-size: 1rem;
}

.info-grid {
    display: grid;
    gap: 1rem;
}

.info-item {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
    padding: 1rem;
    background: white;
    border-radius: 0.5rem;
    border: 1px solid lightgreen;
}

.info-label {
    color: #94a3b8;
    font-size: 0.875rem;
    font-weight: 500;
    margin: 0;
}

.info-value {
   ;
    font-weight: 500;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

/* 事由内容样式 */
.reason-content {
    background: white;
    border: 1px solid lightgreen;
    border-radius: 0.5rem;
    padding: 1rem;
   ;
    line-height: 1.6;
    white-space: pre-wrap;
}

/* 审核历史样式 */
.audit-history {
    padding: 0;
}

.audit-record {
    background: white;
    border: 1px solid lightgreen;
    border-radius: 0.75rem;
    padding: 1.5rem;
}

.audit-info {
    display: flex;
    flex-wrap: wrap;
    gap: 1rem;
    align-items: center;
    margin-bottom: 1rem;
}

.audit-status,
.audit-time,
.audit-admin {
    display: flex;
    align-items: center;
    gap: 0.5rem;
   ;
}

.audit-comment {
    background: white;
    border-left: 3px solid #4f46e5;
    padding: 1rem;
    border-radius: 0.5rem;
   ;
    font-style: italic;
}

/* 表单样式 */
.form-control, textarea {
    background: lightgreen;
    border: 1px solid rgba(255, 255, 255, 0.2);
    border-radius: 0.5rem;
   ;
    padding: 0.75rem 1rem;
    font-size: 0.875rem;
    transition: all 0.3s ease;
}

.form-control:focus, textarea:focus {
    background: lightgreen;
    border-color: #4f46e5;
    box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
   ;
}

.form-control::placeholder, textarea::placeholder {
    color: #94a3b8;
}

.form-label {
   ;
    font-weight: 500;
    margin-bottom: 0.5rem;
    display: block;
}

/* 审核操作区域 */
.audit-actions {
    display: flex;
    gap: 1rem;
    flex-wrap: wrap;
    margin-top: 2rem;
}

/* 按钮样式 */
.btn {
    padding: 0.75rem 1.5rem;
    border-radius: 0.5rem;
    font-weight: 500;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    transition: all 0.3s ease;
    border: none;
    cursor: pointer;
    font-size: 0.875rem;
    gap: 0.5rem;
}

.btn-outline-success {
    background: transparent;
    border: 1px solid #10b981;
    color: #10b981;
}

.btn-outline-success:hover {
    background: #10b981;
    color: white;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
}

.btn-outline-danger {
    background: transparent;
    border: 1px solid #ef4444;
    color: #ef4444;
}

.btn-outline-danger:hover {
    background: #ef4444;
    color: white;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
}

.btn-outline-light {
    background: transparent;
    border: 1px solid rgba(255, 255, 255, 0.2);
   ;
}

.btn-outline-light:hover {
    background: lightgreen;
   ;
    transform: translateY(-2px);
}

.btn-outline-primary {
    background: transparent;
    border: 1px solid #4f46e5;
    color: #4f46e5;
}

.btn-outline-primary:hover {
    background: #4f46e5;
    color: white;
    transform: translateY(-2px);
}

.btn-outline-warning {
    background: transparent;
    border: 1px solid #f59e0b;
    color: #f59e0b;
}

.btn-outline-warning:hover {
    background: #f59e0b;
    color: white;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(245, 158, 11, 0.3);
}

/* 徽章样式 */
.badge-warning {
    background: #f59e0b;
    color: white;
    padding: 0.375rem 0.75rem;
    border-radius: 0.375rem;
    font-size: 0.75rem;
    font-weight: 500;
    display: inline-flex;
    align-items: center;
    gap: 0.25rem;
}

.badge-success {
    background: #10b981;
    color: white;
    padding: 0.375rem 0.75rem;
    border-radius: 0.375rem;
    font-size: 0.75rem;
    font-weight: 500;
    display: inline-flex;
    align-items: center;
    gap: 0.25rem;
}

.badge-danger {
    background: #ef4444;
    color: white;
    padding: 0.375rem 0.75rem;
    border-radius: 0.375rem;
    font-size: 0.75rem;
    font-weight: 500;
    display: inline-flex;
    align-items: center;
    gap: 0.25rem;
}

.badge-outline {
    background: transparent;
    border: 1px solid rgba(255, 255, 255, 0.2);
   ;
    padding: 0.25rem 0.5rem;
    border-radius: 0.375rem;
    font-size: 0.75rem;
    font-weight: 500;
}

.badge-secondary {
    background: lightgreen;
    color: white;
    padding: 0.375rem 0.75rem;
    border-radius: 0.375rem;
    font-size: 0.75rem;
    font-weight: 500;
    display: inline-flex;
    align-items: center;
    gap: 0.25rem;
}

/* 状态徽章 */
.status-badge {
    display: flex;
    align-items: center;
}

/* 文本颜色 */
.text-primary {
    color: #a5b4fc !important;
}

/* 响应式设计 */
@media (max-width: 768px) {
    .page-content {
        padding: 1rem;
    }
    
    .content-header {
        flex-direction: column;
        gap: 1rem;
        align-items: flex-start;
    }
    
    .audit-actions {
        flex-direction: column;
    }
    
    .audit-info {
        flex-direction: column;
        align-items: flex-start;
    }
    
    .card-body-custom {
        padding: 1rem;
    }
    
    .info-section {
        padding: 1rem;
    }
}

/* 按钮禁用状态 */
.btn:disabled {
    opacity: 0.6;
    cursor: not-allowed;
    transform: none !important;
}

/* Alert 样式 */
.alert {
    border: none;
    border-radius: 0.5rem;
    padding: 1rem 1.5rem;
}

.alert-warning {
    background: rgba(245, 158, 11, 0.1);
    color: #fbbf24;
    border: 1px solid rgba(245, 158, 11, 0.2);
}
<style>
     /* 基础样式 - 绿色自然主题 */
 body {
     background: linear-gradient(to bottom, #f0fff0, #e0ffe5);
     color: #333;
     min-height: 100vh;
     font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
     padding-bottom: 30px;
 }

/* 页面容器 */
.page-content {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
}

/* 头部区域 */
.content-header {
    background: white;
    padding: 20px;
    border-radius: 16px;
    box-shadow: 0 5px 25px rgba(46, 163, 85, 0.1);
    margin-bottom: 30px;
    border-bottom: 3px solid #4CAF50;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.content-header h2 {
    font-weight: 700;
    color: #2E8B57;
    margin: 0;
    display: flex;
    align-items: center;
    font-size: 1.8rem;
}

.content-header h2 i {
    margin-right: 10px;
    color: #4CAF50;
}

.header-actions .btn {
    border-radius: 12px;
    padding: 10px 20px;
    font-weight: 500;
    display: inline-flex;
    align-items: center;
}

.btn-outline-light {
    background: transparent;
    border: 2px solid #e0f7e9;
    color: #2E7D32;
    transition: all 0.3s;
}

.btn-outline-light:hover {
    background: #e0f7e9;
    border-color: #4CAF50;
    color: #2E7D32;
}

/* 卡片样式 */
.card-custom {
    background: white;
    border-radius: 16px;
    box-shadow: 0 8px 30px rgba(46, 163, 85, 0.15);
    margin-bottom: 25px;
    overflow: hidden;
    border: 1px solid #e0f7e9;
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

/* 信息网格布局 */
.info-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 20px;
}

.info-section {
    background: #f8fff8;
    border: 1px solid #e0f7e9;
    border-radius: 12px;
    padding: 20px;
    transition: all 0.3s;
}

.info-section:hover {
    transform: translateY(-3px);
    box-shadow: 0 5px 15px rgba(76, 175, 80, 0.1);
    border-color: #81C784;
}

.section-title {
    color: #2E7D32;
    font-weight: 600;
    margin-bottom: 15px;
    display: flex;
    align-items: center;
    font-size: 1.1rem;
    padding-bottom: 10px;
    border-bottom: 1px solid #e0f7e9;
}

.section-title i {
    margin-right: 10px;
    font-size: 1.1em;
    color: #4CAF50;
}

.info-item {
    margin-bottom: 15px;
}

.info-label {
    color: #689F38;
    font-weight: 500;
    margin-bottom: 5px;
    font-size: 0.95rem;
}

.info-value {
    font-weight: 500;
    color: #333;
    display: flex;
    align-items: center;
}

.info-value i {
    color: #4CAF50;
    margin-right: 8px;
    font-size: 1.1em;
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

.badge-warning {
    background: rgba(255, 193, 7, 0.15);
    color: #FF8F00;
    padding: 6px 14px;
    border-radius: 20px;
    font-size: 0.85rem;
    font-weight: 500;
    border: 1px solid #FFB300;
}

.badge-danger {
    background: rgba(239, 68, 68, 0.15);
    color: #D32F2F;
    padding: 6px 14px;
    border-radius: 20px;
    font-size: 0.85rem;
    font-weight: 500;
    border: 1px solid #F44336;
}

/* 事由内容 */
.reason-content {
    background: #f8fff8;
    border: 1px solid #e0f7e9;
    border-radius: 12px;
    padding: 20px;
    color: #333;
    line-height: 1.6;
    white-space: pre-wrap;
    margin-top: 15px;
    font-size: 1rem;
}

/* 审核历史 */
.audit-history {
    background: #f8fff8;
    border: 1px solid #e0f7e9;
    border-radius: 12px;
    padding: 20px;
    margin-top: 20px;
}

.audit-record {
    padding: 15px;
    border-bottom: 1px solid #e0f7e9;
}

.audit-record:last-child {
    border-bottom: none;
}

.audit-info {
    display: flex;
    flex-wrap: wrap;
    gap: 15px;
    margin-bottom: 10px;
}

.audit-status, .audit-time, .audit-admin {
    display: flex;
    align-items: center;
    font-size: 0.95rem;
}

.audit-status i, .audit-time i, .audit-admin i {
    margin-right: 8px;
    color: #4CAF50;
}

.audit-comment {
    background: #e8f5e9;
    border-left: 3px solid #4CAF50;
    padding: 15px;
    border-radius: 8px;
    color: #2E7D32;
    font-style: italic;
    margin-top: 10px;
}

/* 审核表单 */
#auditForm {
    background: #f8fff8;
    border: 1px solid #e0f7e9;
    border-radius: 12px;
    padding: 25px;
}

.form-label {
    color: #2E7D32;
    font-weight: 500;
    margin-bottom: 8px;
    font-size: 1rem;
}

.form-control, textarea {
    border: 2px solid #e0f7e9;
    border-radius: 12px;
    padding: 12px 15px;
    font-size: 1rem;
    transition: all 0.3s;
    background: white;
}

.form-control:focus, textarea:focus {
    border-color: #4CAF50;
    box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.2);
    outline: none;
}

.audit-actions {
    display: flex;
    gap: 15px;
    margin-top: 25px;
    flex-wrap: wrap;
}

.audit-actions .btn {
    flex: 1;
    min-width: 180px;
    padding: 12px 20px;
    border-radius: 12px;
    font-weight: 600;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s;
    box-shadow: 0 4px 10px rgba(76, 175, 80, 0.1);
}

.audit-actions .btn i {
    margin-right: 8px;
    font-size: 1.1em;
}

.btn-outline-success {
    background: transparent;
    border: 2px solid #4CAF50;
    color: #4CAF50;
}

.btn-outline-success:hover {
    background: #4CAF50;
    color: white;
    transform: translateY(-3px);
    box-shadow: 0 6px 15px rgba(76, 175, 80, 0.2);
}

.btn-outline-warning {
    background: transparent;
    border: 2px solid #FFB300;
    color: #FF8F00;
}

.btn-outline-warning:hover {
    background: #FFB300;
    color: white;
    transform: translateY(-3px);
    box-shadow: 0 6px 15px rgba(255, 179, 0, 0.2);
}

.btn-outline-danger {
    background: transparent;
    border: 2px solid #F44336;
    color: #F44336;
}

.btn-outline-danger:hover {
    background: #F44336;
    color: white;
    transform: translateY(-3px);
    box-shadow: 0 6px 15px rgba(244, 67, 54, 0.2);
}

.btn-outline-light {
    background: transparent;
    border: 2px solid #e0f7e9;
    color: #2E7D32;
}

.btn-outline-light:hover {
    background: #e0f7e9;
    border-color: #4CAF50;
    color: #2E7D32;
    transform: translateY(-3px);
}

/* 状态徽章 */
.status-badge {
    display: inline-flex;
    align-items: center;
    padding: 6px 14px;
    border-radius: 20px;
    font-weight: 500;
    font-size: 0.9rem;
}

.badge-warning {
    background: rgba(255, 193, 7, 0.15);
    color: #FF8F00;
    border: 1px solid #FFB300;
}

.badge-success {
    background: rgba(76, 175, 80, 0.15);
    color: #2E7D32;
    border: 1px solid #4CAF50;
}

.badge-danger {
    background: rgba(239, 68, 68, 0.15);
    color: #D32F2F;
    border: 1px solid #F44336;
}

/* 返回按钮 */
.text-center .btn {
    padding: 12px 30px;
    border-radius: 12px;
    font-weight: 600;
    display: inline-flex;
    align-items: center;
    transition: all 0.3s;
    box-shadow: 0 4px 10px rgba(76, 175, 80, 0.1);
}

.btn-outline-primary {
    background: transparent;
    border: 2px solid #4CAF50;
    color: #4CAF50;
}

.btn-outline-primary:hover {
    background: #4CAF50;
    color: white;
    transform: translateY(-3px);
    box-shadow: 0 6px 15px rgba(76, 175, 80, 0.2);
}

/* 响应式调整 */
@media (max-width: 992px) {
    .content-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 15px;
    }

    .header-actions {
        width: 100%;
        justify-content: flex-end;
    }
}

@media (max-width: 768px) {
    .info-grid {
        grid-template-columns: 1fr;
    }

    .audit-actions .btn {
        min-width: 100%;
    }

    .card-body-custom {
        padding: 15px;
    }
}
</style>

