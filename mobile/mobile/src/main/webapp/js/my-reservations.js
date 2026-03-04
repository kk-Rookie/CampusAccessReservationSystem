/**
 * 我的预约页面 JavaScript
 * 处理预约列表加载、筛选、搜索等功能
 */

let currentFilter = 'all';
let allReservations = [];

// 页面加载时执行
document.addEventListener('DOMContentLoaded', function() {
    console.log('我的预约页面已加载');
    initializePage();
});

// 初始化页面
function initializePage() {
    loadReservations();
    loadUserStats();
    addTechEffects();
    bindEventListeners();
}

// 绑定事件监听器
function bindEventListeners() {
    // 筛选标签点击事件
    document.querySelectorAll('.filter-tab').forEach(tab => {
        tab.addEventListener('click', function() {
            // 更新活动状态
            document.querySelectorAll('.filter-tab').forEach(t => t.classList.remove('active'));
            this.classList.add('active');
            
            currentFilter = this.dataset.status;
            filterReservations();
        });
    });

    // 搜索输入事件
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            filterReservations();
        });
    }

    // 通用按钮事件处理
    document.addEventListener('click', function(e) {
        const action = e.target.dataset.action || e.target.closest('[data-action]')?.dataset.action;
        
        if (action) {
            switch (action) {
                case 'back':
                    window.location.href = '../../index.jsp';
                    break;
                case 'refresh':
                    refreshReservations();
                    break;
                case 'search':
                    searchReservations();
                    break;
                case 'cancel':
                    const reservationId = e.target.dataset.reservationId || 
                                         e.target.closest('[data-reservation-id]')?.dataset.reservationId;
                    if (reservationId) {
                        cancelReservation(reservationId);
                    }
                    break;
            }
        }

        // 底部导航事件
        const nav = e.target.dataset.nav || e.target.closest('[data-nav]')?.dataset.nav;
        if (nav) {
            const contextPath = getContextPath();
            switch (nav) {
                case 'home':
                    window.location.href = `${contextPath}/index.jsp`;
                    break;
                case 'qrcode':
                    window.location.href = `${contextPath}/pages/qrcode/pass-code.jsp`;
                    break;
                case 'profile':
                    window.location.href = `${contextPath}/pages/profile/index.jsp`;
                    break;
            }
        }
    });
}

// 添加科技感效果
function addTechEffects() {
    // 在页面底部创建科技感视觉特效元素
    const container = document.querySelector('.container');
    if (container) {
        const techBackground = document.createElement('div');
        techBackground.classList.add('tech-background');
        techBackground.innerHTML = `
            <div class="tech-circle tech-circle-1"></div>
            <div class="tech-circle tech-circle-2"></div>
            <div class="tech-circle tech-circle-3"></div>
            <div class="tech-dots"></div>
        `;
        container.appendChild(techBackground);
        
        // 创建随机点阵
        const dots = document.querySelector('.tech-dots');
        if (dots) {
            for (let i = 0; i < 50; i++) {
                const dot = document.createElement('div');
                dot.classList.add('tech-dot');
                dot.style.left = `${Math.random() * 100}%`;
                dot.style.top = `${Math.random() * 100}%`;
                dot.style.animationDelay = `${Math.random() * 5}s`;
                dots.appendChild(dot);
            }
        }
    }
}

// 加载预约列表
function loadReservations() {
    showLoading(true);
    
    // 尝试获取当前登录用户名
    let currentUsername = null;
    const userInfoStr = localStorage.getItem('userInfo');
    if (userInfoStr) {
        try {
            const userInfo = JSON.parse(userInfoStr);
            currentUsername = userInfo.username;
            console.log('从localStorage获取到用户名:', currentUsername);
        } catch (e) {
            console.error('解析用户信息失败:', e);
        }
    }
    
    // 构建API URL
    const contextPath = getContextPath();
    const apiUrl = currentUsername ? 
        `${contextPath}/api/reservation/my?username=${encodeURIComponent(currentUsername)}` : 
        `${contextPath}/api/reservation/my`;
        
    console.log('请求预约列表的URL:', apiUrl);
    
    // 创建一个可终止的fetch请求
    const controller = new AbortController();
    const signal = controller.signal;
    
    // 设置超时处理
    const timeoutId = setTimeout(() => controller.abort(), 10000);
    
    fetch(apiUrl, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'Cache-Control': 'no-cache',
            'Pragma': 'no-cache'
        },
        credentials: 'include',
        signal: signal
    })
    .then(response => {
        clearTimeout(timeoutId);
        if (response.status === 400) {
            // 400错误通常表示用户未登录或session过期
            showLoginRequired();
            return null;
        }
        if (!response.ok) {
            throw new Error(`服务器响应错误: ${response.status} ${response.statusText}`);
        }
        return response.json();
    })
    .then(data => {
        if (data === null) return; // 如果是登录问题，直接返回
        
        showLoading(false);
        if (data.success) {
            allReservations = data.data || [];
            renderReservations(allReservations);
            console.log('成功加载预约列表:', allReservations.length, '条记录');
        } else {
            console.error('获取预约失败:', data.message);
            showErrorState('获取数据失败', data.message || '服务器返回错误');
        }
    })
    .catch(error => {
        clearTimeout(timeoutId);
        showLoading(false);
        console.error('网络错误:', error);
        
        let errorMessage = '网络连接错误';
        if (error.name === 'AbortError') {
            errorMessage = '请求超时，请检查网络连接';
        }
        
        showErrorState('连接错误', errorMessage);
    });
}

