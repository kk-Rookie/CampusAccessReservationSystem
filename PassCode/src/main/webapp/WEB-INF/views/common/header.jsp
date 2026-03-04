<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - 校园通行码预约管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* 基础样式重置 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            color: #333;
            min-height: 100vh;
            overflow-x: hidden;
            margin-top:20px;
            padding: 0;

        }

        /* 导航栏优化 - 白绿配色 */
        .navbar-custom {
            background: linear-gradient(135deg, rgba(220, 255, 220, 0.95), rgba(190, 255, 190, 0.95));
            box-shadow: 0 4px 12px rgba(0, 90, 10, 0.1);
            border-bottom: 2px solid #d5ffd5;
            border-radius: 0 0 20px 20px;
            backdrop-filter: blur(4px);
            padding: 0.8rem 1.5rem;
        }
        .navbar-custom {
            background: linear-gradient(135deg, rgba(220, 255, 220, 0.95), rgba(190, 255, 190, 0.95));
            box-shadow: 0 4px 12px rgba(0, 90, 10, 0.1);
            border-bottom: 2px solid #d5ffd5;
            border-radius: 0 0 20px 20px;
            backdrop-filter: blur(4px);
            padding: 0.8rem 1rem;
        }

        .navbar-collapse {
            display: flex;
            justify-content: space-between;
            width: 100%;
        }

        .navbar-nav {
            display: flex;
            flex: 1;
            justify-content: space-around;
        }

        .navbar-nav.me-auto {
            margin-right: 0 !important;
        }

        .navbar-nav.ms-auto {
            margin-left: 0 !important;
        }

        .nav-item {
            flex: 1;
            display: flex;
            justify-content: center;
            max-width: 180px;
        }

        .nav-link {
            position: relative;
            font-weight: 500;
            color: #006600;
            padding: 0.8rem 1rem;
            border-radius: 12px;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            min-height: 60px;
            width: 100%;
        }
        .navbar-custom .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            color: #005000;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
        }

        .navbar-custom .navbar-brand i {
            margin-right: 10px;
            font-size: 1.8rem;
            color: #28a745;
        }

        .navbar-custom .nav-link {
            position: relative;
            font-weight: 500;
            color: #006600;
            padding: 0.8rem 1.2rem;
            margin: 0 0.25rem;
            border-radius: 12px;
            transition: all 0.3s ease;
        }

        .navbar-custom .nav-link i {
            margin-right: 0.5rem;
            transition: all 0.3s ease;
        }

        .navbar-custom .nav-link:hover {
            color: #0044cc;
            background: rgba(255, 255, 255, 0.4);
        }

        .navbar-custom .nav-link.active {
            background: rgba(220, 255, 220, 0.8);
            box-shadow: 0 4px 8px rgba(0, 128, 0, 0.1);
            color: #004d00;
        }

        .navbar-custom .nav-link.active:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            width: 30px;
            height: 4px;
            background: linear-gradient(to right, #78ff78, #4cd965);
            border-radius: 2px;
            transform: translateX(-50%);
            transition: all 0.3s ease;
        }

        /* 主内容区优化 */
        .main-content {
            padding-top: 80px;
            padding-bottom: 2rem;
        }

        /* 功能卡片优化 */
        .feature-banner {
            background: linear-gradient(135deg, rgba(220, 255, 220, 0.6), rgba(200, 255, 200, 0.8));
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 8px 20px rgba(0, 90, 10, 0.1);
            border: 1px solid rgba(100, 255, 100, 0.2);
            text-align: center;
        }

        .feature-banner h3 {
            color: #005000;
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .feature-banner p {
            color: #006600;
            font-size: 1.1rem;
        }

        /* 统计卡片优化 */
        .stats-card {
            background: white;
            border-radius: 20px;
            padding: 1.5rem;
            box-shadow: 0 6px 15px rgba(0, 128, 0, 0.08);
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
            border: none;
            height: 100%;
            text-align: center;
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 128, 0, 0.15);
        }

        .stats-icon {
            font-size: 2.5rem;
            background: linear-gradient(135deg, #88ff88, #66ff66);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            margin-bottom: 1rem;
            display: block;
        }

        .stat-number {
            font-size: 1.8rem;
            font-weight: 700;
            color: #005000;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: #006600;
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* 功能区优化 */
        .card-custom {
            background: white;
            border-radius: 20px;
            padding: 0;
            box-shadow: 0 6px 15px rgba(0, 128, 0, 0.08);
            margin-bottom: 1.5rem;
            overflow: hidden;
        }

        .card-header-custom {
            background: linear-gradient(135deg, rgba(220, 255, 220, 0.5), rgba(200, 255, 200, 0.6));
            border-bottom: 1px solid rgba(100, 255, 100, 0.3);
            padding: 1rem 1.5rem;
            font-weight: 600;
            font-size: 1.1rem;
            color: #005000;
        }

        .card-body-custom {
            padding: 1.5rem;
        }

        .quick-btn {
            display: block;
            padding: 1.5rem 0.5rem;
            border-radius: 15px;
            text-align: center;
            transition: all 0.3s ease;
            text-decoration: none;
            color: #333;
            border: 1px solid #e0f7e0;
            background: white;
        }

        .quick-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 15px rgba(0, 128, 0, 0.1);
            background: #f0fff0;
        }

        .quick-btn i {
            font-size: 2rem;
            margin-bottom: 0.5rem;
            display: block;
            color: #28a745;
        }

        /* 图表区域优化 */
        .card-body-custom canvas {
            width: 100%;
            height: 250px;
        }

        /* 系统信息卡片优化 */
        .system-info-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 6px 15px rgba(0, 128, 0, 0.08);
            overflow: hidden;
        }

        .system-info-list {
            list-style: none;
            padding: 0;
        }

        .system-info-list li {
            display: flex;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid #e0f7e0;
        }

        .system-info-list li:last-child {
            border-bottom: none;
        }

        .info-icon-lg {
            width: 40px;
            height: 40px;
            background: #e8f5e9;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            color: #28a745;
            font-size: 1.2rem;
        }

        .info-label {
            flex: 1;
            font-weight: 500;
            color: #006600;
        }

        .info-value {
            font-weight: 600;
            color: #005000;
        }

        /* 响应式优化 */
        @media (max-width: 992px) {
            .navbar-custom .navbar-collapse {
                background: linear-gradient(135deg, rgba(220, 255, 220, 0.95), rgba(190, 255, 190, 0.95));
                padding: 0.5rem 1rem;
                border-radius: 0 0 15px 15px;
                box-shadow: 0 6px 15px rgba(0, 100, 0, 0.1);
            }

            .navbar-custom .nav-link {
                padding: 0.8rem 1rem;
                margin: 0.1rem;
            }
        }

        @media (max-width: 768px) {
            .stats-card {
                margin-bottom: 1rem;
            }

            .quick-btn {
                margin-bottom: 1rem;
            }
        }
    </style>
