<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我要预约 - 校园通行码</title>
    <link rel="stylesheet" href="../../css/common.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        :root {
            /* 主要绿色调 */
            --primary-green: #22c55e;      /* 主绿色 */
            --secondary-green: #16a34a;    /* 次绿色 */
            --light-green: #6ee7b7;        /* 浅绿色 */
            --mint-green: #a7f3d0;         /* 薄荷绿 */
            --olive-green: #84cc16;        /* 橄榄绿 */
            --forest-green: #166534;       /* 森林绿 */
            --dark-green: #052e16;         /* 深绿色 */

            /* 绿色背景变体 */
            --primary-light: #ecfdf5;      /* 浅绿背景 */
            --secondary-light: #d1fae5;    /* 次浅绿背景 */
            --accent-light: #f0fdf4;       /* 极浅绿背景 */

            --primary-dark: #047857;       /* 深绿色 */
            --text-dark: #1e293b;          /* 深色文字 */
            --text-light: #64748b;         /* 浅色文字 */

            /* 使用绿色系的渐变 */
            --primary-color: var(--primary-green);
            --accent-color: var(--light-green);
            --gradient-tech: linear-gradient(135deg, var(--primary-green) 0%, var(--secondary-green) 100%);
            --gradient-light: linear-gradient(135deg, var(--primary-light) 0%, var(--secondary-light) 100%);
        }
        
        body {
            background: #ffffff;
            position: relative;
            overflow-x: hidden;
        }
        
        /* 科技感背景元素 */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                radial-gradient(circle at 20% 20%, rgba(37, 99, 235, 0.05) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(59, 130, 246, 0.05) 0%, transparent 50%);
            pointer-events: none;
            z-index: -1;
        }
        
        .container {
            padding: 4px;
            max-width: 425px;
            margin: 0 auto;
        }
        
        /* 头部优化 */
        .header {
            background: var(--gradient-tech);
            border-radius: 8px;
            margin-bottom: 8px;
            position: relative;
            overflow: hidden;
            padding: 10px 15px;
        }
        
        .header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255,255,255,0.1), transparent);
            animation: shine 3s ease-in-out infinite;
        }
        
        @keyframes shine {
            0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
            50% { transform: translateX(100%) translateY(100%) rotate(45deg); }
            100% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
        }
        
        .header h1 {
            color: white;
            font-weight: 700;
            text-shadow: 0 2px 10px rgba(0,0,0,0.2);
            font-size: 16px;
            margin: 0;
        }
        
        /* 表单卡片优化 */
        .card {
            background: var(--gradient-light);
            border: 1px solid rgba(78, 145, 251, 0.2);
            border-radius: 10px;
            margin-bottom: 10px;
            box-shadow: 0 2px 12px rgba(78, 145, 251, 0.08);
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(78, 145, 251, 0.15);
        }
        
        .card-header {
            background: var(--gradient-tech);
            color: white;
            padding: 10px 15px;
            font-weight: 600;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .card-body {
            padding: 12px 15px;
        }
        
        /* 预约类型选择优化 */
        .reservation-type-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin-top: 8px;
        }
        
        .type-option {
            background: white;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 12px 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .type-option:hover {
            border-color: var(--primary-color);
            background: var(--primary-light);
        }
        
        .type-option.selected {
            border-color: var(--primary-color);
            background: var(--gradient-tech);
            color: white;
        }
        
        .type-option input[type="radio"] {
            display: none;
        }
        
        .type-option i {
            font-size: 18px;
            margin-bottom: 5px;
            display: block;
        }
        
        /* 表单元素优化 */
        .form-group {
            margin-bottom: 12px;
        }

        .form-label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
            color: var(--primary-dark); /* 使用绿色系中的深绿色 */
            font-size: 13px;
        }
        
        .form-input, .form-select {
            width: 100%;
            padding: 10px 12px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: white;
        }
        
        .form-input:focus, .form-select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(78, 145, 251, 0.1);
        }
        
        /* 校区选择网格 */
        .campus-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 8px;
            margin-top: 8px;
        }
        
        .campus-option {
            background: white;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 10px 6px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .campus-option:hover {
            border-color: var(--primary-color);
            background: var(--primary-light);
        }
        
        .campus-option.selected {
            border-color: var(--primary-color);
            background: var(--gradient-tech);
            color: white;
        }
        
        .campus-option i {
            font-size: 16px;
            margin-bottom: 3px;
            display: block;
        }
        
        /* 随行人员卡片 */
        .companion-item {
            background: white;
            border: 2px solid var(--primary-color);
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 10px;
            position: relative;
        }
        
        .companion-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            padding-bottom: 6px;
            border-bottom: 1px solid #e9ecef;
        }
        
        .companion-remove {
            background: none;
            border: none;
            color: var(--accent-color);
            cursor: pointer;
            font-size: 18px;
            transition: all 0.3s ease;
        }
        
        .companion-remove:hover {
            color: #ff6b9d;
            transform: scale(1.1);
        }
        
        /* 添加按钮 */
        .add-companion-btn {
            background: var(--gradient-tech);
            border: none;
            color: white;
            padding: 6px 12px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.3s ease;
        }
        
        .add-companion-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 10px rgba(78, 145, 251, 0.3);
        }
        
        /* 提交按钮 */
        .btn-primary {
            background: var(--gradient-tech);
            border: none;
            color: white;
            padding: 12px 20px;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            width: 100%;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .btn-primary::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: width 0.3s ease, height 0.3s ease;
        }
        
        .btn-primary:hover::before {
            width: 300px;
            height: 300px;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(78, 145, 251, 0.3);
        }
        
        /* 响应式设计 */
        @media (max-width: 480px) {
            .container {
                padding: 2px;
            }
            
            .header {
                padding: 8px 12px;
                margin-bottom: 6px;
            }
            
            .header h1 {
                font-size: 15px;
            }
            
            .card {
                margin-bottom: 8px;
                border-radius: 8px;
            }
            
            .card-header {
                padding: 8px 12px;
                font-size: 13px;
            }
            
            .card-body {
                padding: 10px 12px;
            }
            
            .form-group {
                margin-bottom: 10px;
            }
            
            .form-label {
                font-size: 12px;
                margin-bottom: 4px;
            }
            
            .form-input, .form-select {
                padding: 8px 10px;
                font-size: 13px;
            }
            
            .reservation-type-grid {
                grid-template-columns: 1fr;
                gap: 8px;
            }
            
            .type-option {
                padding: 10px 6px;
            }
            
            .type-option i {
                font-size: 16px;
                margin-bottom: 4px;
            }
            
            .campus-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 6px;
            }
            
            .campus-option {
                padding: 8px 4px;
            }
            
            .campus-option i {
                font-size: 14px;
                margin-bottom: 2px;
            }
            
            .companion-item {
                padding: 10px;
                margin-bottom: 8px;
            }
            
            .companion-header {
                margin-bottom: 8px;
                padding-bottom: 5px;
            }
            
            .btn-primary {
                padding: 10px 16px;
                font-size: 14px;
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
            background: linear-gradient(135deg, #b1f63b, #3bf68c);
            border-left: 4px solid #4ef63b;
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
    </style>
</head>
<body>
    <div class="container">
        <!-- 头部 -->
        <header class="header">
            <button class="back-btn" onclick="history.back()">
                <i class="fas fa-arrow-left"></i>
            </button>
            <h1>我要预约</h1>
        </header>

        <form id="reservationForm" class="form-section">
            <!-- 预约类型选择 -->
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-tags"></i> 预约类型
                </div>
                <div class="card-body">
                    <div class="reservation-type-grid">
                        <div class="type-option selected" data-type="public">
                            <input type="radio" id="public" name="reservationType" value="public" checked>
                            <i class="fas fa-users"></i>
                            <div>社会公众预约</div>
                            <small>适用于外来访客</small>
                        </div>
                        <div class="type-option" data-type="business">
                            <input type="radio" id="business" name="reservationType" value="business">
                            <i class="fas fa-briefcase"></i>
                            <div>公务预约</div>
                            <small>适用于公务访问</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 基本信息 -->
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-info-circle"></i> 基本信息
                </div>
                <div class="card-body">
                    <div class="form-group">
                        <label class="form-label">预约校区 *</label>
                        <div class="campus-grid">
                            <div class="campus-option" data-campus="main">
                                <i class="fas fa-university"></i>
                                <div>主校区</div>
                            </div>
                            <div class="campus-option" data-campus="east">
                                <i class="fas fa-building"></i>
                                <div>东校区</div>
                            </div>
                            <div class="campus-option" data-campus="west">
                                <i class="fas fa-school"></i>
                                <div>西校区</div>
                            </div>
                        </div>
                        <input type="hidden" name="campus" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">预约进校时间 *</label>
                        <input type="datetime-local" class="form-input" name="visitTime" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">所在单位 *</label>
                        <input type="text" class="form-input" name="organization" placeholder="请输入所在单位" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">姓名 *</label>
                        <input type="text" class="form-input" name="name" placeholder="请输入姓名" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">身份证号 *</label>
                        <input type="text" class="form-input" name="idCard" placeholder="请输入身份证号" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">手机号 *</label>
                        <input type="tel" class="form-input" name="phone" placeholder="请输入手机号" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">交通方式 *</label>
                        <select class="form-select" name="transportation" required>
                            <option value="">请选择交通方式</option>
                            <option value="walk">步行</option>
                            <option value="bike">自行车</option>
                            <option value="car">私家车</option>
                            <option value="taxi">出租车</option>
                            <option value="bus">公交车</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">车牌号</label>
                        <input type="text" class="form-input" name="plateNumber" placeholder="如有车辆请填写车牌号">
                    </div>
                </div>
            </div>

            <!-- 随行人员 -->
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-user-friends"></i> 随行人员（可选）
                    <button type="button" id="addCompanion" class="add-companion-btn" style="float: right;">
                        <i class="fas fa-plus"></i> 添加
                    </button>
                </div>
                <div class="card-body" id="companionList">
                    <!-- 随行人员列表将在这里动态生成 -->
                </div>
            </div>

            <!-- 公务信息（仅公务预约显示） -->
            <div class="card" id="businessInfo" style="display: none;">
                <div class="card-header">
                    <i class="fas fa-briefcase"></i> 公务信息
                </div>
                <div class="card-body">
                    <div class="form-group">
                        <label class="form-label">公务访问部门 *</label>
                        <select class="form-select" name="visitDepartment">
                            <option value="">请选择访问部门</option>
                            <option value="1">行政办公室</option>
                            <option value="2">教务处</option>
                            <option value="3">学生处</option>
                            <option value="7">计算机学院</option>
                            <option value="8">电子工程学院</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">公务访问接待人 *</label>
                        <input type="text" class="form-input" name="contactPerson" placeholder="请输入接待人姓名">
                    </div>

                    <div class="form-group">
                        <label class="form-label">来访事由 *</label>
                        <textarea class="form-input" name="visitReason" rows="3" placeholder="请详细说明来访事由"></textarea>
                    </div>
                </div>
            </div>

            <button type="submit" class="btn-primary" style="margin: 15px 0 10px 0;">
                <i class="fas fa-paper-plane"></i> 提交预约申请
            </button>
        </form>
    </div>

    <script>
        let selectedCampus = '';
        
        // 现代化通知函数
        function showNotification(message, type = 'info', duration = 5000) {
            console.log('显示通知:', message, type);
            
            // 使用最简单的alert弹框
            alert(message);
        }
        
        // 预约类型切换
        document.querySelectorAll('.type-option').forEach(option => {
            option.addEventListener('click', function() {
                // 移除其他选中状态
                document.querySelectorAll('.type-option').forEach(opt => opt.classList.remove('selected'));
                // 添加当前选中状态
                this.classList.add('selected');
                
                // 设置radio值
                const radioValue = this.dataset.type;
                const radio = document.querySelector(`input[value="${radioValue}"]`);
                radio.checked = true;
                
                // 触发change事件
                radio.dispatchEvent(new Event('change'));
            });
        });
        
        // 原有的预约类型切换逻辑
        document.querySelectorAll('input[name="reservationType"]').forEach(radio => {
            radio.addEventListener('change', function() {
                const businessInfo = document.getElementById('businessInfo');
                if (this.value === 'business') {
                    businessInfo.style.display = 'block';
                    businessInfo.querySelectorAll('input, select, textarea').forEach(input => {
                        input.required = true;
                    });
                } else {
                    businessInfo.style.display = 'none';
                    businessInfo.querySelectorAll('input, select, textarea').forEach(input => {
                        input.required = false;
                    });
                }
            });
        });

        // 校区选择
        document.querySelectorAll('.campus-option').forEach(option => {
            option.addEventListener('click', function() {
                // 移除其他选中状态
                document.querySelectorAll('.campus-option').forEach(opt => opt.classList.remove('selected'));
                // 添加当前选中状态
                this.classList.add('selected');
                selectedCampus = this.dataset.campus;
                
                // 设置隐藏字段值
                document.querySelector('input[name="campus"]').value = selectedCampus;
            });
        });

        // 添加随行人员
        let companionCount = 0;
        document.getElementById('addCompanion').addEventListener('click', function() {
            companionCount++;
            const companionHtml = `
                <div class="companion-item">
                    <div class="companion-header">
                        <strong><i class="fas fa-user"></i> 随行人员 ${companionCount}</strong>
                        <button type="button" class="companion-remove" onclick="this.parentElement.parentElement.remove()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <div class="form-group">
                        <label class="form-label">姓名</label>
                        <input type="text" class="form-input" name="companion_name_${companionCount}" placeholder="请输入随行人员姓名">
                    </div>
                    <div class="form-group">
                        <label class="form-label">身份证号</label>
                        <input type="text" class="form-input" name="companion_idcard_${companionCount}" placeholder="请输入身份证号">
                    </div>
                    <div class="form-group">
                        <label class="form-label">手机号</label>
                        <input type="tel" class="form-input" name="companion_phone_${companionCount}" placeholder="请输入手机号">
                    </div>
                </div>
            `;
            document.getElementById('companionList').innerHTML += companionHtml;
        });

        // 表单提交 - 连接后端API
        document.getElementById('reservationForm').addEventListener('submit', function(e) {
            e.preventDefault();
            console.log('🚀 预约表单提交开始');
            
            // 验证校区选择
            if (!selectedCampus) {
                showNotification('请选择预约校区', 'warning');
                console.log('❌ 校区未选择');
                return;
            }
            
            // 获取提交按钮并显示加载状态
            const submitBtn = document.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 提交中...';
            
            // 收集表单数据
            const formData = new FormData(this);
            console.log('📝 表单数据收集完成');
            
            // 收集随行人员信息
            const companions = [];
            for (let i = 1; i <= companionCount; i++) {
                const name = formData.get(`companion_name_${i}`);
                const idCard = formData.get(`companion_idcard_${i}`);
                const phone = formData.get(`companion_phone_${i}`);
                
                if (name && idCard && phone) {
                    companions.push({ name, idCard, phone });
                }
            }
            console.log('👥 随行人员信息:', companions);
            
            // 从session获取当前登录用户名
            let currentUsername = null;
            // 如果localStorage中有用户信息，提取用户名
            const userInfoStr = localStorage.getItem('userInfo');
            if (userInfoStr) {
                try {
                    const userInfo = JSON.parse(userInfoStr);
                    currentUsername = userInfo.username;
                    console.log('👤 获取到用户名:', currentUsername);
                } catch (e) {
                    console.error('解析用户信息失败:', e);
                }
            }
            
            // 构建请求数据
            const requestData = {
                reservationType: formData.get('reservationType'),
                campus: selectedCampus,
                visitTime: formData.get('visitTime'),
                organization: formData.get('organization'),
                name: formData.get('name'),
                idCard: formData.get('idCard'),
                phone: formData.get('phone'),
                username: currentUsername, // 添加当前登录用户名
                transportation: formData.get('transportation'),
                plateNumber: formData.get('plateNumber') || null,
                visitDepartment: formData.get('visitDepartment') || null,
                contactPerson: formData.get('contactPerson') || null,
                visitReason: formData.get('visitReason') || null,
                companions: companions
            };
            
            // 打印完整请求数据以便调试
            console.log('📤 发送的预约请求数据:', requestData);
            
            // 发送到后端
            fetch('/mobile/api/reservation/create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                // 添加credentials确保会话cookie被发送
                credentials: 'include',
                body: JSON.stringify(requestData)
            })
            .then(response => {
                console.log('📥 收到响应状态:', response.status);
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                console.log('📄 响应数据:', data);
                if (data.success) {
                    showNotification('预约申请提交成功！系统将在1-2个工作日内审核您的申请。', 'success', 3000);
                    // 跳转到我的预约页面
                    setTimeout(() => {
                        console.log('🔄 正在跳转到我的预约页面');
                        window.location.href = '/mobile/pages/reservation/my-reservations.jsp';
                    }, 3000);
                } else {
                    console.log('❌ 提交失败:', data.message);
                    showNotification('提交失败: ' + (data.message || '未知错误'), 'error');
                }
            })
            .catch(error => {
                console.error('🚨 网络错误:', error);
                showNotification('网络错误，请检查网络连接后重试', 'error');
            })
            .finally(() => {
                // 恢复提交按钮状态
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
                console.log('🔄 按钮状态已恢复');
            });
        });
    </script>
</body>
</html>