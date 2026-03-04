<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="系统审计" />
<c:set var="currentPage" value="system_audit" />
<%@ include file="../../common/header.jsp" %>

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

<div class="page-content">
    <div class="content-header">
        <h2><i class="bi bi-shield-check me-2"></i>系统审计</h2>


        </div>
    </div>

    <!-- 搜索区域 -->
    <div class="card-custom search-section">
        <h5 class="mb-3"><i class="bi bi-funnel me-2"></i>筛选条件</h5>
        <form method="post" action="${pageContext.request.contextPath}/admin/audit/search">
            <div class="row">
                <div class="col-md-3 mb-3">
                    <label class="form-label">审计类型</label>
                    <select name="auditType" class="form-select">
                        <option value="">所有类型</option>
                        <c:forEach var="type" items="${auditTypes}">
                            <option value="${type}" ${auditType == type ? 'selected' : ''}>${type}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3 mb-3">
                    <label class="form-label">模块</label>
                    <select name="moduleName" class="form-select">
                        <option value="">所有模块</option>
                        <c:forEach var="module" items="${moduleNames}">
                            <option value="${module}" ${moduleName == module ? 'selected' : ''}>${module}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3 mb-3">
                    <label class="form-label">操作人员</label>
                    <input type="text" name="adminName" class="form-control" 
                           placeholder="管理员姓名" value="${adminName}">
                </div>
                <div class="col-md-3 mb-3">
                    <label class="form-label">每页显示</label>
                    <select name="pageSize" class="form-select">
                        <option value="10" ${pageSize == 10 ? 'selected' : ''}>10条</option>
                        <option value="20" ${pageSize == 20 ? 'selected' : ''}>20条</option>
                        <option value="50" ${pageSize == 50 ? 'selected' : ''}>50条</option>
                        <option value="100" ${pageSize == 100 ? 'selected' : ''}>100条</option>
                    </select>
                </div>
            </div>
            <div class="row">
                <div class="col-md-4 mb-3">
                    <label class="form-label">开始日期</label>
                    <input type="date" name="startDate" class="form-control" value="${startDate}">
                </div>
                <div class="col-md-4 mb-3">
                    <label class="form-label">结束日期</label>
                    <input type="date" name="endDate" class="form-control" value="${endDate}">
                </div>
                <div class="col-md-4 mb-3">
                    <label class="form-label">&nbsp;</label>
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn-gradient-primary flex-fill">
                            <i class="bi bi-search me-2"></i>筛选
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/audit/list" 
                           class="btn-gradient-info">
                            <i class="bi bi-arrow-clockwise me-2"></i>重置
                        </a>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <!-- 统计信息 -->
    <div class="stats-section">
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">${totalCount}</div>
                <div class="stat-label">总审计记录</div>
            </div>

        </div>
    </div>

    <!-- 审计列表 -->
    <div class="card-custom">
        <div class="card-header-custom">
            <h5 class="mb-0">
                <i class="bi bi-list-ul me-2"></i>审计记录
                <span class="text-muted ms-2">(共 ${totalCount} 条记录)</span>
            </h5>
        </div>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <i class="bi bi-exclamation-triangle me-2"></i>${error}
            </div>
        </c:if>

        <div class="table-responsive">
            <table class="table table-custom">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>审计类型</th>
                        <th>模块</th>
                        <th>操作人员</th>
                        <th>操作描述</th>
                        <th>结果</th>
                        <th>IP地址</th>
                        <th>操作时间</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty audits}">
                            <c:forEach var="audit" items="${audits}">
                                <tr>
                                    <td>${audit.id}</td>
                                    <td>
                                        <span class="badge badge-audit-${audit.auditType}">
                                            ${audit.auditTypeDescription}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="text-info">${audit.moduleNameDescription}</span>
                                    </td>
                                    <td>
                                        <div>
                                            <strong>${audit.adminRealName != null ? audit.adminRealName : audit.adminName}</strong>
                                            <br>
                                            <small class="text-muted">${audit.adminRoleDescription}</small>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="text-truncate" style="max-width: 300px;" 
                                             title="${audit.operationDescription}">
                                            ${audit.operationDescription}
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge badge-result-${audit.operationResult}">
                                            ${audit.operationResultDescription}
                                        </span>
                                    </td>
                                    <td>
                                        <code class="text-warning">${audit.ipAddress}</code>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${audit.auditTime}" 
                                                       pattern="yyyy-MM-dd HH:mm:ss" />
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/audit/view/${audit.id}" 
                                           class="btn btn-sm btn-gradient-info" target="_blank">
                                            <i class="bi bi-eye me-1"></i>详情
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="9" class="text-center py-4">
                                    <div class="text-muted">
                                        <i class="bi bi-inbox me-2"></i>暂无审计记录
                                    </div>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <!-- 分页 -->
        <c:if test="${totalPages > 1}">
            <div class="pagination-custom">
                <!-- 上一页 -->
                <c:if test="${currentPage > 1}">
                    <a href="?page=${currentPage - 1}&pageSize=${pageSize}&auditType=${auditType}&moduleName=${moduleName}&adminName=${adminName}&startDate=${startDate}&endDate=${endDate}" 
                       class="page-link">
                        <i class="bi bi-chevron-left"></i>
                    </a>
                </c:if>

                <!-- 页码 -->
                <c:set var="startPage" value="${currentPage - 2}" />
                <c:set var="endPage" value="${currentPage + 2}" />
                <c:if test="${startPage < 1}">
                    <c:set var="startPage" value="1" />
                </c:if>
                <c:if test="${endPage > totalPages}">
                    <c:set var="endPage" value="${totalPages}" />
                </c:if>

                <c:if test="${startPage > 1}">
                    <a href="?page=1&pageSize=${pageSize}&auditType=${auditType}&moduleName=${moduleName}&adminName=${adminName}&startDate=${startDate}&endDate=${endDate}" 
                       class="page-link">1</a>
                    <c:if test="${startPage > 2}">
                        <span class="page-link">...</span>
                    </c:if>
                </c:if>

                <c:forEach var="pageNum" begin="${startPage}" end="${endPage}">
                    <a href="?page=${pageNum}&pageSize=${pageSize}&auditType=${auditType}&moduleName=${moduleName}&adminName=${adminName}&startDate=${startDate}&endDate=${endDate}" 
                       class="page-link ${pageNum == currentPage ? 'active' : ''}">${pageNum}</a>
                </c:forEach>

                <c:if test="${endPage < totalPages}">
                    <c:if test="${endPage < totalPages - 1}">
                        <span class="page-link">...</span>
                    </c:if>
                    <a href="?page=${totalPages}&pageSize=${pageSize}&auditType=${auditType}&moduleName=${moduleName}&adminName=${adminName}&startDate=${startDate}&endDate=${endDate}" 
                       class="page-link">${totalPages}</a>
                </c:if>

                <!-- 下一页 -->
                <c:if test="${currentPage < totalPages}">
                    <a href="?page=${currentPage + 1}&pageSize=${pageSize}&auditType=${auditType}&moduleName=${moduleName}&adminName=${adminName}&startDate=${startDate}&endDate=${endDate}" 
                       class="page-link">
                        <i class="bi bi-chevron-right"></i>
                    </a>
                </c:if>
            </div>
        </c:if>
    </div>
</div>

<script>
function exportAuditLog() {
    // 构建导出URL，包含当前的筛选条件
    const params = new URLSearchParams();
    const auditType = document.querySelector('select[name="auditType"]').value;
    const moduleName = document.querySelector('select[name="moduleName"]').value;
    const adminName = document.querySelector('input[name="adminName"]').value;
    const startDate = document.querySelector('input[name="startDate"]').value;
    const endDate = document.querySelector('input[name="endDate"]').value;
    
    if (auditType) params.append('auditType', auditType);
    if (moduleName) params.append('moduleName', moduleName);
    if (adminName) params.append('adminName', adminName);
    if (startDate) params.append('startDate', startDate);
    if (endDate) params.append('endDate', endDate);
    
    const url = `${pageContext.request.contextPath}/admin/audit/export?${params.toString()}`;
    window.open(url, '_blank');
}

// 自动提交表单当选择框改变时
document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('form');
    const selects = form.querySelectorAll('select[name="auditType"], select[name="moduleName"]');
    
    selects.forEach(select => {
        select.addEventListener('change', function() {
            // 延迟提交，给用户时间选择其他条件
            setTimeout(() => form.submit(), 100);
        });
    });
});
</script>

