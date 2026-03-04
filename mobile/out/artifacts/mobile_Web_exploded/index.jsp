<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园通行码预约系统</title>
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-green: #4ade80;
            --secondary-green: #34d399;
            --light-green: #6ee7b7;
            --mint-green: #a7f3d0;
            --olive-green: #65a30d;
            --forest-green: #166534;
            --dark-green: #052e16;
            --primary-light: #ecfdf5;
            --secondary-light: #d1fae5;
            --accent-light: #f0fdf4;
            --text-dark: #223b1e;
            --text-light: #648b69;
            --transition: all 0.3s ease;
        }

        body {
            background: linear-gradient(135deg, #f8fafc 0%, var(--accent-light) 100%);
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
        }

        .container {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            max-width: 425px;
            margin: 0 auto;
        }

        /* 头部样式 */
        .header {
            background: linear-gradient(135deg, var(--primary-green) 0%, var(--secondary-green) 100%);
            box-shadow: 0 4px 20px rgba(37, 235, 47, 0.15);
            padding: 20px 15px;
            color: white;
            position: relative;
        }

        .header h1 {
            font-weight: 700;
            text-shadow: 0 2px 10px rgba(255, 255, 255, 0.3);
            margin: 0;
            font-size: 22px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .header h1 i {
            font-size: 24px;
        }

        .header p {
            color: rgba(255, 255, 255, 0.9);
            margin: 8px 0 0;
            font-size: 14px;
        }

        /* 用户菜单和登录按钮 */
        .header-actions {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .user-menu-btn {
            background: none;
            border: none;
            color: white;
            font-size: 24px;
            cursor: pointer;
        }

        .login-btn {
            background: rgba(255, 255, 255, 0.2);
            border: none;
            color: white;
            padding: 8px 16px;
            font-size: 14px;
            border-radius: 8px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 4px;
            transition: var(--transition);
        }

        .login-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
        }

        /* 主要内容区 */
        .main-content {
            padding: 20px 15px;
            padding-bottom: 60px; /* 为底部导航留出空间 */
        }

        /* 功能区样式 */
        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--text-dark);
            margin: 0 0 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--secondary-light);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .section-title i {
            color: var(--primary-green);
        }

        /* 功能列表样式 */
        .function-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-bottom: 25px;
        }

        .function-item {
            background: white;
            border-radius: 12px;
            padding: 18px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            display: flex;
            align-items: center;
            gap: 15px;
            transition: var(--transition);
            border: 1px solid var(--secondary-light);
        }

        .function-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 12px rgba(74, 222, 128, 0.15);
            border-color: var(--primary-green);
        }

        .function-icon {
            width: 40px;
            height: 40px;
            background: var(--primary-light);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-green);
            flex-shrink: 0;
        }

        .function-icon i {
            font-size: 20px;
        }

        .function-content {
            flex: 1;
        }

        .function-title {
            font-weight: 600;
            font-size: 16px;
            color: var(--text-dark);
            margin-bottom: 4px;
        }

        .function-desc {
            color: var(--text-light);
            font-size: 13px;
            line-height: 1.4;
        }

        .action-btn {
            background: linear-gradient(135deg, var(--primary-green) 0%, var(--secondary-green) 100%);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 8px 16px;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(74, 222, 128, 0.3);
        }

        /* 快速通行码 */
        .quick-pass {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            margin-bottom: 25px;
            border: 1px solid var(--secondary-light);
        }

        .quick-pass-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
        }

        .quick-pass-header i {
            color: var(--primary-green);
            font-size: 20px;
        }

        .quick-pass-header h3 {
            font-weight: 600;
            font-size: 16px;
            color: var(--text-dark);
            margin: 0;
        }

        .qrcode-container {
            display: flex;
            justify-content: center;
            margin: 20px 0;
            padding: 30px 0;
            position: relative;
        }

        .qrcode-placeholder {
            width: 100%;
            height: 180px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: #f8fafc;
            border-radius: 12px;
            border: 2px dashed var(--secondary-light);
        }

        .qrcode-placeholder i {
            font-size: 48px;
            color: var(--mint-green);
            margin-bottom: 10px;
        }

        .qrcode-text {
            color: var(--text-light);
            font-size: 14px;
            text-align: center;
        }

        .login-prompt {
            color: var(--text-light);
            font-size: 13px;
            text-align: center;
            margin-top: 10px;
        }

        /* 底部导航样式 */
        .bottom-nav {
            display: flex;
            justify-content: space-around;
            background: white;
            border-top: 1px solid #e0e0e0;
            box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.05);
            padding: 12px 0;
            position: fixed;
            bottom: 0;
            width: 100%;
            z-index: 100;
        }

        .nav-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            color: #666;
            font-size: 12px;
            cursor: pointer;
            transition: var(--transition);
        }

        .nav-item i {
            font-size: 22px;
            margin-bottom: 4px;
        }

        .nav-item.active {
            color: var(--primary-green);
        }

        .nav-item:hover:not(.active) {
            color: var(--primary-green);
        }
    </style>
