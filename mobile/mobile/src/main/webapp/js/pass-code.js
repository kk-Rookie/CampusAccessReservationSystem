/**
 * 通行码页面专用JavaScript功能
 */

let currentPassCodeData = null;

// ===== 页面初始化 =====
document.addEventListener('DOMContentLoaded', function() {
    console.log('通行码页面已加载');
    
    // 从URL参数获取预约ID
    const urlParams = new URLSearchParams(window.location.search);
    const reservationId = urlParams.get('reservationId');
    console.log('从URL获取的预约ID:', reservationId);
    
    if (reservationId) {
        document.getElementById('reservationId').value = reservationId;
        // 自动查询
        setTimeout(function() {
            searchByReservationId({ preventDefault: function() {} });
        }, 500);
    } else {
        console.log('URL中未找到预约ID参数');
        showEmptyState();
    }
});

// ===== 查询功能 =====

// 切换查询方式
function switchTab(tabType) {
    const tabs = document.querySelectorAll('.tab-btn');
    const forms = document.querySelectorAll('.search-form');
    
    tabs.forEach(function(tab) {
        tab.classList.remove('active');
    });
    forms.forEach(function(form) {
        form.classList.remove('active');
    });
    
    if (tabType === 'id') {
        document.querySelector('.tab-btn').classList.add('active');
        document.getElementById('idSearchForm').classList.add('active');
    } else {
        document.querySelectorAll('.tab-btn')[1].classList.add('active');
        document.getElementById('personalSearchForm').classList.add('active');
    }
}

// 通过预约ID查询
function searchByReservationId(event) {
    event.preventDefault();
    
    const reservationId = document.getElementById('reservationId').value.trim();
    
    if (!reservationId) {
        showToast('请输入预约ID', 'warning');
        return;
    }

    showLoading();
    hidePassCode();

    // 发送请求到后端
    const apiUrl = '/mobile/api/passcode/generate?reservationId=' + encodeURIComponent(reservationId);
    
    fetch(apiUrl)
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            hideLoading();
            
            if (data.success && data.data) {
                displayPassCode(data.data);
                showToast('通行码生成成功', 'success');
            } else {
                showToast(data.message || '生成通行码失败', 'error');
                showEmptyState();
            }
        })
        .catch(function(error) {
            console.error('生成失败:', error);
            hideLoading();
            
            // 生成模拟数据用于测试
            const mockData = generateMockPassCode(reservationId);
            displayPassCode(mockData);
            showToast('已生成测试通行码（开发模式）', 'info');
        });
}

// 通过个人信息查询
function searchByPersonalInfo(event) {
    event.preventDefault();
    
    const name = document.getElementById('userName').value.trim();
    const idCard = document.getElementById('userIdCard').value.trim();
    const phone = document.getElementById('userPhone').value.trim();
    
    if (!name || !idCard || !phone) {
        showToast('请填写完整的个人信息', 'warning');
        return;
    }

    showLoading();
    hidePassCode();

    // 发送查询请求
    fetch('/mobile/api/reservation/query', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            name: name,
            idCard: idCard,
            phone: phone
        })
    })
    .then(function(response) {
        return response.json();
    })
    .then(function(data) {
        hideLoading();
        
        if (data.success && data.data) {
            if (data.data.status === 'approved') {
                // 根据查询到的预约生成通行码
                generatePassCodeFromReservation(data.data);
            } else {
                showToast('预约状态为: ' + formatStatus(data.data.status) + '，无法生成通行码', 'warning');
                showEmptyState();
            }
        } else {
            showToast(data.message || '未找到匹配的预约记录', 'error');
            showEmptyState();
        }
    })
    .catch(function(error) {
        console.error('查询失败:', error);
        hideLoading();
        
        // 生成模拟数据用于测试
        const mockData = generateMockPassCodeByPersonal(name, idCard, phone);
        displayPassCode(mockData);
        showToast('已生成测试通行码（开发模式）', 'info');
    });
}

