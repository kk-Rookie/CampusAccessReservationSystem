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

        .header-content {
            flex: 1;
        }

        .header-content h1 {
            margin: 0;
            font-size: 20px;
        }

        .header-content p {
            margin: 5px 0 0 0;
            opacity: 0.9;
            font-size: 14px;
        }

        /* 移动端按钮修复 */
        @media (max-width: 768px) {
            .btn-primary {
                /* 强制显示按钮，移除任何可能隐藏按钮的样式 */
                display: block !important;
                visibility: visible !important;
                opacity: 1 !important;
                /* 确保按钮可以被触摸 */
                touch-action: manipulation;
                /* 移除iOS上的默认样式 */
                -webkit-appearance: none;
                appearance: none;
                /* 增加触摸目标大小 */
                min-height: 48px;
                /* 移除tap高亮 */
                -webkit-tap-highlight-color: transparent;
            }
            
            .btn-primary:active {
                /* 添加点击反馈 */
                transform: scale(0.98) !important;
            }
            
            .btn-outline {
                /* 确保轮廓按钮也正常显示 */
                display: inline-block !important;
                visibility: visible !important;
                opacity: 1 !important;
                touch-action: manipulation;
                -webkit-appearance: none;
                appearance: none;
                min-height: 44px;
                -webkit-tap-highlight-color: transparent;
            }
        }

        /* 现代化通知样式 */
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
        
        .notification-warning {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            border-left: 4px solid #92400e;
        }
        
        .notification-info {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            border-left: 4px solid #1d4ed8;
        }
        
        .notification i {
            font-size: 18px;
            flex-shrink: 0;
        }
        
        .notification-close {
            margin-left: auto;
            background: none;
            border: none;
            color: white;
            cursor: pointer;
            padding: 4px;
            border-radius: 4px;
            opacity: 0.8;
        }
        
        .notification-close:hover {
            opacity: 1;
            background: rgba(255, 255, 255, 0.2);
        }
        
        /* 错误消息样式 */
        .error-message {
            color: #dc2626;
            font-size: 12px;
            margin-top: 5px;
            padding: 5px 10px;
            background: rgba(220, 38, 38, 0.1);
            border: 1px solid rgba(220, 38, 38, 0.2);
            border-radius: 4px;
            display: none;
            animation: fadeIn 0.3s ease;
        }
        
        .error-message i {
            margin-right: 5px;
        }
        
        .form-group.has-error .form-control {
            border-color: #dc2626;
            box-shadow: 0 0 0 2px rgba(220, 38, 38, 0.1);
        }
        
        .form-group.has-error .form-control:focus {
            border-color: #dc2626;
            box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.2);
        }
        
        .form-control.error {
            border-color: #dc2626 !important;
            box-shadow: 0 0 0 2px rgba(220, 38, 38, 0.1) !important;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-5px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- 头部 -->
        <header class="header">
            <div class="header-nav">
                <button class="back-btn" onclick="goBack()" title="返回上一页">
                    <i class="fas fa-arrow-left"></i>
                </button>
                <div class="header-content">
                    <h1><i class="fas fa-user-plus"></i> 用户注册</h1>
                    <p>校园通行码预约系统</p>
                </div>
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

            <!-- 注册表单 - 阻止默认提交，使用JavaScript处理 -->
            <form id="registerForm" 
                  action="javascript:void(0)" 
                  method="post" 
                  enctype="application/x-www-form-urlencoded">
                <div class="card">
                    <div class="card-header">
                        <i class="fas fa-user-edit"></i> 创建账户
                    </div>
                    <div class="card-body">
                        <!-- 用户名 -->
                        <div class="form-group" id="usernameGroup">
                            <label class="form-label">
                                <i class="fas fa-user"></i> 用户名 *
                            </label>
                            <input type="text" 
                                   name="username" 
                                   id="username"
                                   class="form-input" 
                                   placeholder="请输入用户名（支持字母、数字、下划线）" 
                                   value="${param.username}"
                                   maxlength="20"
                                   required>
                            <div class="error-message" id="usernameError"></div>
                            <div class="input-hint">
                                <i class="fas fa-info-circle"></i>
                                用户名支持字母、数字、下划线，4-20位字符
                            </div>
                        </div>
                        
                        <!-- 真实姓名 -->
                        <div class="form-group" id="realNameGroup">
                            <label class="form-label">
                                <i class="fas fa-id-card"></i> 真实姓名 *
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
                                真实姓名将用于预约验证，信息已加密保护
                            </div>
                        </div>
                        
                        <!-- 手机号 -->
                        <div class="form-group" id="phoneGroup">
                            <label class="form-label">
                                <i class="fas fa-mobile-alt"></i> 手机号 *
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
                                <i class="fas fa-sms"></i>
                                手机号用于登录和接收通知，已加密存储
                            </div>
                        </div>
                        
                        <!-- 邮箱 -->
                        <div class="form-group" id="emailGroup">
                            <label class="form-label">
                                <i class="fas fa-envelope"></i> 邮箱（可选）
                            </label>
                            <input type="email" 
                                   name="email" 
                                   id="email"
                                   class="form-input" 
                                   placeholder="用于找回密码和接收通知" 
                                   value="${param.email}"
                                   maxlength="100">
                            <div class="error-message" id="emailError"></div>
                        </div>
                        
                        <!-- 密码 -->
                        <div class="form-group" id="passwordGroup">
                            <label class="form-label">
                                <i class="fas fa-lock"></i> 密码 *
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
                            <label class="form-label">
                                <i class="fas fa-lock"></i> 确认密码 *
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
                            <i class="fas fa-user-plus"></i> 立即注册
                        </button>
                    </div>
                </div>
            </form>
            
            <!-- 登录链接 -->
            <div class="card">
                <div class="card-body text-center">
                    <p class="login-prompt">已有账户？</p>
                    <a href="login.jsp" class="btn btn-outline">
                        <i class="fas fa-sign-in-alt"></i> 立即登录
                    </a>
                </div>
            </div>
            
            <!-- 安全提示 -->
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-shield-alt"></i> 安全保障
                </div>
                <div class="card-body">
                    <div class="security-features">
                        <div class="security-item">
                            <i class="fas fa-encryption"></i>
                            <span>SM4国密加密保护个人信息</span>
                        </div>
                        <div class="security-item">
                            <i class="fas fa-database"></i>
                            <span>SM3哈希算法防篡改</span>
                        </div>
                        <div class="security-item">
                            <i class="fas fa-user-shield"></i>
                            <span>严格的数据访问控制</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>



    <!-- 外部JavaScript文件 -->
    <script src="../../js/auth.js"></script>
    <script src="../../js/register.js"></script>
    <script>
        // 现代化通知函数
        function showNotification(message, type = 'info', duration = 5000) {
            console.log('显示通知:', message, type);
            
            // 移除现有的通知
            const existingNotifications = document.querySelectorAll('.notification');
            existingNotifications.forEach(notification => {
                notification.remove();
            });
            
            // 创建通知元素
            const notification = document.createElement('div');
            notification.className = `notification notification-${type}`;
            
            // 根据类型设置图标
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
            
            // 添加到页面
            document.body.appendChild(notification);
            
            // 显示动画
            setTimeout(() => {
                notification.classList.add('show');
            }, 100);
            
            // 自动隐藏
            if (duration > 0) {
                setTimeout(() => {
                    notification.classList.remove('show');
                    setTimeout(() => {
                        if (notification.parentElement) {
                            notification.remove();
                        }
                    }, 300);
                }, duration);
            }
        }

        // 页面加载前就开始阻止缓存跳转
        (function() {
            console.log('🔧 注册页面：立即执行函数开始');
            
            // 确保 allowRedirect 函数可用（备用定义）
            if (typeof window.allowRedirect !== 'function') {
                window.allowedRedirect = false;
                window.allowRedirect = function() {
                    window.allowedRedirect = true;
                    console.log('🔧 注册页面：已允许下一次跳转（备用函数）');
                };
                console.log('🔧 注册页面：已定义备用 allowRedirect 函数');
            }
            
            // 清除所有可能的登录缓存
            try {
                localStorage.clear();
                sessionStorage.clear();
                console.log('✅ 注册页面：已清除所有本地存储');
            } catch (e) {
                console.log('❌ 清除存储时出错:', e);
            }
            
            // 不再覆盖 setTimeout，让 auth.js 中的统一拦截器处理
            // 这样避免了多重拦截器冲突
            console.log('🔧 注册页面：跳过 setTimeout 覆盖，使用 auth.js 统一处理');
            
            // 监听所有可能的导航事件
            window.addEventListener('beforeunload', function(e) {
                console.log('🔄 页面即将卸载，URL:', window.location.href);
                console.log('🔄 Referrer:', document.referrer);
                console.trace('导航跟踪');
            });
            
            console.log('✅ 注册页面：立即执行函数完成');
        })();

        // 返回上一页功能 - 禁用自动跳转到首页
        function goBack() {
            // 不再自动跳转到首页，让用户手动选择
            console.log('goBack函数被调用');
            if (history.length > 1) {
                console.log('执行history.back()');
                history.back();
            } else {
                // 不自动跳转，显示提示
                console.log('无法返回上一页，请手动导航');
                alert('无法返回上一页，请使用导航菜单');
            }
        }
        
        // 添加页面卸载监听器，检查是否有意外跳转
        window.addEventListener('beforeunload', function(e) {
            console.log('页面即将卸载，可能的跳转原因：', e);
        });
        
        // 监听页面可见性变化
        document.addEventListener('visibilitychange', function() {
            if (document.hidden) {
                console.log('页面变为隐藏状态');
            } else {
                console.log('页面变为可见状态');
            }
        });
        
        // 完全禁用页面自动跳转
        document.addEventListener('DOMContentLoaded', function() {
            console.log('注册页面DOM加载完成');
            
            // 再次清除所有缓存
            try {
                localStorage.clear();
                sessionStorage.clear();
                
                // 清除所有cookies
                document.cookie.split(";").forEach(function(c) { 
                    document.cookie = c.replace(/^ +/, "").replace(/=.*/, "=;expires=" + new Date().toUTCString() + ";path=/"); 
                });
                
                console.log('注册页面：已完全清除所有缓存数据');
            } catch (e) {
                console.log('清除缓存时出错:', e);
            }
            
            // 监听页面可见性变化
            document.addEventListener('visibilitychange', function() {
                if (!document.hidden) {
                    // 页面重新变为可见时清除缓存
                    try {
                        localStorage.clear();
                        sessionStorage.clear();
                        console.log('页面重新可见，已清除缓存');
                    } catch (e) {
                        console.log('清除缓存失败:', e);
                    }
                }
            });
            
            // 监听窗口焦点
            window.addEventListener('focus', function() {
                try {
                    localStorage.clear();
                    sessionStorage.clear();
                    console.log('窗口获得焦点，已清除缓存');
                } catch (e) {
                    console.log('清除缓存失败:', e);
                }
            });
        });
        
        // 页面显示时清除缓存
        window.addEventListener('pageshow', function(event) {
            try {
                localStorage.clear();
                sessionStorage.clear();
                console.log('页面显示事件：已清除缓存');
            } catch (e) {
                console.log('清除缓存失败:', e);
            }
        });
    </script>
</body>
</html>