// 加载用户统计
function loadUserStats() {
    const contextPath = getContextPath();
    
    // 创建一个可终止的fetch请求
    const controller = new AbortController();
    const signal = controller.signal;
    
    // 设置超时处理
    const timeoutId = setTimeout(() => controller.abort(), 8000);
    
    fetch(`${contextPath}/api/user/stats`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'Cache-Control': 'no-cache',
            'Pragma': 'no-cache'
        },
        credentials: 'include',
        signal: signal
    })
    .then(response => {
        clearTimeout(timeoutId);
        if (response.status === 400) {
            // 用户未登录，静默处理，不影响主要功能
            resetStatsDisplay();
            return null;
        }
        if (!response.ok) {
            throw new Error(`服务器响应错误: ${response.status} ${response.statusText}`);
        }
        return response.json();
    })
    .then(data => {
        if (data === null) return; // 如果是登录问题，直接返回
        
        if (data.success) {
            const stats = data.data;
            updateStatsDisplay(stats);
            console.log('成功加载统计数据:', stats);
        }
    })
    .catch(error => {
        clearTimeout(timeoutId);
        console.error('获取统计失败:', error);
        // 统计信息加载失败可以静默处理，不影响主要功能
        resetStatsDisplay();
    });
}

// 更新统计显示
function updateStatsDisplay(stats) {
    const elements = {
        'totalCount': stats.totalReservations || 0,
        'approvedCount': stats.approvedReservations || 0,
        'pendingCount': stats.pendingReservations || 0,
        'rejectedCount': stats.rejectedReservations || 0
    };
    
    Object.entries(elements).forEach(([id, value]) => {
        const element = document.getElementById(id);
        if (element) {
            element.textContent = value;
        }
    });
}

// 重置统计显示
function resetStatsDisplay() {
    ['totalCount', 'approvedCount', 'pendingCount', 'rejectedCount'].forEach(id => {
        const element = document.getElementById(id);
        if (element) {
            element.textContent = '--';
        }
    });
}

// 渲染预约列表
function renderReservations(reservations) {
    const container = document.getElementById('reservationContainer');
    if (!container) return;
    
    if (reservations.length === 0) {
        container.innerHTML = `
            <div class="empty-state">
                <i class="fas fa-calendar-alt"></i>
                <h3>暂无预约记录</h3>
                <p>您还没有任何预约记录<br>点击下方按钮创建您的第一个预约</p>
                <div class="empty-state-hint" style="margin-top:20px; font-size:14px; color:var(--primary-color);">
                    <i class="fas fa-lightbulb" style="font-size:16px; margin-right:5px; opacity:0.7;"></i> 
                    预约成功后将获得专属校园通行码
                </div>
            </div>
        `;
        return;
    }

    const contextPath = getContextPath();
    container.innerHTML = reservations.map(reservation => {
        const statusClass = getStatusClass(reservation.status);
        const statusText = getStatusText(reservation.status);
        const typeText = getTypeText(reservation.reservationType);
        const campusText = getCampusText(reservation.campus);

        return `
            <div class="reservation-item" data-status="${reservation.status}">
                <div class="reservation-id">预约编号: ${reservation.id}</div>
                <div class="reservation-header">
                    <span class="reservation-type">${typeText}</span>
                    <span class="reservation-status ${statusClass}">${statusText}</span>
                </div>
                
                <div class="reservation-details">
                    <div><strong>姓名：</strong>${reservation.name || '--'}</div>
                    <div><strong>校区：</strong>${campusText}</div>
                    <div><strong>访问时间：</strong>${formatDateTime(reservation.visitTime)}</div>
                    ${reservation.organization ? `<div><strong>所属单位：</strong>${reservation.organization}</div>` : ''}
                    ${reservation.visitReason ? `<div><strong>访问事由：</strong>${reservation.visitReason}</div>` : ''}
                    ${reservation.phone ? `<div><strong>联系电话：</strong>${reservation.phone}</div>` : ''}
                </div>

                ${generatePassCodeSection(reservation)}

                <div class="reservation-actions">
                    <a href="${contextPath}/pages/reservation/reservation-detail?id=${reservation.id}" 
                       class="btn btn-primary">
                        <i class="fas fa-eye"></i> 查看详情
                    </a>
                    
                    ${generatePassCodeButton(reservation, contextPath)}
                    ${generateCancelButton(reservation)}
                </div>
            </div>
        `;
    }).join('');
}