</head>
<body>
<div class="container">
    <!-- 头部 -->
    <header class="header">
        <h1><i class="fas fa-shield-alt"></i> 校园通行码</h1>
        <p id="userWelcome">预约管理系统</p>

        <!-- 用户菜单和登录按钮 -->
        <div class="header-actions">
            <button class="user-menu-btn" id="userMenuBtn">
                <i class="fas fa-user-circle"></i>
            </button>
            <button class="login-btn" id="loginBtn">
                <i class="fas fa-sign-in-alt"></i> 登录
            </button>
        </div>
    </header>

    <!-- 主要功能区 -->
    <main class="main-content">
        <!-- 常用功能区 -->
        <h2 class="section-title"><i class="fas fa-star"></i> 常用功能</h2>
        <div class="function-list">
            <!-- 预约申请 -->
            <div class="function-item" onclick="navigateToPage('pages/reservation/reserve.jsp')">
                <div class="function-icon">
                    <i class="fas fa-calendar-plus"></i>
                </div>
                <div class="function-content">
                    <div class="function-title">预约申请</div>
                    <div class="function-desc">提交进校预约申请，填写访问信息与事由</div>
                </div>
                <button class="action-btn">
                    <i class="fas fa-arrow-right"></i>
                </button>
            </div>

            <!-- 我的预约 -->
            <div class="function-item" onclick="navigateToPage('pages/reservation/my-reservations.jsp')">
                <div class="function-icon">
                    <i class="fas fa-list-check"></i>
                </div>
                <div class="function-content">
                    <div class="function-title">我的预约</div>
                    <div class="function-desc">查看预约记录，跟踪审核状态与访问时间</div>
                </div>
                <button class="action-btn">
                    <i class="fas fa-arrow-right"></i>
                </button>
            </div>

            <!-- 通行码 -->
            <div class="function-item" onclick="navigateToPage('pages/qrcode/pass-code.jsp')">
                <div class="function-icon">
                    <i class="fas fa-barcode"></i>
                </div>
                <div class="function-content">
                    <div class="function-title">我的通行码</div>
                    <div class="function-desc">生成进校通行凭证，支持扫码验证与离线使用</div>
                </div>
                <button class="action-btn">
                    <i class="fas fa-arrow-right"></i>
                </button>
            </div>

            <!-- 访客预约 -->
            <div class="function-item" onclick="navigateToPage('pages/visitor/register.jsp')">
                <div class="function-icon">
                    <i class="fas fa-user-friends"></i>
                </div>
                <div class="function-content">
                    <div class="function-title">访客预约</div>
                    <div class="function-desc">为来访人员登记信息，提交审核后生成通行码</div>
                </div>
                <button class="action-btn">
                    <i class="fas fa-arrow-right"></i>
                </button>
            </div>
        </div>

        <!-- 其他功能区 -->
        <h2 class="section-title"><i class="fas fa-ellipsis-h"></i> 系统功能</h2>
        <div class="function-list">
            <!-- 预约审批 -->
            <div class="function-item" onclick="navigateToPage('pages/approval/list.jsp')">
                <div class="function-icon">
                    <i class="fas fa-clipboard-check"></i>
                </div>
                <div class="function-content">
                    <div class="function-title">预约审批</div>
                    <div class="function-desc">审核访客预约申请，管理校园访问权限</div>
                </div>
                <button class="action-btn">
                    <i class="fas fa-arrow-right"></i>
                </button>
            </div>

            <!-- 帮助中心 -->
            <div class="function-item" onclick="navigateToPage('pages/help/index.jsp')">
                <div class="function-icon">
                    <i class="fas fa-question-circle"></i>
                </div>
                <div class="function-content">
                    <div class="function-title">帮助中心</div>
                    <div class="function-desc">查看使用指南，获取常见问题解答与操作帮助</div>
                </div>
                <button class="action-btn">
                    <i class="fas fa-arrow-right"></i>
                </button>
            </div>
        </div>

        <!-- 快速通行码（未登录状态） -->
        <div class="quick-pass">
            <div class="quick-pass-header">
                <i class="fas fa-qrcode"></i>
                <h3>快速通行码</h3>
            </div>
            <div class="qrcode-container">
                <div class="qrcode-placeholder">
                    <i class="fas fa-lock"></i>
                    <div class="qrcode-text">通行码已锁定</div>
                </div>
            </div>
            <p class="login-prompt">请先登录账号查看通行码</p>
        </div>
    </main>

    <!-- 底部导航 -->
    <nav class="bottom-nav">
        <div class="nav-item active">
            <i class="fas fa-home"></i>
            <span>首页</span>
        </div>
        <div class="nav-item" onclick="navigateToPage('pages/reservation/my-reservations.jsp')">
            <i class="fas fa-calendar"></i>
            <span>预约</span>
        </div>
        <div class="nav-item" onclick="navigateToPage('pages/qrcode/pass-code.jsp')">
            <i class="fas fa-qrcode"></i>
            <span>通行码</span>
        </div>
        <div class="nav-item" onclick="navigateToPage('pages/profile/index.jsp')">
            <i class="fas fa-user"></i>
            <span>我的</span>
        </div>
    </nav>
</div>

<script>
    // 统一页面跳转函数
    function navigateToPage(url) {
        console.log('导航到:', url);
        window.location.href = url;
    }

    // 页面加载后绑定登录按钮事件
    document.addEventListener('DOMContentLoaded', function() {
        const loginBtn = document.getElementById('loginBtn');
        if (loginBtn) {
            loginBtn.addEventListener('click', function() {
                navigateToPage('/mobile/pages/auth/login.jsp');
            });
        }
    });
</script>
</body>
</html>