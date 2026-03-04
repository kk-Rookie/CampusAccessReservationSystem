<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="编辑管理员" />
<%@ include file="../../common/header.jsp" %>

<div class="page-content">
    <div class="content-header">
        <h1>${pageTitle}</h1>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="bi bi-house"></i> 首页
                    </a>
                </li>
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/admin/manager/list">管理员管理</a>
                </li>
                <li class="breadcrumb-item active">编辑管理员</li>
            </ol>
        </nav>
    </div>

    <div class="page-content-body">
        <!-- 错误消息 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show mb-4">
                <i class="bi bi-exclamation-triangle me-2"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- 操作按钮 -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div></div>
            <a href="${pageContext.request.contextPath}/admin/manager/list" class="btn btn-outline-light">
                <i class="bi bi-arrow-left me-2"></i>返回列表
            </a>
        </div>

        <div class="row g-4">
            <!-- 管理员头像和基本信息 -->
            <div class="col-lg-4">
                <div class="card-custom h-100">
                    <div class="card-header-custom">
                        <h5 class="mb-0">
                            <i class="bi bi-person-circle me-2"></i>管理员信息
                        </h5>
                    </div>
                    <div class="card-body-custom text-center">
                        <div class="admin-avatar mx-auto mb-3">
                            ${admin_user.name.substring(0, 1)}
                        </div>
                        <h5 class="text-white mb-2">${admin_user.name}</h5>
                        <p class="text-muted mb-4">
                            <i class="bi bi-at me-1"></i> ${admin_user.loginName}
                        </p>
                        
                        <div class="admin-info">
                            <div class="info-item">
                                <label class="info-label">管理员ID</label>
                                <div class="info-value">${admin_user.adminId}</div>
                            </div>
                            <div class="info-item">
                                <label class="info-label">当前部门</label>
                            <div class="info-value">${admin_user.deptName}</div>
                        </div>
                        <div class="info-item">
                            <label class="info-label">联系电话</label>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty admin_user.phone}">
                                        ${admin_user.phone}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">未填写</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 编辑表单 -->
        <div class="col-lg-8">
            <div class="card-custom">
                <div class="card-header-custom">
                    <h5 class="mb-0">
                        <i class="bi bi-pencil-square me-2"></i>编辑管理员信息
                    </h5>
                </div>
                <div class="card-body-custom">
                    <form action="${pageContext.request.contextPath}/admin/manager/edit" method="post" 
                          class="needs-validation" novalidate id="editManagerForm">
                        <input type="hidden" name="adminId" value="${admin.adminId}">

                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="name" class="form-label">
                                        <i class="bi bi-person me-1"></i> 姓名 <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="name" name="name" required
                                           value="${admin_user.name != null ? admin_user.name : ''}" placeholder="请输入真实姓名">
                                    <div class="invalid-feedback">请输入姓名</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="loginName" class="form-label">
                                        <i class="bi bi-at me-1"></i> 登录名
                                    </label>
                                    <input type="text" class="form-control" id="loginName" 
                                           value="${admin_user.loginName != null ? admin_user.loginName : ''}" disabled>
                                    <div class="form-text">
                                        <i class="bi bi-info-circle me-1"></i> 登录名不允许修改
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="deptId" class="form-label">
                                <i class="bi bi-building me-1"></i> 所属部门 <span class="text-danger">*</span>
                            </label>
                            <select class="form-select" id="deptId" name="deptId" required>
                                <option value="">-- 请选择部门 --</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.deptId}"
                                        ${admin_user.deptId eq dept.deptId ? 'selected' : ''}>
                                            ${dept.deptName} (${dept.deptType})
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">请选择所属部门</div>
                        </div>

                        <div class="form-group">
                            <label for="phone" class="form-label">
                                <i class="bi bi-telephone me-1"></i> 联系电话
                            </label>
                            <input type="tel" class="form-control" id="phone" name="phone"
                                   value="${admin_user.phone}" placeholder="请输入11位手机号" pattern="^[0-9]{11}$">
                            <div class="invalid-feedback">请输入正确的11位手机号</div>
                        </div>

                        <div class="form-group">
                            <label for="password" class="form-label">
                                <i class="bi bi-lock me-1"></i> 新密码
                                <small class="text-muted">(留空表示不修改密码)</small>
                            </label>
                            <div class="input-group">
                                <input type="password" class="form-control" id="password" name="password"
                                       placeholder="请输入新密码，至少6个字符" minlength="6">
                                <button type="button" class="btn btn-outline-secondary" onclick="togglePassword()">
                                    <i class="bi bi-eye" id="toggleIcon"></i>
                                </button>
                            </div>
                            <div class="form-text">
                                <i class="bi bi-info-circle me-1"></i>
                                如果要修改密码，请输入新密码；否则请留空
                            </div>
                        </div>

                        <div class="d-flex justify-content-end gap-2 mt-4">
                            <a href="${pageContext.request.contextPath}/admin/manager/list" 
                               class="btn btn-outline-light">
                                <i class="bi bi-x-circle me-1"></i> 取消
                            </a>
                            <button type="reset" class="btn btn-outline-warning">
                                <i class="bi bi-arrow-clockwise me-1"></i> 重置
                            </button>
                            <button type="submit" class="btn btn-outline-primary">
                                <i class="bi bi-check-circle me-1"></i> 保存修改
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 提示信息 -->
            <div class="card-custom mt-4">
                <div class="card-header-custom">
                    <h6 class="mb-0">
                        <i class="bi bi-lightbulb me-2"></i> 操作提示
                    </h6>
                </div>
                <div class="card-body-custom">
                    <div class="tip-item">
                        <i class="bi bi-check2 text-success me-2"></i>
                        <span>登录名创建后不能修改，如需修改请联系系统管理员</span>
                    </div>
                    <div class="tip-item">
                        <i class="bi bi-check2 text-success me-2"></i>
                        <span>修改密码后请及时通知相关管理员</span>
                    </div>
                    <div class="tip-item">
                        <i class="bi bi-check2 text-success me-2"></i>
                            <span>部门变更会立即生效，影响管理员的权限范围</span>
                        </div>
                        <div class="tip-item">
                            <i class="bi bi-check2 text-success me-2"></i>
                            <span>联系电话为可选项，建议保持最新</span>
                        </div>
                    </div>
                </div>
            </div>
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

        font-weight: 600;
        margin: 0;
    }

    .card-body-custom {
        padding: 2rem;
    }

    /* 表单样式 */
    .form-label {

        font-weight: 500;
        margin-bottom: 0.5rem;
    }

    .form-control, .form-select {

        border: 1px solid rgba(255, 255, 255, 0.2);

        border-radius: 0.5rem;
    }

    .form-control:focus, .form-select:focus {

        border-color: green;
        box-shadow: 0 0 0 0.2rem rgba(79, 70, 229, 0.25);

    }



    .form-text {

        font-size: 0.875rem;
    }

    .invalid-feedback {
        color: #f87171;
    }

    .is-invalid {
        border-color: #ef4444;
        box-shadow: 0 0 0 0.2rem rgba(239, 68, 68, 0.25);
    }

    /* 按钮样式 */
    .btn-gradient-primary {
        background: green;
        color: white;
        padding: 0.75rem 1.5rem;
        border-radius: 0.5rem;
        font-weight: 500;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        text-decoration: none;
    }

    .btn-gradient-primary:hover {
        background: green;
        color: white;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(124, 58, 237, 0.4);
    }

    .btn-outline-light {
        background: transparent;
        border: 1px solid rgba(255, 255, 255, 0.3);
       ;
        padding: 0.5rem 1rem;
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

    .btn-outline-warning {
        background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
        border: none;
        color: white;
        padding: 0.5rem 1rem;
        border-radius: 0.5rem;
        font-weight: 500;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        text-decoration: none;
    }

    .btn-outline-warning:hover {
        background: linear-gradient(135deg, #d97706 0%, #b45309 100%);
        color: white;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(217, 119, 6, 0.4);
    }

    /* 警告和提示框样式 */
    .alert {
        border: none;
        border-radius: 0.75rem;
        padding: 1rem 1.5rem;
    }

    .alert-danger {
        background: linear-gradient(135deg, rgba(239, 68, 68, 0.2), rgba(220, 38, 38, 0.2));
        border: 1px solid rgba(239, 68, 68, 0.3);
        color: #fca5a5;
    }

    .alert-info {
        background: linear-gradient(135deg, rgba(6, 182, 212, 0.2), rgba(8, 145, 178, 0.2));
        border: 1px solid rgba(6, 182, 212, 0.3);
        color: #7dd3fc;
    }

    /* 状态颜色 */
    .text-danger {
        color: #f87171 !important;
    }

    .text-info {
        color: #60a5fa !important;
    }

    .text-success {
        color: #34d399 !important;
    }

    .text-warning {
        color: #fbbf24 !important;
    }

    .text-light-muted {
        color: #94a3b8 !important;
    }

    /* 统计卡片样式 */
    .stat-card-small {
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

    .stat-card-small:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
        border-color: rgba(255, 255, 255, 0.2);
    }

    .stat-icon {
        width: 3rem;
        height: 3rem;
        border-radius: 0.75rem;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.25rem;
        color: white;
    }

    .stat-icon.bg-primary {
        background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
    }

    .stat-icon.bg-success {
        background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    }

    .stat-icon.bg-warning {
        background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
    }

    .stat-info h6 {
        color: #94a3b8;
        font-size: 0.875rem;
        margin-bottom: 0.25rem;
        font-weight: 500;
    }

    .stat-number {
       ;
        font-size: 1.5rem;
        font-weight: 700;
    }

    .stat-text {
       ;
        font-size: 0.875rem;
        font-weight: 500;
    }

    /* 响应式设计 */
    @media (max-width: 768px) {
        .card-body-custom {
            padding: 1.5rem;
        }

        .btn-group .btn {
            padding: 0.5rem;
            font-size: 0.875rem;
        }
    }
</style>

.is-invalid {
border-color: #dc3545;
box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
}

.invalid-feedback {
display: block;
width: 100%;
margin-top: 0.25rem;
font-size: 0.875em;
color: #dc3545;
}

.form-label {
font-weight: 500;
margin-bottom: 0.5rem;
color:white;
}

.form-control,
.form-select {
background-color: white;
border: 1px solid rgba(255, 255, 255, 0.2);
color:white;
transition: all 0.3s ease;
}

.form-control::placeholder {
color: rgba(226, 232, 240, 0.6);
}

.form-control:focus,
.form-select:focus {
background-color: white;
border-color: #4f46e5;
color:white;
}

.form-control[readonly] {
background-color: rgba(30, 30, 46, 0.5);
border-color: rgba(255, 255, 255, 0.1);
color: #94a3b8;
}

.form-text {
color: rgba(226, 232, 240, 0.7);
font-size: 0.875rem;
}

.text-danger {
color: #f87171 !important;
}

.text-info {
color: #60a5fa !important;
}

.text-success {
color: #34d399 !important;
}

.text-warning {
color: #fbbf24 !important;
}

.btn-outline-warning {
background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
border: none;
color: white;
padding: 0.5rem 1rem;
border-radius: 0.5rem;
font-weight: 500;
transition: all 0.3s ease;
display: inline-flex;
align-items: center;
text-decoration: none;
}

.btn-outline-warning:hover {
background: linear-gradient(135deg, #d97706 0%, #b45309 100%);
color: white;
transform: translateY(-2px);
box-shadow: 0 4px 12px rgba(217, 119, 6, 0.4);
}
</style>

<script>
    // 页面加载时隐藏所有错误提示
    document.addEventListener('DOMContentLoaded', function() {
        var invalidFeedbacks = document.querySelectorAll('.invalid-feedback');
        invalidFeedbacks.forEach(function(element) {
            element.style.display = 'none';
        });
    });

    // 表单验证
    (function() {
        'use strict';
        var forms = document.querySelectorAll('.needs-validation');
        Array.prototype.slice.call(forms).forEach(function(form) {
            form.addEventListener('submit', function(event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                    
                    // 滚动到第一个错误字段
                    var firstInvalidField = form.querySelector(':invalid');
                    if (firstInvalidField) {
                        firstInvalidField.focus();
                        firstInvalidField.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }
                }
                form.classList.add('was-validated');
            }, false);
        });
    })();

    // 密码可见性切换
    function togglePassword() {
        var passwordInput = document.getElementById('password');
        var toggleIcon = document.getElementById('toggleIcon');

        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            toggleIcon.className = 'bi bi-eye-slash';
        } else {
            passwordInput.type = 'password';
            toggleIcon.className = 'bi bi-eye';
        }
    }

    // 密码强度检测
    document.getElementById('password').addEventListener('input', function() {
        var password = this.value;
        var strengthBar = document.getElementById('passwordStrength');

        if (password.length === 0) {
            strengthBar.style.width = '0%';
            strengthBar.className = 'password-strength';
        } else if (password.length < 6) {
            strengthBar.style.width = '33%';
            strengthBar.className = 'password-strength strength-weak';
        } else if (password.length < 10) {
            strengthBar.style.width = '66%';
            strengthBar.className = 'password-strength strength-medium';
        } else {
            strengthBar.style.width = '100%';
            strengthBar.className = 'password-strength strength-strong';
        }
    });

    // 手机号实时验证
    document.getElementById('phone').addEventListener('input', function() {
        var phone = this.value;
        var phoneRegex = /^[0-9]{11}$/;
        
        if (phone && !phoneRegex.test(phone)) {
            this.setCustomValidity('请输入正确的11位手机号');
        } else {
            this.setCustomValidity('');
        }
    });

    // 表单重置时清空验证状态
    document.querySelector('[type="reset"]').addEventListener('click', function() {
        setTimeout(function() {
            document.getElementById('editManagerForm').classList.remove('was-validated');
            document.getElementById('passwordStrength').style.width = '0%';
            document.getElementById('passwordStrength').className = 'password-strength';
        }, 10);
    });
</script>
