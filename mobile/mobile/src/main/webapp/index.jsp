<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园通行码预约系统</title>
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        /* 多样蓝色科技风格配色方案 */
        :root {
            --primary-blue: #3b82f6;      /* 主蓝色 - 调整为更友好的蓝色 */
            --secondary-blue: #3b82f6;    /* 次蓝色 */
            --light-blue: #60a5fa;        /* 浅蓝色 */
            --sky-blue: #0ea5e9;          /* 天空蓝 */
            --indigo-blue: #6366f1;       /* 靛蓝 */
            --cyan-blue: #06b6d4;         /* 青蓝色 */
            --steel-blue: #475569;        /* 钢蓝色 */
            --ocean-blue: #0c4a6e;        /* 海洋蓝 */
            
            --primary-light: #dbeafe;     /* 浅蓝背景 */
            --secondary-light: #e0f2fe;   /* 次浅蓝背景 */
            --accent-light: #f0f9ff;      /* 极浅蓝背景 */
            
            --primary-dark: #1e40af;      /* 深蓝色 */
            --text-dark: #1e293b;         /* 深色文字 */
            --text-light: #64748b;        /* 浅色文字 */
            
            /* 渐变色组合 */
            --gradient-primary: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 100%);
            --gradient-sky: linear-gradient(135deg, var(--sky-blue) 0%, var(--light-blue) 100%);
            --gradient-ocean: linear-gradient(135deg, var(--cyan-blue) 0%, var(--indigo-blue) 100%);
            --gradient-steel: linear-gradient(135deg, var(--steel-blue) 0%, var(--ocean-blue) 100%);
            --gradient-light: linear-gradient(135deg, var(--primary-light) 0%, var(--secondary-light) 100%);
        }
        
        body {
            background: linear-gradient(135deg, #f8fafc 0%, var(--accent-light) 100%);
            position: relative;
            overflow-x: hidden;
            min-height: 100vh;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
        }
        
        /* 动态网格背景效果 */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: 
                linear-gradient(to right, rgba(37, 99, 235, 0.02) 1px, transparent 1px),
                linear-gradient(to bottom, rgba(37, 99, 235, 0.02) 1px, transparent 1px);
            background-size: 60px 60px;
            animation: grid-move 20s linear infinite;
            z-index: -1;
        }
        
        @keyframes grid-move {
            0% { transform: translate(0, 0); }
            100% { transform: translate(60px, 60px); }
        }
        
        /* 浮动装饰元素 */
        body::after {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background:
                radial-gradient(circle at 25% 25%, var(--primary-blue) 0px, transparent 1px),
                radial-gradient(circle at 75% 75%, var(--sky-blue) 0px, transparent 1px),
                radial-gradient(circle at 50% 10%, var(--cyan-blue) 0px, transparent 1px),
                radial-gradient(circle at 10% 90%, var(--indigo-blue) 0px, transparent 1px);
            background-size: 100px 100px, 150px 150px, 80px 80px, 120px 120px;
            animation: float-particles 25s ease-in-out infinite;
            opacity: 0.4;
            z-index: -1;
        }
        
        @keyframes float-particles {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            25% { transform: translate(10px, -10px) rotate(1deg); }
            50% { transform: translate(-5px, -20px) rotate(-1deg); }
            75% { transform: translate(-10px, -5px) rotate(0.5deg); }
        }
        
        /* 增强的动态浮动点阵 */
        .tech-dots {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: -1;
        }
        
        .tech-dot {
            position: absolute;
            width: 2px;
            height: 2px;
            background: var(--primary-blue);
            border-radius: 50%;
            opacity: 0.4;
            animation: float 8s ease-in-out infinite;
        }
        
        .tech-dot:nth-child(2n) {
            background: var(--sky-blue);
            animation-delay: -2s;
            animation-duration: 10s;
        }
        
        .tech-dot:nth-child(3n) {
            background: var(--light-blue);
            animation-delay: -4s;
            animation-duration: 12s;
        }
        
        .tech-dot:nth-child(4n) {
            background: var(--cyan-blue);
            animation-delay: -1s;
            animation-duration: 9s;
        }
        
        .tech-dot:nth-child(5n) {
            background: var(--indigo-blue);
            animation-delay: -3s;
            animation-duration: 11s;
        }
        
        @keyframes float {
            0%, 100% { 
                transform: translateY(0) rotate(0deg) scale(1); 
                opacity: 0.4;
            }
            50% { 
                transform: translateY(-30px) rotate(180deg) scale(1.2); 
                opacity: 0.8;
            }
        }
        
        /* 头部增强设计 */
        .header {
            background: var(--gradient-primary);
            position: relative;
            box-shadow: 0 4px 20px rgba(37, 99, 235, 0.15);
        }
        
        .header::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 2px;
            background: var(--gradient-sky);
            opacity: 0.6;
        }
        
        .header h1 {
            color: white;
            font-weight: 700;
            text-shadow: 0 2px 10px rgba(255,255,255,0.3);
        }
        
        /* 功能网格优化 */
        .function-grid {
            gap: 15px;
            padding: 15px;
        }
        
        .function-item {
            background: white;
            border: 1px solid rgba(0, 0, 0, 0.1);
            border-radius: 16px;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            transform-style: preserve-3d;
            perspective: 1000px;
        }
        
        .function-item::before {
            content: '';
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            background: var(--gradient-tech);
            border-radius: 18px;
            z-index: -1;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .function-item:hover::before {
            opacity: 1;
        }
        
        .function-item:hover {
            transform: translateY(-8px) rotateX(5deg) rotateY(5deg);
            box-shadow: 
                0 10px 30px rgba(37, 99, 235, 0.15),
                0 0 0 1px rgba(37, 99, 235, 0.1);
        }
        
        .function-item::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 20px;
            height: 20px;
            background: radial-gradient(circle, var(--primary-blue) 0%, transparent 70%);
            border-radius: 50%;
            transform: translate(-50%, -50%) scale(0);
            transition: transform 0.3s ease;
            opacity: 0.2;
        }
        
        .function-item:hover::after {
            transform: translate(-50%, -50%) scale(4);
        }
        
        .icon-wrapper {
            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 12px;
            box-shadow: 0 3px 12px rgba(59, 130, 246, 0.3);
            position: relative;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .icon-wrapper::after {
            content: '';
            position: absolute;
            width: 60px;
            height: 60px;
            background: rgba(59, 130, 246, 0.1);
            border-radius: 16px;
            top: -5px;
            left: -5px;
            z-index: -1;
            transition: all 0.3s ease;
        }

        .function-item:hover .icon-wrapper::after {
            transform: scale(1.2);
            background: rgba(59, 130, 246, 0.2);
        }
        
        .icon-wrapper i {
            color: white;
            font-size: 20px;
            text-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
        }

        .function-item:hover .icon-wrapper i {
            transform: scale(1.1);
            text-shadow: 0 2px 8px rgba(255, 255, 255, 0.3);
        }
        
        .function-item h3 {
            color: #1f2937;
            font-weight: 600;
            margin-bottom: 6px;
            font-size: 15px;
        }
        
        .function-item p {
            color: #6b7280;
            font-size: 12px;
            margin: 0;
            line-height: 1.4;
        }
        
        /* 快速入口优化 */
        .card {
            background: white;
            border: 1px solid rgba(0, 0, 0, 0.1);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            border-radius: 16px;
            overflow: hidden;
        }
        
        .card-header {
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 100%);
            color: white;
            font-weight: 600;
            padding: 15px 20px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
        }
        
        .card-body {
            padding: 20px;
            background: white;
        }
        
        .qr-code {
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            border-radius: 12px;
        }
        
        .qr-code i {
            animation: tech-breathe 2s ease-in-out infinite;
        }
        
        @keyframes tech-breathe {
            0%, 100% { transform: scale(1); opacity: 0.8; }
            50% { transform: scale(1.1); opacity: 1; }
        }
        
        /* 底部导航优化 */
        .bottom-nav {
            background: white;
            border-top: 1px solid #e0e0e0;
            box-shadow: 0 -2px 20px rgba(0, 0, 0, 0.1);
        }
        
        .nav-item.active {
            color: var(--primary-color);
        }
        
        .nav-item.active i {
            animation: bounce 1s ease-in-out;
        }
        
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
            40% { transform: translateY(-5px); }
            60% { transform: translateY(-3px); }
        }
        
        /* 按钮优化 */
        .btn {
            background: var(--gradient-tech);
            border: none;
            border-radius: 12px;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
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
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: width 0.3s ease, height 0.3s ease;
        }
        
        .btn:hover::before {
            width: 300px;
            height: 300px;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(78, 145, 251, 0.3);
        }
        
        /* 特殊首页效果 - 动画波浪背景 */
        .wave-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -2;
            overflow: hidden;
        }
        
        .wave {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 200%;
            height: 200px;
            background: linear-gradient(0deg, 
                rgba(37, 99, 235, 0.03) 0%, 
                rgba(37, 99, 235, 0.01) 50%, 
                transparent 100%);
            border-radius: 50%;
            animation: wave-move 15s ease-in-out infinite;
        }
        
        .wave:nth-child(2) {
            background: linear-gradient(0deg, 
                rgba(59, 130, 246, 0.02) 0%, 
                rgba(59, 130, 246, 0.01) 50%, 
                transparent 100%);
            animation-delay: -5s;
            animation-duration: 20s;
        }
        
        .wave:nth-child(3) {
            background: linear-gradient(0deg, 
                rgba(14, 165, 233, 0.025) 0%, 
                rgba(14, 165, 233, 0.005) 50%, 
                transparent 100%);
            animation-delay: -10s;
            animation-duration: 25s;
        }
        
        @keyframes wave-move {
            0%, 100% { 
                transform: translateX(-50%) translateY(0) rotate(0deg); 
            }
            25% { 
                transform: translateX(-40%) translateY(-20px) rotate(1deg); 
            }
            50% { 
                transform: translateX(-60%) translateY(-10px) rotate(-1deg); 
            }
            75% { 
                transform: translateX(-45%) translateY(-25px) rotate(0.5deg); 
            }
        }
        
        /* 增强的粒子系统 */
        .particle-system {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            pointer-events: none;
        }
        
        .particle {
            position: absolute;
            width: 4px;
            height: 4px;
            background: var(--primary-blue);
            border-radius: 50%;
            opacity: 0.3;
            animation: float-particle 12s ease-in-out infinite;
        }
        
        .particle:nth-child(even) {
            background: var(--sky-blue);
            animation-delay: -6s;
            animation-duration: 15s;
        }
        
        .particle:nth-child(3n) {
            background: var(--light-blue);
            animation-delay: -3s;
            animation-duration: 18s;
        }
        
        .particle:nth-child(4n) {
            background: var(--cyan-blue);
            animation-delay: -9s;
            animation-duration: 14s;
        }
        
        @keyframes float-particle {
            0%, 100% { 
                transform: translateY(0) scale(1) rotate(0deg);
                opacity: 0.1;
            }
            25% { 
                transform: translateY(-50px) scale(1.2) rotate(90deg);
                opacity: 0.4;
            }
            50% { 
                transform: translateY(-80px) scale(0.8) rotate(180deg);
                opacity: 0.6;
            }
            75% { 
                transform: translateY(-30px) scale(1.1) rotate(270deg);
                opacity: 0.3;
            }
        }
        
        /* 动态边框效果 */
        .stats-card {
            position: relative;
            overflow: hidden;
        }
        
        .stats-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, 
                transparent 0%, 
                rgba(37, 99, 235, 0.1) 50%, 
                transparent 100%);
            transition: left 0.5s ease;
        }
        
        .stats-card:hover::before {
            left: 100%;
        }
        
        /* 移动端响应式优化 - 减少页面长度 */
        @media (max-width: 425px) {
            .header {
                padding: 15px;
            }
            
            .header h1 {
                font-size: 18px;
                margin-bottom: 3px;
            }
            
            .function-grid {
                gap: 12px;
                padding: 12px;
            }
            
            .function-item {
                padding: 15px;
                border-radius: 12px;
            }
            
            .function-item::before {
                border-radius: 14px;
            }
            
            .icon-wrapper {
                width: 50px;
                height: 50px;
                margin: 0 auto 10px;
            }
            
            .icon-wrapper i {
                font-size: 24px;
            }
            
            .function-item h3 {
                font-size: 14px;
                margin-bottom: 5px;
            }
            
            .function-item p {
                font-size: 12px;
                line-height: 1.4;
            }
            
            .qr-code {
                height: auto;
                padding: 15px;
            }
            
            .card-header {
                padding: 12px 15px;
                font-size: 14px;
            }
            
            .card-body {
                padding: 12px;
            }
            
            /* 减少装饰元素对性能的影响 */
            .tech-dots {
                display: none;
            }
            
            body::before,
            body::after {
                opacity: 0.2;
            }
        }
        
        /* 超小屏幕优化 */
        @media (max-width: 375px) {
            .header {
                padding: 12px;
            }
            
            .header h1 {
                font-size: 16px;
            }
            
            .function-grid {
                gap: 8px;
                padding: 8px;
            }
            
            .function-item {
                padding: 12px;
            }
            
            .icon-wrapper {
                width: 45px;
                height: 45px;
                margin: 0 auto 8px;
            }
            
            .icon-wrapper i {
                font-size: 20px;
            }
            
            .function-item h3 {
                font-size: 13px;
                margin-bottom: 3px;
            }
            
            .function-item p {
                font-size: 11px;
            }
            
            /* 头部压缩 */
            .header {
                padding: 15px;
            }
            
            .header h1 {
                font-size: 18px;
                margin-bottom: 5px;
            }
            
            .header p {
                font-size: 13px;
            }
            
            /* 快速入口区域压缩 */
            .card {
                margin: 10px 15px;
            }
            
            .card-header, .card-body {
                padding: 12px 15px;
            }
            
            .entry-grid {
                gap: 8px;
            }
            
            .entry-item {
                padding: 10px;
            }
            
            .entry-item i {
                font-size: 16px;
                margin-bottom: 5px;
            }
            
            .entry-item span {
                font-size: 11px;
            }
        }
        
        /* 极小屏幕优化 */
        @media (max-width: 360px) {
            .function-grid {
                gap: 10px;
                padding: 10px;
            }
            
            .function-item {
                padding: 12px 8px;
            }
            
            .icon-wrapper {
                width: 40px;
                height: 40px;
                margin-bottom: 8px;
            }
            
            .icon-wrapper i {
                font-size: 16px;
            }
            
            .function-item h3 {
                font-size: 12px;
                margin-bottom: 2px;
            }
            
            .function-item p {
                font-size: 10px;
            }
            
            .header {
                padding: 12px;
            }
            
            .header h1 {
                font-size: 16px;
            }
            
            .header p {
                font-size: 12px;
            }
        }
    </style>
