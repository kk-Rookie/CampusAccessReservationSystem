<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>快速预约 - 校园通行码</title>
    <link rel="stylesheet" href="../../css/common.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-blue: #3b82f6;
            --secondary-blue: #3b82f6;
            --primary-light: #dbeafe;
            --primary-dark: #1e40af;
        }

        .quick-reserve {
            padding: 10px;
        }
        
        .form-section {
            margin-bottom: 15px;
        }
        
        .form-row {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
        }
        
        .form-row .form-group {
            flex: 1;
        }
        
        .campus-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin: 10px 0;
        }
        
        .campus-option {
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 15px 10px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .campus-option:hover {
            border-color: var(--primary-blue);
            background: var(--primary-light);
        }
        
        .campus-option.selected {
            border-color: var(--primary-blue);
            background: var(--primary-blue);
            color: white;
        }
        
        .time-quick-select {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
            margin: 10px 0;
        }
        
        .time-option {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 6px;
            padding: 10px;
            text-align: center;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        
        .time-option:hover {
            border-color: var(--primary-blue);
            background: var(--primary-light);
        }
        
        .time-option.selected {
            border-color: var(--primary-blue);
            background: var(--primary-blue);
            color: white;
        }
        
        .submit-section {
            padding: 20px 0;
            border-top: 1px solid #e9ecef;
            margin-top: 20px;
        }
        
        .advanced-link {
            text-align: center;
            margin-top: 15px;
        }
        
        .advanced-link a {
            color: var(--primary-blue);
            text-decoration: none;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container quick-reserve">
        <!-- 头部 -->
        <header class="header">
            <button class="back-btn" onclick="history.back()">
                <i class="fas fa-arrow-left"></i>
            </button>
            <h1>快速预约</h1>
        </header>

        <form id="quickReservationForm">
            <!-- 选择校区 -->
            <div class="card form-section">
                <div class="card-header">
                    <i class="fas fa-map-marker-alt"></i> 选择校区
                </div>
                <div class="card-body">
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
                </div>
            </div>

            <!-- 选择时间 -->
            <div class="card form-section">
                <div class="card-header">
                    <i class="fas fa-clock"></i> 进校时间
                </div>
                <div class="card-body">
                    <div class="time-quick-select">
                        <div class="time-option" data-time="now">
                            <div>现在进校</div>
                            <small>立即生效</small>
                        </div>
                        <div class="time-option" data-time="1hour">
                            <div>1小时后</div>
                            <small id="time1h"></small>
                        </div>
                        <div class="time-option" data-time="2hour">
                            <div>2小时后</div>
                            <small id="time2h"></small>
                        </div>
                        <div class="time-option" data-time="tomorrow">
                            <div>明天上午</div>
                            <small id="timeTomorrow"></small>
                        </div>
                    </div>
                    
                    <div class="form-group" style="margin-top: 15px;">
                        <label class="form-label">自定义时间</label>
                        <input type="datetime-local" class="form-input" name="customTime" id="customTime">
                    </div>
                </div>
            </div>

            <!-- 基本信息 -->
            <div class="card form-section">
                <div class="card-header">
                    <i class="fas fa-user"></i> 基本信息
                </div>
                <div class="card-body">
                    <div class="form-group">
                        <label class="form-label">姓名 *</label>
                        <input type="text" class="form-input" name="name" placeholder="请输入姓名" required>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">身份证号 *</label>
                            <input type="text" class="form-input" name="idCard" placeholder="身份证号" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">手机号 *</label>
                            <input type="tel" class="form-input" name="phone" placeholder="手机号" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">所在单位 *</label>
                        <input type="text" class="form-input" name="organization" placeholder="请输入所在单位" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">交通方式</label>
                        <select class="form-select" name="transportation">
                            <option value="walk">步行</option>
                            <option value="bike">自行车</option>
                            <option value="car">私家车</option>
                            <option value="taxi">出租车</option>
                            <option value="bus">公交车</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- 提交按钮 -->
            <div class="submit-section">
                <button type="submit" class="btn btn-primary btn-block">
                    <i class="fas fa-paper-plane"></i> 提交快速预约
                </button>
                
                <div class="advanced-link">
                    <a href="/mobile/pages/reservation/reserve.jsp">
                        <i class="fas fa-cog"></i> 需要更多选项？使用完整预约
                    </a>
                </div>
            </div>
        </form>
    </div>

    <script>
        // 初始化时间显示
        function initTimeDisplay() {
            const now = new Date();
            
            // 1小时后
            const time1h = new Date(now.getTime() + 60 * 60 * 1000);
            document.getElementById('time1h').textContent = 
                time1h.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' });
            
            // 2小时后
            const time2h = new Date(now.getTime() + 2 * 60 * 60 * 1000);
            document.getElementById('time2h').textContent = 
                time2h.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' });
            
            // 明天上午9点
            const tomorrow = new Date(now);
            tomorrow.setDate(tomorrow.getDate() + 1);
            tomorrow.setHours(9, 0, 0, 0);
            document.getElementById('timeTomorrow').textContent = 
                tomorrow.toLocaleDateString('zh-CN', { month: 'short', day: 'numeric' }) + ' 09:00';
        }

        // 校区选择
        let selectedCampus = '';
        document.querySelectorAll('.campus-option').forEach(option => {
            option.addEventListener('click', function() {
                // 移除其他选中状态
                document.querySelectorAll('.campus-option').forEach(opt => opt.classList.remove('selected'));
                // 添加当前选中状态
                this.classList.add('selected');
                selectedCampus = this.dataset.campus;
            });
        });

        // 时间选择
        let selectedTimeType = '';
        let selectedTime = '';
        
        document.querySelectorAll('.time-option').forEach(option => {
            option.addEventListener('click', function() {
                // 移除其他选中状态
                document.querySelectorAll('.time-option').forEach(opt => opt.classList.remove('selected'));
                // 添加当前选中状态
                this.classList.add('selected');
                selectedTimeType = this.dataset.time;
                
                // 清空自定义时间
                document.getElementById('customTime').value = '';
                
                // 计算实际时间
                const now = new Date();
                switch(selectedTimeType) {
                    case 'now':
                        selectedTime = now.toISOString();
                        break;
                    case '1hour':
                        selectedTime = new Date(now.getTime() + 60 * 60 * 1000).toISOString();
                        break;
                    case '2hour':
                        selectedTime = new Date(now.getTime() + 2 * 60 * 60 * 1000).toISOString();
                        break;
                    case 'tomorrow':
                        const tomorrow = new Date(now);
                        tomorrow.setDate(tomorrow.getDate() + 1);
                        tomorrow.setHours(9, 0, 0, 0);
                        selectedTime = tomorrow.toISOString();
                        break;
                }
            });
        });

        // 自定义时间选择
        document.getElementById('customTime').addEventListener('change', function() {
            if (this.value) {
                // 移除快速时间选择
                document.querySelectorAll('.time-option').forEach(opt => opt.classList.remove('selected'));
                selectedTime = new Date(this.value).toISOString();
                selectedTimeType = 'custom';
            }
        });

        // 表单提交
        document.getElementById('quickReservationForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // 验证必填项
            if (!selectedCampus) {
                alert('请选择校区');
                return;
            }
            
            if (!selectedTime && !document.getElementById('customTime').value) {
                alert('请选择进校时间');
                return;
            }
            
            const formData = new FormData(this);
            
            // 使用自定义时间（如果有的话）
            const finalTime = document.getElementById('customTime').value ? 
                new Date(document.getElementById('customTime').value).toISOString() : selectedTime;
            
            // 从localStorage尝试获取用户名
            let currentUsername = null;
            const userInfoStr = localStorage.getItem('userInfo');
            if (userInfoStr) {
                try {
                    const userInfo = JSON.parse(userInfoStr);
                    currentUsername = userInfo.username;
                    console.log('快速预约从localStorage获取到用户名:', currentUsername);
                } catch (e) {
                    console.error('解析用户信息失败:', e);
                }
            }
            
            // 构建请求数据
            const requestData = {
                reservationType: 'public', // 快速预约默认为社会公众预约
                campus: selectedCampus,
                visitTime: finalTime,
                organization: formData.get('organization'),
                name: formData.get('name'),
                idCard: formData.get('idCard'),
                phone: formData.get('phone'),
                username: currentUsername, // 添加用户名
                transportation: formData.get('transportation'),
                plateNumber: null,
                visitDepartment: null,
                contactPerson: null,
                visitReason: '快速预约',
                companions: []
            };
            
            // 打印完整请求数据以便调试
            console.log('发送的快速预约请求数据:', requestData);
            
            // 提交到后端
            fetch('/mobile/api/reservation/create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                // 添加credentials确保会话cookie被发送
                credentials: 'include',
                body: JSON.stringify(requestData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('预约成功！\n' + data.message);
                    // 跳转到我的预约页面
                    location.href = 'my-reservations.jsp';
                } else {
                    alert('预约失败: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('网络错误，请稍后重试');
            });
        });

        // 页面加载时初始化
        document.addEventListener('DOMContentLoaded', function() {
            initTimeDisplay();
        });
    </script>
</body>
</html>
