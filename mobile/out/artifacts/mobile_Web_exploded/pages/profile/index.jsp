<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人中心 - 校园通行码</title>
    <link rel="stylesheet" href="../../css/common.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-blue: #3bf68c;
            --secondary-blue: #60facc;
            --light-blue: #dbeafe;
            --success-green: #10b981;
            --warning-yellow: #f59e0b;
            --danger-red: #ef4444;
            --text-dark: #1f3b1e;
            --text-light: #648b66;
            --text-muted: #94a3b8;
            --border-color: #e2e8f0;
            --bg-light: #f8fafc;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
            min-height: 100vh;
        }

        .container {
            max-width: 425px;
            width: 100%;
            margin: 0 auto;
            min-height: 100vh;
            background: white;
            position: relative;
            padding-bottom: 80px;
            box-shadow: 0 0 30px rgba(59, 130, 246, 0.1);
        }

        .header {
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 100%);
            color: white;
            padding: 25px 20px;
            text-align: center;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 4px 20px rgba(59, 130, 246, 0.15);
        }

        .header h1 {
            font-size: 20px;
            font-weight: 700;
            margin: 0;
            letter-spacing: 0.5px;
        }

        .content-padding {
            padding: 16px;
        }

        .card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 2px 16px rgba(0, 0, 0, 0.06);
            margin-bottom: 16px;
            overflow: hidden;
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }

        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 32px rgba(59, 130, 246, 0.1);
        }

        .card-header {
            background: var(--bg-light);
            padding: 16px 20px;
            border-bottom: 1px solid var(--border-color);
            font-weight: 600;
            color: var(--text-dark);
            font-size: 15px;
        }

        .card-body {
            padding: 20px;
        }

        .loading-state {
            text-align: center;
            padding: 60px 20px;
        }

        .loading {
            border: 3px solid #f1f5f9;
            border-top: 3px solid var(--primary-blue);
            border-radius: 50%;
            width: 48px;
            height: 48px;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .user-avatar {
            width: 68px;
            height: 68px;
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 16px;
            box-shadow: 0 4px 16px rgba(59, 130, 246, 0.2);
        }

        .user-avatar i {
            color: white;
            font-size: 28px;
        }

        .user-info {
            flex: 1;
        }

        .user-name {
            font-size: 18px;
            font-weight: 600;
            color: var(--text-dark);
            margin: 0 0 6px 0;
        }

        .user-desc {
            color: var(--text-light);
            font-size: 14px;
            margin: 0;
        }

        .user-details {
            background: var(--bg-light);
            padding: 16px;
            border-radius: 12px;
            margin-top: 20px;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 0;
        }

        .detail-row:not(:last-child) {
            border-bottom: 1px solid var(--border-color);
        }

        .detail-label {
            color: var(--text-light);
            font-size: 14px;
        }

        .detail-value {
            color: var(--text-dark);
            font-size: 14px;
            font-weight: 500;
        }

        .function-item {
            padding: 18px 20px;
            border-bottom: 1px solid var(--border-color);
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .function-item:last-child {
            border-bottom: none;
        }

        .function-item:hover {
            background: var(--bg-light);
        }

        .function-left {
            display: flex;
            align-items: center;
        }

        .function-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 14px;
            font-size: 18px;
        }

        .function-icon.blue { background: rgba(59, 130, 246, 0.1); color: var(--primary-blue); }
        .function-icon.yellow { background: rgba(245, 158, 11, 0.1); color: var(--warning-yellow); }
        .function-icon.teal { background: rgba(20, 212, 6, 0.1); color: #6ad406; }
        .function-icon.gray { background: rgba(100, 116, 139, 0.1); color: var(--text-light); }

        .function-text {
            font-size: 15px;
            font-weight: 500;
            color: var(--text-dark);
        }

        .function-arrow {
            color: var(--text-muted);
            font-size: 14px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
            margin-bottom: 16px;
        }

        .stat-item {
            text-align: center;
            padding: 16px 8px;
        }

        .stat-number {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .stat-label {
            font-size: 12px;
            color: var(--text-light);
            font-weight: 500;
        }

        .stat-number.blue { color: var(--primary-blue); }
        .stat-number.green { color: var(--success-green); }
        .stat-number.yellow { color: var(--warning-yellow); }
        .stat-number.red { color: var(--danger-red); }

        .logout-btn {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            color: white;
            border: none;
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

        .logout-btn:hover {
            background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(239, 68, 68, 0.3);
        }

        .version-info {
            text-align: center;
            margin: 32px 0 20px;
            color: var(--text-muted);
            font-size: 13px;
            line-height: 1.5;
        }

        .hidden {
            display: none !important;
        }

        .text-center {
            text-align: center;
        }

        .toast {
            background: white;
            border-radius: 12px;
            padding: 16px 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
            border: 1px solid var(--border-color);
            font-size: 14px;
            font-weight: 500;
            color: var(--text-dark);
            white-space: pre-line;
        }

        .toast.success {
            border-left: 4px solid var(--success-green);
        }

        .toast.error {
            border-left: 4px solid var(--danger-red);
        }

        .toast.info {
            border-left: 4px solid var(--primary-blue);
        }

        .login-prompt {
            text-align: center;
            padding: 20px 0;
        }

        .login-prompt h3 {
            color: var(--text-dark);
            margin-bottom: 12px;
            font-size: 16px;
            font-weight: 600;
        }

        .login-links {
            display: flex;
            flex-direction: row;
            gap: 12px;
            margin: 16px 0;
            justify-content: center;
        }

        .login-link {
            flex: 1;
            padding: 12px;
            background: var(--bg-light);
            color: var(--primary-blue);
            border: none;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.3s ease;
            border: 1px solid var(--border-color);
        }

        .login-link:hover {
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 100%);
            color: white;
            border-color: transparent;
            transform: translateY(-2px);
            box-shadow: 0 4px 16px rgba(59, 130, 246, 0.2);
        }
    </style>
</head>
<body>
<div class="container">
    <header class="header">
        <h1>个人中心</h1>
    </header>

    <div class="content-padding">
        <div id="loadingState" class="loading-state">
            <div class="card">
                <div class="card-body">
                    <div class="loading"></div>
                    <p style="color: var(--text-light); margin-top: 16px;">正在加载个人信息...</p>
                </div>
            </div>
        </div>

        <div id="profileContent" class="hidden">
            <div class="card">
                <div class="card-body">
                    <div style="display: flex; align-items: center; margin-bottom: 20px;">
                        <div class="user-avatar">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="user-info">
                            <h3 class="user-name" id="userDisplayName">未登录</h3>
                            <p class="user-desc">请先登录查看个人信息</p>
                        </div>
                    </div>

                    <div class="login-prompt">
                        <h3>请先登录</h3>
                        <div class="login-links">
                            <a href="../auth/login.jsp" class="login-link">
                                <i class="fas fa-sign-in-alt"></i>
                                立即登录
                            </a>
                            <a href="../auth/register.jsp" class="login-link">
                                <i class="fas fa-user-plus"></i>
                                注册账户
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-body" style="padding: 0;">
                    <div class="function-item" onclick="showToast('请先登录后使用此功能', 'info')">
                        <div class="function-left">
                            <div class="function-icon blue">
                                <i class="fas fa-calendar-alt"></i>
                            </div>
                            <span class="function-text">我的预约</span>
                        </div>
                        <i class="fas fa-chevron-right function-arrow"></i>
                    </div>

                    <div class="function-item" onclick="showToast('请先登录后使用此功能', 'info')">
                        <div class="function-left">
                            <div class="function-icon blue">
                                <i class="fas fa-qrcode"></i>
                            </div>
                            <span class="function-text">通行码</span>
                        </div>
                        <i class="fas fa-chevron-right function-arrow"></i>
                    </div>

                    <div class="function-item" onclick="showToast('请先登录后使用此功能', 'info')">
                        <div class="function-left">
                            <div class="function-icon yellow">
                                <i class="fas fa-chart-bar"></i>
                            </div>
                            <span class="function-text">预约统计</span>
                        </div>
                        <i class="fas fa-chevron-right function-arrow"></i>
                    </div>

                    <div class="function-item" onclick="location.href='../help/index.jsp'">
                        <div class="function-left">
                            <div class="function-icon teal">
                                <i class="fas fa-question-circle"></i>
                            </div>
                            <span class="function-text">帮助中心</span>
                        </div>
                        <i class="fas fa-chevron-right function-arrow"></i>
                    </div>

                    <div class="function-item" onclick="showToast('请先登录后使用此功能', 'info')">
                        <div class="function-left">
                            <div class="function-icon gray">
                                <i class="fas fa-cog"></i>
                            </div>
                            <span class="function-text">设置</span>
                        </div>
                        <i class="fas fa-chevron-right function-arrow"></i>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <i class="fas fa-chart-line"></i> 我的统计
                </div>
                <div class="card-body">
                    <p style="text-align: center; color: var(--text-muted); padding: 20px 0;">请先登录查看预约统计数据</p>
                </div>
            </div>

            <div class="version-info">
                <p>校园通行码预约系统</p>
                <p>版本 v1.0.0</p>
            </div>
        </div>
    </div>

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
        <div class="nav-item active">
            <i class="fas fa-user"></i>
            <span>我的</span>
        </div>
    </nav>
</div>

<script>
    let isLoggedIn = false;

    document.addEventListener('DOMContentLoaded', function() {
        console.log('个人中心页面已加载');
        checkLoginStatus();
    });

    function checkLoginStatus() {
        // 模拟未登录状态
        isLoggedIn = false;
        showProfileContent();
    }

    function showLoading() {
        document.getElementById('loadingState').classList.remove('hidden');
        document.getElementById('profileContent').classList.add('hidden');
    }

    function hideLoading() {
        document.getElementById('loadingState').classList.add('hidden');
    }

    function showProfileContent() {
        hideLoading();
        document.getElementById('profileContent').classList.remove('hidden');
    }

    function showToast(message, type = 'info') {
        const toastContainer = document.getElementById('toastContainer') || createToastContainer();
        const toast = document.createElement('div');
        toast.className = 'toast ' + type;
        toast.textContent = message;
        toastContainer.appendChild(toast);

        setTimeout(() => {
            toast.remove();
        }, 3000);
    }

    function createToastContainer() {
        const container = document.createElement('div');
        container.id = 'toastContainer';
        container.style.position = 'fixed';
        container.style.top = '20px';
        container.style.right = '20px';
        container.style.zIndex = '1000';
        container.style.display = 'flex';
        container.style.flexDirection = 'column';
        container.style.gap = '10px';
        document.body.appendChild(container);
        return container;
    }
</script>
</body>
</html>