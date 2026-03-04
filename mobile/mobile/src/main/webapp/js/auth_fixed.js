/**
 * 认证相关的通用JavaScript功能
 * 
 * 重要：为确保用户每次都需要重新登录，所有自动登录检查和缓存功能已被完全禁用
 */

// 全局变量用于控制允许的跳转（在页面加载之前就定义）
window.allowedRedirect = false;

// 允许下一次跳转的函数（全局定义）
window.allowRedirect = function() {
    window.allowedRedirect = true;
    console.log('🟢 auth.js: 已允许下一次跳转');
};

// 立即覆盖 setTimeout（不等待 DOMContentLoaded）
(function() {
    console.log('🔧 auth.js: 立即执行，开始覆盖 setTimeout');
    
    const originalSetTimeout = window.setTimeout;
    window.setTimeout = function(fn, delay) {
        // 检查是否是跳转相关的定时器
        if (typeof fn === 'function') {
            const fnString = fn.toString();
            if (fnString.includes('location') || fnString.includes('href') || fnString.includes('redirect') || fnString.includes('navigate')) {
                if (window.allowedRedirect) {
                    console.log('✅ auth.js: 执行已授权的跳转');
                    window.allowedRedirect = false; // 重置标志
                    return originalSetTimeout.apply(this, arguments);
                } else {
                    console.log('🚫 auth.js: 阻止了未授权的自动跳转定时器');
                    console.log('🚫 auth.js: 被阻止的函数:', fnString.substring(0, 150));
                    return null;
                }
            }
        }
        return originalSetTimeout.apply(this, arguments);
    };
    
    console.log('🔧 auth.js: setTimeout 覆盖完成');
})();

// 完全清除所有本地存储的登录信息
function clearAllLoginData() {
    try {
        // 清除localStorage中的所有认证相关数据
        localStorage.removeItem('userInfo');
        localStorage.removeItem('loginToken');
        localStorage.removeItem('isLoggedIn');
        localStorage.removeItem('lastLoginTime');
        localStorage.removeItem('rememberMe');
        localStorage.removeItem('username');
        localStorage.removeItem('authToken');
        localStorage.removeItem('sessionData');
        
        // 清除sessionStorage中的所有认证相关数据
        sessionStorage.removeItem('userInfo');
        sessionStorage.removeItem('loginToken');
        sessionStorage.removeItem('isLoggedIn');
        sessionStorage.removeItem('lastLoginTime');
        sessionStorage.removeItem('rememberMe');
        sessionStorage.removeItem('username');
        sessionStorage.removeItem('authToken');
        sessionStorage.removeItem('sessionData');
        
        // 清除所有cookies
        document.cookie.split(";").forEach(function(c) { 
            document.cookie = c.replace(/^ +/, "").replace(/=.*/, "=;expires=" + new Date().toUTCString() + ";path=/"); 
        });
        
        console.log('所有登录相关数据已清除');
    } catch (error) {
        console.log('清除登录数据时出错:', error);
    }
}

// 页面加载时立即清除所有登录缓存
document.addEventListener('DOMContentLoaded', function() {
    // 立即清除所有登录相关的缓存数据
    clearAllLoginData();
    
    // 不再重复覆盖 setTimeout，已在上面完成
    
    // 禁用setInterval中的跳转（setInterval中的跳转始终被阻止）
    const originalSetInterval = window.setInterval;
    window.setInterval = function(fn, delay) {
        if (typeof fn === 'function') {
            const fnString = fn.toString();
            if (fnString.includes('location') || fnString.includes('href') || fnString.includes('redirect') || fnString.includes('navigate')) {
                console.log('🚫 auth.js: 阻止了自动跳转循环');
                return null;
            }
        }
        return originalSetInterval.apply(this, arguments);
    };
    
    console.log('🔧 auth.js: 页面加载完成，所有自动跳转已禁用，登录缓存已清除');
});

// 页面显示时也清除缓存（处理浏览器前进/后退）
window.addEventListener('pageshow', function(event) {
    clearAllLoginData();
    console.log('页面显示时清除了登录缓存');
});

// 页面获得焦点时清除缓存
window.addEventListener('focus', function() {
    clearAllLoginData();
    console.log('页面获得焦点时清除了登录缓存');
});

// 切换密码显示/隐藏
function togglePassword(inputId = 'password') {
    const passwordInput = document.getElementById(inputId);
    const toggle = passwordInput.parentElement.querySelector('.password-toggle');
    
    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        toggle.className = 'fas fa-eye-slash password-toggle';
    } else {
        passwordInput.type = 'password';
        toggle.className = 'fas fa-eye password-toggle';
    }
}

// 显示Toast提示
function showToast(message, type = 'info', duration = 3000) {
    const toast = document.createElement('div');
    toast.className = 'toast toast-' + type;
    
    let backgroundColor;
    switch(type) {
        case 'success':
            backgroundColor = '#28a745';
            break;
        case 'error':
            backgroundColor = '#dc3545';
            break;
        case 'warning':
            backgroundColor = '#ffc107';
            break;
        default:
            backgroundColor = '#17a2b8';
    }
    
    toast.style.cssText = 
        'position: fixed;' +
        'top: 20px;' +
        'left: 50%;' +
        'transform: translateX(-50%);' +
        'background: ' + backgroundColor + ';' +
        'color: white;' +
        'padding: 12px 20px;' +
        'border-radius: 5px;' +
        'z-index: 10000;' +
        'box-shadow: 0 2px 10px rgba(0,0,0,0.1);' +
        'font-size: 14px;';
    
    toast.textContent = message;
    document.body.appendChild(toast);
    
    setTimeout(function() {
        toast.style.opacity = '0';
        toast.style.transition = 'opacity 0.3s';
        setTimeout(function() {
            if (toast.parentNode) {
                document.body.removeChild(toast);
            }
        }, 300);
    }, duration);
}

// 检查登录状态 - 完全禁用所有自动跳转功能
function checkLoginStatus() {
    // 完全禁用登录状态检查和自动跳转
    // 用户可以正常访问所有页面，包括登录和注册页面
    console.log('自动登录检查已完全禁用');
    return false;
}
