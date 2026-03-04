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
            <!-- 快速开始 -->
            <div class="help-section">
                <div class="card">
                    <div class="card-header">
                        <i class="fas fa-rocket"></i> 快速开始
                    </div>
                    <div class="card-body">
                        <div class="quick-steps">
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
                            
                            <div class="step-arrow">
                                <i class="fas fa-arrow-down"></i>
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
                            
                            <div class="step-arrow">
                                <i class="fas fa-arrow-down"></i>
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
                            
                            <div class="step-arrow">
                                <i class="fas fa-arrow-down"></i>
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

            <!-- 功能介绍 -->
            <div class="help-section">
                <div class="card">
                    <div class="card-header">
                        <i class="fas fa-cogs"></i> 功能介绍
                    </div>
                    <div class="card-body">
                        <div class="function-list">
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
                                            <div class="status-item">
                                                <span class="status-badge rejected">已拒绝</span>
                                                <span>预约未通过审核</span>
                                            </div>
                                            <div class="status-item">
                                                <span class="status-badge expired">已过期</span>
                                                <span>通行码已过有效期</span>
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
                                            <div class="feature-item">
                                                <i class="fas fa-download"></i>
                                                <span>二维码保存</span>
                                            </div>
                                            <div class="feature-item">
                                                <i class="fas fa-share"></i>
                                                <span>信息分享</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 使用场景 -->
            <div class="help-section">
                <div class="card">
                    <div class="card-header">
                        <i class="fas fa-map-marked-alt"></i> 使用场景
                    </div>
                    <div class="card-body">
                        <div class="scenario-list">
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

                            <div class="scenario-item">
                                <div class="scenario-icon">
                                    <i class="fas fa-users"></i>
                                </div>
                                <div class="scenario-content">
                                    <h4>团体活动</h4>
                                    <p>组织团体参观、学习交流活动</p>
                                    <div class="scenario-steps">
                                        提前预约 → 添加随行人员 → 统一生成通行码
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 注意事项 -->
            <div class="help-section">
                <div class="card">
                    <div class="card-header">
                        <i class="fas fa-exclamation-triangle"></i> 注意事项
                    </div>
                    <div class="card-body">
                        <div class="notice-list">
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

                            <div class="notice-item info">
                                <i class="fas fa-route"></i>
                                <div>
                                    <strong>通行范围</strong>
                                    <p>通行码仅限指定校区和访问区域</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 常见问题 -->
            <div class="help-section">
                <div class="card">
                    <div class="card-header">
                        <i class="fas fa-question-circle"></i> 常见问题
                    </div>
                    <div class="card-body">
                        <div class="faq-list">
                            <div class="faq-item" onclick="toggleFAQ('faq1')">
                                <div class="faq-question">
                                    <h4>忘记预约ID怎么办？</h4>
                                    <i class="fas fa-chevron-down"></i>
                                </div>
                                <div class="faq-answer" id="faq1">
                                    <p>可以使用"个人信息查询"功能，输入姓名、身份证号和手机号查询通行码。</p>
                                </div>
                            </div>

                            <div class="faq-item" onclick="toggleFAQ('faq2')">
                                <div class="faq-question">
                                    <h4>通行码无法生成？</h4>
                                    <i class="fas fa-chevron-down"></i>
                                </div>
                                <div class="faq-answer" id="faq2">
                                    <p>请检查：1）预约状态是否为"已通过"；2）输入信息是否正确；3）网络连接是否正常。</p>
                                </div>
                            </div>

                            <div class="faq-item" onclick="toggleFAQ('faq3')">
                                <div class="faq-question">
                                    <h4>可以修改预约信息吗？</h4>
                                    <i class="fas fa-chevron-down"></i>
                                </div>
                                <div class="faq-answer" id="faq3">
                                    <p>提交后的预约信息无法修改，如需更改请重新提交预约申请。</p>
                                </div>
                            </div>

                            <div class="faq-item" onclick="toggleFAQ('faq4')">
                                <div class="faq-question">
                                    <h4>二维码扫描失败？</h4>
                                    <i class="fas fa-chevron-down"></i>
                                </div>
                                <div class="faq-answer" id="faq4">
                                    <p>可以向保安出示通行码数字，或者重新生成二维码。保持屏幕亮度充足。</p>
                                </div>
                            </div>

                            <div class="faq-item" onclick="toggleFAQ('faq5')">
                                <div class="faq-question">
                                    <h4>随行人员如何进校？</h4>
                                    <i class="fas fa-chevron-down"></i>
                                </div>
                                <div class="faq-answer" id="faq5">
                                    <p>随行人员信息已包含在主预约中，使用同一个通行码即可，需携带身份证件验证。</p>
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

                            <div class="contact-item">
                                <i class="fas fa-map-marker-alt"></i>
                                <div>
                                    <strong>现场咨询</strong>
                                    <p>校门口保安室</p>
                                    <small>工作日现场协助</small>
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

        // 切换FAQ
        function toggleFAQ(faqId) {
            const answer = document.getElementById(faqId);
            const icon = answer.parentElement.querySelector('.faq-question i');
            
            if (answer.style.display === 'block') {
                answer.style.display = 'none';
                icon.style.transform = 'rotate(0deg)';
            } else {
                answer.style.display = 'block';
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
            --primary-blue: #3b82f6;      /* 主蓝色 - 调整为更友好的蓝色 */
            --secondary-blue: #3b82f6;    /* 次蓝色 */
            --light-blue: #60a5fa;        /* 浅蓝色 */
            --sky-blue: #0ea5e9;          /* 天空蓝 */
            --indigo-blue: #6366f1;       /* 靛蓝 */
            --cyan-blue: #06b6d4;         /* 青蓝色 */
            
            --primary-light: #dbeafe;     /* 浅蓝背景 */
            --secondary-light: #e0f2fe;   /* 次浅蓝背景 */
            --accent-light: #f0f9ff;      /* 极浅蓝背景 */
            
            --primary-dark: #1e40af;      /* 深蓝色 */
            --text-dark: #1e293b;         /* 深色文字 */
            --text-light: #64748b;        /* 浅色文字 */
            
            /* 使用蓝色系作为主色调 */
            --primary-color: var(--primary-blue);
            --accent-color: var(--light-blue);
        }

        .help-section {
            margin-bottom: 12px;
        }

        .quick-steps {
            position: relative;
        }

        .step-item {
            display: flex;
            align-items: center;
            padding: 8px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 6px;
            margin-bottom: 6px;
            position: relative;
        }

        .step-number {
            width: 28px;
            height: 28px;
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 100%);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 14px;
            margin-right: 10px;
            flex-shrink: 0;
        }

        .step-content {
            flex: 1;
        }

        .step-content h4 {
            margin: 0 0 2px 0;
            color: #333;
            font-size: 14px;
        }

        .step-content p {
            margin: 0;
            color: #666;
            font-size: 12px;
            line-height: 1.3;
        }

        .step-icon {
            color: var(--primary-blue);
            font-size: 18px;
        }

        .step-arrow {
            text-align: center;
            color: var(--primary-blue);
            font-size: 14px;
            margin: 3px 0;
        }

        .function-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .function-item {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            overflow: hidden;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .function-item:hover {
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .function-header {
            display: flex;
            align-items: center;
            padding: 12px;
            background: #f8f9fa;
        }

        .function-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 100%);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
            margin-right: 12px;
        }

        .function-title {
            flex: 1;
        }

        .function-title h4 {
            margin: 0 0 3px 0;
            color: #333;
            font-size: 15px;
        }

        .function-title p {
            margin: 0;
            color: #666;
            font-size: 13px;
        }

        .toggle-icon {
            color: var(--primary-blue);
            transition: transform 0.3s ease;
        }

        .function-detail {
            display: none;
            padding: 15px;
            background: white;
            border-top: 1px solid #e0e0e0;
        }

        .feature-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
            margin-bottom: 12px;
        }

        .feature-item {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 6px 10px;
            background: var(--primary-light);
            border-radius: 6px;
            font-size: 13px;
            color: #333;
        }

        .feature-item i {
            color: var(--primary-blue);
        }

        .usage-tip {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 10px;
            background: #fff3cd;
            border-radius: 6px;
            font-size: 13px;
            color: #856404;
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
            padding: 8px;
            background: #f8f9fa;
            border-radius: 6px;
        }

        .status-badge {
            padding: 3px 8px;
            border-radius: 8px;
            font-size: 11px;
            font-weight: 500;
            min-width: 50px;
            text-align: center;
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
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 12px;
        }

        .demo-qr {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
            font-size: 36px;
            color: var(--primary-blue);
            margin-bottom: 8px;
        }

        .demo-code {
            font-family: 'Courier New', monospace;
            font-size: 13px;
            color: #333;
        }

        .passcode-features {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 6px;
        }

        .scenario-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .scenario-item {
            display: flex;
            gap: 12px;
            padding: 15px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 8px;
        }

        .scenario-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
            flex-shrink: 0;
        }

        .scenario-content h4 {
            margin: 0 0 5px 0;
            color: #333;
            font-size: 15px;
        }

        .scenario-content p {
            margin: 0 0 8px 0;
            color: #666;
            font-size: 13px;
        }

        .scenario-steps {
            background: #ffffff;
            padding: 6px 10px;
            border-radius: 4px;
            font-size: 11px;
            color: var(--primary-blue);
            border-left: 3px solid var(--primary-blue);
        }

        .notice-list {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .notice-item {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            padding: 12px;
            border-radius: 6px;
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
            border-left: 4px solid #2196f3;
        }

        .notice-item i {
            margin-top: 1px;
            font-size: 16px;
        }

        .notice-item.important i {
            color: #f44336;
        }

        .notice-item.warning i {
            color: #ff9800;
        }

        .notice-item.info i {
            color: #2196f3;
        }

        .notice-item strong {
            display: block;
            margin-bottom: 3px;
            color: #333;
            font-size: 14px;
        }

        .notice-item p {
            margin: 0;
            color: #666;
            font-size: 13px;
        }

        .faq-list {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .faq-item {
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            overflow: hidden;
        }

        .faq-question {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px;
            background: #f8f9fa;
            cursor: pointer;
        }

        .faq-question h4 {
            margin: 0;
            color: #333;
            font-size: 14px;
        }

        .faq-question i {
            color: var(--primary-blue);
            transition: transform 0.3s ease;
        }

        .faq-answer {
            display: none;
            padding: 12px;
            background: white;
            border-top: 1px solid #e0e0e0;
        }

        .faq-answer p {
            margin: 0;
            color: #666;
            line-height: 1.5;
            font-size: 13px;
        }

        .contact-info {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-bottom: 15px;
        }

        .contact-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 6px;
        }

        .contact-item i {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 14px;
        }

        .contact-item strong {
            display: block;
            margin-bottom: 3px;
            color: #333;
            font-size: 14px;
        }

        .contact-item p {
            margin: 0 0 2px 0;
            color: var(--primary-blue);
            font-weight: 500;
            font-size: 14px;
        }

        .contact-item small {
            color: #666;
            font-size: 11px;
        }

        .quick-actions {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
        }

        .action-btn {
            padding: 10px;
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 100%);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .action-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 3px 8px rgba(37, 99, 235, 0.3);
        }

        /* 移动端响应式优化 */
        @media (max-width: 480px) {
            .help-section {
                margin-bottom: 6px;
            }

            .step-item {
                padding: 6px;
                margin-bottom: 4px;
            }

            .step-number {
                width: 24px;
                height: 24px;
                font-size: 12px;
                margin-right: 8px;
            }

            .step-content h4 {
                font-size: 13px;
                margin-bottom: 1px;
            }

            .step-content p {
                font-size: 11px;
                line-height: 1.2;
            }

            .step-icon {
                font-size: 16px;
            }

            .step-arrow {
                font-size: 12px;
                margin: 2px 0;
            }

            .function-header {
                padding: 10px;
            }

            .function-icon {
                width: 36px;
                height: 36px;
                font-size: 16px;
                margin-right: 10px;
            }

            .function-title h4 {
                font-size: 14px;
            }

            .function-title p {
                font-size: 12px;
            }

            .function-detail {
                padding: 12px;
            }

            .feature-grid {
                gap: 6px;
                margin-bottom: 10px;
            }

            .feature-item {
                padding: 5px 8px;
                font-size: 12px;
            }

            .usage-tip {
                padding: 8px;
                font-size: 12px;
            }

            .scenario-item {
                padding: 12px;
                gap: 10px;
            }

            .scenario-icon {
                width: 36px;
                height: 36px;
                font-size: 16px;
            }

            .scenario-content h4 {
                font-size: 14px;
            }

            .scenario-content p {
                font-size: 12px;
            }

            .scenario-steps {
                font-size: 10px;
                padding: 5px 8px;
            }

            .notice-item {
                padding: 10px;
                gap: 8px;
            }

            .notice-item i {
                font-size: 14px;
            }

            .notice-item strong {
                font-size: 13px;
            }

            .notice-item p {
                font-size: 12px;
            }

            .faq-question {
                padding: 10px;
            }

            .faq-question h4 {
                font-size: 13px;
            }

            .faq-answer {
                padding: 10px;
            }

            .faq-answer p {
                font-size: 12px;
            }

            .contact-item {
                padding: 10px;
                gap: 10px;
            }

            .contact-item i {
                width: 32px;
                height: 32px;
                font-size: 13px;
            }

            .contact-item strong {
                font-size: 13px;
            }

            .contact-item p {
                font-size: 13px;
            }

            .contact-item small {
                font-size: 10px;
            }

            .action-btn {
                padding: 8px;
                font-size: 12px;
            }

            .qr-demo {
                padding: 12px;
            }

            .demo-qr {
                font-size: 32px;
            }

            .demo-code {
                font-size: 12px;
            }
        }

        /* 超小屏幕进一步压缩 */
        @media (max-width: 360px) {
            .help-section {
                margin-bottom: 4px;
            }

            .step-item {
                padding: 4px;
                margin-bottom: 3px;
            }

            .step-number {
                width: 20px;
                height: 20px;
                font-size: 11px;
                margin-right: 6px;
            }

            .step-content h4 {
                font-size: 12px;
                margin-bottom: 1px;
            }

            .step-content p {
                font-size: 10px;
                line-height: 1.1;
            }

            .step-icon {
                font-size: 14px;
            }

            .step-arrow {
                font-size: 10px;
                margin: 1px 0;
            }

            .function-header {
                padding: 8px;
            }

            .function-icon {
                width: 32px;
                height: 32px;
                font-size: 14px;
                margin-right: 8px;
            }

            .function-detail {
                padding: 10px;
            }

            .scenario-item {
                padding: 10px;
                gap: 8px;
            }

            .notice-item {
                padding: 8px;
            }

            .contact-item {
                padding: 8px;
            }

            .action-btn {
                padding: 6px;
                font-size: 11px;
            }
        }
    </style>
</body>
</html>