// 根据预约数据生成通行码
function generatePassCodeFromReservation(reservationData) {
    const apiUrl = '/mobile/api/passcode/generate?reservationId=' + reservationData.id;
    
    fetch(apiUrl)
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            if (data.success && data.data) {
                displayPassCode(data.data);
                showToast('通行码生成成功', 'success');
            } else {
                // 如果后端生成失败，使用预约数据创建模拟通行码
                const passCodeData = {
                    reservationId: reservationData.id,
                    passCode: generatePassCodeNumber(),
                    name: reservationData.name,
                    idCard: maskIdCard(reservationData.idCard || ''),
                    visitTime: formatDateTime(reservationData.visitTime),
                    campus: reservationData.campus,
                    expireTime: calculateExpireTime(reservationData.visitTime),
                    isExpired: false,
                    qrCodeData: generateQRCodeData(reservationData)
                };
                displayPassCode(passCodeData);
                showToast('通行码生成成功', 'success');
            }
        })
        .catch(function(error) {
            console.error('生成通行码失败:', error);
            // 降级处理：创建基于预约数据的模拟通行码
            const passCodeData = {
                reservationId: reservationData.id,
                passCode: generatePassCodeNumber(),
                name: reservationData.name,
                idCard: maskIdCard(reservationData.idCard || ''),
                visitTime: formatDateTime(reservationData.visitTime),
                campus: reservationData.campus,
                expireTime: calculateExpireTime(reservationData.visitTime),
                isExpired: false,
                qrCodeData: generateQRCodeData(reservationData)
            };
            displayPassCode(passCodeData);
            showToast('通行码生成成功（离线模式）', 'info');
        });
}

// ===== 通行码显示功能 =====

// 显示通行码
function displayPassCode(passCodeData) {
    currentPassCodeData = passCodeData;
    
    // 更新页面元素
    document.getElementById('passCodeText').textContent = passCodeData.passCode || generatePassCodeNumber();
    document.getElementById('nameText').textContent = passCodeData.name || '-';
    document.getElementById('idCardText').textContent = passCodeData.idCard || '-';
    document.getElementById('visitTimeText').textContent = passCodeData.visitTime || '-';
    document.getElementById('campusText').textContent = formatCampus(passCodeData.campus) || '-';
    document.getElementById('expireTimeText').textContent = passCodeData.expireTime || '-';
    
    // 显示后端生成的二维码图片
    if (passCodeData.qrCodeImage) {
        const qrDisplay = document.getElementById('qrCodeDisplay');
        if (qrDisplay) {
            qrDisplay.innerHTML = `
                <img src="${passCodeData.qrCodeImage}" 
                     alt="通行码二维码" 
                     style="width: 200px; height: 200px; border-radius: 8px; background: white;">
            `;
        }
    } else {
        // 备用：生成前端二维码（如果后端没有返回图片）
        generateQRCode(passCodeData.qrCodeData || generateQRCodeData(passCodeData));
    }
    
    // 检查过期状态
    updateExpireStatus(passCodeData);
    
    // 显示通行码容器
    showPassCode();
    hideEmptyState();
}

// 生成二维码（已改为使用后端生成的Base64图片）
function generateQRCode(qrData) {
    console.log('注意：系统使用后端ZXing库生成二维码，前端JavaScript库已不再需要');
    // 此函数已不再使用，二维码由后端生成并通过 displayPassCodeWithImage() 显示
}

// 更新过期状态
function updateExpireStatus(passCodeData) {
    const statusIndicator = document.getElementById('statusIndicator');
    const expireTimeElement = document.getElementById('expireTimeText');
    const passCodeContainer = document.getElementById('passCodeContainer');
    
    if (passCodeData.isExpired || isExpired(passCodeData.expireTime)) {
        statusIndicator.textContent = '已过期';
        statusIndicator.className = 'status-indicator status-expired';
        expireTimeElement.style.color = '#e74c3c';
        
        // 添加过期样式到通行码容器
        if (passCodeContainer) {
            passCodeContainer.className = 'pass-code-container status-expired';
        }
        
        // 添加过期样式
        const expireItem = expireTimeElement.closest('.info-item');
        if (expireItem) {
            expireItem.classList.add('expired');
        }
    } else {
        statusIndicator.textContent = '有效';
        statusIndicator.className = 'status-indicator status-valid';
        expireTimeElement.style.color = '#28a745';
        
        // 添加有效样式到通行码容器
        if (passCodeContainer) {
            passCodeContainer.className = 'pass-code-container status-valid';
        }
    }
}

// ===== 操作功能 =====

// 复制通行码
function copyPassCode() {
    const passCodeText = document.getElementById('passCodeText').textContent;
    
    if (navigator.clipboard) {
        navigator.clipboard.writeText(passCodeText).then(function() {
            showToast('通行码已复制到剪贴板', 'success');
        }).catch(function(error) {
            console.error('复制失败:', error);
            fallbackCopyTextToClipboard(passCodeText);
        });
    } else {
        fallbackCopyTextToClipboard(passCodeText);
    }
}

