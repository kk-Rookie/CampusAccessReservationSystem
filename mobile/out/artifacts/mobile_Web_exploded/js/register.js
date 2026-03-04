/**
 * 注册页面专用JavaScript功能
 */

// 密码强度检查
function checkPasswordStrength(password) {
    let strength = 0;
    let feedback = [];
    
    if (password.length >= 8) strength++;
    else feedback.push('至少8位字符');
    
    if (/[a-z]/.test(password)) strength++;
    else feedback.push('包含小写字母');
    
    if (/[A-Z]/.test(password)) strength++;
    else feedback.push('包含大写字母');
    
    if (/[0-9]/.test(password)) strength++;
    else feedback.push('包含数字');
    
    if (/[^a-zA-Z0-9]/.test(password)) strength++;
    else feedback.push('包含特殊字符');
    
    return {
        strength: strength,
        feedback: feedback
    };
}

// 显示字段特定错误信息
function showFieldError(fieldName, message) {
    const errorDiv = document.getElementById(fieldName + 'Error');
    const fieldGroup = document.getElementById(fieldName + 'Group');
    
    if (errorDiv) {
        errorDiv.innerHTML = '<i class="fas fa-exclamation-circle"></i> ' + message;
        errorDiv.style.display = 'block';
    }
    
    if (fieldGroup) {
        fieldGroup.classList.add('has-error');
    }
    
    // 输入框高亮错误状态
    const input = document.getElementById(fieldName);
    if (input) {
        input.classList.add('error');
    }
}

// 清除字段特定错误信息
function clearFieldError(fieldName) {
    const errorDiv = document.getElementById(fieldName + 'Error');
    const fieldGroup = document.getElementById(fieldName + 'Group');
    
    if (errorDiv) {
        errorDiv.innerHTML = '';
        errorDiv.style.display = 'none';
    }
    
    if (fieldGroup) {
        fieldGroup.classList.remove('has-error');
    }
    
    // 移除输入框错误状态
    const input = document.getElementById(fieldName);
    if (input) {
        input.classList.remove('error');
    }
}

// 清除所有错误信息
function clearAllErrors() {
    const errorFields = ['username', 'realName', 'phone', 'email', 'password', 'confirmPassword'];
    errorFields.forEach(field => clearFieldError(field));
}

// 更新密码强度显示
function updatePasswordStrength() {
    const password = document.getElementById('password').value;
    const strengthDiv = document.getElementById('passwordStrength');
    
    if (!password) {
        strengthDiv.innerHTML = '';
        return;
    }
    
    const result = checkPasswordStrength(password);
    let strengthText = '';
    let strengthClass = '';
    
    switch(result.strength) {
        case 0:
        case 1:
            strengthText = '弱';
            strengthClass = 'weak';
            break;
        case 2:
        case 3:
            strengthText = '中';
            strengthClass = 'medium';
            break;
        case 4:
        case 5:
            strengthText = '强';
            strengthClass = 'strong';
            break;
    }
    
    strengthDiv.innerHTML = 
        '<div class="strength-indicator ' + strengthClass + '">' +
        '密码强度：' + strengthText +
        '</div>';
    
    if (result.feedback.length > 0 && result.strength < 3) {
        strengthDiv.innerHTML += 
            '<div class="strength-tips">建议：' + result.feedback.join('、') + '</div>';
    }
}

// 检查密码匹配
function checkPasswordMatch() {
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    const matchDiv = document.getElementById('passwordMatch');
    
    if (!confirmPassword) {
        matchDiv.innerHTML = '';
        return true;
    }
    
    if (password === confirmPassword) {
        matchDiv.innerHTML = '<div class="match-success"><i class="fas fa-check"></i> 密码匹配</div>';
        return true;
    } else {
        matchDiv.innerHTML = '<div class="match-error"><i class="fas fa-times"></i> 密码不匹配</div>';
        return false;
    }
}

// 显示字段错误
function showFieldError(fieldName, message) {
    const errorElement = document.getElementById(fieldName + 'Error');
    if (errorElement) {
        errorElement.textContent = message;
        errorElement.style.display = 'block';
    }
    
    // 为输入字段添加错误样式
    const inputElement = document.getElementById(fieldName);
    if (inputElement) {
        inputElement.classList.add('error');
    }
}

// 清除字段错误
function clearFieldError(fieldName) {
    const errorElement = document.getElementById(fieldName + 'Error');
    if (errorElement) {
        errorElement.textContent = '';
        errorElement.style.display = 'none';
    }
    
    // 移除输入字段的错误样式
    const inputElement = document.getElementById(fieldName);
    if (inputElement) {
        inputElement.classList.remove('error');
    }
}

// 验证用户名格式
function validateUsername() {
    const username = document.getElementById('username').value.trim();
    clearFieldError('username');
    
    if (!username) {
        showFieldError('username', '请输入用户名');
        return false;
    }
    
    const pattern = /^[a-zA-Z0-9_]{4,20}$/;
    if (!pattern.test(username)) {
        showFieldError('username', '用户名只能包含字母、数字和下划线，长度4-20位');
        return false;
    }
    return true;
}

// 验证手机号格式
function validatePhone() {
    const phone = document.getElementById('phone').value.trim();
    clearFieldError('phone');
    
    if (!phone) {
        showFieldError('phone', '请输入手机号');
        return false;
    }
    
    const pattern = /^1[3-9]\d{9}$/;
    if (!pattern.test(phone)) {
        showFieldError('phone', '请输入正确的手机号格式');
        return false;
    }
    return true;
}

