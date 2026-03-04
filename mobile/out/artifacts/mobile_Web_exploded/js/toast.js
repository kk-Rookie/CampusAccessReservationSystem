/**
 * 全局 Toast 提示系统
 * 使用方法：Toast.show('消息', '类型', 持续时间)
 */
window.Toast = (function() {
    let container = null;
    
    // 创建 Toast 容器
    function createContainer() {
        if (container) return container;
        
        container = document.createElement('div');
        container.id = 'globalToastContainer';
        container.style.cssText = `
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: 10000;
            pointer-events: none;
        `;
        document.body.appendChild(container);
        return container;
    }
    
    // 添加 Toast 样式（只添加一次）
    function addStyles() {
        if (document.getElementById('toastStyles')) return;
        
        const style = document.createElement('style');
        style.id = 'toastStyles';
        style.textContent = `
            .global-toast {
                background: rgba(0, 0, 0, 0.85);
                color: white;
                padding: 16px 24px;
                border-radius: 12px;
                font-size: 14px;
                font-weight: 500;
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.1);
                max-width: 300px;
                text-align: center;
                word-wrap: break-word;
                animation: toastSlideIn 0.3s ease-out;
                pointer-events: auto;
                margin-bottom: 10px;
            }

            .global-toast.success {
                background: linear-gradient(135deg, rgba(16, 185, 129, 0.9), rgba(5, 150, 105, 0.9));
                border-color: rgba(16, 185, 129, 0.3);
            }

            .global-toast.error {
                background: linear-gradient(135deg, rgba(239, 68, 68, 0.9), rgba(220, 38, 38, 0.9));
                border-color: rgba(239, 68, 68, 0.3);
            }

            .global-toast.warning {
                background: linear-gradient(135deg, rgba(245, 158, 11, 0.9), rgba(217, 119, 6, 0.9));
                border-color: rgba(245, 158, 11, 0.3);
            }

            .global-toast.info {
                background: linear-gradient(135deg, rgba(59, 130, 246, 0.9), rgba(37, 99, 235, 0.9));
                border-color: rgba(59, 130, 246, 0.3);
            }

            .toast-icon {
                display: inline-block;
                margin-right: 8px;
                font-size: 16px;
            }

            .toast-message {
                display: inline-block;
                vertical-align: middle;
            }

            @keyframes toastSlideIn {
                0% {
                    opacity: 0;
                    transform: scale(0.8) translateY(-20px);
                }
                100% {
                    opacity: 1;
                    transform: scale(1) translateY(0);
                }
            }

            @keyframes toastSlideOut {
                0% {
                    opacity: 1;
                    transform: scale(1) translateY(0);
                }
                100% {
                    opacity: 0;
                    transform: scale(0.8) translateY(-20px);
                }
            }

            .global-toast.removing {
                animation: toastSlideOut 0.3s ease-in forwards;
            }

            @media (max-width: 480px) {
                .global-toast {
                    max-width: 280px;
                    padding: 14px 20px;
                    font-size: 13px;
                }
            }
        `;
        document.head.appendChild(style);
    }
    
    // 显示 Toast
    function show(message, type = 'info', duration = 3000) {
        addStyles();
        const container = createContainer();
        
        // 图标映射
        const icons = {
            success: 'fas fa-check-circle',
            error: 'fas fa-exclamation-circle',
            warning: 'fas fa-exclamation-triangle',
            info: 'fas fa-info-circle'
        };

        // 创建 toast 元素
        const toast = document.createElement('div');
        toast.className = `global-toast ${type}`;
        toast.innerHTML = `
            <i class="${icons[type]} toast-icon"></i>
            <span class="toast-message">${message}</span>
        `;

        // 清除之前的 toast（防止重叠）
        const existingToasts = container.querySelectorAll('.global-toast');
        existingToasts.forEach(t => {
            if (!t.classList.contains('removing')) {
                t.classList.add('removing');
                setTimeout(() => {
                    if (t.parentNode) {
                        t.parentNode.removeChild(t);
                    }
                }, 300);
            }
        });

        // 添加新的 toast
        container.appendChild(toast);

        // 自动移除
        setTimeout(() => {
            if (toast.parentNode) {
                toast.classList.add('removing');
                setTimeout(() => {
                    if (toast.parentNode) {
                        toast.parentNode.removeChild(toast);
                    }
                }, 300);
            }
        }, duration);

        // 点击关闭
        toast.addEventListener('click', () => {
            if (toast.parentNode) {
                toast.classList.add('removing');
                setTimeout(() => {
                    if (toast.parentNode) {
                        toast.parentNode.removeChild(toast);
                    }
                }, 300);
            }
        });
    }
    
    // 便捷方法
    return {
        show: show,
        success: (message, duration) => show(message, 'success', duration),
        error: (message, duration) => show(message, 'error', duration),
        warning: (message, duration) => show(message, 'warning', duration),
        info: (message, duration) => show(message, 'info', duration)
    };
})();

// 兼容旧的 showToast 函数
function showToast(message, type = 'info', duration = 3000) {
    Toast.show(message, type, duration);
}

// 禁用原生 alert 替换，避免意外行为
// window.alert = function(message) {
//     Toast.info(message, 4000);
// };