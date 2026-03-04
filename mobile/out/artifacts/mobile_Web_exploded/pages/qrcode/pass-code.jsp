<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>通行码 - 校园通行码预约系统</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-green: #4ade80;
            --secondary-green: #22c55e;
            --primary-light: #ecfdf5;
            --primary-dark: #047857;
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
            background: linear-gradient(135deg, var(--primary-green) 0%, var(--secondary-green) 100%);
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
            border-radius: 16px;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
            margin-bottom: 16px;
            overflow: hidden;
            border: none;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card-header {
            background: linear-gradient(135deg, var(--primary-green) 10%, var(--primary-light) 100%);
            padding: 16px 20px;
            border-bottom: none;
            font-weight: 600;
            color: white;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 16px;
        }

        .card-header i {
            font-size: 20px;
        }

        .card-body {
            padding: 20px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: #052e16;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .form-group input {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #d1fae5;
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: white;
            box-sizing: border-box;
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--primary-green);
            background: white;
            box-shadow: 0 0 0 3px rgba(78, 145, 251, 0.1);
        }

        .form-hint {
            font-size: 12px;
            color: #648b69;
            margin-top: 6px;
            display: flex;
            align-items: center;
            gap: 3px;
        }

        .btn-primary {
            width: 100%;
            background: linear-gradient(135deg, var(--primary-green) 0%, var(--secondary-green) 100%);
            color: white;
            border: none;
            padding: 16px 24px;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(127, 251, 78, 0.3);
        }

        .pass-code-container {
            margin-bottom: 16px;
        }

        .empty-state,
        .loading-state {
            text-align: center;
            padding: 16px 6px;
        }

        .loading-state p {
            font-size: 14px;
            margin-top: 8px;
        }

        .loading-spinner {
            font-size: 24px;
            margin-bottom: 8px;
        }

        .toast {
            position: fixed;
            top: 20px;
            right: 20px;
            background: white;
            border-radius: 12px;
            padding: 16px 20px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
            display: flex;
            align-items: center;
            gap: 12px;
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
        .toast-info { border-left-color: #2d6833; }

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
            padding: 8px 0;
            box-shadow: 0 -1px 4px rgba(0,0,0,0.04);
            z-index: 100;
        }

        .nav-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 4px;
            padding: 8px 12px;
            cursor: pointer;
            color: #6c757d;
            text-decoration: none;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            position: relative;
            border-radius: 12px;
            margin: 4px 2px;
        }

        .nav-item.active {
            color: var(--primary-green);
            background: #f0fdf4;
        }

        .nav-item i {
            font-size: 20px;
            position: relative;
            z-index: 1;
            transition: transform 0.3s ease;
        }

        .nav-item span {
            font-size: 12px;
            font-weight: 500;
            position: relative;
            z-index: 1;
            letter-spacing: 0.3px;
        }

        .pass-code-info {
            background: #d1fae5;
            border-radius: 16px;
            padding: 16px;
            margin-bottom: 16px;
            border: 2px solid #a7f3d0;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .pass-code-number {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            flex-wrap: wrap;
            width: 100%;
        }

        .pass-code-number .label {
            font-weight: 600;
            color: #052e16;
            font-size: 14px;
        }

        .code-text {
            font-family: 'SF Mono', 'Monaco', 'Cascadia Code', 'Roboto Mono', monospace;
            font-size: 18px;
            font-weight: 700;
            color: var(--primary-green);
            background: white;
            padding: 12px 20px;
            border-radius: 12px;
            letter-spacing: 1.5px;
            border: 2px solid #a7f3d0;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
        }

        .copy-btn {
            background: var(--primary-green);
            color: white;
            border: none;
            padding: 10px 16px;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 14px;
        }

        .copy-btn:hover {
            background: #487e54;
            transform: scale(1.05);
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
            border: 2px solid #f0fdf4;
            transition: all 0.3s ease;
        }

        .info-item i {
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-green));
            color: white;
            border-radius: 10px;
            font-size: 16px;
            flex-shrink: 0;
        }

        .info-item .label {
            font-size: 13px;
            color: #648b69;
            font-weight: 500;
            display: block;
            margin-bottom: 4px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .info-item .value {
            font-weight: 600;
            color: #052e16;
            font-size: 16px;
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

        .action-buttons {
            display: grid;
            grid-template-columns: 1fr;
            gap: 16px;
            margin-top: 24px;
        }

        .action-buttons button {
            padding: 16px 20px;
            border: none;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-secondary {
            background: #f8f9fa;
            color: #495057;
            border: 2px solid #e9ecef;
        }

        .btn-secondary:hover {
            background: #e9ecef;
            transform: translateY(-2px);
        }

        .btn-success {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            transform: translateY(-2px);
        }

        .usage-tip {
            margin-top: 24px;
        }

        .tip-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 16px;
            color: var(--primary-green);
            font-weight: 600;
            font-size: 16px;
        }

        .tip-header i {
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-green));
            color: white;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
        }

        .tip-content {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .tip-item {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            font-size: 14px;
            color: #648b69;
            line-height: 1.6;
        }

        .tip-item i {
            color: #10b981;
            font-size: 18px;
            margin-top: 2px;
            flex-shrink: 0;
        }

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
            border: 2px solid #10b981;
        }

        .status-expired {
            background: #fee2e2;
            color: #991b1b;
            border: 2px solid #ef4444;
        }

        .qr-tip {
            color: #648b69;
            font-size: 14px;
            margin: 16px 0 0 0;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .qr-tip i {
            color: var(--primary-green);
        }

        /* 查询区域样式 */
        .search-section {
            margin-bottom: 20px;
            padding: 16px;
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .search-section h3 {
            font-size: 16px;
            font-weight: 600;
            margin: 0 0 16px 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .search-method {
            margin-bottom: 16px;
        }

        .method-select {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #d1fae5;
            border-radius: 12px;
            font-size: 16px;
            appearance: none;
            background: white url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23648b69' d='M6 8.5L2.5 5 3.91 3.59l2.09 2.09L8.09 3.59 9.5 5z'/%3E%3C/svg%3E") no-repeat right 16px center;
            background-size: 16px;
        }

        .search-form {
            display: none;
        }

        .search-form.active {
            display: block;
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* 无通行码状态 */
        .no-pass-code {
            text-align: center;
            padding: 24px;
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            margin-bottom: 20px;
        }

        .no-pass-code h3 {
            font-size: 18px;
            color: #052e16;
            margin-bottom: 12px;
        }

        .no-pass-code p {
            font-size: 14px;
            color: #648b69;
            margin-bottom: 20px;
        }

        .reserve-link {
            display: inline-block;
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-green));
            color: white;
            padding: 12px 24px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .reserve-link:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(127, 251, 78, 0.3);
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
                padding: 12px 16px;
                font-size: 15px;
            }

            .card-body {
                padding: 16px;
            }

            .search-section {
                padding: 12px;
            }

            .form-group {
                margin-bottom: 10px;
            }

            .form-group input {
                padding: 12px 14px;
                font-size: 14px;
            }

            .no-pass-code {
                padding: 20px;
            }

            .no-pass-code h3 {
                font-size: 16px;
            }

            .reserve-link {
                padding: 10px 20px;
                font-size: 14px;
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
        <!-- 查询通行码区域 -->
        <div class="search-section">
            <h3><i class="fas fa-search"></i> 查询我的通行码</h3>
            <div class="search-method">
                <select id="searchMethod" class="method-select" onchange="showSearchForm(this.value)">
                    <option value="id">预约ID查询</option>
                    <option value="personal">个人信息查询</option>
                </select>
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
                    <span>立即查询</span>
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
                    <span>立即查询</span>
                </button>
            </form>
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

        <!-- 无通行码状态 -->
        <div id="noPassCodeState" class="no-pass-code" style="display: block;">
            <h3>暂无通行码</h3>
            <p>您还没有生成通行码，请通过上方选项查询或创建新的预约申请</p>
            <a href="/mobile/pages/reservation/reserve.jsp" class="reserve-link">
                <i class="fas fa-plus"></i> 立即预约通行码
            </a>
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

<script>
    document.addEventListener('DOMContentLoaded', function() {
        console.log('通行码页面已加载');
        const urlParams = new URLSearchParams(window.location.search);
        const reservationId = urlParams.get('reservationId');
        if (reservationId) {
            document.getElementById('reservationId').value = reservationId;
            document.getElementById('searchMethod').value = 'id';
            showSearchForm('id');
            setTimeout(() => {
                searchByReservationId({ preventDefault: function() {} });
            }, 500);
        }
    });

    function goBack() {
        history.back();
    }

    function refreshPage() {
        location.reload();
    }

    function showSearchForm(method) {
        document.querySelectorAll('.search-form').forEach(form => form.classList.remove('active'));
        document.getElementById(method + 'SearchForm').classList.add('active');
    }

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

        setTimeout(() => toast.classList.add('show'), 100);

        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => {
                if (toast.parentNode) {
                    document.body.removeChild(toast);
                }
            }, 300);
        }, 3000);
    }

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
            const link = document.createElement('a');
            link.download = '校园通行码_' + new Date().getTime() + '.png';
            link.href = qrImg.src;
            link.click();
            showToast('二维码已保存', 'success');
        } else if (qrCanvas) {
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

    function showLoading() {
        document.getElementById('loadingState').style.display = 'block';
        document.getElementById('passCodeContainer').style.display = 'none';
        document.getElementById('noPassCodeState').style.display = 'none';
        document.getElementById('usageTip').style.display = 'none';
    }

    function hideLoading() {
        document.getElementById('loadingState').style.display = 'none';
    }

    function hidePassCode() {
        document.getElementById('passCodeContainer').style.display = 'none';
    }

    function showNoPassCode() {
        document.getElementById('noPassCodeState').style.display = 'block';
        document.getElementById('passCodeContainer').style.display = 'none';
        document.getElementById('usageTip').style.display = 'block';
    }

    function showPassCode() {
        document.getElementById('passCodeContainer').style.display = 'block';
        document.getElementById('noPassCodeState').style.display = 'none';
        document.getElementById('usageTip').style.display = 'block';
    }

    function displayPassCodeWithImage(passCodeData) {
        document.getElementById('passCodeText').textContent = passCodeData.passCode || '无效通行码';

        const qrDisplay = document.getElementById('qrCodeDisplay');
        qrDisplay.innerHTML = `
                <img src="${passCodeData.qrCodeImage}"
                     alt="通行码二维码"
                     style="width: 200px; height: 200px; border-radius: 8px; background: white;">
            `;

        document.getElementById('nameText').textContent = passCodeData.name || '-';
        document.getElementById('idCardText').textContent = passCodeData.idCard || '-';
        document.getElementById('visitTimeText').textContent = passCodeData.visitTime || '-';
        document.getElementById('campusText').textContent = formatCampus(passCodeData.campus) || '-';
        document.getElementById('expireTimeText').textContent = passCodeData.expireTime || '-';

        const statusIndicator = document.getElementById('statusIndicator');
        const now = new Date();
        const expireTime = new Date(passCodeData.expireTime);

        if (expireTime > now) {
            statusIndicator.className = 'status-indicator status-valid';
            statusIndicator.textContent = '有效通行码';
            document.querySelector('.expire-item').classList.remove('expired');
        } else {
            statusIndicator.className = 'status-indicator status-expired';
            statusIndicator.textContent = '已过期';
            document.querySelector('.expire-item').classList.add('expired');
        }

        showPassCode();
    }

    function formatCampus(campus) {
        const campusMap = {
            'main': '主校区',
            'east': '东校区',
            'west': '西校区',
            'north': '北校区'
        };
        return campusMap[campus] || campus;
    }

    function searchByReservationId(event) {
        event.preventDefault();

        const reservationId = document.getElementById('reservationId').value.trim();

        if (!reservationId) {
            showToast('请输入预约ID', 'warning');
            return;
        }

        showLoading();
        hidePassCode();

        // 模拟API请求，实际项目中替换为真实请求
        setTimeout(() => {
            hideLoading();

            // 模拟返回数据
            const passCodeData = {
                passCode: 'A1B2C3D4',
                qrCodeImage: 'https://picsum.photos/200/200?random=' + Math.random(),
                name: '张三',
                idCard: '310101199001011234',
                visitTime: '2025年6月28日 10:00-17:00',
                campus: 'main',
                expireTime: '2025年6月28日 17:00'
            };

            displayPassCodeWithImage(passCodeData);
            showToast('通行码查询成功', 'success');
        }, 1500);
    }

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

        // 模拟API请求，实际项目中替换为真实请求
        setTimeout(() => {
            hideLoading();

            // 模拟返回数据
            const passCodeData = {
                passCode: 'E5F6G7H8',
                qrCodeImage: 'https://picsum.photos/200/200?random=' + Math.random() + '2',
                name: name,
                idCard: idCard,
                visitTime: '2025年6月28日 14:00-18:00',
                campus: 'east',
                expireTime: '2025年6月28日 18:00'
            };

            displayPassCodeWithImage(passCodeData);
            showToast('通行码查询成功', 'success');
        }, 1500);
    }
</script>
</body>
</html>