<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="管理员详情" />
<c:set var="currentPage" value="admin" />
<%@ include file="../../common/header.jsp" %>

<style>
body {
    color: black;
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

.badge-status {
    font-size: 0.9rem;
    padding: 0.4rem 0.8rem;
    border-radius: 0.5rem;
    font-weight: 600;
}
.badge-active { 
    background: linear-gradient(90deg, #a8e6cf 0%, #dcedc8 100%); 
    color: #2e4d3a; 
}
.badge-inactive { 
    background: linear-gradient(90deg, #ffb3ba 0%, #ffc3c6 100%); 
    color: #5d2a2f; 
}
.badge-super-admin { 
    background: linear-gradient(90deg, #ffd700 0%, #ffed4e 100%); 
    color: #5d4e00; 
}
.badge-admin { 
    background: linear-gradient(90deg, #7ec8e3 0%, #b3e0f2 100%); 
    color: #2a4d5d; 
}
.overview-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 1.5rem;
    margin-top: 1rem;
}
.overview-item {
    display: flex;
    align-items: center;
    padding: 1rem;
    background: rgba(30,30,46,0.8);
    border: 1px solid rgba(255,255,255,0.1);
    border-radius: 0.75rem;
    gap: 1rem;
    transition: all 0.3s ease;
}
.overview-item:hover {
    background: lightgreen;
    transform: translateY(-2px);
}
.overview-icon {
    width: 50px;
    height: 50px;
    border-radius: 0.75rem;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.25rem;
    color: white;
    background: linear-gradient(135deg, #4f46e5, #7c3aed);
}
.overview-content {
    flex: 1;
}
.overview-label {
    color: #94a3b8;
    font-size: 0.875rem;
    margin-bottom: 0.25rem;
}
.overview-value {
   ;
    font-size: 1.1rem;
    font-weight: 600;
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
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/manager/list">管理员管理</a></li>
                            <li class="breadcrumb-item active">管理员详情</li>
                        </ol>
                    </nav>
                    <h1>管理员详情</h1>
                </div>
                <div class="col-auto">
                    <a href="${pageContext.request.contextPath}/admin/manager/list" class="btn btn-gradient-primary">
                        <i class="fas fa-arrow-left me-2"></i>返回列表
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/manager/edit/${admin.adminId}" class="btn btn-gradient-success" target="_blank">
                        <i class="fas fa-edit me-2"></i>编辑管理员
                    </a>
                </div>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>${error}
            </div>
        </c:if>

        <c:if test="${not empty admin}">
            
            <!-- 管理员概览 -->
            <div class="card-custom">
                <h4 class="mb-4" style="color: #a78bfa; font-weight: 700;">
                    <i class="fas fa-user-shield me-2"></i>管理员概览
                </h4>
                
                <div class="overview-grid">
                    <div class="overview-item">
                        <div class="overview-icon">
                            <i class="fas fa-hashtag"></i>
                        </div>
                        <div class="overview-content">
                            <div class="overview-label">管理员ID</div>
                            <div class="overview-value">#${admin.adminId}</div>
                        </div>
                    </div>
                    <div class="overview-item">
                        <div class="overview-icon">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="overview-content">
                            <div class="overview-label">姓名</div>
                            <div class="overview-value">${admin.name}</div>
                        </div>
                    </div>
                    <div class="overview-item">
                        <div class="overview-icon">
                            <i class="fas fa-sign-in-alt"></i>
                        </div>
                        <div class="overview-content">
                            <div class="overview-label">登录名</div>
                            <div class="overview-value">${admin.loginName}</div>
                        </div>
                    </div>
                    <div class="overview-item">
                        <div class="overview-icon">
                            <i class="fas fa-user-tag"></i>
                        </div>
                        <div class="overview-content">
                            <div class="overview-label">角色</div>
                            <div class="overview-value">
                                <c:choose>
                                    <c:when test="${admin.role == 'super_admin'}">
                                        <span class="badge-status badge-super-admin">
                                            <i class="fas fa-crown me-1"></i>超级管理员
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-status badge-admin">
                                            <i class="fas fa-user-shield me-1"></i>管理员
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    <div class="overview-item">
                        <div class="overview-icon">
                            <i class="fas fa-toggle-on"></i>
                        </div>
                        <div class="overview-content">
                            <div class="overview-label">状态</div>
                            <div class="overview-value">
                                <c:choose>
                                    <c:when test="${admin.status == 'active'}">
                                        <span class="badge-status badge-active">
                                            <i class="fas fa-check-circle me-1"></i>活跃
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-status badge-inactive">
                                            <i class="fas fa-times-circle me-1"></i>禁用
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    <c:if test="${not empty admin.createTime}">
                        <div class="overview-item">
                            <div class="overview-icon">
                                <i class="fas fa-calendar-plus"></i>
                            </div>
                            <div class="overview-content">
                                <div class="overview-label">创建时间</div>
                                <div class="overview-value">
                                    <fmt:formatDate value="${admin.createTime}" pattern="yyyy-MM-dd"/>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- 基本信息 -->
            <div class="card-custom">
                <h4 class="mb-4" style="color: #a78bfa; font-weight: 700;">
                    <i class="fas fa-info-circle me-2"></i>基本信息
                </h4>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="detail-label">管理员ID</div>
                        <div class="detail-value">${admin.adminId}</div>
                    </div>
                    <div class="col-md-6">
                        <div class="detail-label">姓名</div>
                        <div class="detail-value">${admin.name}</div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="detail-label">登录名</div>
                        <div class="detail-value">${admin.loginName}</div>
                    </div>
                    <div class="col-md-6">
                        <div class="detail-label">角色</div>
                        <div class="detail-value">
                            <c:choose>
                                <c:when test="${admin.role == 'super_admin'}">
                                    <span class="badge-status badge-super-admin">
                                        <i class="fas fa-crown me-1"></i>超级管理员
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-status badge-admin">
                                        <i class="fas fa-user-shield me-1"></i>管理员
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="detail-label">状态</div>
                        <div class="detail-value">
                            <c:choose>
                                <c:when test="${admin.status == 'active'}">
                                    <span class="badge-status badge-active">
                                        <i class="fas fa-check-circle me-1"></i>活跃
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-status badge-inactive">
                                        <i class="fas fa-times-circle me-1"></i>禁用
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <c:if test="${not empty admin.createTime}">
                        <div class="col-md-6">
                            <div class="detail-label">创建时间</div>
                            <div class="detail-value">
                                <fmt:formatDate value="${admin.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- 联系信息 -->
            <div class="card-custom">
                <h4 class="mb-4" style="color: #a78bfa; font-weight: 700;">
                    <i class="fas fa-address-book me-2"></i>联系信息
                </h4>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="detail-label">邮箱</div>
                        <div class="detail-value">
                            <c:choose>
                                <c:when test="${not empty admin.email}">
                                    <i class="fas fa-envelope me-2"></i>${admin.email}
                                </c:when>
                                <c:otherwise><span style="color: #94a3b8;">未设置</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="detail-label">手机号</div>
                        <div class="detail-value">
                            <c:choose>
                                <c:when test="${not empty admin.phone}">
                                    <i class="fas fa-phone me-2"></i>${admin.phone}
                                </c:when>
                                <c:otherwise><span style="color: #94a3b8;">未设置</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

        </c:if>

    </div>
</div>

