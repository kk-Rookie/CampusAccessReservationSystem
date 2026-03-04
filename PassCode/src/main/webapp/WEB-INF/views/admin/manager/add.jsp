<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="添加管理员" />
<%@ include file="../../common/header.jsp" %>

<div class="page-content">
    <div class="content-header">
        <div class="d-flex justify-content-between align-items-center">
            <h2><i class="bi bi-person-plus me-2"></i>添加管理员</h2>
            <a href="${pageContext.request.contextPath}/admin/manager/list" class="btn-outline-light">
                <i class="bi bi-arrow-left me-2"></i>返回列表
            </a>
        </div>
    </div>

    <!-- 错误消息 -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- 表单卡片 -->
    <div class="card-custom">
        <div class="card-header-custom">
            <h5 class="mb-0">
                <i class="bi bi-person-circle me-2"></i>管理员信息
            </h5>
        </div>
        <div class="card-body-custom">
            <form id="addManagerForm" method="post" action="${pageContext.request.contextPath}/admin/manager/add" novalidate>
                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="name" class="form-label dark-label">
                                <i class="bi bi-person me-1"></i>姓名 <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control dark-input" id="name" 
                                   name="name" required 
                                   placeholder="请输入管理员姓名">
                            <div class="invalid-feedback">
                                请输入管理员姓名
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="username" class="form-label dark-label">
                                <i class="bi bi-at me-1"></i>用户名 <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control dark-input" id="username" 
                                   name="username" required 
                                   placeholder="请输入用户名(登录账号)">
                            <div class="invalid-feedback">
                                请输入用户名
                            </div>
                            <div class="form-text text-light">
                                <i class="bi bi-info-circle me-1"></i>用户名用于登录，建议使用字母数字组合
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="password" class="form-label dark-label">
                                <i class="bi bi-key me-1"></i>密码 <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <input type="password" class="form-control dark-input" id="password" 
                                       name="password" required 
                                       placeholder="请输入密码">
                                <button class="btn btn-outline-secondary dark-btn-outline" type="button" id="togglePassword">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                            <div class="password-strength" id="passwordStrength"></div>
                            <div class="invalid-feedback">
                                请输入密码
                            </div>
                            <div class="form-text text-light">
                                <i class="bi bi-info-circle me-1"></i>密码长度至少6位，建议包含字母和数字
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label dark-label">
                                <i class="bi bi-key-fill me-1"></i>确认密码 <span class="text-danger">*</span>
                            </label>
                            <input type="password" class="form-control dark-input" id="confirmPassword" 
                                   name="confirmPassword" required 
                                   placeholder="请再次输入密码">
                            <div class="invalid-feedback">
                                两次密码输入不一致
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="role" class="form-label dark-label">
                                <i class="bi bi-shield me-1"></i>角色 <span class="text-danger">*</span>
                            </label>
                            <select class="form-select dark-select" id="role" name="role" required>
                                <option value="" selected disabled>-- 请选择角色 --</option>
                                <option value="超级管理员">超级管理员</option>
                                <option value="普通管理员">普通管理员</option>
                            </select>
                            <div class="invalid-feedback">
                                请选择角色
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="status" class="form-label dark-label">
                                <i class="bi bi-toggle-on me-1"></i>状态
                            </label>
                            <select class="form-select dark-select" id="status" name="status">
                                <option value="1" selected>启用</option>
                                <option value="0">禁用</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="phone" class="form-label dark-label">
                                <i class="bi bi-telephone me-1"></i>联系电话
                            </label>
                            <input type="tel" class="form-control dark-input" id="phone" name="phone">
                            <div class="invalid-feedback">
                                请输入正确的手机号码
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="email" class="form-label dark-label">
                                <i class="bi bi-envelope me-1"></i>邮箱地址
                            </label>
                            <input type="email" class="form-control dark-input" id="email" name="email">
                            <div class="invalid-feedback">
                                请输入正确的邮箱地址
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="remark" class="form-label dark-label">
                        <i class="bi bi-card-text me-1"></i>备注
                    </label>
                    <textarea class="form-control dark-input" id="remark" name="remark" rows="3" placeholder="请输入备注信息（可选）"></textarea>
                </div>

                <div class="mb-4">
                    <div class="form-text text-light">
                        <i class="bi bi-info-circle text-info me-2"></i>
                        <strong>角色权限说明：</strong>
                        <ul class="mt-2 mb-0">
                            <li><strong>超级管理员：</strong>拥有系统所有权限，可以管理其他管理员</li>
                            <li><strong>普通管理员：</strong>可以管理预约和部门信息，但不能管理其他管理员</li>
                        </ul>
                    </div>
                </div>

                <!-- 按钮组 -->
                <div class="d-flex justify-content-end gap-2 mt-4">
                    <a href="${pageContext.request.contextPath}/admin/manager/list" class="btn btn-outline-light">
                        <i class="bi bi-x-circle me-2"></i>取消
                    </a>
                    <button type="reset" class="btn btn-outline-warning">
                        <i class="bi bi-arrow-clockwise me-2"></i>重置
                    </button>
                    <button type="submit" class="btn btn-gradient-primary">
                        <i class="bi bi-check-circle me-2"></i>保存
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- 操作提示 -->
    <div class="card-custom mt-4">
        <div class="card-header-custom">
            <h6 class="mb-0">
                <i class="bi bi-lightbulb text-warning me-2"></i>操作提示
            </h6>
        </div>
        <div class="card-body-custom">
            <div class="row">
                <div class="col-md-6">
                    <div class="d-flex align-items-center mb-2">
                        <i class="bi bi-check2-circle text-success me-2"></i>
                        <span>用户名必须唯一，不能重复</span>
                    </div>
                    <div class="d-flex align-items-center mb-2">
                        <i class="bi bi-check2-circle text-success me-2"></i>
                        <span>密码至少6位，建议强密码</span>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="d-flex align-items-center mb-2">
                        <i class="bi bi-check2-circle text-success me-2"></i>
                        <span>超级管理员权限较高，请谨慎分配</span>
                    </div>
                    <div class="d-flex align-items-center mb-2">
                        <i class="bi bi-check2-circle text-success me-2"></i>
                        <span>联系方式便于后续沟通</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    // 页面加载时隐藏所有错误提示
    $('.invalid-feedback').hide();
    
    // 密码可见性切换
    $('#togglePassword').click(function() {
        const password = $('#password');
        const icon = $(this).find('i');
        
        if (password.attr('type') === 'password') {
            password.attr('type', 'text');
            icon.removeClass('bi-eye').addClass('bi-eye-slash');
        } else {
            password.attr('type', 'password');
            icon.removeClass('bi-eye-slash').addClass('bi-eye');
        }
    });
    
    // 设置字段错误
    function setFieldError(field, message) {
        if (message && message.trim() !== '') {
            field.addClass('is-invalid');
            const feedback = field.siblings('.invalid-feedback');
            if (feedback.length > 0) {
                feedback.text(message).show();
            }
        }
    }
    
    // 清除字段错误
    function clearFieldError(field) {
        field.removeClass('is-invalid');
        const feedback = field.siblings('.invalid-feedback');
        if (feedback.length > 0) {
            feedback.hide();
        }
    }
    
    // 密码强度检测
    $('#password').on('input', function() {
        const password = $(this).val();
        const strengthBar = $('#passwordStrength');
        let strength = 0;
        
        // 清除验证错误状态
        clearFieldError($(this));
        
        // 计算密码强度
        if (password.length >= 6) strength++;
        if (password.match(/[a-z]/)) strength++;
        if (password.match(/[A-Z]/)) strength++;
        if (password.match(/[0-9]/)) strength++;
        if (password.match(/[^a-zA-Z0-9]/)) strength++;
        
        // 更新强度显示
        strengthBar.removeClass('strength-weak strength-medium strength-strong');
        if (password.length === 0) {
            strengthBar.css('width', '0%');
        } else if (strength <= 2) {
            strengthBar.addClass('strength-weak').css('width', '33%');
        } else if (strength <= 3) {
            strengthBar.addClass('strength-medium').css('width', '66%');
        } else {
            strengthBar.addClass('strength-strong').css('width', '100%');
        }
        
        // 验证确认密码匹配
        validatePasswordConfirmation();
    });
    
    // 确认密码验证
    $('#confirmPassword').on('input', function() {
        clearFieldError($(this));
        validatePasswordConfirmation();
    });
    
    // 验证密码确认
    function validatePasswordConfirmation() {
        const password = $('#password').val();
        const confirmPassword = $('#confirmPassword').val();
        const confirmField = $('#confirmPassword');
        
        if (confirmPassword.length > 0) {
            if (password !== confirmPassword) {
                setFieldError(confirmField, '两次密码输入不一致');
            } else {
                clearFieldError(confirmField);
            }
        }
    }
    
    // 实时输入验证 - 清除错误状态
    $('input[required], select[required]').on('input change', function() {
        const field = $(this);
        const value = field.val().trim();
        
        if (value) {
            clearFieldError(field);
        }
    });
    
    // 姓名验证
    $('#name').on('input', function() {
        const name = $(this).val().trim();
        clearFieldError($(this));
        
        if (name && name.length < 2) {
            setFieldError($(this), '姓名至少2个字符');
        }
    });
    
    // 用户名验证
    $('#username').on('input', function() {
        const username = $(this).val().trim();
        clearFieldError($(this));
        
        if (username) {
            if (username.length < 3) {
                setFieldError($(this), '用户名至少3个字符');
            } else if (!/^[a-zA-Z0-9_]+$/.test(username)) {
                setFieldError($(this), '用户名只能包含字母、数字和下划线');
            }
        }
    });
    
    // 用户名唯一性检查（失焦时）
    $('#username').on('blur', function() {
        const username = $(this).val().trim();
        if (username && username.length >= 3 && /^[a-zA-Z0-9_]+$/.test(username)) {
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/manager/checkUsername',
                method: 'POST',
                data: { username: username },
                success: function(response) {
                    if (response.exists) {
                        setFieldError($('#username'), '用户名已存在');
                    }
                }
            });
        }
    });
    
    // 手机号验证
    $('#phone').on('input', function() {
        const phone = $(this).val().trim();
        clearFieldError($(this));
        
        if (phone && !/^1[3-9]\d{9}$/.test(phone)) {
            setFieldError($(this), '请输入正确的手机号码');
        }
    });
    
    // 邮箱验证
    $('#email').on('input', function() {
        const email = $(this).val().trim();
        clearFieldError($(this));
        
        if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            setFieldError($(this), '请输入正确的邮箱格式');
        }
    });
    
    // 获取必填字段提示信息
    function getRequiredMessage(field) {
        const fieldId = field.attr('id');
        const messages = {
            'name': '请输入管理员姓名',
            'username': '请输入用户名',
            'password': '请输入密码',
            'confirmPassword': '请确认密码',
            'role': '请选择角色'
        };
        return messages[fieldId] || '此字段为必填项';
    }
    
    // 表单验证函数
    function validateForm() {
        let isValid = true;
        
        // 验证必填字段
        $('[required]').each(function() {
            const field = $(this);
            const value = field.val().trim();
            
            if (!value) {
                setFieldError(field, getRequiredMessage(field));
                isValid = false;
            }
        });
        
        // 验证密码
        const password = $('#password').val();
        if (password.length < 6) {
            setFieldError($('#password'), '密码长度至少6位');
            isValid = false;
        }
        
        // 验证密码确认
        const confirmPassword = $('#confirmPassword').val();
        if (password !== confirmPassword) {
            setFieldError($('#confirmPassword'), '两次密码输入不一致');
            isValid = false;
        }
        
        // 验证手机号（如果填写了）
        const phone = $('#phone').val().trim();
        if (phone && !/^1[3-9]\d{9}$/.test(phone)) {
            setFieldError($('#phone'), '请输入正确的手机号码');
            isValid = false;
        }
        
        // 验证邮箱（如果填写了）
        const email = $('#email').val().trim();
        if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            setFieldError($('#email'), '请输入正确的邮箱格式');
            isValid = false;
        }
        
        if (!isValid) {
            showAlert('请修正表单中的错误', 'warning');
        }
        
        return isValid;
    }
    
    // 表单提交
    $('#addManagerForm').on('submit', function(e) {
        e.preventDefault();
        
        if (!validateForm()) {
            return;
        }
        
        // 显示加载状态
        const submitBtn = $(this).find('button[type="submit"]');
        const originalText = submitBtn.html();
        submitBtn.html('<i class="bi bi-hourglass-split me-2"></i>保存中...').prop('disabled', true);
        
        // 提交表单
        $.ajax({
            url: this.action,
            method: 'POST',
            data: $(this).serialize(),
            success: function(response) {
                if (response.success) {
                    showAlert('管理员添加成功！', 'success');
                    setTimeout(function() {
                        window.location.href = '${pageContext.request.contextPath}/admin/manager/list';
                    }, 1500);
                } else {
                    showAlert(response.message || '添加失败，请重试', 'error');
                }
            },
            error: function() {
                showAlert('网络错误，请重试', 'error');
            },
            complete: function() {
                submitBtn.html(originalText).prop('disabled', false);
            }
        });
    });
});

