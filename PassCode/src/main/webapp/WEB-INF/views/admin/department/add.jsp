<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="添加部门" />
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
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/admin/department/list">部门管理</a>
                </li>
                <li class="breadcrumb-item active">添加部门</li>
            </ol>
        </nav>
    </div>

    <div class="page-content-body">
        <!-- 操作按钮 -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div></div>
            <a href="${pageContext.request.contextPath}/admin/department/list" class="btn btn-outline-light">
                <i class="bi bi-arrow-left me-2"></i>返回列表
            </a>
        </div>

        <!-- 错误消息 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show mb-4">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- 表单卡片 -->
        <div class="card-custom">
            <div class="card-header-custom">
                <h5 class="mb-0">
                    <i class="bi bi-building me-2"></i>部门信息
                </h5>
            </div>
            <div class="card-body-custom">
                <form id="addDepartmentForm" method="post" action="${pageContext.request.contextPath}/admin/department/add">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="deptName" class="form-label">
                                    <i class="bi bi-building me-1"></i>部门名称 <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="deptName" 
                                       name="deptName" 
                                       value="${department != null ? department.deptName : ''}"
                                       placeholder="请输入部门名称">
                                <div class="error-message" id="deptNameError"></div>
                                <div class="form-text">
                                    <i class="bi bi-info-circle me-1"></i>部门名称在系统中必须唯一
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="deptType" class="form-label">
                                    <i class="bi bi-bookmark me-1"></i>部门类型 <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="deptType" name="deptType">
                                    <option value="">-- 请选择部门类型 --</option>
                                    <option value="行政部门" ${department != null && department.deptType eq '行政部门' ? 'selected' : ''}>
                                        行政部门
                                    </option>
                                    <option value="直属部门" ${department != null && department.deptType eq '直属部门' ? 'selected' : ''}>
                                        直属部门
                                    </option>
                                    <option value="学院" ${department != null && department.deptType eq '学院' ? 'selected' : ''}>
                                        学院
                                    </option>
                                </select>
                                <div class="error-message" id="deptTypeError"></div>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">
                            <i class="bi bi-card-text me-1"></i>部门描述
                        </label>
                        <textarea class="form-control" id="description" name="description" 
                                  rows="4" placeholder="请输入部门描述信息（可选）">${department != null ? department.description : ''}</textarea>
                    </div>

                    <div class="mb-4">
                        <div class="form-text">
                            <i class="bi bi-info-circle text-info me-2"></i>
                            <strong>部门类型说明：</strong>
                            <ul class="mt-2 mb-0">
                                <li><strong>行政部门：</strong>如教务处、学生处、人事处等管理部门</li>
                                <li><strong>直属部门：</strong>如图书馆、实验中心、网络中心等服务部门</li>
                                <li><strong>学院：</strong>如信息学院、管理学院、理学院等教学部门</li>
                            </ul>
                        </div>
                    </div>

                    <!-- 按钮组 -->
                    <div class="d-flex justify-content-end gap-2 mt-4">
                        <a href="${pageContext.request.contextPath}/admin/department/list" class="btn btn-outline-light">
                            <i class="bi bi-x-circle me-2"></i>取消
                        </a>
                        <button type="button" class="btn btn-outline-warning" onclick="resetForm()">
                            <i class="bi bi-arrow-clockwise me-2"></i>重置
                        </button>
                        <button type="submit" class="btn btn-outline-primary">
                            <i class="bi bi-check-circle me-2"></i>保存部门
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- 操作提示 -->
        <div class="card-custom mt-4">
            <div class="card-header-custom">
                <h6 class="mb-0">
                    <i class="bi bi-lightbulb me-2"></i>操作提示
                </h6>
            </div>
            <div class="card-body-custom">
                <div class="row">
                    <div class="col-md-4">
                        <div class="d-flex align-items-center mb-2">
                            <i class="bi bi-check2-circle text-success me-2"></i>
                            <span>部门名称必须唯一</span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="d-flex align-items-center mb-2">
                            <i class="bi bi-check2-circle text-success me-2"></i>
                            <span>请选择正确的部门类型</span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="d-flex align-items-center mb-2">
                            <i class="bi bi-check2-circle text-success me-2"></i>
                            <span>可为部门分配管理员</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// 初始化时清除所有错误
document.addEventListener('DOMContentLoaded', function() {
    clearAllErrors();
});

