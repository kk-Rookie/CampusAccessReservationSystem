<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="预约统计" />
<%@ include file="../../common/header.jsp" %>

<div class="page-content">
    <div class="content-header">
        <h2><i class="bi bi-graph-up me-2"></i>预约统计</h2>
    </div>

    <!-- 统计筛选器 -->
    <div class="card-custom mb-4">
        <div class="card-header-custom">
            <h5 class="mb-0">
                <i class="bi bi-funnel me-2"></i>统计筛选条件
            </h5>
        </div>
        <div class="card-body-custom">
            <form id="filterForm" method="get" action="${pageContext.request.contextPath}/admin/reservation/statistics">
                <div class="row">
                    <div class="col-md-3">
                        <label class="form-label dark-label">开始日期</label>
                        <input type="date" class="form-control dark-input" name="startDate" 
                               value="${param.startDate != null ? param.startDate : ''}" id="startDate">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label dark-label">结束日期</label>
                        <input type="date" class="form-control dark-input" name="endDate" 
                               value="${param.endDate != null ? param.endDate : ''}" id="endDate">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label dark-label">部门</label>
                        <select class="form-select dark-select" name="departmentId">
                            <option value="">全部部门</option>
                            <c:forEach var="dept" items="${departments}">
                                <option value="${dept.departmentId}" ${param.departmentId == dept.departmentId ? 'selected' : ''}>${dept.departmentName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3 d-flex align-items-end">
                        <button type="submit" class="btn btn-gradient-primary w-100">
                            <i class="bi bi-search me-2"></i>查询
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- 统计卡片 -->
    <div class="row mb-4">
        <div class="col-md-3 mb-3">
            <div class="stats-card gradient-primary">
                <div class="stats-icon">
                    <i class="bi bi-file-text"></i>
                </div>
                <div class="stats-content">
                    <div class="stats-number">
                        <c:choose>
                            <c:when test="${not empty totalCount}">
                                ${totalCount}
                            </c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stats-label">总预约数</div>

                </div>
            </div>
        </div>

        <div class="col-md-3 mb-3">
            <div class="stats-card gradient-warning">
                <div class="stats-icon">
                    <i class="bi bi-clock"></i>
                </div>
                <div class="stats-content">
                    <div class="stats-number">
                        <c:choose>
                            <c:when test="${not empty pendingCount}">
                                ${pendingCount}
                            </c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stats-label">待审核</div>

                </div>
            </div>
        </div>

        <div class="col-md-3 mb-3">
            <div class="stats-card gradient-success">
                <div class="stats-icon">
                    <i class="bi bi-check-circle"></i>
                </div>
                <div class="stats-content">
                    <div class="stats-number">
                        <c:choose>
                            <c:when test="${not empty approvedCount}">
                                ${approvedCount}
                            </c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stats-label">已通过</div>

                </div>
            </div>
        </div>

        <div class="col-md-3 mb-3">
            <div class="stats-card gradient-danger">
                <div class="stats-icon">
                    <i class="bi bi-x-circle"></i>
                </div>
                <div class="stats-content">
                    <div class="stats-number">
                        <c:choose>
                            <c:when test="${not empty rejectedCount}">
                                ${rejectedCount}
                            </c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stats-label">已拒绝</div>

                </div>
            </div>
        </div>
    </div>
</div>


<script>


function printStatistics() {
    window.print();
}

// 自动提交表单当日期改变时
document.getElementById('startDate').addEventListener('change', function() {
    if (this.value && document.getElementById('endDate').value) {
        document.getElementById('filterForm').submit();
    }
});

document.getElementById('endDate').addEventListener('change', function() {
    if (this.value && document.getElementById('startDate').value) {
        document.getElementById('filterForm').submit();
    }
});
</script>


<style>
body {

    min-height: 100vh;
}

.card-custom {

    border-radius: 1.1rem; box-shadow: 0 2px 12px #0002; padding: 2rem 1.5rem; border: none;
}
.form-label { color: green; font-weight: 600; font-size: 1.01rem; margin-bottom: 0.3rem; }
.form-control, .form-select, textarea {
    background: lightgreen;
    border-radius: 0.7rem; font-size: 1.05rem; font-weight: 500; min-height: 44px;
    box-shadow: none; transition: border-color 0.2s, box-shadow 0.2s;
}
.form-control:focus, .form-select:focus, textarea:focus {
    border-color: white; background: lightgreen; color: #fff; box-shadow: 0 0 0 2px #a78bfa44;
}
.btn-gradient-primary {
    background: linear-gradient(90deg, #7ec8e3 0%, #b3e0f2 100%);
    color: #fff !important;
    border: none;
    border-radius: 0.7rem !important;
    font-weight: 600;
    font-size: 1.02rem;
    padding: 0.5rem 1.1rem;
    margin-right: 0.3rem;
    box-shadow: 0 2px 8px #7ec8e322;
    transition: background 0.2s, color 0.2s, box-shadow 0.2s;
}
.btn-gradient-primary:hover {
    background: linear-gradient(90deg, #b3e0f2 0%, #7ec8e3 100%);
    color: #fff;
}
.btn-gradient-success {
    background: linear-gradient(90deg, #a8e6cf 0%, #dcedc8 100%);
    color: #2e4d3a !important;
    border: none;
    border-radius: 0.7rem !important;
    font-weight: 600;
    font-size: 1.02rem;
    padding: 0.5rem 1.1rem;
    margin-right: 0.3rem;
    box-shadow: 0 2px 8px #a8e6cf22;
    transition: background 0.2s, color 0.2s, box-shadow 0.2s;
}
.btn-gradient-success:hover {
    background: linear-gradient(90deg, #dcedc8 0%, #a8e6cf 100%);
    color: #2e4d3a !important;
}
.btn-gradient-danger {
    background: linear-gradient(90deg, #ffb3b3 0%, #ffd6d6 100%);
    color: #7a2e2e !important;
    border: none;
    border-radius: 0.7rem !important;
    font-weight: 600;
    font-size: 1.02rem;
    padding: 0.5rem 1.1rem;
    margin-right: 0.3rem;
    box-shadow: 0 2px 8px #ffb3b322;
    transition: background 0.2s, color 0.2s, box-shadow 0.2s;
}
.btn-gradient-danger:hover {
    background: linear-gradient(90deg, #ffd6d6 0%, #ffb3b3 100%);
    color: #7a2e2e !important;
}
.btn-gradient-outline {
    background: linear-gradient(90deg, #b2f7ef 0%, #e0f7fa 100%);
    color: #2d4d4d !important;
    border: none;
    border-radius: 0.7rem !important;
    font-weight: 600;
    font-size: 1.02rem;
    padding: 0.5rem 1.1rem;
    margin-right: 0.3rem;
    box-shadow: 0 2px 8px #b2f7ef22;
    transition: background 0.2s, color 0.2s, box-shadow 0.2s;
}
.btn-gradient-outline:hover {
    background: linear-gradient(90deg, #e0f7fa 0%, #b2f7ef 100%);
    color: #2d4d4d !important;
}

@media (max-width: 992px) {
    .form-control, .form-select, textarea { font-size: 0.98rem; min-height: 38px; }
}
</style>