// 验证邮箱格式
function validateEmail() {
    const email = document.getElementById('email').value.trim();
    clearFieldError('email');
    
    if (!email) return true; // 邮箱是可选的
    
    const pattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!pattern.test(email)) {
        showFieldError('email', '请输入正确的邮箱格式');
        return false;
    }
    return true;
}

// 验证真实姓名
function validateRealName() {
    const realName = document.getElementById('realName').value.trim();
    clearFieldError('realName');
    
    if (!realName) {
        showFieldError('realName', '请输入真实姓名');
        return false;
    }
    
    if (realName.length < 2 || realName.length > 20) {
        showFieldError('realName', '真实姓名长度应在2-20位之间');
        return false;
    }
    
    return true;
}

// 验证密码
function validatePassword() {
    const password = document.getElementById('password').value;
    clearFieldError('password');
    
    if (!password) {
        showFieldError('password', '请输入密码');
        return false;
    }
    
    if (password.length < 6) {
        showFieldError('password', '密码长度不能少于6位');
        return false;
    }
    
    return true;
}

// 验证确认密码
function validateConfirmPassword() {
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    clearFieldError('confirmPassword');
    
    if (!confirmPassword) {
        showFieldError('confirmPassword', '请确认密码');
        return false;
    }
    
    if (password !== confirmPassword) {
        showFieldError('confirmPassword', '两次密码输入不一致');
        return false;
    }
    
    return true;
}

// 表单验证
function validateForm() {
    clearAllErrors(); // 清除所有字段错误
    
    let isValid = true;
    
    // 验证各个字段
    if (!validateUsername()) isValid = false;
    if (!validateRealName()) isValid = false;
    if (!validatePhone()) isValid = false;
    if (!validateEmail()) isValid = false;
    if (!validatePassword()) isValid = false;
    if (!validateConfirmPassword()) isValid = false;
    
    // 检查用户协议
    const agreement = document.getElementById('agreement');
    if (!agreement.checked) {
        alert('请阅读并同意用户协议');
        isValid = false;
    }
    
    return isValid;
}

// 页面加载时绑定事件
document.addEventListener('DOMContentLoaded', function() {
    // 密码强度实时检查
    const passwordInput = document.getElementById('password');
    if (passwordInput) {
        passwordInput.addEventListener('input', updatePasswordStrength);
        passwordInput.addEventListener('input', function() {
            clearFieldError('password');
        });
    }
    
    // 密码匹配实时检查
    const confirmPasswordInput = document.getElementById('confirmPassword');
    if (confirmPasswordInput) {
        confirmPasswordInput.addEventListener('input', checkPasswordMatch);
        confirmPasswordInput.addEventListener('input', function() {
            clearFieldError('confirmPassword');
        });
    }
    
    // 为其他输入框添加实时错误清除
    const inputFields = ['username', 'realName', 'phone', 'email'];
    inputFields.forEach(fieldName => {
        const input = document.getElementById(fieldName);
        if (input) {
            input.addEventListener('input', function() {
                clearFieldError(fieldName);
            });
            
            // 失去焦点时进行验证
            input.addEventListener('blur', function() {
                switch(fieldName) {
                    case 'username':
                        validateUsername();
                        break;
                    case 'realName':
                        validateRealName();
                        break;
                    case 'phone':
                        validatePhone();
                        break;
                    case 'email':
                        validateEmail();
                        break;
                }
            });
        }
    });
    
    // 直接处理注册表单提交
    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        // 确保表单使用正确的编码类型
        registerForm.enctype = 'application/x-www-form-urlencoded';
        
        registerForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // 再次确保编码类型正确
            registerForm.enctype = 'application/x-www-form-urlencoded';
            
            if (!validateForm()) {
                return false;
            }
            
            // 提交表单
            submitRegisterForm();
        });
    }
});

// 专门的注册表单提交函数
function submitRegisterForm() {
    const form = document.getElementById('registerForm');
    const submitBtn = document.getElementById('submitBtn');
    
    // 禁用提交按钮
    if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 注册中...';
    }
    
    // 收集表单数据
    const formData = new FormData(form);
    const urlParams = new URLSearchParams();
    
    // 转换为 URL 编码格式（避免 multipart）
    for (const [key, value] of formData.entries()) {
        urlParams.append(key, value);
    }
    
    // 发送请求到正确的端点
    fetch('/mobile/api/auth/register', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: urlParams.toString()
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // 注册成功 - 使用简单的alert显示成功消息
            alert('注册成功！正在跳转到个人资料页面...');
            
            // 允许跳转 - 使用window对象确保能访问到全局函数
            console.log('准备允许跳转...');
            if (typeof window.allowRedirect === 'function') {
                window.allowRedirect();
                console.log('已调用allowRedirect函数');
            } else {
                console.log('allowRedirect函数不可用');
            }
            
            // 延迟2.5秒后跳转，确保用户能看到成功消息
            setTimeout(function() {
                console.log('准备执行跳转...');
                // 跳转到profile页面并刷新
                window.location.href = '/mobile/pages/profile/index.jsp';
            }, 2500);
        } else {
            // 注册失败 - 使用简单的alert显示错误
            alert(data.message || '注册失败，请稍后重试');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('网络错误，请稍后重试');
    })
    .finally(() => {
        // 恢复提交按钮
        if (submitBtn) {
            submitBtn.disabled = false;
            submitBtn.innerHTML = '<i class="fas fa-user-plus"></i> 立即注册';
        }
    });
}

// 简单通知函数 - 直接使用alert
function showNotification(message, type = 'info', duration = 5000) {
    console.log('显示通知:', message, type);
    // 使用最简单的alert弹框
    alert(message);
}

// 为了兼容性，保留showToast函数但调用alert
function showToast(message, type = 'info', duration = 3000) {
    alert(message);
}