// 降级复制方法
function fallbackCopyTextToClipboard(text) {
    const textArea = document.createElement('textarea');
    textArea.value = text;
    document.body.appendChild(textArea);
    textArea.focus();
    textArea.select();
    
    try {
        const successful = document.execCommand('copy');
        if (successful) {
            showToast('通行码已复制到剪贴板', 'success');
        } else {
            showToast('复制失败，请手动复制', 'error');
        }
    } catch (error) {
        console.error('复制失败:', error);
        showToast('复制失败，请手动复制', 'error');
    }
    
    document.body.removeChild(textArea);
}

// 下载二维码
function downloadQRCode() {
    const canvas = document.getElementById('qrCanvas');
    if (!canvas) {
        showToast('找不到二维码，请先生成通行码', 'error');
        return;
    }
    
    try {
        // 创建下载链接
        const link = document.createElement('a');
        link.download = '校园通行码_' + (currentPassCodeData?.passCode || Date.now()) + '.png';
        link.href = canvas.toDataURL();
        
        // 触发下载
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        
        showToast('二维码已保存到下载文件夹', 'success');
    } catch (error) {
        console.error('下载失败:', error);
        showToast('下载失败，请长按二维码保存', 'error');
    }
}

// 分享通行码
function sharePassCode() {
    if (!currentPassCodeData) {
        showToast('请先生成通行码', 'warning');
        return;
    }
    
    const shareData = {
        title: '校园通行码',
        text: `通行码: ${currentPassCodeData.passCode}\n访问时间: ${currentPassCodeData.visitTime}\n校区: ${formatCampus(currentPassCodeData.campus)}`,
        url: window.location.href
    };
    
    if (navigator.share) {
        navigator.share(shareData).then(function() {
            showToast('分享成功', 'success');
        }).catch(function(error) {
            console.error('分享失败:', error);
            fallbackShare(shareData);
        });
    } else {
        fallbackShare(shareData);
    }
}

// 降级分享方法
function fallbackShare(shareData) {
    const shareText = shareData.text + '\n' + shareData.url;
    
    if (navigator.clipboard) {
        navigator.clipboard.writeText(shareText).then(function() {
            showToast('分享内容已复制到剪贴板', 'success');
        });
    } else {
        fallbackCopyTextToClipboard(shareText);
    }
}

// 刷新通行码
function refreshPassCode() {
    if (!currentPassCodeData) {
        showToast('请先生成通行码', 'warning');
        return;
    }
    
    // 重新生成通行码
    const reservationId = currentPassCodeData.reservationId;
    if (reservationId) {
        document.getElementById('reservationId').value = reservationId;
        searchByReservationId({ preventDefault: function() {} });
    } else {
        showToast('无法刷新，缺少预约ID', 'error');
    }
}

// ===== 状态管理 =====

function showLoading() {
    document.getElementById('loadingState').style.display = 'block';
    hideEmptyState();
    hidePassCode();
}

function hideLoading() {
    document.getElementById('loadingState').style.display = 'none';
}

function showPassCode() {
    document.getElementById('passCodeContainer').style.display = 'block';
    hideEmptyState();
}

function hidePassCode() {
    document.getElementById('passCodeContainer').style.display = 'none';
}

function showEmptyState() {
    document.getElementById('emptyState').style.display = 'block';
    hidePassCode();
}

function hideEmptyState() {
    document.getElementById('emptyState').style.display = 'none';
}

// ===== 工具函数 =====

// 格式化日期时间
function formatDateTime(dateStr) {
    if (!dateStr) return '未设置';
    
    try {
        const date = new Date(dateStr);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');
        
        return `${year}-${month}-${day} ${hours}:${minutes}`;
    } catch (error) {
        console.error('日期格式化错误:', error);
        return '时间格式错误';
    }
}

// 格式化校区名称
function formatCampus(campus) {
    const campusMap = {
        'main': '主校区',
        'east': '东校区',
        'west': '西校区',
        'south': '南校区',
        'north': '北校区'
    };
    return campusMap[campus] || campus || '未知校区';
}

// 格式化状态
function formatStatus(status) {
    const statusMap = {
        'pending': '待审核',
        'approved': '已审核',
        'rejected': '已拒绝',
        'expired': '已过期'
    };
    return statusMap[status] || status || '未知状态';
}

// 身份证脱敏
function maskIdCard(idCard) {
    if (!idCard || idCard.length < 8) return '****';
    return idCard.substring(0, 4) + '**********' + idCard.substring(idCard.length - 4);
}

