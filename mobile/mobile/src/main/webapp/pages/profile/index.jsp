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
            --primary-blue: #3b82f6;
            --secondary-blue: #60a5fa;
            --light-blue: #dbeafe;
            --success-green: #10b981;
            --warning-yellow: #f59e0b;
            --danger-red: #ef4444;
            --text-dark: #1e293b;
            --text-light: #64748b;
            --text-muted: #94a3b8;
            --border-color: #e2e8f0;
            --bg-light: #f8fafc;
        }

        /* 全局样式重置 */
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

        /* 主容器 - 移动端优先，最大宽度425px */
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

        /* 头部样式 */
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

        /* 内容区域 */
        .content-padding {
            padding: 16px;
        }

        /* 卡片样式 */
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

        /* 登录提示样式 */
        .login-prompt {
            text-align: center;
            padding: 40px 20px;
        }

        .login-prompt .icon {
            font-size: 72px;
            color: var(--primary-blue);
            margin-bottom: 24px;
            opacity: 0.9;
        }

        .login-prompt h3 {
            color: var(--text-dark);
            margin-bottom: 12px;
            font-size: 22px;
            font-weight: 600;
        }

        .login-prompt p {
            color: var(--text-light);
            margin-bottom: 32px;
            line-height: 1.6;
            font-size: 15px;
        }

        .login-buttons {
            display: flex;
            gap: 12px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-login {
            padding: 14px 28px;
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            min-width: 120px;
            justify-content: center;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(59, 130, 246, 0.3);
        }

        /* 加载状态 */
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

        /* 用户信息卡片 */
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

        /* 功能列表 */
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
        .function-icon.teal { background: rgba(6, 182, 212, 0.1); color: #06b6d4; }
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

        /* 统计卡片 */
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

        /* 退出登录按钮 */
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

        /* 版本信息 */
        .version-info {
            text-align: center;
            margin: 32px 0 20px;
            color: var(--text-muted);
            font-size: 13px;
            line-height: 1.5;
        }

        /* 工具类 */
        .hidden {
            display: none !important;
        }

        .text-center {
            text-align: center;
        }

        /* Toast样式 */
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
    </style>
</head>
<body>
<div class="container">
    <!-- 头部 -->
    <header class="header">
        <h1>个人中心</h1>
    </header>

    <div class="content-padding">
        <!-- 加载状态 -->
        <div id="loadingState" class="loading-state">
            <div class="card">
                <div class="card-body">
                    <div class="loading"></div>
                    <p style="color: var(--text-light); margin-top: 16px;">正在加载个人信息...</p>
                </div>
            </div>
        </div>

        <!-- 未登录状态 -->
        <div id="loginPrompt" class="login-prompt hidden">
            <div class="card">
                <div class="card-body">
                    <div class="icon">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <h3>请先登录</h3>
                    <p>登录后可以查看个人信息<br>管理预约记录，获取通行码</p>

                    <div class="login-buttons">
                        <a href="../auth/login.jsp" class="btn-login">
                            <i class="fas fa-sign-in-alt"></i>
                            立即登录
                        </a>
                        <a href="../auth/register.jsp" class="btn-login">
                            <i class="fas fa-user-plus"></i>
                            注册账户
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- 已登录状态 -->
        <div id="profileContent" class="hidden">
            <!-- 用户信息卡片 -->
            <div class="card">
                <div class="card-body">
                    <div style="display: flex; align-items: center; margin-bottom: 20px;">
                        <div class="user-avatar">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="user-info">
                            <h3 class="user-name" id="userDisplayName">用户信息</h3>
                            <p class="user-desc">管理您的个人信息</p>
                        </div>
                    </div>

                    <div class="user-details">
                        <div class="detail-row">
                            <span class="detail-label">姓名</span>
                            <span class="detail-value" id="userRealName">-</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label">身份证号</span>
                            <span class="detail-value" id="userIdCard">-</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label">手机号</span>
                            <span class="detail-value" id="userPhone">-</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 功能列表 -->
            <div class="card">
                <div class="card-body" style="padding: 0;">
                    <div class="function-item" onclick="location.href='../reservation/reserve.jsp'">
                        <div class="function-left">
                            <div class="function-icon blue">
                                <i class="fas fa-calendar-alt"></i>
                            </div>
                            <span class="function-text">我的预约</span>
                        </div>
                        <i class="fas fa-chevron-right function-arrow"></i>
                    </div>

                    <div class="function-item" onclick="location.href='../qrcode/pass-code.jsp'">
                        <div class="function-left">
                            <div class="function-icon blue">
                                <i class="fas fa-qrcode"></i>
                            </div>
                            <span class="function-text">通行码</span>
                        </div>
                        <i class="fas fa-chevron-right function-arrow"></i>
                    </div>

                    <div class="function-item" onclick="showStatistics()">
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

                    <div class="function-item" onclick="showSettings()">
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

            <!-- 统计信息 -->
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-chart-line"></i> 我的统计
                </div>
                <div class="card-body">
                    <div class="stats-grid">
                        <div class="stat-item">
                            <div class="stat-number blue" id="totalCount">0</div>
                            <div class="stat-label">总预约</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number green" id="approvedCount">0</div>
                            <div class="stat-label">已通过</div>
                        </div>
                    </div>
                    <div class="stats-grid">
                        <div class="stat-item">
                            <div class="stat-number yellow" id="pendingCount">0</div>
                            <div class="stat-label">待审核</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number red" id="rejectedCount">0</div>
                            <div class="stat-label">已拒绝</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 退出登录按钮 -->
            <div class="card">
                <div class="card-body">
                    <button class="logout-btn" onclick="logout()">
                        <i class="fas fa-sign-out-alt"></i> 退出登录
                    </button>
                </div>
            </div>

            <!-- 版本信息 -->
            <div class="version-info">
                <p>校园通行码预约系统</p>
                <p>版本 v1.0.0</p>
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
        <div class="nav-item active">
            <i class="fas fa-user"></i>
            <span>我的</span>
        </div>
    </nav>
</div>

<script>
    // ===== 全局变量 =====
    let currentUser = null;
    let isLoggedIn = false;

    // ===== 页面初始化 =====
    document.addEventListener('DOMContentLoaded', function() {
        console.log('个人中心页面已加载');
        checkLoginStatus();
    });

    // ===== 登录状态检查 =====
    function checkLoginStatus() {
        // 清理旧的本地存储数据，每次重新验证
        localStorage.removeItem('userInfo');

        // 直接检查服务器会话状态
        fetch('../../api/auth/check', {
            credentials: 'include'
        })
            .then(response => response.json())
            .then(data => {
                if (data.success && data.data && data.data.loggedIn) {
                    // 用户已登录，获取用户信息
                    // 注意：API返回的用户信息直接在data.data中，不是data.data.userInfo
                    const userInfo = {
                        id: data.data.id,
                        username: data.data.username,
                        name: data.data.name
                    };

                    currentUser = userInfo;
                    isLoggedIn = true;
                    // 重新设置当前用户信息到localStorage
                    localStorage.setItem('userInfo', JSON.stringify(currentUser));
                    loadUserProfile();
                } else {
                    showLoginPrompt();
                }
            })
            .catch(error => {
                console.log('检查登录状态失败:', error);
                showLoginPrompt();
            });
    }

    // ===== 加载用户资料 =====
    function loadUserProfile() {
        // 获取用户详细信息
        fetch('../../api/user/profile', {
            credentials: 'include'
        })
            .then(response => response.json())
            .then(data => {
                hideLoading();

                if (data.success && data.data) {
                    displayUserProfile(data.data);
                    loadUserStatistics();
                } else {
                    // 使用基本信息显示
                    displayUserProfile(currentUser);
                    loadUserStatistics();
                }
            })
            .catch(error => {
                console.error('加载用户资料失败:', error);
                hideLoading();

                // 使用本地存储的基本信息或模拟数据
                if (currentUser) {
                    displayUserProfile(currentUser);
                    loadUserStatistics();
                } else {
                    showLoginPrompt();
                }
            });
    }

    // ===== 显示用户资料 =====
    function displayUserProfile(userProfile) {
        isLoggedIn = true;

        // 更新用户信息显示
        document.getElementById('userDisplayName').textContent = userProfile.realName || userProfile.username || '用户';
        document.getElementById('userRealName').textContent = maskName(userProfile.realName) || '未设置';
        document.getElementById('userIdCard').textContent = maskIdCard(userProfile.idCard) || '未设置';
        document.getElementById('userPhone').textContent = maskPhone(userProfile.phone) || '未设置';

        // 显示个人中心内容
        showProfileContent();
    }

    // ===== 加载统计数据 =====
    function loadUserStatistics() {
        fetch('../../api/user/statistics', {
            credentials: 'include'
        })
            .then(response => response.json())
            .then(data => {
                if (data.success && data.data) {
                    updateStatistics(data.data);
                } else {
                    // 显示默认统计数据
                    updateStatistics({
                        totalReservations: 0,
                        approvedReservations: 0,
                        pendingReservations: 0,
                        rejectedReservations: 0
                    });
                }
            })
            .catch(error => {
                console.error('加载统计数据失败:', error);
                // 显示默认数据，避免显示模拟数据
                updateStatistics({
                    totalReservations: 0,
                    approvedReservations: 0,
                    pendingReservations: 0,
                    rejectedReservations: 0
                });
            });
    }

    // ===== 更新统计数据 =====
    function updateStatistics(stats) {
        document.getElementById('totalCount').textContent = stats.totalReservations || 0;
        document.getElementById('approvedCount').textContent = stats.approvedReservations || 0;
        document.getElementById('pendingCount').textContent = stats.pendingReservations || 0;
        document.getElementById('rejectedCount').textContent = stats.rejectedReservations || 0;
    }

    // ===== 界面状态管理 =====
    function showLoading() {
        document.getElementById('loadingState').classList.remove('hidden');
        document.getElementById('loginPrompt').classList.add('hidden');
        document.getElementById('profileContent').classList.add('hidden');
    }

    function hideLoading() {
        document.getElementById('loadingState').classList.add('hidden');
    }

    function showLoginPrompt() {
        hideLoading();
        document.getElementById('loginPrompt').classList.remove('hidden');
        document.getElementById('profileContent').classList.add('hidden');
    }

    function showProfileContent() {
        hideLoading();
        document.getElementById('loginPrompt').classList.add('hidden');
        document.getElementById('profileContent').classList.remove('hidden');
    }

    // ===== 数据脱敏函数 =====
    // 姓名脱敏：显示姓和最后一个字，中间用*代替
    function maskName(name) {
        if (!name || name.length < 2) return name;
        if (name.length === 2) {
            return name.charAt(0) + '*';
        }
        return name.charAt(0) + '*'.repeat(name.length - 2) + name.charAt(name.length - 1);
    }

    // 身份证脱敏：显示前4位和后4位
    function maskIdCard(idCard) {
        if (!idCard || idCard.length < 8) return idCard;
        return idCard.substring(0, 4) + '**********' + idCard.substring(idCard.length - 4);
    }

    // 手机号脱敏：显示前3位和后4位
    function maskPhone(phone) {
        if (!phone || phone.length < 7) return phone;
        return phone.substring(0, 3) + '****' + phone.substring(phone.length - 4);
    }

    // ===== 其他功能函数 =====
    function showStatistics() {
        const total = document.getElementById('totalCount').textContent;
        const approved = document.getElementById('approvedCount').textContent;
        const pending = document.getElementById('pendingCount').textContent;

        showToast('预约统计\\n\\n总预约：' + total + '次\\n已通过：' + approved + '次\\n待审核：' + pending + '次', 'info');
    }

    function showSettings() {
        showToast('设置功能\\n\\n· 通知设置\\n· 隐私设置\\n· 关于我们\\n· 退出登录', 'info');
    }

    // 退出登录
    function logout() {
        if (confirm('确定要退出登录吗？')) {
            // 发送退出登录请求
            fetch('../../api/auth/logout', {
                method: 'POST'
            })
                .then(response => response.json())
                .then(data => {
                    // 清理本地存储
                    localStorage.removeItem('userInfo');
                    currentUser = null;
                    isLoggedIn = false;

                    showToast('已退出登录', 'success');
                    setTimeout(() => {
                        location.reload();
                    }, 1000);
                })
                .catch(error => {
                    console.error('退出登录失败:', error);
                    showToast('退出登录失败，请稍后再试', 'error');
                });
        }
    }

    // 显示提示信息
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

    // 创建提示容器
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