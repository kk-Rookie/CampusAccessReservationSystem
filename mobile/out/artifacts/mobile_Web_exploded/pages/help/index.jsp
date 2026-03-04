<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>使用帮助 - 校园通行码预约系统</title>
    <link rel="stylesheet" href="../../css/common.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<div class="container">
    <header class="header">
        <div class="header-nav">
            <i class="fas fa-arrow-left" onclick="goBack()"></i>
            <h1>使用帮助</h1>
            <div></div>
        </div>
    </header>

    <div class="main-content">
        <!-- 快速开始 - 两列布局 -->
        <div class="help-section">
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-rocket"></i> 快速开始
                </div>
                <div class="card-body">
                    <div class="quick-steps grid-cols-2">
                        <div class="step-item">
                            <div class="step-number">1</div>
                            <div class="step-content">
                                <h4>填写预约信息</h4>
                                <p>在首页点击"我要预约"，填写个人信息和访问详情</p>
                                <div class="step-icon">
                                    <i class="fas fa-edit"></i>
                                </div>
                            </div>
                        </div>

                        <div class="step-item">
                            <div class="step-number">2</div>
                            <div class="step-content">
                                <h4>获取预约ID</h4>
                                <p>提交成功后记住预约ID，用于查询通行码</p>
                                <div class="step-icon">
                                    <i class="fas fa-hashtag"></i>
                                </div>
                            </div>
                        </div>

                        <div class="step-item">
                            <div class="step-number">3</div>
                            <div class="step-content">
                                <h4>生成通行码</h4>
                                <p>使用预约ID或个人信息查询，系统自动生成通行码</p>
                                <div class="step-icon">
                                    <i class="fas fa-qrcode"></i>
                                </div>
                            </div>
                        </div>

                        <div class="step-item">
                            <div class="step-number">4</div>
                            <div class="step-content">
                                <h4>进校验证</h4>
                                <p>到校门口出示通行码或二维码给保安验证</p>
                                <div class="step-icon">
                                    <i class="fas fa-shield-alt"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 功能介绍 - 两列布局 -->
        <div class="help-section">
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-cogs"></i> 功能介绍
                </div>
                <div class="card-body">
                    <div class="function-list grid-cols-2 gap-10">
                        <div class="function-item" onclick="toggleFunction('reservation')">
                            <div class="function-header">
                                <div class="function-icon">
                                    <i class="fas fa-calendar-plus"></i>
                                </div>
                                <div class="function-title">
                                    <h4>我要预约</h4>
                                    <p>申请进校预约</p>
                                </div>
                                <i class="fas fa-chevron-down toggle-icon"></i>
                            </div>
                            <div class="function-detail" id="reservation-detail">
                                <div class="detail-content">
                                    <div class="feature-grid">
                                        <div class="feature-item">
                                            <i class="fas fa-user"></i>
                                            <span>个人信息录入</span>
                                        </div>
                                        <div class="feature-item">
                                            <i class="fas fa-clock"></i>
                                            <span>访问时间选择</span>
                                        </div>
                                        <div class="feature-item">
                                            <i class="fas fa-car"></i>
                                            <span>交通方式选择</span>
                                        </div>
                                        <div class="feature-item">
                                            <i class="fas fa-users"></i>
                                            <span>随行人员添加</span>
                                        </div>
                                    </div>
                                    <div class="usage-tip">
                                        <i class="fas fa-lightbulb"></i>
                                        <strong>使用建议：</strong>请准确填写个人信息，确保预约成功
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="function-item" onclick="toggleFunction('myreservations')">
                            <div class="function-header">
                                <div class="function-icon">
                                    <i class="fas fa-list-alt"></i>
                                </div>
                                <div class="function-title">
                                    <h4>我的预约</h4>
                                    <p>查看预约记录</p>
                                </div>
                                <i class="fas fa-chevron-down toggle-icon"></i>
                            </div>
                            <div class="function-detail" id="myreservations-detail">
                                <div class="detail-content">
                                    <div class="status-list">
                                        <div class="status-item">
                                            <span class="status-badge pending">待审核</span>
                                            <span>预约已提交，等待审核</span>
                                        </div>
                                        <div class="status-item">
                                            <span class="status-badge approved">已通过</span>
                                            <span>可以生成通行码</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="function-item" onclick="toggleFunction('passcode')">
                            <div class="function-header">
                                <div class="function-icon">
                                    <i class="fas fa-qrcode"></i>
                                </div>
                                <div class="function-title">
                                    <h4>通行码</h4>
                                    <p>获取进校二维码</p>
                                </div>
                                <i class="fas fa-chevron-down toggle-icon"></i>
                            </div>
                            <div class="function-detail" id="passcode-detail">
                                <div class="detail-content">
                                    <div class="qr-demo">
                                        <div class="demo-qr">
                                            <i class="fas fa-qrcode"></i>
                                            <span>示例二维码</span>
                                        </div>
                                        <div class="demo-code">
                                            <strong>通行码：</strong>CAMPUS001234
                                        </div>
                                    </div>
                                    <div class="passcode-features">
                                        <div class="feature-item">
                                            <i class="fas fa-hashtag"></i>
                                            <span>预约ID查询</span>
                                        </div>
                                        <div class="feature-item">
                                            <i class="fas fa-user-check"></i>
                                            <span>个人信息查询</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 使用场景 - 两列布局 -->
        <div class="help-section">
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-map-marked-alt"></i> 使用场景
                </div>
                <div class="card-body">
                    <div class="scenario-list grid-cols-2 gap-12">
                        <div class="scenario-item">
                            <div class="scenario-icon">
                                <i class="fas fa-graduation-cap"></i>
                            </div>
                            <div class="scenario-content">
                                <h4>学术访问</h4>
                                <p>参加学术会议、讲座、研讨会等学术活动</p>
                                <div class="scenario-steps">
                                    选择"公务预约" → 选择访问部门 → 填写访问事由
                                </div>
                            </div>
                        </div>

                        <div class="scenario-item">
                            <div class="scenario-icon">
                                <i class="fas fa-eye"></i>
                            </div>
                            <div class="scenario-content">
                                <h4>参观游览</h4>
                                <p>游客参观校园、了解学校历史文化</p>
                                <div class="scenario-steps">
                                    选择"社会公众预约" → 选择参观时间 → 提交申请
                                </div>
                            </div>
                        </div>

                        <div class="scenario-item">
                            <div class="scenario-icon">
                                <i class="fas fa-handshake"></i>
                            </div>
                            <div class="scenario-content">
                                <h4>商务洽谈</h4>
                                <p>与学校进行商务合作、项目洽谈</p>
                                <div class="scenario-steps">
                                    选择"公务预约" → 联系相关部门 → 预约时间
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 注意事项 - 两列布局 -->
        <div class="help-section">
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-exclamation-triangle"></i> 注意事项
                </div>
                <div class="card-body">
                    <div class="notice-list grid-cols-2 gap-8">
                        <div class="notice-item important">
                            <i class="fas fa-clock"></i>
                            <div>
                                <strong>时效性</strong>
                                <p>通行码有24小时有效期，过期需重新申请</p>
                            </div>
                        </div>

                        <div class="notice-item important">
                            <i class="fas fa-id-card"></i>
                            <div>
                                <strong>身份验证</strong>
                                <p>进校时需携带有效身份证件配合验证</p>
                            </div>
                        </div>

                        <div class="notice-item warning">
                            <i class="fas fa-shield-alt"></i>
                            <div>
                                <strong>安全须知</strong>
                                <p>请勿将通行码分享给他人，仅限本人使用</p>
                            </div>
                        </div>

                        <div class="notice-item info">
                            <i class="fas fa-mobile-alt"></i>
                            <div>
                                <strong>截图保存</strong>
                                <p>建议截图保存二维码，避免网络问题影响使用</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 联系我们 -->
        <div class="help-section">
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-headset"></i> 需要帮助？
                </div>
                <div class="card-body">
                    <div class="contact-info">
                        <div class="contact-item">
                            <i class="fas fa-phone"></i>
                            <div>
                                <strong>服务热线</strong>
                                <p>021-1234-5678</p>
                                <small>工作时间：9:00-17:00</small>
                            </div>
                        </div>

                        <div class="contact-item">
                            <i class="fas fa-envelope"></i>
                            <div>
                                <strong>邮箱支持</strong>
                                <p>support@campus.edu.cn</p>
                                <small>24小时内回复</small>
                            </div>
                        </div>
                    </div>

                    <div class="quick-actions">
                        <button class="action-btn" onclick="location.href='/mobile/pages/reservation/reserve.jsp'">
                            <i class="fas fa-plus"></i> 立即预约
                        </button>
                        <button class="action-btn" onclick="location.href='/mobile/pages/qrcode/pass-code.jsp'">
                            <i class="fas fa-qrcode"></i> 查看通行码
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 底部导航 -->
    <nav class="bottom-nav">
        <div class="nav-item" onclick="location.href='/mobile/index.jsp'">
            <i class="fas fa-home"></i>
            <span>首页</span>
        </div>
        <div class="nav-item" onclick="location.href='/mobile/pages/reservation/my-reservations.jsp'">
            <i class="fas fa-calendar"></i>
            <span>预约</span>
        </div>
        <div class="nav-item" onclick="location.href='/mobile/pages/qrcode/pass-code.jsp'">
            <i class="fas fa-qrcode"></i>
            <span>通行码</span>
        </div>
        <div class="nav-item active">
            <i class="fas fa-question-circle"></i>
            <span>帮助</span>
        </div>
    </nav>
