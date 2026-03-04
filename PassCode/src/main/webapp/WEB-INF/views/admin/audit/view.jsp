<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="审计详情" />
<c:set var="currentPage" value="system_audit" />
<%@ include file="../../common/header.jsp" %>

<style>
body {
    background: linear-gradient(135deg, #23233a 0%, #2d334d 100%) !important;
    color: #f5f6fa;
    min-height: 100vh;
}
.page-content, .page-content-body {
    color: #f5f6fa;
}
.card-custom {
    background: linear-gradient(135deg, rgba(44,54,80,0.97) 0%, rgba(25,28,38,0.98) 100%);
    border-radius: 1.1rem; 
    box-shadow: 0 2px 12px #0002; 
    padding: 2rem 1.5rem; 
    border: none;
    margin-bottom: 1.5rem;
}
.detail-label {
    color: #a78bfa;
    font-weight: 600;
    font-size: 1.02rem;
    margin-bottom: 0.3rem;
}
.detail-value {
    color: #f5f6fa;
    font-size: 1.05rem;
    font-weight: 500;
    margin-bottom: 1rem;
    padding: 0.5rem;
    background: rgba(50,54,80,0.5);
    border-radius: 0.5rem;
    border-left: 3px solid #4f46e5;
}
.badge-audit-type {
    font-size: 0.9rem;
    padding: 0.4rem 0.8rem;
    border-radius: 0.5rem;
    font-weight: 600;
}
.badge-login { background: linear-gradient(90deg, #a8e6cf 0%, #dcedc8 100%); color: #2e4d3a; }
.badge-logout { background: linear-gradient(90deg, #ffb3ba 0%, #ffc3c6 100%); color: #5d2a2f; }
.badge-create { background: linear-gradient(90deg, #7ec8e3 0%, #b3e0f2 100%); color: #2a4d5d; }
.badge-update { background: linear-gradient(90deg, #ffcc99 0%, #ffe0b3 100%); color: #5d3e2a; }
.badge-delete { background: linear-gradient(90deg, #ff9999 0%, #ffb3b3 100%); color: #5d2a2a; }
.badge-approve { background: linear-gradient(90deg, #b3d9ff 0%, #cce6ff 100%); color: #2a3d5d; }
.badge-reject { background: linear-gradient(90deg, #d9b3ff 0%, #e6ccff 100%); color: #3d2a5d; }
.badge-export { background: linear-gradient(90deg, #ffffb3 0%, #ffffcc 100%); color: #5d5d2a; }
.badge-import { background: linear-gradient(90deg, #b3ffb3 0%, #ccffcc 100%); color: #2a5d2a; }

.badge-success { background: linear-gradient(90deg, #a8e6cf 0%, #dcedc8 100%); color: #2e4d3a; }
.badge-failed { background: linear-gradient(90deg, #ffb3ba 0%, #ffc3c6 100%); color: #5d2a2f; }
.badge-partial { background: linear-gradient(90deg, #ffcc99 0%, #ffe0b3 100%); color: #5d3e2a; }

.json-container {
    background: rgba(30,34,50,0.8);
    border: 1px solid #4f46e5;
    border-radius: 0.5rem;
    padding: 1rem;
    font-family: 'Courier New', monospace;
    font-size: 0.9rem;
   ;
    max-height: 300px;
    overflow-y: auto;
    white-space: pre-wrap;
    word-wrap: break-word;
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
.page-header {
    background: lightgreen;
    border-radius: 1rem;
    padding: 1.5rem;
    margin-bottom: 2rem;
    border: none;
    box-shadow: 0 2px 12px #0002;
}
.page-header h1 {
    color: #f5f6fa;
    font-weight: 700;
    margin: 0;
    font-size: 1.8rem;
}
.breadcrumb {
    background: transparent;
    margin: 0;
    padding: 0;
}
.breadcrumb-item a {
    color: #a78bfa;
    text-decoration: none;
}
.breadcrumb-item.active {
    color: #f5f6fa;
}
.row-detail {
    margin-bottom: 1.5rem;
}
</style>

<div class="page-content">
    <div class="container-fluid">
        
        <!-- 页面标题 -->
        <div class="page-header">
            <div class="row align-items-center">
                <div class="col">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">控制台</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/audit/list">系统审计</a></li>
                            <li class="breadcrumb-item active">审计详情</li>
                        </ol>
                    </nav>
                    <h1>审计详情 #${audit.id}</h1>
                </div>
                <div class="col-auto">
                    <a href="${pageContext.request.contextPath}/admin/audit/list" class="btn btn-gradient-primary">
                        <i class="fas fa-arrow-left me-2"></i>返回列表
                    </a>
                </div>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>${error}
            </div>
        </c:if>

        <c:if test="${not empty audit}">
            
            <!-- 基本信息 -->
            <div class="card-custom">
                <h4 class="mb-4" style="color: #a78bfa; font-weight: 700;">
                    <i class="fas fa-info-circle me-2"></i>基本信息
                </h4>
                
                <div class="row row-detail">
                    <div class="col-md-6">
                        <div class="detail-label">审计ID</div>
                        <div class="detail-value">${audit.id}</div>
                    </div>
                    <div class="col-md-6">
                        <div class="detail-label">审计时间</div>
                        <div class="detail-value">
                            <fmt:formatDate value="${audit.auditTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                        </div>
                    </div>
                </div>
                
                <div class="row row-detail">
                    <div class="col-md-6">
                        <div class="detail-label">审计类型</div>
                        <div class="detail-value">
                            <span class="badge badge-audit-type badge-${audit.auditType}">
                                <c:choose>
                                    <c:when test="${audit.auditType == 'login'}">登录</c:when>
                                    <c:when test="${audit.auditType == 'logout'}">登出</c:when>
                                    <c:when test="${audit.auditType == 'create'}">创建</c:when>
                                    <c:when test="${audit.auditType == 'update'}">更新</c:when>
                                    <c:when test="${audit.auditType == 'delete'}">删除</c:when>
                                    <c:when test="${audit.auditType == 'approve'}">审批</c:when>
                                    <c:when test="${audit.auditType == 'reject'}">拒绝</c:when>
                                    <c:when test="${audit.auditType == 'export'}">导出</c:when>
                                    <c:when test="${audit.auditType == 'import'}">导入</c:when>
                                    <c:otherwise>${audit.auditType}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="detail-label">模块名称</div>
                        <div class="detail-value">
                            <c:choose>
                                <c:when test="${audit.moduleName == 'reservation'}">预约管理</c:when>
                                <c:when test="${audit.moduleName == 'department'}">部门管理</c:when>
                                <c:when test="${audit.moduleName == 'admin'}">管理员管理</c:when>
                                <c:when test="${audit.moduleName == 'blacklist'}">黑名单管理</c:when>
                                <c:when test="${audit.moduleName == 'user'}">用户管理</c:when>
                                <c:otherwise>${audit.moduleName}</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                
                <div class="row row-detail">
                    <div class="col-md-6">
                        <div class="detail-label">操作结果</div>
                        <div class="detail-value">
                            <span class="badge badge-audit-type badge-${audit.operationResult}">
                                <c:choose>
                                    <c:when test="${audit.operationResult == 'success'}">成功</c:when>
                                    <c:when test="${audit.operationResult == 'failed'}">失败</c:when>
                                    <c:when test="${audit.operationResult == 'partial'}">部分成功</c:when>
                                    <c:otherwise>${audit.operationResult}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="detail-label">目标记录ID</div>
                        <div class="detail-value">
                            <c:choose>
                                <c:when test="${not empty audit.targetId}">${audit.targetId}</c:when>
                                <c:otherwise><span style="color: #94a3b8;">无</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                
                <c:if test="${not empty audit.targetType}">
                    <div class="row row-detail">
                        <div class="col-md-12">
                            <div class="detail-label">目标类型</div>
                            <div class="detail-value">${audit.targetType}</div>
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- 操作人员信息 -->
            <div class="card-custom">
                <h4 class="mb-4" style="color: #a78bfa; font-weight: 700;">
                    <i class="fas fa-user me-2"></i>操作人员信息
                </h4>
                
                <div class="row row-detail">
                    <div class="col-md-6">
                        <div class="detail-label">管理员ID</div>
                        <div class="detail-value">${audit.adminId}</div>
                    </div>
                    <div class="col-md-6">
                        <div class="detail-label">管理员用户名</div>
                        <div class="detail-value">${audit.adminName}</div>
                    </div>
                </div>
                
                <div class="row row-detail">
                    <div class="col-md-6">
                        <div class="detail-label">管理员真实姓名</div>
                        <div class="detail-value">
                            <c:choose>
                                <c:when test="${not empty audit.adminRealName}">${audit.adminRealName}</c:when>
                                <c:otherwise><span style="color: #94a3b8;">未设置</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="detail-label">管理员角色</div>
                        <div class="detail-value">
                            <c:choose>
                                <c:when test="${not empty audit.adminRole}">${audit.adminRole}</c:when>
                                <c:otherwise><span style="color: #94a3b8;">未设置</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 操作详情 -->
            <div class="card-custom">
                <h4 class="mb-4" style="color: #a78bfa; font-weight: 700;">
                    <i class="fas fa-edit me-2"></i>操作详情
                </h4>
                
                <div class="row row-detail">
                    <div class="col-md-12">
                        <div class="detail-label">操作描述</div>
                        <div class="detail-value">${audit.operationDescription}</div>
                    </div>
                </div>
                
                <c:if test="${not empty audit.errorMessage}">
                    <div class="row row-detail">
                        <div class="col-md-12">
                            <div class="detail-label">错误信息</div>
                            <div class="detail-value" style="border-left-color: #ef4444; color: #fca5a5;">
                                ${audit.errorMessage}
                            </div>
                        </div>
                    </div>
                </c:if>
                
                <c:if test="${not empty audit.beforeData}">
                    <div class="row row-detail">
                        <div class="col-md-12">
                            <div class="detail-label">操作前数据</div>
                            <div class="json-container">${audit.beforeData}</div>
                        </div>
                    </div>
                </c:if>
                
                <c:if test="${not empty audit.afterData}">
                    <div class="row row-detail">
                        <div class="col-md-12">
                            <div class="detail-label">操作后数据</div>
                            <div class="json-container">${audit.afterData}</div>
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- 网络信息 -->
            <div class="card-custom">
                <h4 class="mb-4" style="color: #a78bfa; font-weight: 700;">
                    <i class="fas fa-network-wired me-2"></i>网络信息
                </h4>
                
                <div class="row row-detail">
                    <div class="col-md-6">
                        <div class="detail-label">IP地址</div>
                        <div class="detail-value">
                            <c:choose>
                                <c:when test="${not empty audit.ipAddress}">${audit.ipAddress}</c:when>
                                <c:otherwise><span style="color: #94a3b8;">未记录</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="detail-label">数据完整性</div>
                        <div class="detail-value">
                            <c:choose>
                                <c:when test="${not empty audit.dataIntegrity}">${audit.dataIntegrity}</c:when>
                                <c:otherwise><span style="color: #94a3b8;">未验证</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                
                <c:if test="${not empty audit.userAgent}">
                    <div class="row row-detail">
                        <div class="col-md-12">
                            <div class="detail-label">用户代理</div>
                            <div class="detail-value" style="word-break: break-all;">
                                ${audit.userAgent}
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>

        </c:if>

    </div>
</div>

<script>
$(document).ready(function() {
    // 格式化JSON数据显示
    $('.json-container').each(function() {
        var jsonText = $(this).text().trim();
        if (jsonText && jsonText.startsWith('{') || jsonText.startsWith('[')) {
            try {
                var jsonObj = JSON.parse(jsonText);
                $(this).text(JSON.stringify(jsonObj, null, 2));
            } catch (e) {
                // 如果不是有效的JSON，保持原样
            }
        }
    });
});
</script>