// 生成通行码信息区域
function generatePassCodeSection(reservation) {
    if (reservation.status === 'approved' && reservation.passCode) {
        return `
            <div class="pass-code-info">
                <div><strong>通行码：</strong><span class="pass-code">${reservation.passCode}</span></div>
                ${reservation.passCodeExpireTime ? `<div><strong>有效期至：</strong>${formatDateTime(reservation.passCodeExpireTime)}</div>` : ''}
            </div>
        `;
    }
    return '';
}

// 生成通行码按钮
function generatePassCodeButton(reservation, contextPath) {
    if (reservation.status === 'approved' && reservation.passCode) {
        return `
            <a href="${contextPath}/pages/qrcode/pass-code.jsp?reservationId=${reservation.id}" 
               class="btn btn-success">
                <i class="fas fa-qrcode"></i> 通行码
            </a>
        `;
    }
    return '';
}

// 生成取消按钮
function generateCancelButton(reservation) {
    if (reservation.status === 'pending') {
        return `
            <button class="btn btn-warning" onclick="cancelReservation('${reservation.id}')">
                <i class="fas fa-times"></i> 取消
            </button>
        `;
    }
    return '';
}

// 筛选预约
function filterReservations() {
    let filtered = allReservations;
    
    if (currentFilter !== 'all') {
        filtered = allReservations.filter(r => r.status === currentFilter);
    }
    
    const searchTerm = document.getElementById('searchInput').value.toLowerCase();
    if (searchTerm) {
        filtered = filtered.filter(r => 
            (r.name && r.name.toLowerCase().includes(searchTerm)) ||
            (r.organization && r.organization.toLowerCase().includes(searchTerm)) ||
            (r.campus && r.campus.toLowerCase().includes(searchTerm))
        );
    }
    
    renderReservations(filtered);
}

// 搜索预约
function searchReservations() {
    filterReservations();
}