</div>

<script>
    // 切换功能详情
    function toggleFunction(functionName) {
        const detail = document.getElementById(functionName + '-detail');
        const icon = detail.parentElement.querySelector('.toggle-icon');

        if (detail.style.display === 'block') {
            detail.style.display = 'none';
            icon.style.transform = 'rotate(0deg)';
        } else {
            // 隐藏其他详情
            document.querySelectorAll('.function-detail').forEach(el => {
                el.style.display = 'none';
            });
            document.querySelectorAll('.toggle-icon').forEach(icon => {
                icon.style.transform = 'rotate(0deg)';
            });

            // 显示当前详情
            detail.style.display = 'block';
            icon.style.transform = 'rotate(180deg)';
        }
    }

    // 返回上一页
    function goBack() {
        history.back();
    }

    // 页面加载时自动展开第一个功能
    document.addEventListener('DOMContentLoaded', function() {
        setTimeout(() => {
            toggleFunction('reservation');
        }, 500);
    });
</script>

<style>
    :root {
        /* 绿色主色调 */
        --primary-green: #4ade80;      /* 主绿色 - 明亮且友好的绿色 */
        --secondary-green: #22c55e;    /* 次绿色 - 稍微深一点的绿色 */
        --light-green: #a3e635;        /* 浅绿色 - 用于背景或柔和区域 */
        --mint-green: #bef264;         /* 薄荷绿 - 清新感 */
        --olive-green: #84cc16;        /* 橄榄绿 - 稍微偏暗 */
        --forest-green: #16a34a;       /* 森林绿 - 更深的绿色 */
        --dark-green: #052e16;         /* 深绿 - 用于文字或强调部分 */

        /* 浅色背景变体 */
        --primary-light: #ecfdf5;      /* 极浅绿背景 - 主内容区域 */
        --secondary-light: #d1fae5;    /* 次浅绿背景 - 用于卡片或按钮悬停 */
        --accent-light: #f0fdf4;       /* 较浅的绿色背景 - 强调区域 */

        /* 深色背景和文字 */
        --primary-dark: #047857;       /* 深绿色 - 用于导航栏、按钮等重要元素 */

        /* 使用绿色系作为主色调 */
        --primary-color: var(--primary-green);
        --accent-color: var(--light-green);

        /* 字体相关变量 */
        --font-sans: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        --font-size-h1: 18px;
        --font-size-h2: 16px;
        --font-size-h3: 15px;
        --font-size-body: 14px;
        --font-size-small: 12px;
        --font-size-xs: 11px;

        --line-height-h1: 1.3;
        --line-height-h2: 1.4;
        --line-height-body: 1.6;
        --line-height-small: 1.5;

        --letter-spacing-h: 0.5px;
        --letter-spacing-body: 0.2px;
    }

    body {
        font-family: var(--font-sans);
        color: #333;
        line-height: var(--line-height-body);
        letter-spacing: var(--letter-spacing-body);
    }

    .help-section {
        margin-bottom: 16px;
    }

    .grid-cols-2 {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 12px;
    }

    @media (max-width: 600px) {
        .grid-cols-2 {
            grid-template-columns: 1fr;
        }
    }

    .quick-steps {
        position: relative;
    }

    .step-item {
        display: flex;
        align-items: flex-start;
        padding: 12px;
        background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        border-radius: 8px;
        margin-bottom: 12px;
        position: relative;
        box-shadow: 0 1px 3px rgba(0,0,0,0.05);
    }

    .step-number {
        width: 36px;
        height: 36px;
        background: linear-gradient(135deg, var(--primary-green) 0%, var(--secondary-green) 100%);
        color: white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        font-size: 16px;
        margin-right: 12px;
        flex-shrink: 0;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }

    .step-content h4 {
        margin: 0 0 6px 0;
        color: #222;
        font-size: var(--font-size-h3);
        font-weight: 600;
        line-height: var(--line-height-h2);
        letter-spacing: var(--letter-spacing-h);
    }

    .step-content p {
        margin: 0;
        color: #666;
        font-size: var(--font-size-body);
        line-height: var(--line-height-body);
    }

    .step-icon {
        color: var(--primary-green);
        font-size: 20px;
        margin-top: 2px;
    }

    .function-list {
        gap: 12px;
    }

    .function-item {
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        overflow: hidden;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 1px 4px rgba(0,0,0,0.05);
    }

    .function-item:hover {
        box-shadow: 0 3px 8px rgba(0,0,0,0.1);
        transform: translateY(-2px);
    }

    .function-header {
        display: flex;
        align-items: center;
        padding: 14px;
        background: #f0fdf4;
        border-bottom: 1px solid #d1fae5;
    }

    .function-icon {
        width: 44px;
        height: 44px;
        background: linear-gradient(135deg, var(--primary-green) 0%, var(--secondary-green) 100%);
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 20px;
        margin-right: 14px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }

    .function-title h4 {
        margin: 0;
        color: #222;
        font-size: var(--font-size-h3);
        font-weight: 600;
        line-height: var(--line-height-h2);
    }

    .function-title p {
        margin: 4px 0 0 0;
        color: #555;
        font-size: var(--font-size-small);
        line-height: var(--line-height-small);
    }

    .toggle-icon {
        color: var(--primary-green);
        transition: transform 0.3s ease;
        font-size: 18px;
    }

    .function-detail {
        display: none;
        padding: 16px;
        background: white;
        border-top: 1px solid #e9ecef;
    }

    .feature-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 8px;
        margin-bottom: 14px;
    }

    .feature-item {
        display: flex;
        align-items: center;
        gap: 6px;
        padding: 8px 10px;
        background: var(--primary-light);
        border-radius: 6px;
        font-size: var(--font-size-small);
        color: #333;
        line-height: var(--line-height-small);
    }

    .feature-item i {
        color: var(--primary-green);
        font-size: 14px;
    }

    .usage-tip {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 12px;
        background: #fff3cd;
        border-radius: 8px;
        font-size: var(--font-size-small);
        color: #856404;
        line-height: var(--line-height-small);
    }

    .usage-tip strong {
        font-weight: 600;
    }

    .status-list {
        display: flex;
        flex-direction: column;
        gap: 8px;
    }

    .status-item {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 10px;
        background: #f8f9fa;
        border-radius: 6px;
    }

    .status-badge {
        padding: 4px 10px;
        border-radius: 12px;
        font-size: var(--font-size-xs);
        font-weight: 500;
        min-width: 60px;
        text-align: center;
        line-height: 1.2;
    }

    .status-badge.pending {
        background: #fff3cd;
        color: #856404;
    }

    .status-badge.approved {
        background: #d4edda;
        color: #155724;
    }

    .status-badge.rejected {
        background: #f8d7da;
        color: #721c24;
    }

    .status-badge.expired {
        background: #e2e3e5;
        color: #383d41;
    }

    .qr-demo {
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 16px;
        background: #f0fdf4;
        border-radius: 8px;
        margin-bottom: 14px;
    }

    .demo-qr {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 6px;
        font-size: 40px;
        color: var(--primary-green);
        margin-bottom: 8px;
    }

    .demo-code {
        font-family: 'Courier New', monospace;
        font-size: var(--font-size-body);
        color: #333;
        font-weight: 500;
    }

    .passcode-features {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 6px;
    }

    .scenario-list {
        gap: 14px;
    }

    .scenario-item {
        display: flex;
        gap: 14px;
        padding: 16px;
        background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        border-radius: 8px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.05);
    }

    .scenario-icon {
        width: 44px;
        height: 44px;
        background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 20px;
        flex-shrink: 0;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }

    .scenario-content h4 {
        margin: 0 0 6px 0;
        color: #222;
        font-size: var(--font-size-h3);
        font-weight: 600;
        line-height: var(--line-height-h2);
    }

    .scenario-content p {
        margin: 0 0 8px 0;
        color: #666;
        font-size: var(--font-size-body);
        line-height: var(--line-height-body);
    }

    .scenario-steps {
        background: #ffffff;
        padding: 6px 10px;
        border-radius: 4px;
        font-size: var(--font-size-xs);
        color: var(--primary-green);
        border-left: 3px solid var(--primary-green);
        line-height: 1.5;
    }

    .notice-list {
        gap: 10px;
    }

    .notice-item {
        display: flex;
        align-items: flex-start;
        gap: 12px;
        padding: 14px;
        border-radius: 8px;
    }

    .notice-item.important {
        background: #ffebee;
        border-left: 4px solid #f44336;
    }

    .notice-item.warning {
        background: #fff3e0;
        border-left: 4px solid #ff9800;
    }

    .notice-item.info {
        background: #e3f2fd;
        border-left: 4px solid var(--primary-green);
    }

    .notice-item i {
        margin-top: 2px;
        font-size: 18px;
    }

    .notice-item strong {
        display: block;
        margin-bottom: 4px;
        color: #222;
        font-size: var(--font-size-h3);
        font-weight: 600;
        line-height: var(--line-height-h2);
    }

    .notice-item p {
        margin: 0;
        color: #666;
        font-size: var(--font-size-body);
        line-height: var(--line-height-body);
    }

    .contact-info {
        display: flex;
        flex-direction: column;
        gap: 14px;
        margin-bottom: 18px;
    }

    .contact-item {
        display: flex;
        align-items: flex-start;
        gap: 14px;
        padding: 14px;
        background: #f0fdf4;
        border-radius: 8px;
    }

    .contact-item i {
        width: 40px;
        height: 40px;
        background: linear-gradient(135deg, var(--primary-green) 0%, var(--secondary-green) 100%);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 16px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }

    .contact-item strong {
        display: block;
        margin-bottom: 4px;
        color: #222;
        font-size: var(--font-size-h3);
        font-weight: 600;
        line-height: var(--line-height-h2);
    }

    .contact-item p {
        margin: 0 0 2px 0;
        color: var(--primary-green);
        font-weight: 500;
        font-size: var(--font-size-body);
        line-height: var(--line-height-body);
    }

    .contact-item small {
        color: #666;
        font-size: var(--font-size-small);
        line-height: var(--line-height-small);
    }

    .quick-actions {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 10px;
    }

    .action-btn {
        padding: 12px;
        background: linear-gradient(135deg, var(--primary-green) 0%, var(--secondary-green) 100%);
        color: white;
        border: none;
        border-radius: 8px;
        font-size: var(--font-size-body);
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
        line-height: 1.3;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }

    .action-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(14, 55, 22, 0.2);
    }

    /* 卡片标题字体优化 */
    .card-header {
        font-family: var(--font-sans);
        font-weight: 600;
        font-size: var(--font-size-h2);
        line-height: var(--line-height-h2);
        letter-spacing: var(--letter-spacing-h);
    }

    /* 移动端响应式字体 */
    @media (max-width: 480px) {
        :root {
            --font-size-h1: 16px;
            --font-size-h2: 15px;
            --font-size-h3: 14px;
            --font-size-body: 13px;
            --font-size-small: 11px;
            --font-size-xs: 10px;
        }

        .help-section {
            margin-bottom: 10px;
        }

        .step-item {
            padding: 10px;
            margin-bottom: 10px;
        }

        .step-number {
            width: 32px;
            height: 32px;
            font-size: 14px;
            margin-right: 10px;
        }

        .function-header {
            padding: 12px;
        }

        .function-icon {
            width: 40px;
            height: 40px;
            font-size: 18px;
            margin-right: 12px;
        }

        .feature-grid {
            gap: 6px;
            margin-bottom: 12px;
        }

        .feature-item {
            padding: 6px 8px;
            font-size: var(--font-size-small);
        }

        .usage-tip {
            padding: 10px;
            font-size: var(--font-size-small);
        }

        .scenario-item {
            padding: 12px;
            gap: 12px;
        }

        .scenario-icon {
            width: 40px;
            height: 40px;
            font-size: 18px;
        }

        .notice-item {
            padding: 12px;
            gap: 10px;
        }

        .contact-item {
            padding: 12px;
            gap: 12px;
        }

        .contact-item i {
            width: 36px;
            height: 36px;
            font-size: 14px;
        }

        .action-btn {
            padding: 10px;
            font-size: var(--font-size-body);
        }
    }

    /* 超小屏幕进一步优化 */
    @media (max-width: 360px) {
        :root {
            --font-size-h2: 14px;
            --font-size-h3: 13px;
            --font-size-body: 12px;
            --font-size-small: 10px;
        }

        .step-item {
            padding: 8px;
        }

        .step-number {
            width: 28px;
            height: 28px;
            font-size: 12px;
            margin-right: 8px;
        }

        .function-icon {
            width: 36px;
            height: 36px;
            font-size: 16px;
            margin-right: 10px;
        }

        .scenario-item {
            padding: 10px;
            gap: 10px;
        }

        .contact-item {
            padding: 10px;
            gap: 10px;
        }

        .action-btn {
            padding: 8px;
            font-size: var(--font-size-body);
        }
    }
</style>
</body>
</html>