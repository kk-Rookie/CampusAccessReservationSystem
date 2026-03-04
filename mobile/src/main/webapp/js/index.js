/**
 * 主页数据加载和管理脚本
 */

// 全局变量
let currentUser = null;
let isLoggedIn = false;

// 页面加载时初始化
document.addEventListener('DOMContentLoaded', function() {
    createTechDots();
    checkLoginStatus();
});

// 创建装饰性动态点
function createTechDots() {
    const dotsContainer = document.querySelector('.tech-dots');
    if (!dotsContainer) return;
    
    for (let i = 0; i < 50; i++) {
        const dot = document.createElement('div');
        dot.className = 'tech-dot';
        dot.style.left = Math.random() * 100 + '%';
        dot.style.top = Math.random() * 100 + '%';
        dot.style.animationDelay = Math.random() * 8 + 's';
        dotsContainer.appendChild(dot);
    }
}

// 检查登录状态
function checkLoginStatus() {
    fetch('/mobile/api/auth/check', {
        credentials: 'include'
    })
    .then(response => response.json())
    .then(data => {
        if (data.success && data.data && data.data.loggedIn) {
            // 已登录
            const user = data.data;
            currentUser = user;
            isLoggedIn = true;
            
            // 更新头部显示
            updateHeaderForLoggedInUser(user);
            
            // 加载用户统计数据
            loadUserStatistics();
            
            // 保存用户信息
            localStorage.setItem('userInfo', JSON.stringify(user));
        } else {
            // 未登录
            updateHeaderForGuestUser();
            showDefaultStatistics();
        }
    })
    .catch(error => {
        console.log('检查登录状态失败:', error);
        updateHeaderForGuestUser();
        showDefaultStatistics();
    });
}

// 更新已登录用户的头部显示
function updateHeaderForLoggedInUser(user) {
    const userWelcome = document.getElementById('userWelcome');
    const userMenu = document.getElementById('userMenu');
    const loginBtn = document.getElementById('loginBtn');
    
    if (userWelcome) {
        userWelcome.textContent = `欢迎，${user.name || user.username}`;
    }
    
    if (userMenu) {
        userMenu.style.display = 'block';
    }
    
    if (loginBtn) {
        loginBtn.style.display = 'none';
    }
}

// 更新访客用户的头部显示
function updateHeaderForGuestUser() {
    const userWelcome = document.getElementById('userWelcome');
    const userMenu = document.getElementById('userMenu');
    const loginBtn = document.getElementById('loginBtn');
    
    if (userWelcome) {
        userWelcome.textContent = '预约管理系统';
    }
    
    if (userMenu) {
        userMenu.style.display = 'none';
    }
    
    if (loginBtn) {
        loginBtn.style.display = 'block';
    }
}

// 加载用户统计数据
function loadUserStatistics() {
    fetch('/mobile/api/user/statistics', {
        credentials: 'include'
    })
    .then(response => response.json())
    .then(data => {
        if (data.success && data.data) {
            updateStatisticsDisplay(data.data);
        } else {
            showDefaultStatistics();
        }
    })
    .catch(error => {
        console.error('加载统计数据失败:', error);
        showDefaultStatistics();
    });
}

// 更新统计数据显示
function updateStatisticsDisplay(stats) {
    const todayCount = document.getElementById('todayReservationCount');
    const totalCount = document.getElementById('totalReservationCount');
    
    if (todayCount) {
        // 这里可以根据实际需要计算今日预约数量
        // 目前简单显示待审核的数量作为今日预约
        todayCount.textContent = stats.pendingReservations || 0;
    }
    
    if (totalCount) {
        totalCount.textContent = stats.totalReservations || 0;
    }
    
    // 如果有其他统计信息也可以在这里更新
    console.log('统计数据已更新:', stats);
}

// 显示默认统计数据（未登录状态）
function showDefaultStatistics() {
    const todayCount = document.getElementById('todayReservationCount');
    const totalCount = document.getElementById('totalReservationCount');
    
    if (todayCount) {
        todayCount.textContent = '--';
    }
    
    if (totalCount) {
        totalCount.textContent = '--';
    }
}

