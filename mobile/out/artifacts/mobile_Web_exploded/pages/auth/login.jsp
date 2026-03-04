<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园通行登录 - 校园通行码系统</title>
    <link rel="stylesheet" href="../../css/common.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-green: #52c41a;
            --secondary-green: #389e0d;
            --light-green: #b7eb8f;
            --text-dark: #303030;
            --text-light: #666666;
            --bg-light: #f6ffed;
            --border-color: #e8f5e9;
        }

        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #f0fff4 0%, #e0f7fa 100%);
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        .container {
            width: 100%;
            max-width: 425px;
            margin: 0 auto;
            min-height: 100vh;
            background: white;
            box-shadow: 0 0 15px rgba(0,0,0,0.05);
        }

        /* 头部样式 */
        .header {
            background: linear-gradient(135deg, var(--primary-green) 0%, var(--secondary-green) 100%);
            color: white;
            padding: 20px 20px;
            position: relative;
        }

        .header-nav {
            display: flex;
            align-items: center;
        }

        .back-btn {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: none;
            border-radius: 50%;
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            text-decoration: none;
        }

        .back-btn:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        /* 主内容区域 */
        .main-content {
            padding: 40px 25px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        /* 登录卡片 */
        .login-card {
            width: 100%;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            padding: 30px;
            margin-bottom: 30px;
        }

        /* 登录表单 */
        .login-form {
            padding: 0;
            margin-bottom: 0;
        }

        .form-header {
            text-align: center;
            margin-bottom: 25px;
        }

        .form-header h2 {
            color: var(--text-dark);
            font-size: 20px;
            font-weight: 600;
            margin: 0 0 8px;
        }

        .form-header p {
            color: var(--text-light);
            font-size: 14px;
            margin: 0;
        }

        /* 表单元素 */
        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            color: var(--text-dark);
            font-weight: 500;
            font-size: 14px;
        }

        .form-input {
            width: 100%;
            padding: 16px 18px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 16px;
            background: white;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }

        .form-input:focus {
            outline: none;
            border-color: var(--primary-green);
            box-shadow: 0 0 0 2px rgba(82, 196, 26, 0.2);
        }

        .password-container {
            position: relative;
        }

        .password-toggle {
            position: absolute;
            right: 18px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #999;
            transition: color 0.3s ease;
        }

        .password-toggle:hover {
            color: var(--primary-green);
        }

        /* 表单选项 */
        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .checkbox-label {
            display: flex;
            align-items: center;
            cursor: pointer;
        }

        .checkbox-label input {
            margin-right: 6px;
        }

        .forgot-link {
            color: var(--primary-green);
            text-decoration: none;
            font-weight: 500;
        }

        .forgot-link:hover {
            text-decoration: underline;
        }

        /* 登录按钮 */
        .login-btn {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, var(--primary-green) 0%, var(--secondary-green) 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 0;
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(82, 196, 26, 0.3);
        }

        .login-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        /* 辅助操作区 */
        .auxiliary-actions {
            text-align: center;
            width: 100%;
            margin-top: 0;
            padding-top: 15px;
            border-top: 1px solid #f0f0f0;
        }

        .auxiliary-actions p {
            color: var(--text-light);
            font-size: 14px;
            margin: 0;
            display: inline-block;
        }

        .register-link {
            color: var(--primary-green);
            text-decoration: none;
            font-weight: 500;
            margin-left: 5px;
        }

        .register-link:hover {
            text-decoration: underline;
        }

        /* 错误提示 */
        .error-message {
            position: absolute;
            bottom: -22px;
            left: 0;
            color: #f5222d;
            font-size: 12px;
            display: none;
        }

        .form-group.error .form-input {
            border-color: #f5222d;
        }

        .form-group.error .error-message {
            display: block;
        }

        /* 登录尝试提示 */
        .login-attempts {
            font-size: 12px;
            color: #f5222d;
            margin-top: 10px;
            padding: 8px 12px;
            background: #fff2f2;
            border-radius: 8px;
            display: none;
        }

        /* 通知提示 */
        .toast {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            padding: 12px 20px;
            border-radius: 8px;
            color: white;
            font-size: 14px;
            font-weight: 500;
            z-index: 10000;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15);
            opacity: 0;
            transition: all 0.3s ease;
        }

        .toast.show {
            opacity: 1;
            transform: translateX(-50%) translateY(0);
        }

        .toast-success {
            background: linear-gradient(135deg, #52c41a, #389e0d);
        }

        .toast-error {
            background: linear-gradient(135deg, #f5222d, #d91e1e);
        }

        .toast-info {
            background: linear-gradient(135deg, #1890ff, #40a9ff);
        }

        /* 底部导航 */
        .bottom-nav {
            position: fixed;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 100%;
            max-width: 425px;
            background: white;
            border-top: 1px solid #e0e0e0;
            padding: 10px 0;
            z-index: 1000;
            display: flex;
            justify-content: space-around;
        }

        .nav-item {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 8px 0;
            cursor: pointer;
            text-decoration: none;
            color: #666;
        }

        .nav-item:hover {
            color: var(--primary-green);
        }

        .nav-item.active {
            color: var(--primary-green);
        }

        .nav-item i {
            font-size: 18px;
            margin-bottom: 4px;
        }

        .nav-item span {
            font-size: 11px;
        }

        /* 加载状态 */
        .loading {
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .spinner {
            width: 16px;
            height: 16px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-top: 2px solid white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* 响应式设计 */
        @media (max-width: 425px) {
            .main-content {
                padding: 30px 20px;
            }

            .login-card {
                padding: 25px;
            }

            .form-input {
                padding: 14px 16px;
            }

            .login-btn {
                padding: 14px 20px;
                font-size: 15px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <!-- 头部 -->
    <header class="header">
        <div class="header-nav">
            <a href="../../index.jsp" class="back-btn" title="返回首页">
                <i class="fas fa-arrow-left"></i>
            </a>
        </div>
    </header>

    <div class="main-content">
        <!-- 错误消息显示区域 -->
        <div id="alertContainer">
            <c:if test="${not empty param.error}">
                <div class="toast toast-error show">
                    <c:choose>
                        <c:when test="${param.error eq 'invalid'}">账号或密码错误，请重新输入</c:when>
                        <c:when test="${param.error eq 'locked'}">账号已锁定，请联系管理员解锁</c:when>
                        <c:when test="${param.error eq 'expired'}">登录会话已过期，请重新登录</c:when>
                        <c:otherwise>登录失败，请稍后再试</c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <c:if test="${not empty param.success}">
                <div class="toast toast-success show">
                    <c:choose>
                        <c:when test="${param.success eq 'registered'}">注册成功，请登录账号</c:when>
                        <c:when test="${param.success eq 'logout'}">已安全退出登录</c:when>
                        <c:otherwise>操作已完成</c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </div>

        <!-- 登录卡片 -->
        <div class="login-card">
            <form id="loginForm" onsubmit="return handleLogin(event)" class="login-form">
                <div class="form-header">
                    <h2>欢迎回来</h2>
                    <p>请输入账号密码登录系统</p>
                </div>

                <!-- 账号输入 -->
                <div class="form-group" id="usernameGroup">
                    <label class="form-label">
                        <i class="fas fa-user"></i> 账号
                    </label>
                    <input type="text"
                           name="username"
                           id="username"
                           class="form-input"
                           placeholder="请输入用户名或手机号"
                           value="${param.username}"
                           maxlength="20"
                           autocomplete="username"
                           required>
                    <div class="error-message" id="usernameError">请输入有效的账号</div>
                </div>

                <!-- 密码输入 -->
                <div class="form-group" id="passwordGroup">
                    <label class="form-label">
                        <i class="fas fa-lock"></i> 密码
                    </label>
                    <div class="password-container">
                        <input type="password"
                               name="password"
                               id="password"
                               class="form-input"
                               placeholder="请输入密码"
                               autocomplete="current-password"
                               required>
                        <i class="fas fa-eye password-toggle" onclick="togglePassword()"></i>
                    </div>
                    <div class="error-message" id="passwordError">请输入正确的密码</div>
                </div>

                <!-- 登录失败次数提示 -->
                <div id="loginAttempts" class="login-attempts">
                    <i class="fas fa-exclamation-triangle"></i>
                    您已尝试登录 <span id="attemptCount">0</span> 次，连续5次失败将锁定账号
                </div>

                <!-- 表单选项 -->
                <div class="form-options">
                    <label class="checkbox-label">
                        <input type="checkbox" name="rememberMe" value="true">
                        <span>记住账号</span>
                    </label>
                    <a href="#" onclick="forgotPassword()" class="forgot-link">忘记密码?</a>
                </div>

                <button type="submit" class="login-btn" id="loginBtn">
                    <i class="fas fa-sign-in-alt"></i> 登录系统
                </button>
            </form>
        </div>

        <!-- 注册链接 -->
        <div class="auxiliary-actions">
            <p>还没有账号？</p>
            <a href="register.jsp" class="register-link">
                <i class="fas fa-user-plus"></i> 立即注册账号
            </a>
        </div>
    </div>

    <!-- 底部导航 -->
    <nav class="bottom-nav">
        <a href="../../index.jsp" class="nav-item">
            <i class="fas fa-home"></i>
            <span>首页</span>
        </a>
        <a href="../reservation/my-reservations.jsp" class="nav-item">
            <i class="fas fa-calendar-check"></i>
            <span>我的预约</span>
        </a>
        <a href="../qrcode/pass-code.jsp" class="nav-item">
            <i class="fas fa-qrcode"></i>
            <span>通行码</span>
        </a>
        <a href="../profile/index.jsp" class="nav-item">
            <i class="fas fa-user-circle"></i>
            <span>个人中心</span>
        </a>
    </nav>
</div>

<script>
    // 全局变量
    let loginAttempts = 0;

    // 密码可见性切换
    function togglePassword() {
        const passwordInput = document.getElementById('password');
        const toggle = passwordInput.nextElementSibling;

        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            toggle.className = 'fas fa-eye-slash password-toggle';
        } else {
            passwordInput.type = 'password';
            toggle.className = 'fas fa-eye password-toggle';
        }
    }

    // 显示字段错误
    function showFieldError(fieldId, message) {
        const group = document.getElementById(fieldId + 'Group');
        const errorDiv = document.getElementById(fieldId + 'Error');

        group.classList.add('error');
        errorDiv.textContent = message;
    }

    // 清除字段错误
    function clearFieldError(fieldId) {
        const group = document.getElementById(fieldId + 'Group');
        const errorDiv = document.getElementById(fieldId + 'Error');

        group.classList.remove('error');
        errorDiv.textContent = '';
    }

    // 清除所有错误
    function clearAllErrors() {
        clearFieldError('username');
        clearFieldError('password');
        document.getElementById('loginAttempts').style.display = 'none';
    }

    // 显示提示信息
    function showToast(message, type = 'error', duration = 3000) {
        // 移除现有toast
        const toasts = document.querySelectorAll('.toast');
        toasts.forEach(toast => toast.remove());

        // 创建新toast
        const toast = document.createElement('div');
        toast.className = `toast toast-${type} show`;
        toast.textContent = message;
        document.body.appendChild(toast);

        // 自动移除
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 300);
        }, duration);
    }

    // 显示登录尝试次数
    function showLoginAttempts(count) {
        loginAttempts = count;
        document.getElementById('attemptCount').textContent = count;
        document.getElementById('loginAttempts').style.display = 'block';
    }

    // 表单验证
    function validateForm() {
        clearAllErrors();

        const username = document.getElementById('username').value.trim();
        const password = document.getElementById('password').value;

        let isValid = true;

        if (!username) {
            showFieldError('username', '请输入账号');
            isValid = false;
        } else if (username.length < 3) {
            showFieldError('username', '账号长度至少3个字符');
            isValid = false;
        }

        if (!password) {
            showFieldError('password', '请输入密码');
            isValid = false;
        } else if (password.length < 6) {
            showFieldError('password', '密码长度至少6个字符');
            isValid = false;
        }

        return isValid;
    }

    // 处理登录
    function handleLogin(event) {
        event.preventDefault();

        if (!validateForm()) {
            return false;
        }

        const loginBtn = document.getElementById('loginBtn');
        const originalText = loginBtn.innerHTML;
        loginBtn.innerHTML = '<i class="fas fa-spinner spinner"></i> 正在登录...';
        loginBtn.disabled = true;

        clearAllErrors();

        const formData = new FormData(event.target);
        const urlParams = new URLSearchParams(formData);

        fetch('/mobile/api/auth/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: urlParams.toString()
        })
            .then(response => response.json())
            .then(data => {
                loginBtn.innerHTML = originalText;
                loginBtn.disabled = false;

                if (data.success) {
                    showToast('登录成功，正在跳转...', 'success');
                    localStorage.setItem('userInfo', JSON.stringify(data.data));

                    const redirect = new URLSearchParams(window.location.search).get('redirect');
                    setTimeout(() => {
                        window.location.href = redirect || '../../index.jsp';
                    }, 1500);
                } else {
                    const message = data.message || '登录失败，请检查账号密码';
                    showToast(message, 'error');

                    if (message.includes('账号或密码错误')) {
                        loginAttempts++;
                        showLoginAttempts(loginAttempts);

                        if (loginAttempts >= 5) {
                            showToast('登录失败次数过多，账号已锁定', 'error');
                        }
                    }

                    document.getElementById('password').value = '';
                    document.getElementById('password').focus();
                }
            })
            .catch(error => {
                loginBtn.innerHTML = originalText;
                loginBtn.disabled = false;
                showToast('网络错误，请稍后再试', 'error');
                console.error('登录请求失败:', error);
            });

        return false;
    }

    // 忘记密码处理
    function forgotPassword() {
        const username = document.getElementById('username').value.trim();
        if (username) {
            showToast('密码找回功能即将开放，请联系管理员重置', 'info');
        } else {
            showToast('请先输入账号', 'info');
            document.getElementById('username').focus();
        }
    }

    // 页面加载初始化
    document.addEventListener('DOMContentLoaded', function() {
        const usernameInput = document.getElementById('username');
        if (usernameInput) {
            usernameInput.focus();
        }

        // 自动关闭提示
        setTimeout(() => {
            const toast = document.querySelector('.toast');
            if (toast) {
                toast.classList.remove('show');
                setTimeout(() => toast.remove(), 300);
            }
        }, 5000);
    });
</script>
</body>
</html>