</head>
<body>
    <!-- 动态背景点阵容器 -->
    <div class="tech-dots"></div>
    
    <div class="container">
        <!-- 头部 -->
        <header class="header">
            <h1>校园通行码</h1>
            <p id="userWelcome">预约管理系统</p>
            
            <!-- 用户菜单 -->
            <div id="userMenu" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); display: none;">
                <i class="fas fa-user-circle" style="font-size: 24px; cursor: pointer;" onclick="showUserMenu()"></i>
            </div>
            
            <!-- 登录按钮 -->
            <div id="loginBtn" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%);">
                <button class="btn btn-secondary" onclick="location.href='/mobile/pages/auth/login.jsp'" style="padding: 8px 16px; font-size: 14px;">
                    <i class="fas fa-sign-in-alt"></i> 登录
                </button>
            </div>
        </header>

        <!-- 主要功能区 -->
        <main class="main-content">
            <div class="function-grid">
                <div class="function-item" onclick="navigateToPage('pages/reservation/reserve.jsp')">
                    <div class="icon-wrapper">
                        <i class="fas fa-calendar-plus"></i>
                    </div>
                    <h3>我要预约</h3>
                    <p>申请进校预约</p>
                </div>

                <div class="function-item" onclick="navigateToPage('pages/reservation/my-reservations.jsp')">
                    <div class="icon-wrapper">
                        <i class="fas fa-list-alt"></i>
                    </div>
                    <h3>我的预约</h3>
                    <p>查看预约记录</p>
                </div>

                <div class="function-item" onclick="navigateToPage('pages/qrcode/pass-code.jsp')">
                    <div class="icon-wrapper">
                        <i class="fas fa-qrcode"></i>
                    </div>
                    <h3>通行码</h3>
                    <p>显示进校码</p>
                </div>

                <div class="function-item" onclick="navigateToPage('pages/help/index.jsp')">
                    <div class="icon-wrapper">
                        <i class="fas fa-question-circle"></i>
                    </div>
                    <h3>帮助中心</h3>
                    <p>使用指南</p>
                </div>
            </div>

            <!-- 快速入口 -->
            <div style="padding: 0 15px;">
                <div class="card">
                    <div class="card-header">
                        <i class="fas fa-calendar-check"></i> 完整预约入口
                    </div>
                    <div class="card-body" style="padding: 20px;">
                        <div style="text-align: center;">
                            <div class="qr-code" style="width: 150px; height: 150px; margin: 10px auto; background: white; border: 2px solid var(--primary-blue); box-shadow: 0 4px 15px rgba(59, 130, 246, 0.15);">
                                <i class="fas fa-qrcode" style="font-size: 60px; color: var(--primary-blue);"></i>
                            </div>
                            <p style="color: #6b7280; font-size: 14px; margin-top: 15px;">扫描二维码快速进入完整预约页面</p>
                        </div>
                    </div>
                </div>

                <!-- 数据统计卡片 -->
                <div class="card stats-card" style="margin-top: 20px;">
                    <div class="card-header">
                        <i class="fas fa-chart-bar"></i> 系统数据
                    </div>
                    <div class="card-body" style="padding: 20px;">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; text-align: center;">
                            <div style="padding: 20px; background: white; border: 1px solid #e5e7eb; border-radius: 12px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);">
                                <div style="font-size: 28px; font-weight: bold; color: var(--primary-blue); margin-bottom: 8px;">
                                    <i class="fas fa-calendar-day" style="font-size: 16px; margin-right: 8px;"></i><span id="todayReservationCount">--</span>
                                </div>
                                <div style="font-size: 12px; color: #666; font-weight: 500;">待审核</div>
                            </div>
                            <div style="padding: 20px; background: white; border: 1px solid #e5e7eb; border-radius: 12px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);">
                                <div style="font-size: 28px; font-weight: bold; color: var(--secondary-blue); margin-bottom: 8px;">
                                    <i class="fas fa-chart-line" style="font-size: 16px; margin-right: 8px;"></i><span id="totalReservationCount">--</span>
                                </div>
                                <div style="font-size: 12px; color: #666; font-weight: 500;">总计预约</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 公告/提示卡片 -->
                <div class="card" style="margin-top: 20px;">
                    <div class="card-header">
                        <i class="fas fa-bullhorn"></i> 温馨提示
                    </div>
                    <div class="card-body" style="padding: 20px;">
                        <div style="background: white; padding: 18px; border-radius: 12px; border: 1px solid #e5e7eb; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06); border-left: 4px solid var(--primary-blue);">
                            <p style="margin: 0; color: #374151; font-size: 14px; line-height: 1.6;">
                                <i class="fas fa-info-circle" style="color: var(--primary-blue); margin-right: 10px; font-size: 16px;"></i>
                                请提前预约进校时间，出示通行码即可快速通行。
                            </p>
                        </div>
                        <div style="background: white; padding: 18px; border-radius: 12px; border: 1px solid #e5e7eb; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06); border-left: 4px solid #10b981; margin-top: 12px;">
                            <p style="margin: 0; color: #374151; font-size: 14px; line-height: 1.6;">
                                <i class="fas fa-shield-alt" style="color: #10b981; margin-right: 10px; font-size: 16px;"></i>
                                系统采用安全加密技术，保护您的个人信息安全。
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- 底部导航 -->
        <nav class="bottom-nav">
            <div class="nav-item active">
                <i class="fas fa-home"></i>
                <span>首页</span>
            </div>
            <div class="nav-item" onclick="navigateToPage('pages/reservation/my-reservations.jsp')">
                <i class="fas fa-calendar"></i>
                <span>预约</span>
            </div>
            <div class="nav-item" onclick="navigateToPage('pages/qrcode/pass-code.jsp')">
                <i class="fas fa-qrcode"></i>
                <span>通行码</span>
            </div>
            <div class="nav-item" onclick="navigateToPage('pages/profile/index.jsp')">
                <i class="fas fa-user"></i>
                <span>我的</span>
            </div>
        </nav>
    </div>

    <!-- 引入主页专用JavaScript文件 -->
    <script src="js/index.js"></script>
</body>
</html>