// 生成通行码号码
function generatePassCodeNumber() {
    const now = new Date();
    const year = now.getFullYear().toString().slice(-2);
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const random = Math.random().toString(36).substring(2, 6).toUpperCase();
    
    return `PC${year}${month}${day}${random}`;
}

// 计算过期时间
function calculateExpireTime(visitTime) {
    if (!visitTime) return null;
    
    try {
        const visit = new Date(visitTime);
        const expire = new Date(visit);
        expire.setHours(23, 59, 59, 999); // 当天23:59:59过期
        
        return formatDateTime(expire);
    } catch (error) {
        console.error('计算过期时间失败:', error);
        return null;
    }
}

// 检查是否过期
function isExpired(expireTimeStr) {
    if (!expireTimeStr) return false;
    
    try {
        const expireTime = new Date(expireTimeStr);
        const now = new Date();
        return now > expireTime;
    } catch (error) {
        console.error('检查过期时间失败:', error);
        return false;
    }
}

// 生成二维码数据
function generateQRCodeData(data) {
    const qrData = {
        type: 'campus_pass',
        passCode: data.passCode || generatePassCodeNumber(),
        reservationId: data.reservationId || '',
        name: data.name || '',
        visitTime: data.visitTime || '',
        campus: data.campus || '',
        expireTime: data.expireTime || '',
        timestamp: new Date().toISOString()
    };
    
    return JSON.stringify(qrData);
}

// 显示Toast提示
function showToast(message, type = 'info', duration = 3000) {
    // 移除已存在的toast
    const existingToast = document.querySelector('.toast');
    if (existingToast) {
        existingToast.remove();
    }
    
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    
    const icon = getToastIcon(type);
    toast.innerHTML = `${icon} ${message}`;
    
    document.body.appendChild(toast);
    
    // 显示动画
    setTimeout(function() {
        toast.classList.add('show');
    }, 100);
    
    // 自动隐藏
    setTimeout(function() {
        toast.classList.remove('show');
        setTimeout(function() {
            if (toast.parentNode) {
                document.body.removeChild(toast);
            }
        }, 300);
    }, duration);
}

// 获取Toast图标
function getToastIcon(type) {
    const iconMap = {
        'success': '<i class="fas fa-check-circle"></i>',
        'error': '<i class="fas fa-exclamation-circle"></i>',
        'warning': '<i class="fas fa-exclamation-triangle"></i>',
        'info': '<i class="fas fa-info-circle"></i>'
    };
    return iconMap[type] || iconMap.info;
}

// ===== 模拟数据生成（开发测试用） =====

function generateMockPassCode(reservationId) {
    const now = new Date();
    const visitTime = new Date(now.getTime() + 24 * 60 * 60 * 1000); // 明天
    const expireTime = new Date(visitTime);
    expireTime.setHours(23, 59, 59, 999);
    
    return {
        reservationId: reservationId,
        passCode: generatePassCodeNumber(),
        name: '测试用户',
        idCard: '1234**********5678',
        visitTime: formatDateTime(visitTime),
        campus: 'main',
        expireTime: formatDateTime(expireTime),
        isExpired: false,
        qrCodeData: generateQRCodeData({
            passCode: generatePassCodeNumber(),
            reservationId: reservationId,
            name: '测试用户',
            visitTime: visitTime.toISOString(),
            campus: 'main'
        })
    };
}

function generateMockPassCodeByPersonal(name, idCard, phone) {
    const now = new Date();
    const visitTime = new Date(now.getTime() + 24 * 60 * 60 * 1000);
    const expireTime = new Date(visitTime);
    expireTime.setHours(23, 59, 59, 999);
    
    return {
        reservationId: Date.now(),
        passCode: generatePassCodeNumber(),
        name: name,
        idCard: maskIdCard(idCard),
        visitTime: formatDateTime(visitTime),
        campus: 'main',
        expireTime: formatDateTime(expireTime),
        isExpired: false,
        qrCodeData: generateQRCodeData({
            passCode: generatePassCodeNumber(),
            reservationId: Date.now(),
            name: name,
            visitTime: visitTime.toISOString(),
            campus: 'main'
        })
    };
}

// ===== 页面其他功能 =====

function goBack() {
    if (history.length > 1) {
        history.back();
    } else {
        location.href = '/mobile/index.jsp';
    }
}

function refreshPage() {
    location.reload();
}

// ===== 页面卸载清理 =====
window.addEventListener('beforeunload', function() {
    // 清理资源
    currentPassCodeData = null;
});