// 显示用户菜单
function showUserMenu() {
    // 显示用户菜单选项
    const options = [
        { text: '个人中心', action: () => location.href = '/mobile/pages/profile/index.jsp' },
        { text: '我的预约', action: () => location.href = '/mobile/pages/reservation/my-reservations.jsp' },
        { text: '退出登录', action: logout }
    ];
    
    // 简单的确认对话框，实际项目中可以使用更美观的菜单
    const choice = prompt(
        '请选择操作：\n' +
        '1. 个人中心\n' +
        '2. 我的预约\n' +
        '3. 退出登录\n\n' +
        '请输入数字(1-3)：'
    );
    
    switch(choice) {
        case '1':
            location.href = '/mobile/pages/profile/index.jsp';
            break;
        case '2':
            location.href = '/mobile/pages/reservation/my-reservations.jsp';
            break;
        case '3':
            logout();
            break;
        default:
            // 取消或无效输入，不做任何操作
            break;
    }
}

// 退出登录
function logout() {
    if (confirm('确定要退出登录吗？')) {
        fetch('/mobile/api/auth/logout', { 
            method: 'POST',
            credentials: 'include'
        })
        .then(response => response.json())
        .then(data => {
            localStorage.removeItem('userInfo');
            currentUser = null;
            isLoggedIn = false;
            location.reload();
        })
        .catch(error => {
            console.error('退出失败:', error);
            // 即使请求失败也清理本地状态
            localStorage.removeItem('userInfo');
            location.reload();
        });
    }
}

// 导航到功能页面 - 无需登录即可访问
function navigateToPage(url) {
    // 构建完整路径
    const fullUrl = url.startsWith('/') ? url : '/mobile/' + url;
    
    // 直接导航，不需要登录检查
    location.href = fullUrl;
}

// 显示登录提示（保留备用，但默认不使用）
function showLoginPrompt(targetUrl) {
    // 创建模态框
    const modal = document.createElement('div');
    modal.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 10000;
        animation: fadeIn 0.3s ease;
    `;
    
    // 创建提示框内容
    const content = document.createElement('div');
    content.style.cssText = `
        background: white;
        border-radius: 16px;
        padding: 30px;
        max-width: 320px;
        width: 90%;
        text-align: center;
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        animation: slideIn 0.3s ease;
    `;
    
    content.innerHTML = `
        <div style="margin-bottom: 20px;">
            <i class="fas fa-info-circle" style="font-size: 48px; color: #3b82f6; margin-bottom: 16px;"></i>
            <h3 style="margin: 0 0 8px 0; color: #1e293b; font-size: 18px;">提示</h3>
            <p style="margin: 0; color: #64748b; font-size: 14px; line-height: 1.5;">
                登录后可享受更多个性化功能<br>是否前往登录页面？
            </p>
        </div>
        <div style="display: flex; gap: 12px; justify-content: center;">
            <button id="loginCancel" style="
                padding: 10px 20px;
                border: 1px solid #e2e8f0;
                background: white;
                color: #64748b;
                border-radius: 8px;
                cursor: pointer;
                font-size: 14px;
                transition: all 0.2s ease;
            ">取消</button>
            <button id="loginConfirm" style="
                padding: 10px 20px;
                border: none;
                background: linear-gradient(135deg, #3b82f6 0%, #60a5fa 100%);
                color: white;
                border-radius: 8px;
                cursor: pointer;
                font-size: 14px;
                transition: all 0.2s ease;
            ">去登录</button>
        </div>
    `;
    
    // 添加CSS动画
    const style = document.createElement('style');
    style.textContent = `
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        @keyframes slideIn {
            from { transform: translateY(-20px) scale(0.95); opacity: 0; }
            to { transform: translateY(0) scale(1); opacity: 1; }
        }
        #loginCancel:hover {
            background: #f8fafc !important;
            border-color: #cbd5e1 !important;
        }
        #loginConfirm:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }
    `;
    document.head.appendChild(style);
    
    modal.appendChild(content);
    document.body.appendChild(modal);
    
    // 绑定事件
    document.getElementById('loginCancel').onclick = () => {
        document.body.removeChild(modal);
        document.head.removeChild(style);
    };
    
    document.getElementById('loginConfirm').onclick = () => {
        document.body.removeChild(modal);
        document.head.removeChild(style);
        location.href = '/mobile/pages/auth/login.jsp';
    };
    
    // 点击背景关闭
    modal.onclick = (e) => {
        if (e.target === modal) {
            document.body.removeChild(modal);
            document.head.removeChild(style);
        }
    };
}