</head>
<body>

    <!-- 侧边栏 -->
    <nav class="navbar navbar-expand-lg navbar-custom">
        <div class="container-fluid">

            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                    <a class="nav-link ${currentPage == 'dashboard' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/admin/dashboard">
                        首页
                    </a>
                </li>
                    <li class="nav-item">
                        <a class="nav-link ${currentPage == 'admin' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/admin/manager/list">

                            管理员管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${currentPage == 'department' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/admin/department/list">

                            部门管理
                        </a>
                    </li>
                    <li class="nav-item">
                    <a class="nav-link ${currentPage == 'reservation' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/admin/reservation/list">

                        公众预约管理
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${currentPage == 'audit' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/admin/reservation/audit">

                        公务预约审核
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${currentPage == 'statistics' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/admin/reservation/statistics">

                        预约数据统计
                    </a>
                </li>


                <li class="nav-item">
                    <a class="nav-link ${currentPage == 'system_audit' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/admin/audit/list">
                        安全审计
                    </a>
                </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-person-circle"></i>
                <div class="user-name">${sessionScope.admin.name}</div>
                            <div class="user-role"></div></a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <li><hr class="dropdown-divider"></li><a href="${pageContext.request.contextPath}/admin/logout" class="logout-btn">
                            <i class="bi bi-box-arrow-right"></i>退出登录
                        </a>
                        </ul>
                    </li></ul></div>
        </div>
    </nav>

</body>
</html>
