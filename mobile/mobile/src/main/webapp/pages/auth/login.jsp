<!-- filepath: /Users/xueshizhuo/Documents/all_实验/java课设/mobile/src/main/webapp/pages/auth/login.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录 - 校园通行码预约系统</title>
    <link rel="stylesheet" href="../../css/common.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* 移动端优化样式 */
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
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
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
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

        /* 头部样式 */
        .header {
            background: linear-gradient(135deg, #3b82f6 0%, #60a5fa 100%);
            color: white;
            padding: 40px 25px 30px;
            text-align: center;
            position: relative;
        }

        .header h1 {
            color: white;
            margin: 0 0 8px 0;
            font-size: 24px;
            font-weight: 700;
        }

        .header p {
            color: rgba(255, 255, 255, 0.9);
            margin: 0;
            font-size: 14px;
        }

        /* 主内容区域 */
        .main-content {
            padding: 25px 20px;
        }

        /* 登录表单普通样式 */
        .login-form {
            padding: 20px 0;
            margin-bottom: 20px;
        }

        .login-form h2 {
            text-align: center;
            color: #1e293b;
            font-size: 20px;
            font-weight: 600;
            margin: 0 0 25px 0;
        }

        /* 表单样式 */
        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 6px;
            color: #374151;
            font-weight: 500;
            font-size: 14px;
        }

        .form-input {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 16px;
            background: #f9fafb;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }

        .form-input:focus {
            outline: none;
            border-color: #3b82f6;
            background: white;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        /* 登录选项 */
        .login-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .remember-me {
            display: flex;
            align-items: center;
            color: #6b7280;
            font-size: 14px;
        }

        .remember-me input {
            margin-right: 8px;
        }

        .forgot-password {
            color: #3b82f6;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
        }

        .forgot-password:hover {
            text-decoration: underline;
        }

        /* 登录按钮 */
        .login-btn {
            width: 100%;
            padding: 18px;
            background: linear-gradient(135deg, #3b82f6 0%, #60a5fa 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 25px;
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(59, 130, 246, 0.3);
        }

        .login-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        /* 底部导航样式 */
        .bottom-nav {
            position: fixed;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 100%;
            max-width: 425px;
            background: white;
            border-top: 1px solid #e5e7eb;
            padding: 8px 0;
            z-index: 1000;
            box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-around;
        }

        .nav-item {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 10px 5px;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
            color: #6b7280;
        }

        .nav-item:hover {
            color: #3b82f6;
            background: rgba(59, 130, 246, 0.05);
        }

        .nav-item.active {
            color: #3b82f6;
        }

        .nav-item i {
            font-size: 20px;
            margin-bottom: 4px;
        }

        .nav-item span {
            font-size: 12px;
            font-weight: 500;
        }

        /* 移动端按钮修复 - 彻底解决按钮可见性问题 */
        .login-btn,
        .btn-primary,
        #loginBtn,
        button[type="submit"] {
            /* 强制显示按钮，移除任何可能隐藏按钮的样式 */
            display: block !important;
            visibility: visible !important;
            opacity: 1 !important;
            /* 确保按钮可以被触摸 */
            touch-action: manipulation !important;
            /* 移除iOS上的默认样式 */
            -webkit-appearance: none !important;
            appearance: none !important;
            /* 增加触摸目标大小 */
            min-height: 48px !important;
            /* 确保按钮在移动端清晰可见 */
            background: #3b82f6 !important;
            color: white !important;
            border: 2px solid #3b82f6 !important;
            /* 移除tap高亮 */
            -webkit-tap-highlight-color: transparent !important;
            /* 确保按钮文字可见 */
            font-size: 18px !important;
            font-weight: 600 !important;
            /* 确保padding正确 */
            padding: 18px !important;
            /* 强制覆盖任何隐藏样式 */
            position: relative !important;
            z-index: 999 !important;
            width: 100% !important;
            box-sizing: border-box !important;
            /* 移除任何悬停相关的transform */
            transform: none !important;
            transition: background-color 0.2s ease, box-shadow 0.2s ease !important;
        }

        @media (max-width: 768px) {
            .login-btn,
            .btn-primary,
            #loginBtn,
            button[type="submit"] {
                /* 移动端强制样式 */
                display: block !important;
                visibility: visible !important;
                opacity: 1 !important;
                background: #3b82f6 !important;
                color: white !important;
                border: 2px solid #3b82f6 !important;
                font-size: 18px !important;
                font-weight: 600 !important;
                padding: 18px !important;
                min-height: 48px !important;
                width: 100% !important;
                box-sizing: border-box !important;
                position: relative !important;
                z-index: 999 !important;
                transform: none !important;
                -webkit-appearance: none !important;
                appearance: none !important;
                touch-action: manipulation !important;
                -webkit-tap-highlight-color: transparent !important;
            }
            
            .login-btn:hover,
            .btn-primary:hover,
            #loginBtn:hover,
            button[type="submit"]:hover {
                /* 移动端移除悬停效果，保持按钮可见 */
                transform: none !important;
                box-shadow: 0 4px 15px rgba(59, 130, 246, 0.3) !important;
                opacity: 1 !important;
                visibility: visible !important;
                background: #3b82f6 !important;
                color: white !important;
            }
            
            .login-btn:active,
            .btn-primary:active,
            #loginBtn:active,
            button[type="submit"]:active {
                /* 添加点击反馈 */
                transform: scale(0.98) !important;
                background: #2563eb !important;
                opacity: 1 !important;
                visibility: visible !important;
            }
            
            .login-btn:focus,
            .btn-primary:focus,
            #loginBtn:focus,
            button[type="submit"]:focus {
                /* 确保焦点状态下也可见 */
                opacity: 1 !important;
                visibility: visible !important;
                background: #3b82f6 !important;
                color: white !important;
            }
        }

        /* 注册链接 */
        .register-link {
            text-align: center;
            padding: 20px;
            background: #f8fafc;
            border-radius: 12px;
            margin-top: 20px;
        }

        .register-link p {
            margin: 0 0 15px 0;
            color: #6b7280;
            font-size: 15px;
        }

        .register-btn {
            display: inline-block;
            padding: 12px 30px;
            background: white;
            color: #3b82f6;
            border: 2px solid #3b82f6;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .register-btn:hover {
            background: #3b82f6;
            color: white;
            transform: translateY(-1px);
        }

        /* Toast 通知样式 - 顶部中间弹出 */
        .toast {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%) translateY(-100px);
            background: white;
            color: #374151;
            padding: 16px 24px;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
            z-index: 10000;
            font-size: 15px;
            font-weight: 500;
            max-width: calc(100% - 40px);
            display: flex;
            align-items: center;
            gap: 12px;
            opacity: 0;
            transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
        }

        .toast.show {
            opacity: 1;
            transform: translateX(-50%) translateY(0);
        }

        .toast.success {
            border-left: 4px solid #10b981;
            color: #065f46;
        }

        .toast.error {
            border-left: 4px solid #ef4444;
            color: #991b1b;
        }

        .toast.warning {
            border-left: 4px solid #f59e0b;
            color: #92400e;
        }

        .toast.info {
            border-left: 4px solid #3b82f6;
            color: #1e40af;
        }

        /* 错误消息样式 */
        .error-message {
            background: #fef2f2;
            border: 1px solid #fecaca;
            border-left: 4px solid #ef4444;
            color: #991b1b;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
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

        /* 移动端优化 */
        @media (max-width: 480px) {
            .main-content {
                padding: 20px 20px;
            }
            
            .form-section {
                padding: 15px;
            }
            
            .header {
                padding: 40px 20px 30px;
            }
        }

        /* 主内容区域 */
        .main-content {
            flex: 1;
            padding: 30px;
            background: white;
        }

        /* 表单区域普通样式 - 移除卡片背景 */
        .form-section {
            padding: 20px;
            background: transparent;
            margin-bottom: 20px;
        }

        .form-group {
            background: transparent;
            border-radius: 8px;
            padding: 10px 0;
            margin-bottom: 20px;
            border: none;
        }

        /* 表单标题样式 */
        .form-header h2 {
            text-align: center;
            color: #1e293b;
            font-size: 20px;
            font-weight: 600;
            margin: 0 0 25px 0;
            padding: 15px 0;
            border-bottom: 2px solid #e5e7eb;
        }

        /* 注册区域样式 */
        .register-section {
            text-align: center;
            padding: 20px 0;
            margin: 20px 0;
            border-top: 1px solid #e5e7eb;
        }

        /* 快速体验区域样式 */
        .quick-access-section {
            text-align: center;
            padding: 20px 0;
            margin: 20px 0;
            border-top: 1px solid #e5e7eb;
        }

        .quick-access-section h3 {
            color: #374151;
            font-size: 16px;
            font-weight: 600;
            margin: 0 0 10px 0;
        }

        /* 表单样式优化 */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group.error .form-input {
            border-color: #dc3545;
            box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
        }

        .form-group.error .form-label {
            color: #dc3545;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #495057;
            font-size: 14px;
        }

        .form-input {
            width: 100%;
            padding: 14px 16px;  /* 增加内边距 */
            border: 2px solid #e5e7eb;
            border-radius: 12px;  /* 增加圆角 */
            font-size: 16px;
            transition: all 0.3s ease;
            box-sizing: border-box;
            background: white;
        }

        .form-input:focus {
            outline: none;
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            background: white;
        }

        .password-container {
            position: relative;
        }

        .password-toggle {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #6c757d;
            transition: color 0.3s ease;
        }

        .password-toggle:hover {
            color: #495057;
        }

        /* 按钮样式优化 */
        .btn {
            display: inline-block;
            padding: 16px 24px;  /* 增加内边距 */
            border: none;
            border-radius: 12px;  /* 增加圆角 */
            font-size: 16px;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 100%);
            color: white;
            border: 2px solid transparent;
        }

        .btn-primary:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(37, 99, 235, 0.3);
        }

        /* 移动端触摸反馈 - 确保按钮始终可见 */
        .btn-primary:active {
            transform: translateY(0);
            box-shadow: 0 4px 15px rgba(37, 99, 235, 0.2);
        }

        .btn-primary:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        /* 移动端专用样式 - 确保按钮可见性 */
        @media (max-width: 768px) {
            .btn-primary,
            button.btn-primary,
            input.btn-primary,
            #loginBtn,
            button[type="submit"] {
                opacity: 1 !important;
                visibility: visible !important;
                display: block !important;
                background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 100%) !important;
                color: white !important;
                min-height: 48px !important;
                -webkit-tap-highlight-color: rgba(37, 99, 235, 0.3) !important;
                touch-action: manipulation !important;
                border: none !important;
                width: 100% !important;
                font-size: 16px !important;
                font-weight: 600 !important;
                padding: 16px 24px !important;
                border-radius: 12px !important;
                cursor: pointer !important;
                transition: all 0.3s ease !important;
                box-shadow: 0 4px 15px rgba(37, 99, 235, 0.2) !important;
            }
            
            .btn-primary:hover,
            .btn-primary:focus,
            .btn-primary:active,
            button.btn-primary:hover,
            button.btn-primary:focus,
            button.btn-primary:active,
            #loginBtn:hover,
            #loginBtn:focus,
            #loginBtn:active,
            button[type="submit"]:hover,
            button[type="submit"]:focus,
            button[type="submit"]:active {
                opacity: 1 !important;
                visibility: visible !important;
                display: block !important;
                background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%) !important;
                color: white !important;
                transform: translateY(-1px) !important;
                box-shadow: 0 6px 20px rgba(37, 99, 235, 0.4) !important;
            }
            
            /* 强制覆盖所有可能的hover状态 */
            .btn:not(:disabled):hover,
            .btn-primary:not(:disabled):hover {
                opacity: 1 !important;
                visibility: visible !important;
            }
        }

        .btn-block {
            width: 100%;
        }

        .btn-success {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            border: 2px solid transparent;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(16, 185, 129, 0.3);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
            border: 2px solid transparent;
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(108, 117, 125, 0.3);
        }

        /* 警告框样式优化 */
        .alert {
            padding: 16px;
            margin-bottom: 20px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 12px;
            border-left: 4px solid;
            background: white;
            border: 1px solid;  /* 添加边框 */
        }

        .alert-error {
            background-color: #fee2e2;
            color: #991b1b;
            border-color: #ef4444;
        }

        .alert-success {
            background-color: #d1fae5;
            color: #065f46;
            border-color: #10b981;
        }

        .alert-warning {
            background-color: #fef3c7;
            color: #92400e;
            border-color: #f59e0b;
        }

        /* 表单选项样式 */
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
            user-select: none;
        }

        .checkbox-label input[type="checkbox"] {
            margin-right: 8px;
        }

        .forgot-link {
            color: var(--primary-blue);
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .forgot-link:hover {
            color: var(--secondary-blue);
            text-decoration: underline;
        }

        /* 文本样式 */
        .text-center {
            text-align: center;
        }

        .register-prompt {
            margin: 0 0 15px 0;
            color: #6c757d;
            font-size: 14px;
        }

        .quick-access-desc {
            margin: 0 0 15px 0;
            color: #6c757d;
            font-size: 13px;
            line-height: 1.5;
        }

        /* 错误消息样式 */
        .error-message {
            color: #dc3545;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }

        .login-attempts {
            font-size: 12px;
            color: #dc3545;
            margin-top: 10px;
            padding: 8px 12px;
            background: #fee2e2;
            border-radius: 8px;
            border: 1px solid #ef4444;
            display: none;
        }

        /* Toast 样式 */
        .toast {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            padding: 12px 20px;
            border-radius: 12px;
            color: white;
            font-size: 14px;
            font-weight: 500;
            z-index: 10000;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .toast-success {
            background: linear-gradient(135deg, #10b981, #059669);
        }

        .toast-error {
            background: linear-gradient(135deg, #ef4444, #dc2626);
        }

        .toast-info {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
        }

        /* 头部导航样式 */
        .header-nav {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 15px;
        }

        .back-btn {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .back-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-1px);
        }

        .back-btn i {
            font-size: 18px;
        }

        .header-title {
            flex: 1;
            text-align: center;
        }

        .header-spacer {
            width: 40px; /* 占位符，保持标题居中 */
        }

        /* 响应式设计 */
        @media (max-width: 425px) {
            .container {
                max-width: 100%;
                padding: 15px;
                border-left: none;   /* 移动端移除边框 */
                border-right: none;
                box-shadow: none;
            }

            .header {
                padding: 20px;
            }

            .form-section {
                padding: 15px;
            }

            .form-options {
                flex-direction: column;
                gap: 10px;
                align-items: flex-start;
            }

            .btn {
                padding: 14px 20px;
            }
        }


    </style>
</head>
<body>
    <div class="container">
        <!-- 头部 - 添加返回按钮 -->
        <header class="header">
            <div class="header-nav">
                <a href="../../index.jsp" class="back-btn" title="返回主页">
                    <i class="fas fa-arrow-left"></i>
                </a>
                <div class="header-title">
                    <h1><i class="fas fa-sign-in-alt"></i> 用户登录</h1>
                    <p>校园通行码预约系统</p>
                </div>
                <div class="header-spacer"></div>
            </div>
        </header>

        <div class="form-section">
            <!-- 错误消息显示区域 -->
            <div id="alertContainer">
                <c:if test="${not empty param.error}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <c:choose>
                            <c:when test="${param.error eq 'invalid'}">用户名或密码错误</c:when>
                            <c:when test="${param.error eq 'locked'}">账户已被锁定，请联系管理员</c:when>
                            <c:when test="${param.error eq 'expired'}">会话已过期，请重新登录</c:when>
                            <c:otherwise>登录失败，请稍后重试</c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <!-- 成功消息显示 -->
                <c:if test="${not empty param.success}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <c:choose>
                            <c:when test="${param.success eq 'registered'}">注册成功，请登录</c:when>
                            <c:when test="${param.success eq 'logout'}">已成功退出登录</c:when>
                            <c:otherwise>操作成功</c:otherwise>
                        </c:choose>
                    </div>
                </c:if>
            </div>

            <!-- 登录表单 -->
            <form id="loginForm" onsubmit="return handleLogin(event)" class="login-form">
                <div class="form-header">
                    <h2><i class="fas fa-user-circle"></i> 账户登录</h2>
                </div>
                
                <!-- 用户名输入 -->
                <div class="form-group" id="usernameGroup">
                    <label class="form-label">
                        <i class="fas fa-user"></i> 用户名
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
                    <div class="error-message" id="usernameError"></div>
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
                    <div class="error-message" id="passwordError"></div>
                </div>

                <!-- 登录失败次数提示 -->
                <div id="loginAttempts" class="login-attempts">
                    <i class="fas fa-exclamation-triangle"></i>
                    您已登录失败 <span id="attemptCount">0</span> 次，连续失败5次将锁定账户
                </div>
                
                <!-- 表单选项 -->
                <div class="form-options">
                    <label class="checkbox-label">
                        <input type="checkbox" name="rememberMe" value="true">
                        <span>记住我（7天）</span>
                    </label>
                    <a href="#" onclick="forgotPassword()" class="forgot-link">忘记密码？</a>
                </div>
                
                <button type="submit" class="btn btn-primary btn-block" id="loginBtn">
                    <i class="fas fa-sign-in-alt"></i> 立即登录
                </button>
            </form>
            
            <!-- 注册链接 -->
            <div class="register-section">
                <p class="register-prompt">还没有账户？</p>
                <a href="register.jsp" class="btn btn-success">
                    <i class="fas fa-user-plus"></i> 立即注册
                </a>
            </div>
            
            <!-- 快速体验 -->
            <div class="quick-access-section">
                <h3><i class="fas fa-mobile-alt"></i> 快速体验</h3>
                <p class="quick-access-desc">无需注册，直接使用手机号和身份证预约通行码</p>
                <a href="../../index.jsp" class="btn btn-secondary">
                    <i class="fas fa-home"></i> 返回主页
                </a>
            </div>
        </div>
    </div>

    <!-- 底部导航 -->
    <nav class="bottom-nav">
        <div class="nav-item" onclick="location.href='../../index.jsp'">
            <i class="fas fa-home"></i>
            <span>首页</span>
        </div>
        <div class="nav-item" onclick="location.href='../reservation/my-reservations.jsp'">
            <i class="fas fa-calendar"></i>
            <span>预约</span>
        </div>
        <div class="nav-item" onclick="location.href='../qrcode/pass-code.jsp'">
            <i class="fas fa-qrcode"></i>
            <span>通行码</span>
        </div>
        <div class="nav-item" onclick="location.href='../profile/index.jsp'">
            <i class="fas fa-user"></i>
            <span>我的</span>
        </div>
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

        // 显示错误信息
        function showFieldError(fieldId, message) {
            const group = document.getElementById(fieldId + 'Group');
            const errorDiv = document.getElementById(fieldId + 'Error');
            
            group.classList.add('error');
            errorDiv.textContent = message;
            errorDiv.style.display = 'block';
        }

        // 清除错误信息
        function clearFieldError(fieldId) {
            const group = document.getElementById(fieldId + 'Group');
            const errorDiv = document.getElementById(fieldId + 'Error');
            
            group.classList.remove('error');
            errorDiv.style.display = 'none';
        }

        // 清除所有错误
        function clearAllErrors() {
            clearFieldError('username');
            clearFieldError('password');
            
            // 清除页面顶部的警告
            const alertContainer = document.getElementById('alertContainer');
            alertContainer.innerHTML = '';
        }

        // 显示页面级警告
        function showAlert(message, type = 'error') {
            const alertContainer = document.getElementById('alertContainer');
            
            const alertHtml = `
                <div class="alert alert-${type}">
                    <i class="fas fa-${type == 'success' ? 'check-circle' : type == 'warning' ? 'exclamation-triangle' : 'exclamation-circle'}"></i>
                    ${message}
                </div>
            `;
            
            alertContainer.innerHTML = alertHtml;
            
            // 滚动到顶部显示错误
            alertContainer.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }

        // 显示登录失败次数
        function showLoginAttempts(count) {
            const attemptsDiv = document.getElementById('loginAttempts');
            const countSpan = document.getElementById('attemptCount');
            
            loginAttempts = count;
            countSpan.textContent = count;
            
            if (count > 0) {
                attemptsDiv.style.display = 'block';
            } else {
                attemptsDiv.style.display = 'none';
            }
        }

        // 表单验证
        function validateForm() {
            clearAllErrors();
            
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value;
            
            let isValid = true;
            
            // 验证用户名
            if (!username) {
                showFieldError('username', '请输入用户名或手机号');
                isValid = false;
            } else if (username.length < 3) {
                showFieldError('username', '用户名长度至少3个字符');
                isValid = false;
            }
            
            // 验证密码
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
            
            // 表单验证
            if (!validateForm()) {
                return false;
            }
            
            const form = event.target;
            const loginBtn = document.getElementById('loginBtn');
            const formData = new FormData(form);
            
            // 显示加载状态
            const originalText = loginBtn.innerHTML;
            loginBtn.innerHTML = '<i class="fas fa-spinner spinner"></i> 登录中...';
            loginBtn.disabled = true;
            
            // 清除之前的错误
            clearAllErrors();
            
            // 准备请求数据
            const urlParams = new URLSearchParams();
            for (const [key, value] of formData.entries()) {
                urlParams.append(key, value);
            }
            
            // 发送登录请求
            fetch('/mobile/api/auth/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: urlParams.toString()
            })
            .then(response => response.json())
            .then(data => {
                console.log('登录响应:', data);
                
                if (data.success) {
                    // 登录成功
                    showNotification('登录成功！正在跳转...', 'success', 2000);
                    
                    // 保存用户信息
                    if (data.data) {
                        localStorage.setItem('userInfo', JSON.stringify(data.data));
                    }
                    
                    // 延迟跳转，让用户看到成功提示
                    setTimeout(() => {
                        const redirect = new URLSearchParams(window.location.search).get('redirect');
                        // 如果有指定的跳转页面，则跳转到指定页面，否则跳转到主页
                        window.location.href = redirect || '../../index.jsp';
                    }, 1500);
                    
                } else {
                    // 登录失败 - 不跳转，直接显示错误
                    const message = data.message || '登录失败，请检查用户名和密码';
                    
                    // 根据错误类型显示不同的错误信息
                    if (message.includes('用户名或密码错误')) {
                        showAlert('用户名或密码错误，请重新输入', 'error');
                        showNotification('用户名或密码错误，请重新输入', 'error');
                        loginAttempts++;
                        showLoginAttempts(loginAttempts);
                    } else if (message.includes('账户已被锁定')) {
                        showAlert('账户已被锁定，请联系管理员解锁', 'error');
                        showNotification('账户已被锁定，请联系管理员解锁', 'error');
                    } else if (message.includes('登录失败次数过多')) {
                        showAlert('登录失败次数过多，账户已被锁定', 'error');
                        showNotification('登录失败次数过多，账户已被锁定', 'error');
                    } else {
                        showAlert(message, 'error');
                        showNotification(message, 'error');
                    }
                    
                    // 清空密码输入框
                    document.getElementById('password').value = '';
                    document.getElementById('password').focus();
                }
            })
            .catch(error => {
                console.error('登录请求失败:', error);
                showAlert('网络连接异常，请检查网络后重试', 'error');
                showNotification('网络连接异常，请检查网络后重试', 'error');
            })
            .finally(() => {
                // 恢复按钮状态
                loginBtn.innerHTML = originalText;
                loginBtn.disabled = false;
            });
            
            return false;
        }

        // 忘记密码
        function forgotPassword() {
            const username = document.getElementById('username').value.trim();
            if (username) {
                showToast('忘记密码功能开发中，请联系管理员重置密码', 'info');
            } else {
                showToast('请先输入用户名，然后点击忘记密码', 'info');
                document.getElementById('username').focus();
            }
        }

        // Toast 提示
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

        // 为了兼容性，保留showToast函数但调用showNotification
        function showToast(message, type = 'info', duration = 3000) {
            showNotification(message, type, duration);
        }

        // 页面加载时的初始化
        document.addEventListener('DOMContentLoaded', function() {
            // 404错误检测和自动重试机制
            checkForPageLoadError();
            
            // 页面加载性能监控
            monitorPageLoadPerformance();
            
            // 自动聚焦到用户名输入框
            const usernameInput = document.getElementById('username');
            if (usernameInput && !usernameInput.value) {
                usernameInput.focus();
            }

            // 清除输入框错误状态
            document.getElementById('username').addEventListener('input', function() {
                if (this.classList.contains('error')) {
                    clearFieldError('username');
                }
            });

            document.getElementById('password').addEventListener('input', function() {
                if (this.classList.contains('error')) {
                    clearFieldError('password');
                }
            });

            // 回车键提交表单
            document.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    const loginBtn = document.getElementById('loginBtn');
                    if (!loginBtn.disabled) {
                        loginBtn.click();
                    }
                }
            });
        });

        // 404错误检测和自动重试
        function checkForPageLoadError() {
            // 页面加载检测 - 移除自动刷新逻辑，避免无限循环
            console.log('✅ 登录页面加载完成');
        }

        // 页面加载性能监控
        function monitorPageLoadPerformance() {
            const startTime = performance.now();
            
            // 监控页面完全加载时间
            window.addEventListener('load', function() {
                const loadTime = performance.now() - startTime;
                console.log(`📊 页面加载时间: ${loadTime.toFixed(2)}ms`);
                
                // 如果加载时间过长，给出提示
                if (loadTime > 5000) {
                    console.log('⚠️ 页面加载较慢，可能存在性能问题');
                }
            });
            
            // 超时监控
            setTimeout(function() {
                if (document.readyState !== 'complete') {
                    console.log('⏰ 页面加载超时，可能存在问题');
                    alert('页面加载较慢，请稍候或尝试刷新页面');
                }
            }, 8000);
        }
    </script>
</body>
</html>