// 重置表单
function resetForm() {
    document.getElementById('addDepartmentForm').reset();
    clearAllErrors();
}

// 清除所有错误信息
function clearAllErrors() {
    // 清除错误信息
    document.querySelectorAll('.error-message').forEach(function(element) {
        element.style.display = 'none';
        element.textContent = '';
        element.innerHTML = '';
    });
    
    // 移除错误样式
    document.querySelectorAll('.form-control, .form-select').forEach(function(element) {
        element.classList.remove('is-invalid');
    });
}

// 显示错误信息
function showError(fieldId, message) {
    const field = document.getElementById(fieldId);
    const errorDiv = document.getElementById(fieldId + 'Error');
    
    if (field && errorDiv) {
        field.classList.add('is-invalid');
        errorDiv.textContent = message;
        errorDiv.style.display = 'block';
        errorDiv.style.color = '#f87171';
        errorDiv.style.fontSize = '0.875rem';
        errorDiv.style.marginTop = '0.25rem';
    }
}

// 清除特定字段错误
function clearError(fieldId) {
    const field = document.getElementById(fieldId);
    const errorDiv = document.getElementById(fieldId + 'Error');
    
    if (field && errorDiv) {
        field.classList.remove('is-invalid');
        errorDiv.textContent = '';
        errorDiv.style.display = 'none';
    }
}

// 表单提交处理
document.getElementById('addDepartmentForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    // 清除之前的错误
    clearAllErrors();
    
    // 基本验证
    let valid = true;
    
    // 检查部门名称
    const deptName = document.getElementById('deptName').value.trim();
    if (!deptName) {
        showError('deptName', '请输入部门名称');
        valid = false;
    } else if (deptName.length < 2) {
        showError('deptName', '部门名称至少需要2个字符');
        valid = false;
    }
    
    // 检查部门类型
    const deptType = document.getElementById('deptType').value;
    if (!deptType) {
        showError('deptType', '请选择部门类型');
        valid = false;
    }
    
    if (!valid) {
        showAlert('请完善必填信息', 'warning');
        return;
    }
    
    // 显示加载状态
    const submitBtn = this.querySelector('button[type="submit"]');
    const originalText = submitBtn.innerHTML;
    submitBtn.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>保存中...';
    submitBtn.disabled = true;
    
    // 提交表单
    fetch(this.action, {
        method: 'POST',
        body: new FormData(this)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showAlert('部门添加成功', 'success');
            setTimeout(() => {
                window.location.href = '${pageContext.request.contextPath}/admin/department/list';
            }, 1000);
        } else {
            showAlert(data.message || '添加失败', 'danger');
            submitBtn.innerHTML = originalText;
            submitBtn.disabled = false;
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showAlert('网络错误，请稍后重试', 'danger');
        submitBtn.innerHTML = originalText;
        submitBtn.disabled = false;
    });
});

// 实时验证 - 只在有值时清除错误
document.getElementById('deptName').addEventListener('input', function() {
    if (this.value.trim()) {
        clearError('deptName');
    }
});

document.getElementById('deptType').addEventListener('change', function() {
    if (this.value) {
        clearError('deptType');
    }
});

// 显示提示信息
function showAlert(message, type) {
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-' + type + ' alert-dismissible fade show position-fixed';
    alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
    alertDiv.innerHTML = 
        message +
        '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
    document.body.appendChild(alertDiv);
    
    setTimeout(() => {
        if (alertDiv.parentNode) {
            alertDiv.remove();
        }
    }, 3000);
}
</script>
                            <strong>部门类型说明：</strong>
                            <ul class="mt-2 mb-0">
                                <li><strong>行政部门：</strong>如教务处、学生处、人事处等管理部门</li>
                                <li><strong>直属部门：</strong>如图书馆、实验中心、网络中心等服务部门</li>
                                <li><strong>学院：</strong>如信息学院、管理学院、理学院等教学部门</li>
                            </ul>
                        </div>
                    </div>

                    <!-- 按钮组 -->
                    <div class="d-flex justify-content-end gap-2 mt-4">
                        <a href="${pageContext.request.contextPath}/admin/department/list" class="btn btn-outline-light">
                            <i class="bi bi-x-circle me-2"></i>取消
                        </a>
                        <button type="button" class="btn btn-outline-warning" onclick="resetForm()">
                            <i class="bi bi-arrow-clockwise me-2"></i>重置
                        </button>
                        <button type="submit" class="btn btn-outline-primary">
                            <i class="bi bi-check-circle me-2"></i>保存部门
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- 操作提示 -->
        <div class="card-custom mt-4">
            <div class="card-header-custom">
                <h6 class="mb-0">
                    <i class="bi bi-lightbulb me-2"></i>操作提示
                </h6>
            </div>
            <div class="card-body-custom">
                <div class="row">
                    <div class="col-md-4">
                        <div class="d-flex align-items-center mb-2">
                            <i class="bi bi-check2-circle text-success me-2"></i>
                            <span>部门名称必须唯一</span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="d-flex align-items-center mb-2">
                            <i class="bi bi-check2-circle text-success me-2"></i>
                            <span>请选择正确的部门类型</span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="d-flex align-items-center mb-2">
                            <i class="bi bi-check2-circle text-success me-2"></i>
                            <span>可为部门分配管理员</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// 重置表单
