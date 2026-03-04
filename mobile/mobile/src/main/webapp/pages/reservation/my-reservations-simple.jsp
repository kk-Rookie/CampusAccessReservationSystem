<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的预约 - 校园通行码预约系统</title>
    <link rel="stylesheet" href="../../css/common.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        :root {
            --primary-blue: #3b82f6;
            --secondary-blue: #3b82f6;
            --primary-dark: #1e40af;
        }

        .header-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 100%);
            color: white;
        }

        .header-nav h1 {
            font-size: 18px;
            margin: 0;
            font-weight: 600;
        }

        .back-button {
            color: white;
            text-decoration: none;
            font-size: 20px;
            transition: transform 0.3s ease;
        }

        .back-button:hover {
            transform: scale(1.1);
        }

        .profile-avatar {
            width: 40px;
            height: 40px;
            background: rgba(40, 167, 69, 0.8);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px solid rgba(40, 167, 69, 0.3);
        }

        .profile-avatar i {
            font-size: 20px;
            color: white;
        }

        .container {
            max-width: 425px;
            margin: 0 auto;
            background: white;
            min-height: 100vh;
        }

        .user-welcome {
            padding: 20px;
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
        }

        .user-welcome h3 {
            margin: 0 0 5px 0;
            color: #333;
            font-size: 16px;
        }

        .user-welcome p {
            margin: 0;
            color: #666;
            font-size: 14px;
        }

        .reservation-list {
            padding: 20px;
        }

        .reservation-item {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            margin-bottom: 15px;
            padding: 15px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .reservation-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .reservation-type {
            background: var(--primary-blue);
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
        }

        .reservation-status {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-approved {
            background: #d4edda;
            color: #155724;
        }

        .status-rejected {
            background: #f8d7da;
            color: #721c24;
        }

        .reservation-details {
            font-size: 14px;
            color: #666;
            line-height: 1.5;
        }

        .reservation-details div {
            margin-bottom: 5px;
        }

        .reservation-actions {
            margin-top: 15px;
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            display: inline-block;
            text-align: center;
        }

        .btn-primary {
            background: var(--primary-blue);
            color: white;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn:hover {
            opacity: 0.9;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .empty-state i {
            font-size: 48px;
            color: #ccc;
            margin-bottom: 20px;
        }

        .empty-state h3 {
            margin-bottom: 10px;
            color: #333;
        }

        .empty-state p {
            margin-bottom: 30px;
            line-height: 1.5;
        }

        .new-reservation-btn {
            background: var(--primary-blue);
            color: white;
            padding: 12px 24px;
            border-radius: 6px;
            text-decoration: none;
            display: inline-block;
            font-weight: 500;
        }

        .new-reservation-btn:hover {
            background: var(--primary-dark);
        }

        .pass-code-info {
            background: #e7f3ff;
            border: 1px solid #b3d7ff;
            border-radius: 4px;
            padding: 10px;
            margin-top: 10px;
            font-size: 13px;
        }

        .pass-code {
            font-family: 'Courier New', monospace;
            font-weight: bold;
            color: #0066cc;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- 头部导航 -->
        <div class="header-nav">
            <a href="../../index.jsp" class="back-button">
                <i class="fas fa-arrow-left"></i>
            </a>
            <h1>我的预约</h1>
            <div class="profile-avatar">
                <i class="fas fa-user"></i>
            </div>
        </div>

        <!-- 用户欢迎信息 -->
        <c:if test="${not empty username}">
            <div class="user-welcome">
                <h3>欢迎回来，${username}</h3>
                <p>您可以在这里查看和管理您的所有预约</p>
            </div>
        </c:if>

        <!-- 预约列表 -->
        <div class="reservation-list">
            <c:choose>
                <c:when test="${not empty reservations}">
                    <c:forEach var="reservation" items="${reservations}">
                        <div class="reservation-item">
                            <div class="reservation-header">
                                <span class="reservation-type">
                                    <c:choose>
                                        <c:when test="${reservation.reservationType == 'public'}">公务预约</c:when>
                                        <c:when test="${reservation.reservationType == 'business'}">商务预约</c:when>
                                        <c:otherwise>${reservation.reservationType}</c:otherwise>
                                    </c:choose>
                                </span>
                                <span class="reservation-status 
                                    <c:choose>
                                        <c:when test="${reservation.status == 'pending'}">status-pending</c:when>
                                        <c:when test="${reservation.status == 'approved'}">status-approved</c:when>
                                        <c:when test="${reservation.status == 'rejected'}">status-rejected</c:when>
                                    </c:choose>
                                ">
                                    <c:choose>
                                        <c:when test="${reservation.status == 'pending'}">待审核</c:when>
                                        <c:when test="${reservation.status == 'approved'}">已通过</c:when>
                                        <c:when test="${reservation.status == 'rejected'}">已拒绝</c:when>
                                        <c:otherwise>${reservation.status}</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            
                            <div class="reservation-details">
                                <div><strong>姓名：</strong>${reservation.name}</div>
                                <div><strong>校区：</strong>${reservation.campus}</div>
                                <div><strong>访问时间：</strong>
                                    <c:out value="${requestScope['visitTime_'.concat(reservation.id)]}" default="${reservation.visitTime}"/>
                                </div>
                                <c:if test="${not empty reservation.organization}">
                                    <div><strong>所属单位：</strong>${reservation.organization}</div>
                                </c:if>
                                <c:if test="${not empty reservation.visitReason}">
                                    <div><strong>访问事由：</strong>${reservation.visitReason}</div>
                                </c:if>
                            </div>

                            <!-- 通行码信息 -->
                            <c:if test="${reservation.status == 'approved' && not empty reservation.passCode}">
                                <div class="pass-code-info">
                                    <div><strong>通行码：</strong><span class="pass-code">${reservation.passCode}</span></div>
                                    <c:if test="${not empty reservation.passCodeExpireTime}">
                                        <div><strong>有效期至：</strong>
                                            <c:out value="${requestScope['expireTime_'.concat(reservation.id)]}" default="${reservation.passCodeExpireTime}"/>
                                        </div>
                                    </c:if>
                                </div>
                            </c:if>

                            <div class="reservation-actions">
                                <a href="/mobile/pages/reservation/reservation-detail?id=${reservation.id}" 
                                   class="btn btn-primary">查看详情</a>
                                
                                <c:if test="${reservation.status == 'approved' && not empty reservation.passCode}">
                                    <a href="/mobile/pages/qrcode/pass-code.jsp?reservationId=${reservation.id}" 
                                       class="btn btn-secondary">生成二维码</a>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-calendar-alt"></i>
                        <h3>暂无预约记录</h3>
                        <p>您还没有任何预约记录<br>点击下方按钮创建您的第一个预约</p>
                        <a href="/mobile/pages/reservation/reserve.jsp" class="new-reservation-btn">
                            <i class="fas fa-plus"></i> 新建预约
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
