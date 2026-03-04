<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员登录 - 校园通行码管理系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Microsoft YaHei', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background:linear-gradient(to right, #eafafa, #d4fc79);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow-x: hidden;}

        body {
            font-family: 'Microsoft YaHei', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background:linear-gradient(to right, #eafafa, #d4fc79);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow-x: hidden;
        }
        body::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
        }

        .login-container {
            width: 100%;
            max-width: 1000px;
            margin: 0 auto;
            padding: 2rem;
            position: relative;
            z-index: 10;
        }

        .login-card {
            background: white;
            backdrop-filter: blur(20px);
            border-radius: 25px;
            box-shadow:
                    0 25px 80px rgba(0, 0, 0, 0.4),
                    inset 0 1px 0 rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.1);
            overflow: hidden;
            position: relative;
        }

        .login-left {
            color: darkgreen;
            padding: 3rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
            text-align: center;
            position: relative;
            overflow: hidden;
            border-right: 1px solid rgba(255, 255, 255, 0.1);
        }

        .brand-icon {
            font-size: 4rem;
            background: green;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: auto;
        }

        .brand-title {
            font-size: 2rem;
            font-weight: 700;
            display: flex;justify-content: center;
            margin: 1rem auto;
            background: forestgreen;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .brand-subtitle {
            font-size: 1.1rem;
            color: green;text-align: center;
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        .login-right {
            padding: 3rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .login-title {
            color: darkgreen;
            font-weight: 600;
            margin-bottom: 0.5rem;
            font-size: 1.8rem;
        }

        .login-subtitle {
            color: green;
            font-size: 0.95rem;
        }

        .form-floating .form-control {
            width: 100%;
            padding: 1rem 0.75rem;
            color: #333;
            background-color: #fff;
            border-color: #ced4da;
        }

        .form-floating .form-control:focus {
            background: lightgreen;
            border-color: greenyellow;
            color: #333;
            box-shadow: 0 0 0 0.25rem rgba(25, 135, 84, 0.25);
        }

        .form-floating .form-control:focus ~ label,
        .form-floating .form-control:not(:placeholder-shown) ~ label {
            font-size:1.25rem;
        }

        .btn-login {
            background: mediumseagreen;
            border: none;
            border-radius: 15px;
            padding: 1rem;
            font-weight: 600;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            color: #fff;
        }

        .btn-login:hover {
            background: #2e8b57; /* 悬停时使用更深的绿色 */
            color: white;
        }

        .btn-register {
            background: forestgreen;
            border: none;
            border-radius: 15px;
            padding: 1rem;
            font-weight: 600;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            color: #fff;
        }

        .btn-register:hover {
            background: #196434; /* 悬停时使用更深的绿色 */
            color: white;
        }

        .alert {
            border-radius: 15px;
            border: none;
            background: lightgreen;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .alert-success {
            background: rgba(40, 167, 69, 0.2);
            border-color: rgba(40, 167, 69, 0.3);
            color: #90ee90;
        }

        .alert-danger {
            background: rgba(220, 53, 69, 0.2);
            border-color: rgba(220, 53, 69, 0.3);
            color: #ffb3b3;
        }

        .alert-info {
            background: rgba(13, 202, 240, 0.2);
            border-color: rgba(13, 202, 240, 0.3);
            color: #87ceeb;
        }

        .login-footer {
            text-align: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .back-home {
            color: darkgreen;
            text-decoration: none;
            font-weight: 500;
        }

        .back-home:hover {
            color: black;
            text-decoration: none;
        }

        .modal-content {
            background: white;
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: darkgreen;
            border-radius: 15px;
            box-shadow: 0 10px 50px rgba(0, 0, 0, 0.2);
        }

        .modal-header {
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            background: forestgreen;
            color: white;
            border-radius: 15px 15px 0 0;
        }

        /* 表单验证样式 */
        .was-validated .form-control:valid {
            border-color: #28a745;
            background-image: none;
            color: #333;
        }

        .was-validated .form-control:invalid {
            border-color: #dc3545;
            background-image: none;
        }

        .invalid-feedback {
            color: #ff6b6b;
        }

        /* 注册表单样式优化 */
        .register-form .form-group {
            margin-bottom: 1.5rem;
        }

        .register-form label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: darkgreen;
        }

        .register-form .form-control {
            border-radius: 10px;
            padding: 0.75rem 1rem;
            border: 1px solid #ddd;
            transition: all 0.3s ease;
        }

        .register-form .form-control:focus {
            border-color: forestgreen;
            box-shadow: 0 0 0 0.25rem rgba(34, 139, 34, 0.25);
            outline: none;
        }

        .register-form .form-select {
            border-radius: 10px;
            padding: 0.75rem 1rem;
            border: 1px solid #ddd;
            background-color: white;
            color: #333;
        }

        .register-form .form-select:focus {
            border-color: forestgreen;
            box-shadow: 0 0 0 0.25rem rgba(34, 139, 34, 0.25);
            outline: none;
        }

        .register-form textarea {
            resize: none;
            height: 120px !important;
            color: #333 !important;
        }
        #btn btn-primary{
            background-color: green;
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="login-card">
        <div class="row g-0">
            <!-- 左侧品牌区域 -->
            <div class="col-md-6">
                <div class="login-left">
                    <div class="login-left-content">
                        <div class="brand-icon">
                            <i class="bi bi-shield-check"></i>
                        </div>
                        <h2 class="brand-title">校园通行码管理系统</h2>
                        <p class="brand-subtitle">- 高效便捷的校园通行解决方案 -</p>
                        <div class="login-footer">
                            <a href="${pageContext.request.contextPath}/" class="back-home">
                                <i class="bi bi-arrow-left me-2"></i>点击返回首页
                            </a>
                            <div class="mt-3">
                                <small style="color: darkseagreen;">
                                    <i class="bi bi-info-circle me-1"></i>
                                    如有问题请联系系统管理员
                                </small>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

            <!-- 右侧登录表单 -->
            <div class="col-md-6">
                <div class="login-right">
                    <div class="login-header">
                        <h3 class="login-title">管理员登录</h3>

                    </div>

                    <!-- 消息提示 -->
                    <c:if test="${param.message eq 'logout'}">
                        <div class="alert alert-success alert-dismissible fade show">
                            <i class="bi bi-check-circle me-2"></i>您已成功登出
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show">
                            <i class="bi bi-exclamation-triangle me-2"></i>${error}
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/admin/login" method="post" class="needs-validation" novalidate>
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control dark-input" id="loginName" name="loginName" placeholder="请输入用户名" value="${param.loginName != null ? param.loginName : ''}">
                            <label for="loginName">
                                <i class="bi bi-person me-2"></i>登录名
                            </label>
                            <div class="invalid-feedback">请输入登录名</div>
                        </div>

                        <div class="form-floating mb-4">
                            <input type="password" class="form-control dark-input" id="password" name="password" placeholder="请输入密码">
                            <label for="password">
                                <i class="bi bi-lock me-2"></i>密码
                            </label>
                            <div class="invalid-feedback">请输入密码</div>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-login btn-lg">
                                <i class="bi bi-box-arrow-in-right me-2"></i>立即登录
                            </button>
                            <button type="button" class="btn btn-register" onclick="showRegisterModal()">
                                <i class="bi bi-person-plus me-2"></i>申请注册账号
                            </button>
                        </div>
                    </form>

                        </div>
                    </div>
                </div>
            </div>
        </div>

<!-- 注册申请模态框 -->
<div class="modal fade" id="registerModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content" style="border-radius: 20px; border: none;">
            <div class="modal-header" style="border-radius: 20px 20px 0 0;">
                <h5 class="modal-title">
                    <i class="bi bi-person-plus me-2"></i>申请管理员账号
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form class="needs-validation" novalidate>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" id="applyName" required>
                                <label for="applyName">姓名</label>
                                <div class="invalid-feedback">请输入真实姓名</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <input type="tel" class="form-control" id="applyPhone" required pattern="^[0-9]{11}$">
                                <label for="applyPhone">联系电话</label>
                                <div class="invalid-feedback">请输入正确的11位手机号</div>
                            </div>
                        </div>
                    </div>

                    <div class="form-floating mb-3">
                        <input type="email" class="form-control" id="applyEmail" required>
                        <label for="applyEmail">邮箱</label>
                        <div class="invalid-feedback">请输入正确的邮箱地址</div>
                    </div>

                    <div class="form-floating mb-3">
                        <select class="form-select" id="applyDept" required style="background: lightgreen; border: 2px solid rgba(255, 255, 255, 0.1); color: #fff;">
                            <option value="" selected disabled>-- 请选择 --</option>
                            <option value="教务处">教务处</option>
                            <option value="学生处">学生处</option>
                            <option value="信息学院">信息学院</option>
                            <option value="管理学院">管理学院</option>
                            <option value="其他">其他</option>
                        </select>
                        <label for="applyDept">所属部门</label>
                        <div class="invalid-feedback">请选择所属部门</div>
                    </div>

                    <div class="form-floating mb-3">
                        <textarea class="form-control" id="applyReason" style="height: 100px; background: lightgreen; border: 2px solid rgba(255, 255, 255, 0.1); color: #fff;" required></textarea>
                        <label for="applyReason">申请理由</label>
                        <div class="invalid-feedback">请填写申请理由</div>
                    </div>
                </form>
            </div>
            <div class="modal-footer" style="justify-content: center; padding: 1rem 2rem 2rem;">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal" style="border-radius: 10px; border-color: rgba(255, 255, 255, 0.3); color: rgba(255, 255, 255, 0.8);">
                    <i class="bi bi-x me-2"></i>取消
                </button>
                <button type="button" class="btn btn-primary" onclick="submitApplication()" style="border-radius: 10px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none;">
                    <i class="bi bi-send me-2"></i>提交申请
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 表单验证
    (function() {
        'use strict';
        window.addEventListener('load', function() {
            var forms = document.getElementsByClassName('needs-validation');
            var validation = Array.prototype.filter.call(forms, function(form) {
                form.addEventListener('submit', function(event) {
                    if (form.checkValidity() === false) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        }, false);
    })();

    // 显示注册模态框
    function showRegisterModal() {
        var registerModal = new bootstrap.Modal(document.getElementById('registerModal'));
        registerModal.show();
    }

    // 提交申请
    function submitApplication() {
        var form = document.querySelector('#registerModal .needs-validation');
        if (form.checkValidity()) {
            // 这里可以添加实际的提交逻辑
            alert('申请已提交！\n\n我们会在1-2个工作日内处理您的申请，请耐心等待。\n如有紧急情况，请直接联系系统管理员。');
            bootstrap.Modal.getInstance(document.getElementById('registerModal')).hide();
            form.reset();
            form.classList.remove('was-validated');
        } else {
            form.classList.add('was-validated');
        }
    }

    // 页面加载动画
    window.addEventListener('load', function() {
        const card = document.querySelector('.login-card');
        card.style.opacity = '0';
        card.style.transform = 'translateY(30px)';

        setTimeout(() => {
            card.style.transition = 'all 0.8s ease-out';
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, 100);
    });

    // 输入框焦点动画
    document.querySelectorAll('.form-control').forEach(input => {
        input.addEventListener('focus', function() {
            this.parentElement.style.transform = 'scale(1.02)';
        });
        
        input.addEventListener('blur', function() {
            this.parentElement.style.transform = 'scale(1)';
        });
    });
</script>
</body>
</html>
