<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>预约成功 - 校园通行码预约系统</title>
    <link rel="stylesheet" href="../../css/common.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        :root {
            --primary-blue: #67eb25;
            --secondary-blue: rgba(59, 246, 103, 0.47);
            --light-blue: #60fa84;
            --sky-blue: #6af63b;
            --indigo-blue: rgba(241, 213, 99, 0.85);
            --cyan-blue: #6fe339;
            
            --primary-light: #dbeafe;
            --secondary-light: #e0f2fe;
            --accent-light: #f0f9ff;
            
            --primary-dark: #1eaf58;
            --text-dark: #1e293b;
            --text-light: #64748b;
            --success-color: #10b981;
            
            /* 使用绿色系作为主色调 */
            --primary-color: var(--primary-blue);
            --accent-color: var(--light-blue);
            --light-bg: var(--accent-light);
            --border-color: var(--primary-light);
        }

        .header-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 100%);
            color: white;
            box-shadow: 0 2px 15px rgba(37, 99, 235, 0.2);
        }

        .header-nav h1 {
            font-size: 18px;
            margin: 0;
            font-weight: 600;
        }

        .container {
            max-width: 425px;
            margin: 0 auto;
            background: white;
            min-height: 100vh;
            position: relative;
            overflow: hidden;
        }

        .container::before {
            content: '';
            position: absolute;
            top: -50px;
            right: -50px;
            width: 150px;
            height: 150px;
            background: radial-gradient(circle, rgba(78, 145, 251, 0.1), transparent);
            border-radius: 50%;
            z-index: 0;
        }

        .container::after {
            content: '';
            position: absolute;
            bottom: -30px;
            left: -30px;
            width: 120px;
            height: 120px;
            background: radial-gradient(circle, rgba(255, 140, 180, 0.1), transparent);
            border-radius: 50%;
            z-index: 0;
        }

        .success-content {
            padding: 40px 20px;
            text-align: center;
            position: relative;
            z-index: 1;
        }

        .success-icon {
            font-size: 64px;
            color: var(--success-color);
            margin-bottom: 20px;
            animation: successPulse 2s ease-in-out infinite;
        }

        @keyframes successPulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .success-title {
            font-size: 24px;
            color: var(--text-dark);
            margin-bottom: 10px;
            font-weight: 600;
        }

        .success-message {
            color: var(--text-light);
            margin-bottom: 30px;
            line-height: 1.5;
        }

        .reservation-info {
            background: var(--light-bg);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 30px;
            text-align: left;
            border: 1px solid var(--border-color);
            box-shadow: 0 4px 15px rgba(78, 145, 251, 0.08);
        }

        .reservation-info h3 {
            margin: 0 0 15px 0;
            color: var(--text-dark);
            font-size: 16px;
            text-align: center;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid var(--border-color);
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-label {
            color: var(--text-light);
            font-weight: 500;
        }

        .info-value {
            color: var(--text-dark);
            font-weight: 600;
        }

        .pass-code-section {
            background: linear-gradient(135deg, var(--primary-light), var(--accent-light));
            border: 2px solid var(--primary-color);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(78, 145, 251, 0.15);
        }

        .pass-code-title {
            color: var(--primary-color);
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 15px;
            text-align: center;
        }

        .pass-code {
            font-family: 'Courier New', monospace;
            font-size: 24px;
            font-weight: bold;
            color: var(--primary-color);
            text-align: center;
            padding: 15px;
            background: white;
            border-radius: 8px;
            margin-bottom: 10px;
            letter-spacing: 2px;
            box-shadow: 0 2px 8px rgba(78, 145, 251, 0.1);
        }

        .pass-code-info {
            font-size: 14px;
            color: var(--text-light);
            text-align: center;
        }

        .action-buttons {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .btn {
            padding: 15px;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .btn:hover::before {
            width: 300px;
            height: 300px;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            box-shadow: 0 4px 15px rgba(115, 251, 78, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(101, 251, 78, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #6c757d, #5a6268);
            color: white;
            box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(108, 117, 125, 0.4);
        }

        .btn-outline {
            background: transparent;
            color: var(--primary-color);
            border: 2px solid var(--primary-color);
        }

        .btn-outline:hover {
            background: var(--primary-color);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(101, 251, 78, 0.3);
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- 头部导航 -->
        <div class="header-nav">
            <div></div>
            <h1>预约成功</h1>
            <div></div>
        </div>

        <div class="success-content">
            <!-- 成功图标和消息 -->
            <div class="success-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            
            <h2 class="success-title">预约申请成功！</h2>
            
            <p class="success-message">
                <c:out value="${successMessage}" default="您的预约申请已提交成功"/>
            </p>

            <!-- 预约信息展示 -->
            <c:if test="${not empty reservation}">
                <div class="reservation-info">
                    <h3>预约详情</h3>
                    
                    <div class="info-item">
                        <span class="info-label">预约ID：</span>
                        <span class="info-value">${reservationId}</span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">预约类型：</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${reservation.reservationType == 'public'}">公务预约</c:when>
                                <c:when test="${reservation.reservationType == 'business'}">商务预约</c:when>
                                <c:otherwise>${reservation.reservationType}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">访问校区：</span>
                        <span class="info-value">${reservation.campus}</span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">访问时间：</span>
                        <span class="info-value">
                            <fmt:formatDate value="${reservation.visitTime}" pattern="yyyy-MM-dd HH:mm"/>
                        </span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">申请状态：</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${reservation.status == 'approved'}">已通过</c:when>
                                <c:when test="${reservation.status == 'pending'}">待审核</c:when>
                                <c:otherwise>${reservation.status}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
            </c:if>

            <!-- 通行码信息（如果是自动通过的公务预约） -->
            <c:if test="${reservation.status == 'approved' && not empty reservation.passCode}">
                <div class="pass-code-section">
                    <div class="pass-code-title">
                        <i class="fas fa-qrcode"></i> 您的通行码
                    </div>
                    
                    <div class="pass-code">${reservation.passCode}</div>
                    
                    <div class="pass-code-info">
                        <c:if test="${not empty reservation.passCodeExpireTime}">
                            有效期至：<fmt:formatDate value="${reservation.passCodeExpireTime}" pattern="yyyy-MM-dd HH:mm"/>
                        </c:if>
                    </div>
                </div>
            </c:if>

            <!-- 操作按钮 -->
            <div class="action-buttons">
                
                <!-- 如果已通过，显示查看二维码按钮 -->
                <c:if test="${reservation.status == 'approved' && not empty reservation.passCode}">
                    <a href="/mobile/pages/qrcode/pass-code.jsp?reservationId=${reservationId}" 
                       class="btn btn-primary">
                        <i class="fas fa-qrcode"></i> 生成二维码
                    </a>
                </c:if>
                
                <!-- 查看我的预约 -->
                <a href="/mobile/pages/reservation/my-reservations" 
                   class="btn btn-secondary">
                    <i class="fas fa-list"></i> 查看我的预约
                </a>
                
                <!-- 继续预约 -->
                <a href="/mobile/pages/reservation/reserve.jsp" 
                   class="btn btn-outline">
                    <i class="fas fa-plus"></i> 继续预约
                </a>
                
                <!-- 返回首页 -->
                <a href="/mobile/index.jsp" 
                   class="btn btn-outline">
                    <i class="fas fa-home"></i> 返回首页
                </a>
            </div>
        </div>
    </div>
</body>
</html>
