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
            --primary-green: #27ae60;
            --secondary-green: #2ecc71;
            --primary-light: #e8f8f5;
            --text-dark: #1d2c1b;
            --text-light: #5d6d66;
            --border-color: #d5dbdb;
        }

        body {
            background-color: #f5f7fa;
            font-family: 'Segoe UI', Roboto, sans-serif;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 425px;
            margin: 0 auto;
            background: white;
            min-height: 100vh;
            position: relative;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.05);
        }

        /* 头部样式 */
        .header {
            background: linear-gradient(135deg, var(--primary-green) 0%, var(--secondary-green) 100%);
            color: white;
            padding: 15px 20px;
            position: sticky;
            top: 0;
            z-index: 100;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-title {
            font-size: 18px;
            font-weight: 600;
            margin: 0;
        }

        .header-action {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.3s;
        }

        .header-action:hover {
            background: rgba(255, 255, 255, 0.2);
        }

        /* 登录提示 */
        .login-tip {
            padding: 12px 20px;
            text-align: center;
            font-size: 14px;
            color: var(--text-dark);
            background: var(--primary-light);
        }

        .login-tip a {
            color: var(--primary-green);
            text-decoration: none;
            font-weight: 500;
        }

        /* 筛选器样式 - 竖式排列 */
        .filter-section {
            padding: 15px 20px;
            background: white;
            border-bottom: 1px solid var(--border-color);
            position: sticky;
            top: 50px;
            z-index: 90;
        }

        .filter-tabs {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-bottom: 16px;
        }

        .filter-tab {
            padding: 12px 16px;
            border: none;
            border-radius: 8px;
            text-align: left;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
            color: var(--text-light);
            background: var(--primary-light);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .filter-tab.active {
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-green));
            color: white;
            font-weight: 500;
        }

        /* 搜索框 */
        .search-box {
            position: relative;
        }

        .search-input {
            width: 100%;
            padding: 10px 40px 10px 15px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 14px;
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary-green);
        }

        .search-btn {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--primary-green);
            cursor: pointer;
        }

        /* 预约项样式 */
        .reservation-list {
            padding: 0 15px 80px;
        }

        .reservation-item {
            background: white;
            border-radius: 10px;
            margin-bottom: 15px;
            padding: 15px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            border-left: 4px solid var(--primary-green);
        }

        .reservation-id {
            font-size: 12px;
            color: var(--text-light);
            margin-bottom: 10px;
        }

        .reservation-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .reservation-type {
            background: linear-gradient(135deg, var(--primary-green), #38b000);
            color: white;
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 500;
        }

        .reservation-status {
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 500;
        }

        .status-approved {
            background: #d1fae5;
            color: #065f46;
        }

        .status-pending {
            background: #fef9e7;
            color: #92400e;
        }

        .status-rejected {
            background: #fee2e2;
            color: #991b1b;
        }

        .reservation-details {
            font-size: 14px;
            color: var(--text-light);
            line-height: 1.6;
        }

        .reservation-details div {
            margin-bottom: 6px;
        }

        .reservation-details strong {
            color: var(--text-dark);
            min-width: 80px;
            display: inline-block;
        }

        .pass-code-info {
            background: var(--primary-light);
            border-left: 3px solid var(--primary-green);
            border-radius: 8px;
            padding: 12px 15px;
            margin: 10px 0;
        }

        .pass-code {
            font-family: monospace;
            font-weight: bold;
            color: var(--primary-green);
            font-size: 18px;
            background: white;
            padding: 5px 10px;
            border-radius: 4px;
            border: 1px solid #a7f3d0;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
            text-decoration: none;
            font-weight: 500;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-green));
            color: white;
        }

        .btn-success {
            background: #10b981;
            color: white;
        }

        .btn-warning {
            background: #f59e0b;
            color: white;
        }

        .reservation-actions {
            display: flex;
            gap: 8px;
            margin-top: 12px;
            flex-wrap: wrap;
        }

        .empty-state {
            text-align: center;
            padding: 50px 20px;
            color: var(--text-light);
        }

        .empty-state h3 {
            color: var(--text-dark);
            font-size: 20px;
            margin-bottom: 10px;
        }

        .new-reservation-btn {
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-green));
            color: white;
            padding: 14px 20px;
            border-radius: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            width: 80%;
            max-width: 300px;
            box-shadow: 0 4px 12px rgba(78, 145, 251, 0.3);
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 10;
            text-decoration: none;
            justify-content: center;
            gap: 8px;
        }

        .loading {
            text-align: center;
            padding: 50px 20px;
            color: var(--text-light);
        }

        @media (max-width: 480px) {
            .filter-section {
                padding: 12px 15px;
                top: 45px;
            }
            .reservation-item {
                padding: 12px;
            }
            .new-reservation-btn {
                padding: 12px 16px;
                width: 85%;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <!-- 头部 -->
    <header class="header">
        <button class="header-action" data-action="back">
            <i class="fas fa-arrow-left"></i>
        </button>
        <h1 class="header-title">我的预约</h1>
        <button class="header-action" data-action="refresh">
            <i class="fas fa-sync-alt"></i>
        </button>
    </header>

    <!-- 登录提示 - 简化为文字 -->
    <c:if test="${empty username}">
        <div class="login-tip">
            请先 <a href="/mobile/pages/auth/login.jsp">登录</a> 或 <a href="/mobile/pages/auth/register.jsp">注册</a> 查看预约记录
        </div>
    </c:if>

    <!-- 筛选器 - 竖式排列 -->
    <div class="filter-section">
        <div class="filter-tabs">
            <div class="filter-tab active" data-status="all">
                <span>全部</span>
                <span class="status-count" id="allCount">0</span>
            </div>
            <div class="filter-tab" data-status="pending">
                <span>待审核</span>
                <span class="status-count" id="pendingCount">0</span>
            </div>
            <div class="filter-tab" data-status="approved">
                <span>已通过</span>
                <span class="status-count" id="approvedCount">0</span>
            </div>
            <div class="filter-tab" data-status="rejected">
                <span>已拒绝</span>
                <span class="status-count" id="rejectedCount">0</span>
            </div>
        </div>
        <div class="search-box">
            <input type="text" class="search-input" id="searchInput" placeholder="搜索预约记录...">
            <button class="search-btn" data-action="search">
                <i class="fas fa-search"></i>
            </button>
        </div>
    </div>

    <!-- 预约列表 - 仅登录后显示 -->
    <c:if test="${not empty username}">
        <div class="reservation-list">
            <div id="loadingIndicator" class="loading" style="display: none;">
                <i class="fas fa-spinner fa-spin"></i>
                <p>数据加载中...</p>
            </div>

            <div id="reservationContainer">
                <c:choose>
                    <c:when test="${not empty reservations}">
                        <c:forEach var="reservation" items="${reservations}">
                            <div class="reservation-item" data-status="${reservation.status}">
                                <div class="reservation-id">预约编号: ${reservation.id}</div>
                                <div class="reservation-header">
                                    <span class="reservation-type">
                                        <c:choose>
                                            <c:when test="${reservation.reservationType == 'public'}">社会公众预约</c:when>
                                            <c:when test="${reservation.reservationType == 'business'}">公务预约</c:when>
                                            <c:otherwise>${reservation.reservationType}</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="reservation-status ${reservation.status == 'pending' ? 'status-pending' : reservation.status == 'approved' ? 'status-approved' : 'status-rejected'}">
                                        <c:choose>
                                            <c:when test="${reservation.status == 'pending'}">待审核</c:when>
                                            <c:when test="${reservation.status == 'approved'}">已通过</c:when>
                                            <c:otherwise>已拒绝</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <div class="reservation-details">
                                    <div><strong>姓名：</strong>${reservation.name}</div>
                                    <div><strong>校区：</strong>
                                        <c:choose>
                                            <c:when test="${reservation.campus == 'main'}">主校区</c:when>
                                            <c:when test="${reservation.campus == 'east'}">东校区</c:when>
                                            <c:otherwise>${reservation.campus}</c:otherwise>
                                        </c:choose>
                                    </div>
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

                                <c:if test="${reservation.status == 'approved' && not empty reservation.passCode}">
                                    <div class="pass-code-info">
                                        <div><strong>通行码：</strong><span class="pass-code">${reservation.passCode}</span></div>
                                        <c:if test="${not empty reservation.passCodeExpireTime}">
                                            <div><strong>有效期至：</strong>${reservation.passCodeExpireTime}</div>
                                        </c:if>
                                    </div>
                                </c:if>

                                <div class="reservation-actions">
                                    <a href="/mobile/pages/reservation/reservation-detail?id=${reservation.id}" class="btn btn-primary">
                                        <i class="fas fa-eye"></i> 详情
                                    </a>
                                    <c:if test="${reservation.status == 'approved' && not empty reservation.passCode}">
                                        <a href="/mobile/pages/qrcode/pass-code.jsp?reservationId=${reservation.id}" class="btn btn-success">
                                            <i class="fas fa-qrcode"></i> 通行码
                                        </a>
                                    </c:if>
                                    <c:if test="${reservation.status == 'pending'}">
                                        <button class="btn btn-warning" data-action="cancel" data-reservation-id="${reservation.id}">
                                            <i class="fas fa-times"></i> 取消
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <h3>暂无预约记录</h3>
                            <p>您还没有任何预约记录</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- 新建预约按钮 -->
        <a href="/mobile/pages/reservation/reserve.jsp" class="new-reservation-btn">
            <i class="fas fa-plus"></i> 新建预约
        </a>
    </c:if>
</div>
<script src="/mobile/js/my-reservations.js"></script>
</body>
</html>