function resetForm() {
    document.getElementById('addDepartmentForm').reset();
    clearAllErrors();
}

// 清除所有错误信息
function clearAllErrors() {
    document.querySelectorAll('.error-message').forEach(function(element) {
        element.style.display = 'none';
        element.textContent = '';
    });
    document.querySelectorAll('.form-control, .form-select').forEach(function(element) {
        element.classList.remove('is-invalid');
    });
}

// 显示错误信息
function showError(fieldId, message) {
    const field = document.getElementById(fieldId);
    const errorDiv = document.getElementById(fieldId + 'Error');
    
    if (field && errorDiv) {
        field.classList.add('is-invalid');
        errorDiv.textContent = message;
        errorDiv.style.display = 'block';
    }
}

// 清除特定字段错误
function clearError(fieldId) {
    const field = document.getElementById(fieldId);
    const errorDiv = document.getElementById(fieldId + 'Error');
    
    if (field && errorDiv) {
        field.classList.remove('is-invalid');
        errorDiv.textContent = '';
        errorDiv.style.display = 'none';
    }
}

// 表单提交处理
document.getElementById('addDepartmentForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    // 清除之前的错误
    clearAllErrors();
    
    // 基本验证
    let valid = true;
    
    // 检查部门名称
    const deptName = document.getElementById('deptName').value.trim();
    if (!deptName) {
        showError('deptName', '请输入部门名称');
        valid = false;
    } else if (deptName.length < 2) {
        showError('deptName', '部门名称至少需要2个字符');
        valid = false;
    }
    
    // 检查部门类型
    const deptType = document.getElementById('deptType').value;
    if (!deptType) {
        showError('deptType', '请选择部门类型');
        valid = false;
    }
    
    if (!valid) {
        showAlert('请完善必填信息', 'warning');
        return;
    }
    
    // 显示加载状态
    const submitBtn = this.querySelector('button[type="submit"]');
    const originalText = submitBtn.innerHTML;
    submitBtn.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>保存中...';
    submitBtn.disabled = true;
    
    // 提交表单
    fetch(this.action, {
        method: 'POST',
        body: new FormData(this)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showAlert('部门添加成功', 'success');
            setTimeout(() => {
                window.location.href = '${pageContext.request.contextPath}/admin/department/list';
            }, 1000);
        } else {
            showAlert(data.message || '添加失败', 'danger');
            submitBtn.innerHTML = originalText;
            submitBtn.disabled = false;
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showAlert('网络错误，请稍后重试', 'danger');
        submitBtn.innerHTML = originalText;
        submitBtn.disabled = false;
    });
});

// 实时验证
document.getElementById('deptName').addEventListener('input', function() {
    if (this.value.trim()) {
        clearError('deptName');
    }
});

document.getElementById('deptType').addEventListener('change', function() {
    if (this.value) {
        clearError('deptType');
    }
});

// 显示提示信息
function showAlert(message, type) {
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-' + type + ' alert-dismissible fade show position-fixed';
    alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
    alertDiv.innerHTML = 
        message +
        '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
    document.body.appendChild(alertDiv);
    
    setTimeout(() => {
        if (alertDiv.parentNode) {
            alertDiv.remove();
        }
    }, 3000);
}
</script>

<style>


/* 响应式设计 */
@media (max-width: 768px) {
    .card-body-custom {
        padding: 1.5rem;
    }
    
    .btn-outline-primary,
    .btn-outline-light,
    .btn-outline-warning {
        padding: 0.5rem 1rem;
        font-size: 0.875rem;
    }
}
</style>