// 取消预约
function cancelReservation(reservationId) {
    if (!confirm('确定要取消这个预约吗？')) {
        return;
    }
    
    const contextPath = getContextPath();
    
    fetch(`${contextPath}/api/reservation/cancel/${reservationId}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        credentials: 'include'
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert('预约已取消');
            loadReservations();
            loadUserStats();
        } else {
            alert('取消失败: ' + data.message);
        }
    })
    .catch(error => {
        console.error('取消预约错误:', error);
        alert('网络错误，请稍后重试');
    });
}

// 刷新预约列表
function refreshReservations() {
    console.log('刷新预约列表');
    loadReservations();
    loadUserStats();
}

// 显示/隐藏加载状态
function showLoading(show) {
    const loadingIndicator = document.getElementById('loadingIndicator');
    if (loadingIndicator) {
        loadingIndicator.style.display = show ? 'block' : 'none';
    }
}

// 显示登录提示
function showLoginRequired() {
    const container = document.getElementById('reservationContainer');
    if (container) {
        container.innerHTML = `
            <div class="login-required-state" style="text-align: center; padding: 40px 20px;">
                <div style="background: linear-gradient(135deg, #3b82f6 0%, #60a5fa 100%); width: 56px; height: 56px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 18px; box-shadow: 0 4px 12px rgba(59, 130, 246, 0.25);">
                    <i class="fas fa-user-lock" style="font-size: 22px; color: white;"></i>
                </div>
                <h3 style="color: #1e293b; font-size: 16px; font-weight: 600; margin: 0 0 6px 0;">需要登录访问</h3>
                <p style="color: #64748b; font-size: 12px; line-height: 1.5; margin: 0 0 20px 0; max-width: 220px; margin-left: auto; margin-right: auto;">
                    您需要登录后才能查看和管理预约记录
                </p>
                <div style="display: flex; gap: 8px; justify-content: center; margin-bottom: 18px;">
                    <button class="btn btn-primary" onclick="goToLogin()" style="
                        background: linear-gradient(135deg, #3b82f6 0%, #60a5fa 100%);
                        color: white;
                        border: none;
                        padding: 8px 16px;
                        border-radius: 6px;
                        font-size: 12px;
                        font-weight: 500;
                        cursor: pointer;
                        transition: all 0.2s ease;
                        box-shadow: 0 2px 6px rgba(59, 130, 246, 0.2);
                        display: inline-flex;
                        align-items: center;
                        gap: 5px;
                        min-width: 75px;
                    " onmouseover="this.style.transform='translateY(-1px)'; this.style.boxShadow='0 3px 10px rgba(59, 130, 246, 0.3)'" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 2px 6px rgba(59, 130, 246, 0.2)'">
                        <i class="fas fa-sign-in-alt" style="font-size: 11px;"></i>
                        登录
                    </button>
                    <button class="btn btn-secondary" onclick="goToRegister()" style="
                        background: white;
                        color: #64748b;
                        border: 1px solid #e2e8f0;
                        padding: 8px 16px;
                        border-radius: 6px;
                        font-size: 12px;
                        font-weight: 500;
                        cursor: pointer;
                        transition: all 0.2s ease;
                        display: inline-flex;
                        align-items: center;
                        gap: 5px;
                        min-width: 75px;
                    " onmouseover="this.style.background='#f8fafc'; this.style.borderColor='#cbd5e1'; this.style.color='#475569'" onmouseout="this.style.background='white'; this.style.borderColor='#e2e8f0'; this.style.color='#64748b'">
                        <i class="fas fa-user-plus" style="font-size: 11px;"></i>
                        注册
                    </button>
                </div>
                <div style="padding: 10px 14px; background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%); border-radius: 6px; border-left: 3px solid #3b82f6; max-width: 220px; margin: 0 auto;">
                    <p style="margin: 0; color: #1e40af; font-size: 11px; line-height: 1.4;">
                        <i class="fas fa-info-circle" style="margin-right: 3px; font-size: 10px;"></i>
                        登录后可查看预约历史、管理记录、获取通行码
                    </p>
                </div>
            </div>
        `;
    }
    
    // 隐藏加载状态
    showLoading(false);
    
    // 重置统计显示
    resetStatsDisplay();
}

// 跳转到登录页面
function goToLogin() {
    const contextPath = getContextPath();
    window.location.href = `${contextPath}/pages/auth/login.jsp`;
}

// 跳转到注册页面
function goToRegister() {
    const contextPath = getContextPath();
    window.location.href = `${contextPath}/pages/auth/register.jsp`;
}

// 显示错误状态
function showErrorState(title, message) {
    const container = document.getElementById('reservationContainer');
    if (container) {
        container.innerHTML = `
            <div class="empty-state">
                <i class="fas fa-exclamation-triangle" style="color: #f59e0b"></i>
                <h3>${title}</h3>
                <p>${message}<br>请稍后重试</p>
                <button class="btn btn-primary" style="margin-top: 20px" onclick="loadReservations()">
                    <i class="fas fa-sync-alt"></i> 重试
                </button>
            </div>
        `;
    }
}

// 工具函数：获取应用上下文路径
function getContextPath() {
    // 直接返回固定的上下文路径，避免从URL中动态提取导致无限循环
    return '/mobile';
}

// 工具函数：获取状态样式类
function getStatusClass(status) {
    const statusMap = {
        'pending': 'status-pending',
        'approved': 'status-approved',
        'rejected': 'status-rejected'
    };
    return statusMap[status] || '';
}

// 工具函数：获取状态文本
function getStatusText(status) {
    const statusMap = {
        'pending': '待审核',
        'approved': '已通过',
        'rejected': '已拒绝'
    };
    return statusMap[status] || status;
}

// 工具函数：获取预约类型文本
function getTypeText(type) {
    const typeMap = {
        'public': '社会公众预约',
        'business': '公务预约'
    };
    return typeMap[type] || type;
}

// 工具函数：获取校区文本
function getCampusText(campus) {
    const campusMap = {
        'main': '主校区',
        'east': '东校区',
        'west': '西校区'
    };
    return campusMap[campus] || campus;
}

// 工具函数：格式化日期时间
function formatDateTime(dateTimeStr) {
    if (!dateTimeStr) return '--';
    
    const date = new Date(dateTimeStr);
    if (isNaN(date.getTime())) return '--';
    
    return date.toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
    });
}

// 将函数暴露到全局作用域，供HTML onclick使用
window.refreshReservations = refreshReservations;
window.searchReservations = searchReservations;
window.cancelReservation = cancelReservation;
window.goToLogin = goToLogin;
window.goToRegister = goToRegister;