// 显示提示信息
function showAlert(message, type) {
    let alertClass = 'alert-info';
    let icon = 'bi-info-circle';
    
    switch(type) {
        case 'success':
            alertClass = 'alert-success';
            icon = 'bi-check-circle';
            break;
        case 'error':
            alertClass = 'alert-danger';
            icon = 'bi-exclamation-circle';
            break;
        case 'warning':
            alertClass = 'alert-warning';
            icon = 'bi-exclamation-triangle';
            break;
    }
    
    let alert = `
        <div class="alert ${alertClass} alert-dismissible fade show" role="alert">
            <i class="bi ${icon} me-2"></i>${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    `;
    
    $('.page-content').prepend(alert);
    
    // 自动关闭
    setTimeout(function() {
        $('.alert').fadeOut();
    }, 3000);
}
</script>

<style>
/* 深色主题基础样式 */
body {
    ;
   ;
    min-height: 100vh;
}

.page-content {
   ;
}

.content-header {
    margin-bottom: 2rem;
}

.content-header h2 {
   ;
    font-weight: 600;
}

/* 卡片样式 */
.card-custom {
    background: white;
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 1rem;
    backdrop-filter: blur(20px);
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
    padding: 2rem 1.5rem;
}

.card-header-custom {
    background: rgba(79, 70, 229, 0.2);
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

/* 表单样式 */
.form-label {
   ;
    font-weight: 500;
    margin-bottom: 0.5rem;
}

.form-control, .form-select, textarea {
    background: rgba(30, 30, 46, 0.7);
    border: 1px solid rgba(255, 255, 255, 0.1);
   ;
    border-radius: 0.5rem;
    padding: 0.75rem 1rem;
    font-size: 0.875rem;
}

.form-control:focus, .form-select:focus, textarea:focus {
    background: white;
    border-color: #4f46e5;
   ;
    box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
}

.form-control::placeholder {
    color: #6b7280;
}

.form-text {
    color: #94a3b8;
    font-size: 0.875rem;
}

.invalid-feedback {
    color: #f87171;
    display: block;
    width: 100%;
    margin-top: 0.25rem;
    font-size: 0.875em;
}

.is-invalid {
    border-color: #ef4444;
    box-shadow: 0 0 0 0.2rem rgba(239, 68, 68, 0.25);
}

/* 按钮样式 */
.btn-gradient-primary {
    background: #4f46e5;
    color: white !important;
    border: none;
    padding: 0.75rem 1.5rem;
    border-radius: 0.5rem;
    font-weight: 500;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    transition: all 0.2s;
}

.btn-gradient-primary:hover {
    background: #4338ca;
    color: white !important;
}

.btn-gradient-success {
    background: #10b981;
    color: white !important;
    border: none;
    padding: 0.75rem 1.5rem;
    border-radius: 0.5rem;
    font-weight: 500;
    transition: all 0.2s;
}

.btn-gradient-success:hover {
    background: #059669;
    color: white !important;
}

.btn-gradient-danger {
    background: #ef4444;
    color: white !important;
    border: none;
    padding: 0.75rem 1.5rem;
    border-radius: 0.5rem;
    font-weight: 500;
    transition: all 0.2s;
}

.btn-gradient-danger:hover {
    background: #dc2626;
    color: white !important;
}

.btn-gradient-outline {
    background: #6b7280;
    color: white !important;
    border: none;
    padding: 0.75rem 1.5rem;
    border-radius: 0.5rem;
    font-weight: 500;
    transition: all 0.2s;
}

.btn-gradient-outline:hover {
    background: #4b5563;
    color: white !important;
}

/* 其他样式 */
.breadcrumb-item a {
    color: #94a3b8;
    text-decoration: none;
}

.breadcrumb-item a:hover {
   ;
}

.breadcrumb-item.active {
   ;
}

@media (max-width: 992px) {
    .form-control, .form-select, textarea {
        font-size: 0.875rem;
    }
}
</style>

.content-header h2 {
   ;
    font-weight: 600;
}

/* 卡片样式 */
.card-custom {
    background: linear-gradient(135deg, white 0%, rgba(15, 15, 25, 0.95) 100%);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 1rem;
    backdrop-filter: blur(20px);
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
}

.card-header-custom {
    background: linear-gradient(135deg, rgba(79, 70, 229, 0.2), rgba(124, 58, 237, 0.2));
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

/* 表单样式 */
.form-label {
   ;
    font-weight: 500;
    margin-bottom: 0.5rem;
}

.form-control, .form-select {
    background-color: white;
    border: 1px solid rgba(255, 255, 255, 0.2);
   ;
    border-radius: 0.5rem;
    transition: all 0.3s ease;
}

.form-control:focus, .form-select:focus {
    background-color: white;
    border-color: #4f46e5;
    box-shadow: 0 0 0 0.2rem rgba(79, 70, 229, 0.25);
   ;
}

.form-control::placeholder {
    color: #94a3b8;
}

.form-text {
    color: #94a3b8;
    font-size: 0.875rem;
}

.invalid-feedback {
    color: #f87171;
    display: block;
    width: 100%;
    margin-top: 0.25rem;
    font-size: 0.875em;
}

.is-invalid {
    border-color: #ef4444;
    box-shadow: 0 0 0 0.2rem rgba(239, 68, 68, 0.25);
}

/* 按钮样式 */
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

/* 深色主题基础样式 */
body {
    background: linear-gradient(135deg,green 0%, #2d3748 100%);
   ;
    min-height: 100vh;
}

.page-content {
   ;
}

.content-header {
    margin-bottom: 2rem;
}

.content-header h2 {
   ;
    font-weight: 600;
}

/* 卡片样式 */
.card-custom {
    background: linear-gradient(135deg, white 0%, rgba(15, 15, 25, 0.95) 100%);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 1rem;
    backdrop-filter: blur(20px);
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
}

.card-header-custom {
    background: linear-gradient(135deg, rgba(79, 70, 229, 0.2), rgba(124, 58, 237, 0.2));
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

/* 表单样式 */
.form-label {
   ;
    font-weight: 500;
    margin-bottom: 0.5rem;
}

.form-control, .form-select {
    background-color: white;
    border: 1px solid rgba(255, 255, 255, 0.2);
   ;
    border-radius: 0.5rem;
    transition: all 0.3s ease;
}

.form-control:focus, .form-select:focus {
    background-color: white;
    border-color: #4f46e5;
    box-shadow: 0 0 0 0.2rem rgba(79, 70, 229, 0.25);
   ;
}

.form-control::placeholder {
    color: #94a3b8;
}

.form-text {
    color: #94a3b8;
    font-size: 0.875rem;
}

.invalid-feedback {
    color: #f87171;
    display: block;
    width: 100%;
    margin-top: 0.25rem;
    font-size: 0.875em;
}

.is-invalid {
    border-color: #ef4444;
    box-shadow: 0 0 0 0.2rem rgba(239, 68, 68, 0.25);
}

/* 按钮样式 */
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
