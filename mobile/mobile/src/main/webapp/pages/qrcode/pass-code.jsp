<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>通行码 - 校园通行码预约系统</title>
    <link rel="stylesheet" href="../../css/common.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- 二维码由后端ZXing库生成，无需前端JavaScript库 -->
    <style>
        :root {
            --primary-blue: #3b82f6;      /* 主蓝色 - 调整为更友好的蓝色 */
            --secondary-blue: #3b82f6;    /* 次蓝色 */
            --light-blue: #60a5fa;        /* 浅蓝色 */
            --sky-blue: #0ea5e9;          /* 天空蓝 */
            --indigo-blue: #6366f1;       /* 靛蓝 */
            --cyan-blue: #06b6d4;         /* 青蓝色 */
            --steel-blue: #475569;        /* 钢蓝色 */
            --ocean-blue: #0c4a6e;        /* 海洋蓝 */
            
            --primary-light: #dbeafe;     /* 浅蓝背景 */
            --secondary-light: #e0f2fe;   /* 次浅蓝背景 */
            --accent-light: #f0f9ff;      /* 极浅蓝背景 */
            
            --primary-dark: #1e40af;      /* 深蓝色 */
            
            /* 使用蓝色系作为主色调 */
            --primary-color: var(--primary-blue);
            --accent-color: var(--light-blue);
        }

        body {
            background: white;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 425px;
            margin: 0 auto;
            min-height: 100vh;
            background: white;
            position: relative;
            padding-bottom: 60px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }

        .header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--accent-color) 100%);
            color: white;
            padding: 12px 15px;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 2px 12px rgba(78, 145, 251, 0.2);
        }

        .header-nav {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .header-nav i {
            font-size: 18px;
            cursor: pointer;
            padding: 6px;
            border-radius: 50%;
            transition: background 0.3s ease;
        }

        .header-nav i:hover {
            background: rgba(255, 255, 255, 0.2);
        }

        .header h1 {
            font-size: 16px;
            font-weight: 600;
            margin: 0;
        }

        .main-content {
            padding: 12px 15px;
            background: white;
            min-height: calc(100vh - 110px);
        }

        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
            margin-bottom: 12px;
            overflow: hidden;
            border: 1px solid #e9ecef;
        }

        .card-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 12px 15px;
            border-bottom: 1px solid #e9ecef;
            font-weight: 600;
            color: #495057;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }

        .card-body {
            padding: 15px;
        }

        .search-tabs {
            display: flex;
            gap: 8px;
            margin-bottom: 15px;
            background: #f8f9fa;
            padding: 4px;
            border-radius: 8px;
        }

        .tab-btn {
            flex: 1;
            padding: 8px 12px;
            border: none;
            background: transparent;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            color: #6c757d;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .tab-btn.active {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--accent-color) 100%);
            color: white;
            box-shadow: 0 2px 8px rgba(78, 145, 251, 0.3);
            transform: translateY(-1px);
        }

        .tab-btn:hover:not(.active) {
            background: #e9ecef;
            color: #495057;
        }

        .search-form {
            display: none;
            animation: fadeIn 0.3s ease;
        }

        .search-form.active {
            display: block;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: #374151;
            margin-bottom: 6px;
            font-size: 13px;
        }

        .form-group input {
            width: 100%;
            padding: 10px 12px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: white;
            box-sizing: border-box;
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--primary-color);
            background: white;
            box-shadow: 0 0 0 3px rgba(78, 145, 251, 0.1);
        }

        .form-hint {
            font-size: 11px;
            color: #9ca3af;
            margin-top: 4px;
            display: flex;
            align-items: center;
            gap: 3px;
        }

        .form-hint::before {
            content: "💡";
            font-size: 9px;
        }

        .btn-primary {
            width: 100%;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--accent-color) 100%);
            color: white;
            border: none;
            padding: 12px 18px;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(78, 145, 251, 0.3);
        }

        .pass-code-container {
            margin-bottom: 15px;
        }

        .qr-card {
            background: white;
            border: 2px solid #e9ecef;
        }

        .qr-card .card-header {
            background: linear-gradient(135deg, var(--primary-color) 10%, var(--accent-color) 100%);
            color: white;
            border-bottom: none;
        }

        .qr-code-section {
            text-align: center;
            margin-bottom: 10px;
        }

        .qr-code-display {
            background: #fff;
            border-radius: 8px;
            padding: 8px;
            margin-bottom: 8px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.03);
            border: 1px solid #e9ecef;
        }

        .qr-code-display img {
            width: 100px;
            height: 100px;
            border-radius: 6px;
        }

        /* 通行码状态样式 - 有效状态 */
        .pass-code-container.status-valid .qr-code-display {
            border-color: #10b981;
            background: #f0fdf4;
            box-shadow: 0 4px 20px rgba(16, 185, 129, 0.15);
        }

        .pass-code-container.status-valid .qr-code-display::before {
            background: linear-gradient(135deg, #10b981, #059669);
            opacity: 1;
        }

        .pass-code-container.status-valid .qr-code-display img {
            filter: none;
            opacity: 1;
            box-shadow: 0 2px 8px rgba(16, 185, 129, 0.2);
        }

        /* 通行码状态样式 - 过期状态 */
        .pass-code-container.status-expired .qr-code-display {
            border-color: #9ca3af;
            background: #f9fafb;
            box-shadow: 0 4px 16px rgba(156, 163, 175, 0.15);
        }

        .pass-code-container.status-expired .qr-code-display::before {
            background: linear-gradient(135deg, #9ca3af, #6b7280);
            opacity: 0.7;
        }

        .pass-code-container.status-expired .qr-code-display img {
            filter: grayscale(100%) brightness(0.8);
            opacity: 0.5;
        }

        .pass-code-container.status-expired .qr-tip {
            color: #9ca3af;
        }

        .pass-code-container.status-expired .qr-tip i {
            color: #d1d5db;
        }

        .empty-state,
        .loading-state {
            text-align: center;
            padding: 12px 6px;
        }

        .empty-state h3 {
            font-size: 14px;
            margin: 0 0 4px 0;
        }

        .empty-state p {
            font-size: 12px;
            margin: 0 0 8px 0;
        }

        .loading-state p {
            font-size: 12px;
            margin-top: 6px;
        }

        .loading-spinner {
            font-size: 18px;
            margin-bottom: 6px;
        }

        .toast {
            position: fixed;
            top: 20px;
            right: 20px;
            background: white;
            border-radius: 8px;
            padding: 12px 16px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
            display: flex;
            align-items: center;
            gap: 8px;
            transform: translateX(100%);
            transition: transform 0.3s ease;
            z-index: 1000;
            min-width: 250px;
            border-left: 4px solid;
            font-size: 14px;
        }

        .toast.show {
            transform: translateX(0);
        }

        .toast-success { border-left-color: #10b981; }
        .toast-error { border-left-color: #ef4444; }
        .toast-warning { border-left-color: #f59e0b; }
        .toast-info { border-left-color: #3b82f6; }

        .bottom-nav {
            position: fixed;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 100%;
            max-width: 425px;
            background: white;
            border-top: 1px solid #e9ecef;
            display: flex;
            justify-content: space-around;
            padding: 4px 0 env(safe-area-inset-bottom);
            box-shadow: 0 -1px 4px rgba(0,0,0,0.04);
            z-index: 100;
        }

        .nav-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 3px;
            padding: 6px 8px;
            cursor: pointer;
            color: #6c757d;
            text-decoration: none;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            position: relative;
            border-radius: 8px;
            margin: 4px 2px;
        }

        .nav-item.active {
            color: var(--primary-blue);
            background: white;
        }

        .nav-item i {
            font-size: 18px;
            position: relative;
            z-index: 1;
            transition: transform 0.3s ease;
        }

        .nav-item span {
            font-size: 10px;
            font-weight: 500;
            position: relative;
            z-index: 1;
            letter-spacing: 0.3px;
        }

        /* 通行码信息样式 */
        .pass-code-info {
            background: #f8f9ff;
            border-radius: 12px;
            padding: 15px;
            margin-bottom: 15px;
            border: 1px solid #e6f0ff;
        }

        .pass-code-number {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .pass-code-number .label {
            font-weight: 600;
            color: #495057;
            font-size: 13px;
        }

        .code-text {
            font-family: 'SF Mono', 'Monaco', 'Cascadia Code', 'Roboto Mono', monospace;
            font-size: 16px;
            font-weight: 700;
            color: var(--primary-color);
            background: white;
            padding: 8px 15px;
            border-radius: 8px;
            letter-spacing: 1.5px;
            border: 2px solid #e9ecef;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
        }

        .copy-btn {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 8px 10px;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 13px;
        }

        .copy-btn:hover {
            background: #5a67d8;
            transform: scale(1.05);
        }

        /* 详细信息网格 */
        .pass-info {
            margin-bottom: 15px;
        }

        .info-grid {
            display: grid;
            gap: 12px;
            grid-template-columns: 1fr;
        }

        .info-item {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 16px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            border: 1px solid #f1f3f4;
            transition: all 0.3s ease;
        }

        .info-item:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .info-item i {
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            border-radius: 8px;
            font-size: 12px;
            flex-shrink: 0;
        }

        .info-item > div {
            flex: 1;
            min-width: 0;
        }

        .info-item .label {
            font-size: 12px;
            color: #6c757d;
            font-weight: 500;
            display: block;
            margin-bottom: 4px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .info-item .value {
            font-weight: 600;
            color: #1f2937;
            font-size: 14px;
            word-break: break-all;
        }

        .expire-item.expired {
            background: #fef2f2;
            border-color: #fca5a5;
        }

        .expire-item.expired i {
            background: linear-gradient(135deg, #ef4444, #dc2626);
        }

        .expire-time {
            color: #dc2626 !important;
            font-weight: 700;
        }

        /* 操作按钮 */
        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
            gap: 12px;
            margin-top: 24px;
        }

        .action-buttons button {
            padding: 14px 16px;
            border: none;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .btn-secondary {
            background: #f8f9fa;
            color: #495057;
            border: 1px solid #dee2e6;
        }

        .btn-secondary:hover {
            background: #e9ecef;
            transform: translateY(-1px);
        }

        .btn-success {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            transform: translateY(-1px);
        }

        /* 使用提示 */
        .usage-tip {
            margin-top: 24px;
        }

        .tip-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 16px;
            color: var(--primary-color);
            font-weight: 600;
        }

        .tip-header i {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
        }

        .tip-content {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .tip-item {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            font-size: 14px;
            color: #6c757d;
            line-height: 1.5;
        }

        .tip-item i {
            color: #10b981;
            font-size: 16px;
            margin-top: 2px;
            flex-shrink: 0;
        }

        /* 状态指示器 */
        .status-indicator {
            font-size: 12px;
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-valid {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #10b981;
        }

        .status-expired {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #ef4444;
        }

        .qr-tip {
            color: #6c757d;
            font-size: 14px;
            margin: 16px 0 0 0;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .qr-tip i {
            color: var(--primary-color);
        }

        @media (max-width: 480px) {
            .container {
                padding-bottom: 45px;
            }
            
            .header {
                padding: 8px 12px;
            }
            
            .header h1 {
                font-size: 15px;
            }
            
            .main-content {
                padding: 8px 12px;
            }
            
            .card {
                margin-bottom: 8px;
            }
            
            .card-header {
                padding: 8px 12px;
                font-size: 13px;
            }
            
            .card-body {
                padding: 10px 12px;
            }
            
            .search-tabs {
                margin-bottom: 10px;
            }
            
            .form-group {
                margin-bottom: 10px;
            }
            
            .form-group input {
                padding: 8px 10px;
                font-size: 14px;
            }
            
            .qr-code-display img {
                width: 90px;
                height: 90px;
            }
            
            .qr-code-display {
                padding: 6px;
                margin-bottom: 6px;
            }
            
            .pass-code-info {
                padding: 8px;
                margin-bottom: 8px;
            }
            
            .info-item {
                padding: 8px;
            }
            
            .info-item .value {
                font-size: 12px;
            }
            
            .btn-primary {
                padding: 8px 12px;
                font-size: 13px;
            }
            
            .empty-state,
            .loading-state {
                padding: 10px 4px;
            }
            
            .empty-state h3 {
                font-size: 13px;
                margin: 0 0 3px 0;
            }
            
            .empty-state p {
                font-size: 11px;
                margin: 0 0 6px 0;
            }
            
            .loading-state p {
                font-size: 11px;
                margin-top: 4px;
            }
            
            .loading-spinner {
                font-size: 16px;
                margin-bottom: 4px;
            }
            
            .bottom-nav {
                padding: 3px 0 env(safe-area-inset-bottom);
                box-shadow: 0 -1px 3px rgba(0,0,0,0.03);
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <header class="header">
            <div class="header-nav">
                <i class="fas fa-arrow-left" onclick="goBack()" title="返回"></i>
                <h1>我的通行码</h1>
                <i class="fas fa-redo" onclick="refreshPage()" title="刷新页面"></i>
            </div>
        </header>

        <div class="main-content">
            <div class="search-methods">
                <div class="card">
                    <div class="card-header">
                        <i class="fas fa-search"></i>
                        <span>查询我的通行码</span>
                    </div>
                    <div class="card-body">
                        <div class="search-tabs">
                            <button class="tab-btn active" onclick="switchTab('id')">
                                <i class="fas fa-hashtag"></i>
                                <span>预约ID查询</span>
                            </button>
                            <button class="tab-btn" onclick="switchTab('personal')">
                                <i class="fas fa-user"></i>
                                <span>个人信息查询</span>
                            </button>
                        </div>

                        <form id="idSearchForm" class="search-form active" onsubmit="searchByReservationId(event)">
                            <div class="form-group">
                                <label>预约ID</label>
                                <input type="number" 
                                       id="reservationId" 
                                       name="reservationId" 
                                       placeholder="请输入预约ID" 
                                       required>
                                <div class="form-hint">预约成功后系统会提供唯一的预约ID</div>
                            </div>
                            <button type="submit" class="btn-primary">
                                <i class="fas fa-qrcode"></i>
                                <span>生成通行码</span>
                            </button>
                        </form>

                        <form id="personalSearchForm" class="search-form" onsubmit="searchByPersonalInfo(event)">
                            <div class="form-group">
                                <label>姓名</label>
                                <input type="text" 
                                       id="userName" 
                                       name="userName" 
                                       placeholder="请输入真实姓名" 
                                       required>
                            </div>
                            <div class="form-group">
                                <label>身份证号</label>
                                <input type="text" 
                                       id="userIdCard" 
                                       name="userIdCard" 
                                       placeholder="请输入18位身份证号" 
                                       maxlength="18"
                                       required>
                            </div>
                            <div class="form-group">
                                <label>手机号</label>
                                <input type="tel" 
                                       id="userPhone" 
                                       name="userPhone" 
                                       placeholder="请输入11位手机号" 
                                       maxlength="11"
                                       required>
                                <div class="form-hint">请输入预约时使用的手机号</div>
                            </div>
                            <button type="submit" class="btn-primary">
                                <i class="fas fa-search"></i>
                                <span>查询通行码</span>
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- 通行码显示区域 -->
            <div id="passCodeContainer" class="pass-code-container" style="display: none;">
                <div class="card qr-card">
                    <div class="card-header">
                        <i class="fas fa-qrcode"></i>
                        <span>我的通行码</span>
                        <span id="statusIndicator" class="status-indicator"></span>
                    </div>
                    <div class="card-body">
                        <!-- 二维码显示 -->
                        <div class="qr-code-section">
                            <div id="qrCodeDisplay" class="qr-code-display">
                                <canvas id="qrCanvas"></canvas>
                            </div>
                            <p class="qr-tip">
                                <i class="fas fa-mobile-alt"></i>
                                <span>请向门卫出示此二维码</span>
                            </p>
                        </div>

                        <!-- 通行码信息 -->
                        <div class="pass-code-info">
                            <div class="pass-code-number">
                                <span class="label">通行码</span>
                                <span id="passCodeText" class="code-text">-</span>
                                <button class="copy-btn" onclick="copyPassCode()" title="复制通行码">
                                    <i class="fas fa-copy"></i>
                                </button>
                            </div>
                        </div>

                        <!-- 详细信息 -->
                        <div class="pass-info">
                            <div class="info-grid">
                                <div class="info-item">
                                    <i class="fas fa-user"></i>
                                    <div>
                                        <span class="label">访客姓名</span>
                                        <span id="nameText" class="value">-</span>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-id-card"></i>
                                    <div>
                                        <span class="label">身份证号</span>
                                        <span id="idCardText" class="value">-</span>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-clock"></i>
                                    <div>
                                        <span class="label">访问时间</span>
                                        <span id="visitTimeText" class="value">-</span>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <div>
                                        <span class="label">访问校区</span>
                                        <span id="campusText" class="value">-</span>
                                    </div>
                                </div>
                                <div class="info-item expire-item">
                                    <i class="fas fa-hourglass-end"></i>
                                    <div>
                                        <span class="label">有效期至</span>
                                        <span id="expireTimeText" class="value expire-time">-</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 操作按钮 -->
                        <div class="action-buttons">
                            <button class="btn-secondary" onclick="refreshPassCode()">
                                <i class="fas fa-sync"></i>
                                <span>刷新</span>
                            </button>
                            <button class="btn-success" onclick="downloadQRCode()">
                                <i class="fas fa-download"></i>
                                <span>保存</span>
                            </button>
                            <button class="btn-primary" onclick="sharePassCode()">
                                <i class="fas fa-share"></i>
                                <span>分享</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 使用提示 -->
            <div id="usageTip" class="usage-tip">
                <div class="card">
                    <div class="card-body">
                        <div class="tip-header">
                            <i class="fas fa-lightbulb"></i>
                            <span>使用说明</span>
                        </div>
                        <div class="tip-content">
                            <div class="tip-item">
                                <i class="fas fa-check-circle"></i>
                                <span>到达校门时向门卫出示通行码或二维码</span>
                            </div>
                            <div class="tip-item">
                                <i class="fas fa-check-circle"></i>
                                <span>请在有效期内使用，过期后需重新预约</span>
                            </div>
                            <div class="tip-item">
                                <i class="fas fa-check-circle"></i>
                                <span>建议保存二维码图片以便离线使用</span>
                            </div>
                            <div class="tip-item">
                                <i class="fas fa-check-circle"></i>
                                <span>如有问题请联系门卫或管理人员</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 空状态 -->
            <div id="emptyState" class="empty-state">
                <div class="card">
                    <div class="card-body">
                        <i class="fas fa-qrcode"></i>
                        <h3>暂无通行码</h3>
                        <p>请先选择查询方式获取您的通行码<br>或创建新的预约申请</p>
                        <button class="btn-primary" onclick="location.href='/mobile/pages/reservation/reserve.jsp'">
                            <i class="fas fa-plus"></i>
                            <span>立即预约</span>
                        </button>
                    </div>
                </div>
            </div>

            <!-- 加载状态 -->
            <div id="loadingState" class="loading-state" style="display: none;">
                <div class="card">
                    <div class="card-body">
                        <div class="loading-spinner">
                            <i class="fas fa-spinner fa-spin"></i>
                        </div>
                        <p>正在生成通行码...</p>
                    </div>
                </div>
            </div>
        </div>

        <nav class="bottom-nav">
            <div class="nav-item" onclick="location.href='/mobile/'">
                <i class="fas fa-home"></i>
                <span>首页</span>
            </div>
            <div class="nav-item" onclick="location.href='/mobile/pages/reservation/my-reservations.jsp'">
                <i class="fas fa-calendar"></i>
                <span>预约</span>
            </div>
            <div class="nav-item active">
                <i class="fas fa-qrcode"></i>
                <span>通行码</span>
            </div>
            <div class="nav-item" onclick="location.href='/mobile/pages/profile/index.jsp'">
                <i class="fas fa-user"></i>
                <span>我的</span>
            </div>
        </nav>
    </div>

    <script src="../../js/pass-code.js"></script>
    <script>
        // 页面初始化
        document.addEventListener('DOMContentLoaded', function() {
            console.log('通行码页面已加载');
            
            // 从URL参数获取预约ID
            const urlParams = new URLSearchParams(window.location.search);
            const reservationId = urlParams.get('reservationId');
            if (reservationId) {
                document.getElementById('reservationId').value = reservationId;
                // 自动查询
                setTimeout(function() {
                    searchByReservationId({ preventDefault: function() {} });
                }, 500);
            }
        });
        
        // 页面控制函数
        function goBack() {
            history.back();
        }

        function refreshPage() {
            location.reload();
        }

        function switchTab(tabType) {
            // 切换标签页状态
            document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
            document.querySelectorAll('.search-form').forEach(form => form.classList.remove('active'));
            
            event.target.closest('.tab-btn').classList.add('active');
            
            if (tabType == 'id') {
                document.getElementById('idSearchForm').classList.add('active');
            } else {
                document.getElementById('personalSearchForm').classList.add('active');
            }
        }

        // Toast提示函数
        function showToast(message, type) {
            if (!type) type = 'info';
            
            const iconMap = {
                'success': 'check-circle',
                'error': 'exclamation-circle',
                'warning': 'exclamation-triangle',
                'info': 'info-circle'
            };
            
            const iconClass = iconMap[type] || 'info-circle';
            
            const toast = document.createElement('div');
            toast.className = 'toast toast-' + type;
            toast.innerHTML = '<i class="fas fa-' + iconClass + '"></i><span>' + message + '</span>';
            
            document.body.appendChild(toast);
            
            setTimeout(function() {
                toast.classList.add('show');
            }, 100);
            
            setTimeout(function() {
                toast.classList.remove('show');
                setTimeout(function() {
                    if (toast.parentNode) {
                        document.body.removeChild(toast);
                    }
                }, 300);
            }, 3000);
        }

        // ===== 通行码功能函数 =====
        function copyPassCode() {
            const passCodeText = document.getElementById('passCodeText').textContent;
            if (navigator.clipboard) {
                navigator.clipboard.writeText(passCodeText).then(() => {
                    showToast('通行码已复制到剪贴板', 'success');
                });
            } else {
                showToast('浏览器不支持复制功能', 'warning');
            }
        }

        function refreshPassCode() {
            showToast('正在刷新通行码...', 'info');
            // 重新执行当前的查询
            const urlParams = new URLSearchParams(window.location.search);
            const reservationId = urlParams.get('reservationId');
            if (reservationId) {
                document.getElementById('reservationId').value = reservationId;
                searchByReservationId({ preventDefault: function() {} });
            }
        }

        function downloadQRCode() {
            const qrImg = document.querySelector('#qrCodeDisplay img');
            const qrCanvas = document.querySelector('#qrCodeDisplay canvas');
            
            if (qrImg) {
                // 如果是图片格式
                const link = document.createElement('a');
                link.download = '校园通行码_' + new Date().getTime() + '.png';
                link.href = qrImg.src;
                link.click();
                showToast('二维码已保存', 'success');
            } else if (qrCanvas) {
                // 如果是canvas格式
                const link = document.createElement('a');
                link.download = '校园通行码_' + new Date().getTime() + '.png';
                link.href = qrCanvas.toDataURL();
                link.click();
                showToast('二维码已保存', 'success');
            } else {
                showToast('没有可下载的二维码', 'warning');
            }
        }

        function sharePassCode() {
            if (navigator.share) {
                const passCodeText = document.getElementById('passCodeText').textContent;
                navigator.share({
                    title: '校园通行码',
                    text: `我的通行码：${passCodeText}`,
                }).then(() => {
                    showToast('分享成功', 'success');
                }).catch(() => {
                    showToast('分享取消', 'info');
                });
            } else {
                showToast('浏览器不支持分享功能', 'warning');
            }
        }

        // ===== 状态管理函数 =====
        function showLoading() {
            document.getElementById('loadingState').style.display = 'block';
            document.getElementById('passCodeContainer').style.display = 'none';
            document.getElementById('emptyState').style.display = 'none';
            document.getElementById('usageTip').style.display = 'none';
        }

        function hideLoading() {
            document.getElementById('loadingState').style.display = 'none';
        }

        function hidePassCode() {
            document.getElementById('passCodeContainer').style.display = 'none';
        }

        function showEmptyState() {
            document.getElementById('emptyState').style.display = 'block';
            document.getElementById('passCodeContainer').style.display = 'none';
            document.getElementById('usageTip').style.display = 'block';
        }

        function showPassCode() {
            document.getElementById('passCodeContainer').style.display = 'block';
            document.getElementById('emptyState').style.display = 'none';
            document.getElementById('usageTip').style.display = 'block';
        }

        // ===== 数据显示函数 =====
        function displayPassCodeWithImage(passCodeData) {
            // 显示通行码数字
            document.getElementById('passCodeText').textContent = passCodeData.passCode || '无效通行码';
            
            // 显示二维码图片
            const qrDisplay = document.getElementById('qrCodeDisplay');
            qrDisplay.innerHTML = `
                <img src="${passCodeData.qrCodeImage}" 
                     alt="通行码二维码" 
                     style="width: 200px; height: 200px; border-radius: 8px; background: white;">
            `;
            
            // 更新其他信息
            document.getElementById('nameText').textContent = passCodeData.name || '-';
            document.getElementById('idCardText').textContent = passCodeData.idCard || '-';
            document.getElementById('visitTimeText').textContent = passCodeData.visitTime || '-';
            document.getElementById('campusText').textContent = formatCampus(passCodeData.campus) || '-';
            document.getElementById('expireTimeText').textContent = passCodeData.expireTime || '-';
            
            // 设置状态指示器和容器样式
            const statusIndicator = document.getElementById('statusIndicator');
            const passCodeContainer = document.getElementById('passCodeContainer');
            const now = new Date();
            const expireTime = new Date(passCodeData.expireTime);
            
            if (expireTime > now) {
                statusIndicator.className = 'status-indicator status-valid';
                statusIndicator.textContent = '有效通行码';
                if (passCodeContainer) {
                    passCodeContainer.className = 'pass-code-container status-valid';
                }
                document.querySelector('.expire-item').classList.remove('expired');
            } else {
                statusIndicator.className = 'status-indicator status-expired';
                statusIndicator.textContent = '已过期';
                if (passCodeContainer) {
                    passCodeContainer.className = 'pass-code-container status-expired';
                }
                document.querySelector('.expire-item').classList.add('expired');
            }
            
            // 显示通行码区域
            showPassCode();
        }

        // 格式化校区显示
        function formatCampus(campus) {
            const campusMap = {
                'main': '主校区',
                'east': '东校区',
                'west': '西校区',
                'north': '北校区'
            };
            return campusMap[campus] || campus;
        }

        // 格式化状态显示
        function formatStatus(status) {
            const statusMap = {
                'pending': '待审核',
                'approved': '已通过',
                'rejected': '已拒绝'
            };
            return statusMap[status] || status;
        }

        // ===== 查询功能 =====
        function searchByPersonalInfo(event) {
            event.preventDefault();
            
            const name = document.getElementById('userName').value.trim();
            const idCard = document.getElementById('userIdCard').value.trim();
            const phone = document.getElementById('userPhone').value.trim();
            
            if (!name || !idCard || !phone) {
                showToast('请填写完整的个人信息', 'warning');
                return;
            }

            showLoading();
            hidePassCode();

            // 先查询预约
            const formData = new FormData();
            formData.append('action', 'guestQuery');
            formData.append('name', name);
            formData.append('idCard', idCard);
            formData.append('phone', phone);

            fetch('../../ReservationServlet', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success && data.data && Array.isArray(data.data) && data.data.length > 0) {
                    const reservation = data.data[0];
                    if (reservation.status === 'approved') {
                        // 生成通行码
                        return fetch(`../../api/passcode/generate?reservationId=${reservation.id}`, {
                            credentials: 'include'
                        });
                    } else {
                        throw new Error('预约状态为: ' + formatStatus(reservation.status) + '，无法生成通行码');
                    }
                } else {
                    throw new Error(data.message || '未找到匹配的预约记录');
                }
            })
            .then(response => response.json())
            .then(data => {
                hideLoading();
                
                if (data.success && data.data) {
                    displayPassCodeWithImage(data.data);
                    showToast('通行码生成成功', 'success');
                } else {
                    showToast(data.message || '生成通行码失败', 'error');
                    showEmptyState();
                }
            })
            .catch(error => {
                console.error('查询失败:', error);
                hideLoading();
                showToast(error.message || '查询失败，请稍后重试', 'error');
                showEmptyState();
            });
        }
    </script>
</body>
</html>
