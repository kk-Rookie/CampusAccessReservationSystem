<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>预约详情 - 校园通行码预约系统</title>
    <link rel="stylesheet" href="../../css/common.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        :root {
            --primary-blue: #22c55e;      /* 主绿色 - 鲜明且友好的绿色 */
            --secondary-blue: #16a34a;    /* 次绿色 - 稍深一点的绿色 */
            --light-blue: #6ee7b7;        /* 浅绿色 - 清新背景色 */
            --sky-blue: #a7f3d0;          /* 天空绿 - 更柔和的亮绿色 */
            --indigo-blue: rgba(132, 194, 85, 0.86); /* 靛绿色 - 接近橄榄绿 */
            --cyan-blue: #4ade80;         /* 青绿 - 明亮清新的绿色 */

            --primary-light: #ecfdf5;     /* 浅绿背景 - 极浅背景 */
            --secondary-light: #d1fae5;   /* 次浅绿背景 - 用于卡片/按钮悬停 */
            --accent-light: #f0fdf4;      /* 极浅绿背景 - 强调区域背景 */

            --primary-dark: #047857;      /* 深绿色 - 用于导航栏/强调文字 */
            --text-dark: #1e293b;         /* 深色文字 - 不变（通用深灰） */
            --text-light: #64748b;        /* 浅色文字 - 不变（通用灰） */

            /* 使用绿色系作为主色调 */
            --primary-color: var(--primary-blue); /* 绿色为主色调 */
            --accent-color: var(--light-blue);    /* 辅助色仍使用浅绿色 */
        }

        .header-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 15px;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--accent-color) 100%);
            color: white;
        }

        .header-nav h1 {
            font-size: 16px;
            margin: 0;
            font-weight: 600;
        }

        .back-button {
            color: white;
            text-decoration: none;
            font-size: 18px;
            transition: transform 0.3s ease;
        }

        .back-button:hover {
            transform: scale(1.1);
        }

        .container {
            max-width: 425px;
            margin: 0 auto;
            background: white;
            min-height: 100vh;
        }

        .detail-content {
            padding: 12px 15px;
        }

        .status-card {
            background: #f8f9fa;
            border-radius: 6px;
            padding: 15px;
            margin-bottom: 15px;
            text-align: center;
        }

        .status-icon {
            font-size: 36px;
            margin-bottom: 10px;
        }

        .status-approved .status-icon {
            color: #28a745;
        }

        .status-pending .status-icon {
            color: #ffc107;
        }

        .status-rejected .status-icon {
            color: #dc3545;
        }

        .status-text {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 4px;
        }

        .status-approved .status-text {
            color: #28a745;
        }

        .status-pending .status-text {
            color: #856404;
        }

        .status-rejected .status-text {
            color: #721c24;
        }

        .status-description {
            color: #666;
            font-size: 14px;
        }

        .info-section {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 6px;
            margin-bottom: 12px;
            overflow: hidden;
        }

        .info-section-header {
            background: #f8f9fa;
            padding: 10px 15px;
            border-bottom: 1px solid #e9ecef;
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }

        .info-section-body {
            padding: 12px 15px;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            padding: 8px 0;
            border-bottom: 1px solid #f1f3f4;
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-label {
            color: #666;
            font-weight: 500;
            flex: 0 0 80px;
            font-size: 13px;
        }

        .info-value {
            color: #333;
            font-weight: 400;
            flex: 1;
            text-align: right;
            word-break: break-all;
            font-size: 13px;
        }

        .pass-code-section {
            background: linear-gradient(135deg, #e7f3ff 0%, #f0f8ff 100%);
            border: 2px solid #b3d7ff;
            border-radius: 6px;
            padding: 15px;
            margin-bottom: 12px;
        }

        .pass-code-header {
            text-align: center;
            margin-bottom: 12px;
        }

        .pass-code-title {
            color: #a2f63b;
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 4px;
        }

        .pass-code {
            font-family: 'Courier New', monospace;
            font-size: 18px;
            font-weight: bold;
            color: #0ecc00;
            text-align: center;
            padding: 10px;
            background: white;
            border-radius: 4px;
            margin-bottom: 10px;
            letter-spacing: 2px;
            border: 2px solid #e9ffb3;
        }

        .pass-code-info {
            text-align: center;
            font-size: 13px;
            color: #666;
        }

        .pass-code-expired {
            background: #f8d7da;
            border-color: #f5c6cb;
            color: #721c24;
        }

        .action-buttons {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .btn {
            padding: 12px;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: var(--primary-blue);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        .btn-outline {
            background: transparent;
            color: var(--primary-blue);
            border: 2px solid var(--primary-blue);
        }

        .btn-outline:hover {
            background: var(--primary-blue);
            color: white;
        }

        .btn:disabled {
            background: #e9ecef;
            color: #6c757d;
            cursor: not-allowed;
        }

        /* 移动端响应式设计 */
        @media (max-width: 425px) {
            .container {
                padding-bottom: 50px;
            }
            
            .header-nav {
                padding: 10px 12px;
            }
            
            .header-nav h1 {
                font-size: 15px;
            }
            
            .pass-code-section {
                padding: 12px;
                margin-bottom: 10px;
            }
            
            .pass-code {
                font-size: 15px;
                padding: 8px;
                letter-spacing: 1px;
                margin-bottom: 8px;
            }
            
            .pass-code-header {
                margin-bottom: 10px;
            }
            
            .pass-code-title {
                font-size: 15px;
                margin-bottom: 3px;
            }
            
            .info-section {
                margin-bottom: 10px;
            }
            
            .info-section-header {
                padding: 8px 12px;
                font-size: 13px;
            }
            
            .info-section-body {
                padding: 10px 12px;
            }
            
            .info-item {
                padding: 6px 0;
            }
            
            .info-label {
                flex: 0 0 70px;
                font-size: 12px;
            }
            
            .info-value {
                font-size: 12px;
            }
            
            .status-section {
                padding: 12px;
                margin-bottom: 10px;
            }
            
            .status-icon {
                width: 40px;
                height: 40px;
            }
            
            .status-icon i {
                font-size: 18px;
            }
            
            .status-content h3 {
                font-size: 15px;
                margin-bottom: 2px;
            }
            
            .status-description {
                font-size: 12px;
            }
        }
        
        /* 超小屏幕优化 */
        @media (max-width: 375px) {
            .header-nav {
                padding: 8px 10px;
            }
            
            .pass-code-section {
                padding: 8px;
            }
            
            .pass-code {
                font-size: 13px;
                padding: 6px;
            }
            
            .info-section-header {
                padding: 6px 10px;
            }
            
            .info-section-body {
                padding: 8px 10px;
            }
            
            .info-label {
                flex: 0 0 60px;
                font-size: 11px;
            }
            
            .info-value {
                font-size: 11px;
            }
        }

        /* 移动端紧凑优化 */
        @media (max-width: 480px) {
            .detail-content {
                padding: 8px 6px;
            }
            .status-card {
                padding: 10px;
                margin-bottom: 8px;
            }
            .status-icon {
                font-size: 28px;
                margin-bottom: 6px;
            }
            .status-text {
                font-size: 13px;
            }
            .info-section {
                border-radius: 4px;
                margin-bottom: 8px;
            }
            .info-section-header {
                padding: 7px 10px;
                font-size: 12px;
            }
            .info-section-body {
                padding: 8px 10px;
            }
            .info-label, .info-value {
                font-size: 12px;
            }
            .pass-code-section {
                padding: 8px;
                margin-bottom: 8px;
            }
            .pass-code-title {
                font-size: 13px;
            }
            .pass-code {
                font-size: 13px;
                padding: 6px;
                margin-bottom: 6px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- 头部导航 -->
        <div class="header-nav">
            <a href="javascript:history.back()" class="back-button">
                <i class="fas fa-arrow-left"></i>
            </a>
            <h1>预约详情</h1>
            <div></div>
        </div>

        <div class="detail-content">
            
            <c:if test="${not empty reservation}">
                
                <!-- 状态卡片 -->
                <div class="status-card 
                    <c:choose>
                        <c:when test="${reservation.status == 'approved'}">status-approved</c:when>
                        <c:when test="${reservation.status == 'pending'}">status-pending</c:when>
                        <c:when test="${reservation.status == 'rejected'}">status-rejected</c:when>
                    </c:choose>
                ">
                    <div class="status-icon">
                        <c:choose>
                            <c:when test="${reservation.status == 'approved'}">
                                <i class="fas fa-check-circle"></i>
                            </c:when>
                            <c:when test="${reservation.status == 'pending'}">
                                <i class="fas fa-clock"></i>
                            </c:when>
                            <c:when test="${reservation.status == 'rejected'}">
                                <i class="fas fa-times-circle"></i>
                            </c:when>
                        </c:choose>
                    </div>
                    <div class="status-text">
                        <c:choose>
                            <c:when test="${reservation.status == 'approved'}">预约已通过</c:when>
                            <c:when test="${reservation.status == 'pending'}">等待审核</c:when>
                            <c:when test="${reservation.status == 'rejected'}">预约被拒绝</c:when>
                            <c:otherwise>${reservation.status}</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="status-description">
                        <c:choose>
                            <c:when test="${reservation.status == 'approved'}">您的预约已审核通过，可以正常访问</c:when>
                            <c:when test="${reservation.status == 'pending'}">您的预约正在审核中，请耐心等待</c:when>
                            <c:when test="${reservation.status == 'rejected'}">抱歉，您的预约申请未通过审核</c:when>
                        </c:choose>
                    </div>
                </div>

                <!-- 通行码信息 -->
                <c:if test="${reservation.status == 'approved' && not empty reservation.passCode}">
                    <div class="pass-code-section <c:if test="${not isPassCodeValid}">pass-code-expired</c:if>">
                        <div class="pass-code-header">
                            <div class="pass-code-title">
                                <i class="fas fa-qrcode"></i> 
                                <c:choose>
                                    <c:when test="${isPassCodeValid}">通行码</c:when>
                                    <c:otherwise>通行码（已过期）</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <div class="pass-code">${reservation.passCode}</div>
                        
                        <div class="pass-code-info">
                            <c:if test="${not empty reservation.passCodeExpireTime}">
                                <c:choose>
                                    <c:when test="${isPassCodeValid}">
                                        有效期至：<fmt:formatDate value="${reservation.passCodeExpireTime}" pattern="yyyy-MM-dd HH:mm"/>
                                    </c:when>
                                    <c:otherwise>
                                        已于 <fmt:formatDate value="${reservation.passCodeExpireTime}" pattern="yyyy-MM-dd HH:mm"/> 过期
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                        </div>
                    </div>
                </c:if>

                <!-- 基本信息 -->
                <div class="info-section">
                    <div class="info-section-header">
                        <i class="fas fa-info-circle"></i> 基本信息
                    </div>
                    <div class="info-section-body">
                        <div class="info-item">
                            <span class="info-label">预约ID：</span>
                            <span class="info-value">${reservation.id}</span>
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
                            <span class="info-label">申请时间：</span>
                            <span class="info-value">
                                <fmt:formatDate value="${reservation.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- 个人信息 -->
                <div class="info-section">
                    <div class="info-section-header">
                        <i class="fas fa-user"></i> 个人信息
                    </div>
                    <div class="info-section-body">
                        <div class="info-item">
                            <span class="info-label">姓名：</span>
                            <span class="info-value">${reservation.name}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">身份证：</span>
                            <span class="info-value">
                                ${reservation.idCard.substring(0, 6)}****${reservation.idCard.substring(14)}
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">手机号：</span>
                            <span class="info-value">
                                ${reservation.phone.substring(0, 3)}****${reservation.phone.substring(7)}
                            </span>
                        </div>
                        <c:if test="${not empty reservation.organization}">
                            <div class="info-item">
                                <span class="info-label">所属单位：</span>
                                <span class="info-value">${reservation.organization}</span>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- 访问信息 -->
                <c:if test="${reservation.reservationType == 'business' && (not empty reservation.contactPerson || not empty reservation.visitReason)}">
                    <div class="info-section">
                        <div class="info-section-header">
                            <i class="fas fa-building"></i> 访问信息
                        </div>
                        <div class="info-section-body">
                            <c:if test="${not empty reservation.contactPerson}">
                                <div class="info-item">
                                    <span class="info-label">联系人：</span>
                                    <span class="info-value">${reservation.contactPerson}</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty reservation.visitReason}">
                                <div class="info-item">
                                    <span class="info-label">访问事由：</span>
                                    <span class="info-value">${reservation.visitReason}</span>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:if>

                <!-- 交通信息 -->
                <c:if test="${not empty reservation.transportation || not empty reservation.plateNumber}">
                    <div class="info-section">
                        <div class="info-section-header">
                            <i class="fas fa-car"></i> 交通信息
                        </div>
                        <div class="info-section-body">
                            <c:if test="${not empty reservation.transportation}">
                                <div class="info-item">
                                    <span class="info-label">交通方式：</span>
                                    <span class="info-value">${reservation.transportation}</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty reservation.plateNumber}">
                                <div class="info-item">
                                    <span class="info-label">车牌号：</span>
                                    <span class="info-value">${reservation.plateNumber}</span>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:if>

                <!-- 操作按钮 -->
                <div class="action-buttons">
                    
                    <!-- 如果预约已通过且通行码有效，显示二维码按钮 -->
                    <c:if test="${reservation.status == 'approved' && not empty reservation.passCode && isPassCodeValid}">
                        <a href="/mobile/pages/qrcode/pass-code.jsp?reservationId=${reservation.id}" 
                           class="btn btn-primary">
                            <i class="fas fa-qrcode"></i> 生成二维码
                        </a>
                    </c:if>
                    
                    <!-- 返回我的预约 -->
                    <a href="/mobile/pages/reservation/my-reservations.jsp" 
                       class="btn btn-secondary">
                        <i class="fas fa-list"></i> 返回我的预约
                    </a>
                    
                    <!-- 新建预约 -->
                    <a href="/mobile/pages/reservation/reserve.jsp" 
                       class="btn btn-outline">
                        <i class="fas fa-plus"></i> 新建预约
                    </a>
                </div>

            </c:if>

            <!-- 如果没有预约信息 -->
            <c:if test="${empty reservation}">
                <div class="status-card">
                    <div class="status-icon" style="color: #dc3545;">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <div class="status-text" style="color: #721c24;">预约不存在</div>
                    <div class="status-description">找不到指定的预约记录</div>
                </div>
                
                <div class="action-buttons">
                    <a href="/mobile/pages/reservation/my-reservations.jsp" 
                       class="btn btn-secondary">
                        <i class="fas fa-list"></i> 返回我的预约
                    </a>
                </div>
            </c:if>

        </div>
    </div>
</body>
</html>
