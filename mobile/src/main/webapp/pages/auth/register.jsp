<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>注册 - 校园通行码预约系统</title>
    <link rel="stylesheet" href="../../css/common.css">
    <link rel="stylesheet" href="../../css/auth.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-green: #4ade80;
            --secondary-green: #22c55e;
            --primary-light: #ecfdf5;
            --primary-dark: #047857;
        }

        .header-nav {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 20px;
        }

        .back-btn {
            background: rgba(255, 255, 255, 0.2);
            border: none;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 16px;
            transition: all 0.3s ease;
        }

        .back-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-1px);
        }

        .header {
            background-color: #4ade80 !important;
            color: white;
        }

        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            min-width: 300px;
            max-width: 350px;
            padding: 16px 20px;
            border-radius: 12px;
            color: white;
            font-size: 14px;
            font-weight: 500;
            z-index: 10000;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15);
            transform: translateX(420px);
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .notification.show {
            transform: translateX(0);
        }

        .notification-success {
            background: linear-gradient(135deg, #10b981, #059669);
            border-left: 4px solid #065f46;
        }

        .notification-error {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            border-left: 4px solid #991b1b;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-green));
            color: white;
            border: none;
            border-radius: 8px;
            padding: 14px 20px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            box-shadow: 0 4px 12px rgba(78, 145, 251, 0.2);
        }

        .btn-outline {
            background: white;
            color: var(--primary-green);
            border: 2px solid var(--primary-green);
            border-radius: 8px;
            padding: 12px 20px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-block {
            width: 100%;
        }

        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            margin-bottom: 16px;
            overflow: hidden;
            border: none;
        }

        .card-header {
            background: linear-gradient(135deg, var(--primary-green) 10%, var(--primary-light) 100%);
            color: white;
            padding: 16px 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 600;
            font-size: 16px;
        }

        .card-body {
            padding: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            font-size: 15px;
        }

        .form-input {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #d1fae5;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: white;
            box-sizing: border-box;
        }

        .form-input:focus {
            outline: none;
            border-color: var(--primary-green);
            box-shadow: 0 0 0 3px rgba(78, 145, 251, 0.1);
        }

        .password-container {
            position: relative;
        }

        .password-toggle {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #6c757d;
            transition: color 0.3s ease;
        }

        .password-toggle:hover {
            color: var(--primary-green);
        }

        .checkbox-label {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            color: #6c757d;
            cursor: pointer;
        }

        .checkbox-label input {
            width: 18px;
            height: 18px;
            accent-color: var(--primary-green);
        }

        .agreement-label a {
            color: var(--primary-green);
            text-decoration: none;
        }

        .alert {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 16px;
            margin-bottom: 16px;
            border-radius: 8px;
            font-size: 14px;
        }

        .alert-error {
            background: rgba(239, 68, 68, 0.1);
            border-left: 4px solid #ef4444;
            color: #721c24;
        }

        /* 新增：底部登录链接样式 */
        .login-link-area {
            text-align: center;
            padding: 20px;
            margin-top: 10px;
        }

        .login-prompt {
            display: inline-block;
            margin-right: 5px;
            color: #6c757d;
        }

        .login-link {
            color: var(--primary-green);
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .login-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- 头部 - 仅保留返回按钮 -->
    <header class="header">
        <div class="header-nav">
            <button class="back-btn" onclick="goBack()" title="返回上一页">
                <i class="fas fa-arrow-left"></i>
            </button>
        </div>
    </header>

    <div class="form-section">
        <!-- 错误消息显示 -->
        <c:if test="${not empty param.error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <c:choose>
                    <c:when test="${param.error eq 'username_exists'}">用户名已存在，请换一个</c:when>
                    <c:when test="${param.error eq 'phone_exists'}">手机号已注册，请直接登录</c:when>
                    <c:when test="${param.error eq 'invalid_username'}">用户名格式不正确</c:when>
                    <c:when test="${param.error eq 'invalid_phone'}">手机号格式不正确</c:when>
                    <c:when test="${param.error eq 'password_weak'}">密码强度不够</c:when>
                    <c:when test="${param.error eq 'password_mismatch'}">两次密码输入不一致</c:when>
                    <c:otherwise>注册失败，请稍后重试</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <!-- 注册表单 -->
        <form id="registerForm"
              action="javascript:void(0)"
              method="post"
              enctype="application/x-www-form-urlencoded">
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-graduation-cap"></i> 账号注册
                </div>
                <div class="card-body">
                    <!-- 用户名 -->
                    <div class="form-group" id="usernameGroup">
                        <label class="form-label required">
                            <i class="fas fa-user-tie"></i> 用户名 *
                        </label>
                        <input type="text"
                               name="username"
                               id="username"
                               class="form-input"
                               placeholder="请输入用户名（4-20位）"
                               value="${param.username}"
                               maxlength="20"
                               required>
                        <div class="error-message" id="usernameError"></div>
                        <div class="input-hint">
                            <i class="fas fa-info-circle"></i>
                            用户名支持字母、数字、下划线
                        </div>
                    </div>

                    <!-- 真实姓名 -->
                    <div class="form-group" id="realNameGroup">
                        <label class="form-label required">
                            <i class="fas fa-user-check"></i> 真实姓名 *
                        </label>
                        <input type="text"
                               name="name"
                               id="realName"
                               class="form-input"
                               placeholder="请输入真实姓名"
                               value="${param.name}"
                               maxlength="20"
                               required>
                        <div class="error-message" id="realNameError"></div>
                        <div class="input-hint">
                            <i class="fas fa-shield-alt"></i>
                            用于身份验证，信息加密保护
                        </div>
                    </div>

                    <!-- 手机号 -->
                    <div class="form-group" id="phoneGroup">
                        <label class="form-label required">
                            <i class="fas fa-phone-alt"></i> 手机号 *
                        </label>
                        <input type="tel"
                               name="phone"
                               id="phone"
                               class="form-input"
                               placeholder="请输入11位手机号"
                               value="${param.phone}"
                               pattern="^1[3-9]\d{9}$"
                               title="请输入正确的手机号格式"
                               maxlength="11"
                               required>
                        <div class="error-message" id="phoneError"></div>
                        <div class="input-hint">
                            <i class="fas fa-comment-dots"></i>
                            用于接收通知和找回密码
                        </div>
                    </div>

                    <!-- 邮箱 -->
                    <div class="form-group" id="emailGroup">
                        <label class="form-label">
                            <i class="fas fa-envelope-open-text"></i> 邮箱（可选）
                        </label>
                        <input type="email"
                               name="email"
                               id="email"
                               class="form-input"
                               placeholder="请输入邮箱地址"
                               value="${param.email}"
                               maxlength="100">
                        <div class="error-message" id="emailError"></div>
                    </div>

                    <!-- 密码 -->
                    <div class="form-group" id="passwordGroup">
                        <label class="form-label required">
                            <i class="fas fa-key"></i> 密码 *
                        </label>
                        <div class="password-container">
                            <input type="password"
                                   name="password"
                                   id="password"
                                   class="form-input"
                                   placeholder="至少6位密码"
                                   minlength="6"
                                   maxlength="50"
                                   required>
                            <i class="fas fa-eye password-toggle" onclick="togglePassword('password')"></i>
                        </div>
                        <div class="error-message" id="passwordError"></div>
                        <div class="password-strength" id="passwordStrength"></div>
                    </div>

                    <!-- 确认密码 -->
                    <div class="form-group" id="confirmPasswordGroup">
                        <label class="form-label required">
                            <i class="fas fa-key"></i> 确认密码 *
                        </label>
                        <div class="password-container">
                            <input type="password"
                                   name="confirmPassword"
                                   id="confirmPassword"
                                   class="form-input"
                                   placeholder="请再次输入密码"
                                   minlength="6"
                                   maxlength="50"
                                   required>
                            <i class="fas fa-eye password-toggle" onclick="togglePassword('confirmPassword')"></i>
                        </div>
                        <div class="error-message" id="confirmPasswordError"></div>
                        <div class="password-match" id="passwordMatch"></div>
                    </div>

                    <!-- 用户协议 -->
                    <div class="form-group">
                        <label class="checkbox-label agreement-label">
                            <input type="checkbox" name="agreement" id="agreement" required>
                            <span class="checkmark"></span>
                            我已阅读并同意
                            <a href="../../pages/legal/privacy.jsp" target="_blank">《隐私政策》</a>
                            和
                            <a href="../../pages/legal/terms.jsp" target="_blank">《用户协议》</a>
                        </label>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block" id="submitBtn">
                        <i class="fas fa-save"></i> 立即注册
                    </button>
                </div>
            </div>
        </form>

        <!-- 登录链接 - 并排显示 -->
        <div class="login-link-area">
            <p class="login-prompt">已有账户？</p>
            <a href="login.jsp" class="login-link">
                <i class="fas fa-sign-in-alt"></i> 立即登录
            </a>
        </div>
    </div>
</div>

<script src="../../js/auth.js"></script>
<script src="../../js/register.js"></script>
<script>
    function showNotification(message, type = 'info', duration = 5000) {
        const existingNotifications = document.querySelectorAll('.notification');
        existingNotifications.forEach(notification => notification.remove());

        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;

        let icon = '';
        switch(type) {
            case 'success':
                icon = '<i class="fas fa-check-circle"></i>';
                break;
            case 'error':
                icon = '<i class="fas fa-exclamation-circle"></i>';
                break;
            case 'warning':
                icon = '<i class="fas fa-exclamation-triangle"></i>';
                break;
            case 'info':
            default:
                icon = '<i class="fas fa-info-circle"></i>';
                break;
        }

        notification.innerHTML = `
            ${icon}
            <span>${message}</span>
            <button class="notification-close" onclick="this.parentElement.remove()">
                <i class="fas fa-times"></i>
            </button>
        `;

        document.body.appendChild(notification);
        setTimeout(() => notification.classList.add('show'), 100);

        if (duration > 0) {
            setTimeout(() => {
                notification.classList.remove('show');
                setTimeout(() => notification.remove(), 300);
            }, duration);
        }
    }

    function goBack() {
        if (history.length > 1) {
            history.back();
        } else {
            alert('无法返回上一页，请使用导航菜单');
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        try {
            localStorage.clear();
            sessionStorage.clear();
        } catch (e) {
            console.log('清除缓存失败:', e);
        }
    });
</script>
</body>
</html>