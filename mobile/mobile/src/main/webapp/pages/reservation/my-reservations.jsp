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
            
            --success-color: #10b981;     /* 成功绿色 */
            --warning-color: #f59e0b;     /* 警告橙色 */
            --danger-color: #ef4444;      /* 危险红色 */
            
            /* 使用主蓝色系作为主要颜色 */
            --primary-color: var(--primary-blue);
            --accent-color: var(--light-blue);
            --border-color: var(--primary-light);
            --light-bg: var(--accent-light);
        }

        .profile-avatar {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--success-color), #27ae60);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px solid rgba(46, 204, 113, 0.3);
            box-shadow: 0 2px 8px rgba(46, 204, 113, 0.3);
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
            box-shadow: 0 0 25px rgba(78, 145, 251, 0.08);
            position: relative;
            overflow: hidden;
        }
        
        .container::before {
            content: '';
            position: absolute;
            top: -10px;
            right: -10px;
            width: 120px;
            height: 120px;
            background: var(--accent-light);
            border-radius: 50%;
            opacity: 0.6;
            z-index: 0;
        }
        
        .container::after {
            content: '';
            position: absolute;
            bottom: 80px;
            left: -20px;
            width: 150px;
            height: 150px;
            background: var(--primary-light);
            border-radius: 50%;
            opacity: 0.4;
            z-index: 0;
        }

        .header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--accent-color) 100%);
            color: white;
            padding: 12px 15px;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 2px 12px rgba(78, 145, 251, 0.2);
        }

        .header-nav {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .header-nav i {
            font-size: 20px;
            cursor: pointer;
            padding: 8px;
            border-radius: 50%;
            transition: background 0.3s ease;
        }

        .header-nav i:hover {
            background: rgba(255, 255, 255, 0.2);
        }

        .header h1 {
            font-size: 16px;
            font-weight: 600;
            margin: 0;
        }

        .user-welcome {
            padding: 12px 15px;
            background: linear-gradient(to right, var(--light-bg), white);
            border-bottom: 1px solid var(--border-color);
            position: relative;
            z-index: 1;
            border-left: 3px solid var(--primary-color);
        }

        .user-welcome h3 {
            margin: 0 0 3px 0;
            color: var(--text-dark);
            font-size: 15px;
            font-weight: 600;
        }

        .user-welcome p {
            margin: 0;
            color: #666;
            font-size: 13px;
        }

        /* 筛选器样式 */
        .filter-section {
            padding: 12px 15px;
            background: white;
            border-bottom: 1px solid var(--border-color);
            position: relative;
            z-index: 1;
            box-shadow: 0 2px 8px rgba(78, 145, 251, 0.05);
        }

        .filter-tabs {
            display: flex;
            gap: 4px;
            margin-bottom: 10px;
            background: var(--light-bg);
            padding: 3px;
            border-radius: 8px;
        }

        .filter-tab {
            flex: 1;
            padding: 8px 10px;
            background: transparent;
            border: none;
            border-radius: 6px;
            text-align: center;
            cursor: pointer;
            font-size: 13px;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            color: var(--text-light);
            position: relative;
            overflow: hidden;
        }
        
        .filter-tab::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: rgba(78, 145, 251, 0.1);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: width 0.4s, height 0.4s;
            z-index: -1;
        }
        
        .filter-tab:hover::before {
            width: 120%;
            height: 200px;
        }

        .filter-tab.active {
            background: linear-gradient(135deg, var(--primary-color), #3a80ea);
            color: white;
            box-shadow: 0 3px 6px rgba(78, 145, 251, 0.2);
            font-weight: 500;
        }

        .search-box {
            position: relative;
            margin-top: 5px;
        }

        .search-input {
            width: 100%;
            padding: 8px 35px 8px 12px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 13px;
            background: white;
            transition: all 0.3s ease;
            box-shadow: 0 1px 4px rgba(78, 145, 251, 0.08);
        }
        
        .search-input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 2px 10px rgba(78, 145, 251, 0.15);
        }
        
        .search-input::placeholder {
            color: #aab7c4;
            font-style: italic;
        }

        .search-btn {
            position: absolute;
            right: 8px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--primary-color);
            cursor: pointer;
            font-size: 14px;
            transition: transform 0.3s ease;
        }
        
        .search-btn:hover {
            transform: translateY(-50%) scale(1.1);
        }

        .reservation-list {
            padding: 12px 15px;
            position: relative;
            z-index: 1;
        }

        .reservation-item {
            background: white;
            border-radius: 10px;
            margin-bottom: 12px;
            padding: 12px;
            box-shadow: 0 2px 10px rgba(78, 145, 251, 0.08);
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            border-left: 3px solid var(--primary-color);
            position: relative;
            overflow: hidden;
        }
        
        .reservation-item::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, rgba(78, 145, 251, 0.05), rgba(255, 140, 180, 0.05));
            border-radius: 0 0 0 100%;
            z-index: 0;
        }

        .reservation-item:hover {
            box-shadow: 0 4px 15px rgba(78, 145, 251, 0.15);
            transform: translateY(-1px);
        }

        .reservation-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
            position: relative;
            z-index: 1;
        }

        .reservation-type {
            background: linear-gradient(135deg, var(--primary-color), #3a80ea);
            color: white;
            padding: 3px 8px;
            border-radius: 15px;
            font-size: 11px;
            box-shadow: 0 1px 3px rgba(78, 145, 251, 0.2);
            display: inline-flex;
            align-items: center;
        }
        
        .reservation-type::before {
            content: '•';
            margin-right: 4px;
            font-size: 14px;
        }

        .reservation-status {
            padding: 3px 8px;
            border-radius: 15px;
            font-size: 11px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }
        
        .reservation-status::before {
            content: '';
            display: inline-block;
            width: 6px;
            height: 6px;
            border-radius: 50%;
            margin-right: 4px;
        }

        .status-pending {
            background: #fff8e6;
            color: #b7791f;
        }
        
        .status-pending::before {
            background: #f1c40f;
        }

        .status-approved {
            background: #e6fff0;
            color: #1e8449;
        }
        
        .status-approved::before {
            background: #2ecc71;
        }

        .status-rejected {
            background: #ffe6e6;
            color: #c0392b;
        }
        
        .status-rejected::before {
            background: #e74c3c;
        }

        .reservation-details {
            font-size: 13px;
            color: var(--text-light);
            line-height: 1.5;
            position: relative;
            z-index: 1;
            background: rgba(255, 255, 255, 0.8);
            padding: 8px;
            border-radius: 8px;
            margin: 4px 0;
        }

        .reservation-details div {
            margin-bottom: 6px;
            display: flex;
            flex-wrap: wrap;
        }
        
        .reservation-details strong {
            color: var(--text-dark);
            min-width: 70px;
            position: relative;
            font-size: 12px;
        }
        
        .reservation-details strong::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 1px;
            background: var(--primary-color);
            transition: width 0.3s ease;
        }
        
        .reservation-item:hover .reservation-details strong::after {
            width: 70%;
        }

        .reservation-actions {
            margin-top: 18px;
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            justify-content: flex-start;
            position: relative;
            z-index: 1;
        }

        .btn {
            padding: 10px 18px;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            font-weight: 500;
            position: relative;
            overflow: hidden;
            min-width: 100px;
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
            transition: width 0.4s, height 0.4s;
            z-index: 1;
        }
        
        .btn:hover::before {
            width: 200%;
            height: 200%;
        }
        
        .btn i {
            margin-right: 8px;
            font-size: 16px;
            z-index: 2;
        }
        
        .btn span {
            z-index: 2;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), #3a80ea);
            color: white;
            box-shadow: 0 4px 10px rgba(78, 145, 251, 0.25);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #8395a7, #6c757d);
            color: white;
            box-shadow: 0 4px 10px rgba(108, 117, 125, 0.25);
        }

        .btn-success {
            background: linear-gradient(135deg, #2ecc71, #27ae60);
            color: white;
            box-shadow: 0 4px 10px rgba(46, 204, 113, 0.25);
        }

        .btn-warning {
            background: linear-gradient(135deg, #f1c40f, #f39c12);
            color: #212529;
            box-shadow: 0 4px 10px rgba(241, 196, 15, 0.25);
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
        }
        
        .btn:active {
            transform: translateY(0);
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .empty-state, .login-required-state {
            text-align: center;
            padding: 70px 25px;
            color: var(--text-light);
            background: linear-gradient(135deg, white, var(--light-bg));
            border-radius: 16px;
            position: relative;
            overflow: hidden;
        }
        
        .empty-state::before, .login-required-state::before {
            content: '';
            position: absolute;
            top: -30px;
            right: -30px;
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: var(--accent-light);
            opacity: 0.5;
        }
        
        .empty-state::after, .login-required-state::after {
            content: '';
            position: absolute;
            bottom: -40px;
            left: -40px;
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background: var(--primary-light);
            opacity: 0.4;
        }

        .empty-state i, .login-required-state i {
            font-size: 64px;
            color: var(--primary-color);
            margin-bottom: 25px;
            opacity: 0.7;
            text-shadow: 0 3px 8px rgba(78, 145, 251, 0.2);
        }

        .empty-state h3, .login-required-state h3 {
            margin-bottom: 12px;
            color: var(--text-dark);
            font-size: 22px;
            font-weight: 600;
            position: relative;
        }
        
        .empty-state h3::after, .login-required-state h3::after {
            content: '';
            position: absolute;
            bottom: -6px;
            left: 50%;
            transform: translateX(-50%);
            width: 50px;
            height: 2px;
            background: var(--accent-color);
            opacity: 0.7;
        }

        .empty-state p, .login-required-state p {
            margin-bottom: 30px;
            line-height: 1.6;
            max-width: 280px;
            margin-left: auto;
            margin-right: auto;
        }

        .new-reservation-btn {
            background: linear-gradient(135deg, var(--primary-color), #3a80ea);
            color: white;
            padding: 14px 22px;
            border-radius: 50px;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            margin: 25px auto;
            width: 85%;
            max-width: 300px;
            box-shadow: 0 5px 15px rgba(78, 145, 251, 0.3);
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            position: relative;
            overflow: hidden;
            z-index: 2;
        }

        .new-reservation-btn i {
            font-size: 20px;
            margin-right: 12px;
            background: rgba(255, 255, 255, 0.2);
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
        }
        
        .new-reservation-btn::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent 0%, rgba(255, 255, 255, 0.1) 50%, transparent 100%);
            background-size: 200% 200%;
            animation: shine 3s infinite;
            z-index: -1;
        }
        
        @keyframes shine {
            0% { background-position: 200% 0; }
            100% { background-position: -200% 0; }
        }

        .new-reservation-btn:hover {
            background: linear-gradient(135deg, #3a80ea, var(--primary-color));
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(78, 145, 251, 0.4);
        }
        
        .new-reservation-btn:active {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(78, 145, 251, 0.3);
        }

        .pass-code-info {
            background: linear-gradient(to right, var(--primary-light), white);
            border-left: 3px solid var(--primary-color);
            border-radius: 8px;
            padding: 12px 15px;
            margin-top: 12px;
            font-size: 13px;
            box-shadow: 0 3px 10px rgba(78, 145, 251, 0.1);
            position: relative;
            overflow: hidden;
        }
        
        .pass-code-info::before {
            content: '';
            position: absolute;
            top: -10px;
            right: -10px;
            width: 40px;
            height: 40px;
            background: var(--accent-light);
            border-radius: 50%;
            opacity: 0.4;
        }

        .pass-code {
            font-family: 'Courier New', monospace;
            font-weight: bold;
            color: var(--primary-color);
            font-size: 18px;
            letter-spacing: 1px;
            text-shadow: 0 1px 2px rgba(78, 145, 251, 0.1);
            background: white;
            padding: 5px 10px;
            border-radius: 4px;
            display: inline-block;
            margin: 3px 0;
            border: 1px solid rgba(78, 145, 251, 0.3);
            animation: tech-breathe 3s infinite;
            position: relative;
        }
        
        .pass-code::before {
            content: '';
            position: absolute;
            top: 50%;
            left: -8px;
            width: 6px;
            height: 6px;
            background: var(--primary-color);
            border-radius: 50%;
            transform: translateY(-50%);
            opacity: 0.8;
            box-shadow: 0 0 8px var(--primary-color);
            animation: blink 2s infinite;
        }
        
        @keyframes blink {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.4; }
        }

        /* 加载状态 */
        .loading {
            text-align: center;
            padding: 50px 20px;
            color: var(--text-light);
            position: relative;
        }
        
        .loading::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(255,140,180,0.1) 0%, rgba(78,145,251,0.05) 70%, transparent 100%);
            animation: pulse-bg 2s ease-in-out infinite;
            z-index: -1;
        }
        
        @keyframes pulse-bg {
            0% { transform: translate(-50%, -50%) scale(1); opacity: 0.5; }
            50% { transform: translate(-50%, -50%) scale(1.5); opacity: 0.3; }
            100% { transform: translate(-50%, -50%) scale(1); opacity: 0.5; }
        }

        .loading-spinner {
            position: relative;
            width: 80px;
            height: 80px;
            margin: 0 auto 15px;
        }
        
        .spinner-ring {
            position: absolute;
            border-radius: 50%;
            border: 3px solid transparent;
            border-top-color: var(--primary-color);
            box-sizing: border-box;
        }
        
        .spinner-ring.outer {
            width: 70px;
            height: 70px;
            top: 5px;
            left: 5px;
            animation: spinner-rotate 2s linear infinite;
            border-top-color: var(--primary-color);
            border-right-color: var(--primary-color);
            opacity: 0.6;
        }
        
        .spinner-ring.middle {
            width: 50px;
            height: 50px;
            top: 15px;
            left: 15px;
            animation: spinner-rotate 1.8s linear infinite reverse;
            border-top-color: var(--accent-color);
            border-left-color: var(--accent-color);
            opacity: 0.7;
        }
        
        .spinner-ring.inner {
            width: 30px;
            height: 30px;
            top: 25px;
            left: 25px;
            animation: spinner-rotate 1.5s linear infinite;
            border-top-color: var(--primary-color);
            border-bottom-color: var(--primary-color);
            opacity: 0.8;
        }
        
        .loading-spinner i {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 16px;
            color: var(--primary-color);
            animation: flicker 2s infinite alternate;
        }
        
        @keyframes spinner-rotate {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        @keyframes flicker {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.6; }
        }
        
        .loading p {
            margin-top: 20px;
            font-size: 15px;
            opacity: 0.8;
            color: var(--primary-color);
            position: relative;
            animation: loading-text-fade 2s ease-in-out infinite;
        }
        
        @keyframes loading-text-fade {
            0% { opacity: 0.5; }
            50% { opacity: 1; }
            100% { opacity: 0.5; }
        }
        
        /* 科技感的呼吸效果 */
        @keyframes tech-breathe {
            0% { box-shadow: 0 0 10px rgba(78, 145, 251, 0.3); }
            50% { box-shadow: 0 0 20px rgba(78, 145, 251, 0.5); }
            100% { box-shadow: 0 0 10px rgba(78, 145, 251, 0.3); }
        }

        /* 统计信息 */
        .stats-section {
            padding: 18px 20px;
            background: linear-gradient(to right, var(--light-bg), white);
            border-bottom: 1px solid var(--border-color);
            position: relative;
            z-index: 1;
        }
        
        .stats-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: radial-gradient(circle at 50% 50%, var(--accent-light) 0%, transparent 20%),
                              radial-gradient(circle at 80% 80%, var(--primary-light) 0%, transparent 20%);
            opacity: 0.3;
            z-index: -1;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
        }

        .stat-item {
            text-align: center;
            padding: 12px 5px;
            background: white;
            border-radius: 12px;
            border: 1px solid var(--border-color);
            box-shadow: 0 3px 8px rgba(78, 145, 251, 0.05);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stat-item::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 2px;
            background: linear-gradient(to right, transparent, var(--primary-color), transparent);
            transform: translateX(-100%);
            animation: stats-line 3s infinite;
        }
        
        .stat-item:nth-child(2)::after {
            animation-delay: 0.5s;
            background: linear-gradient(to right, transparent, var(--accent-color), transparent);
        }
        
        .stat-item:nth-child(3)::after {
            animation-delay: 1s;
        }
        
        .stat-item:nth-child(4)::after {
            animation-delay: 1.5s;
            background: linear-gradient(to right, transparent, var(--accent-color), transparent);
        }
        
        @keyframes stats-line {
            0% { transform: translateX(-100%); }
            50% { transform: translateX(100%); }
            100% { transform: translateX(100%); }
        }
        
        .stat-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(78, 145, 251, 0.1);
            border-color: var(--primary-color);
        }

        .stat-number {
            font-size: 20px;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 5px;
            position: relative;
            display: inline-block;
        }
        
        .stat-number::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 50%;
            transform: translateX(-50%);
            width: 0;
            height: 2px;
            background: var(--accent-color);
            transition: width 0.3s ease;
        }
        
        .stat-item:hover .stat-number::after {
            width: 80%;
        }

        .stat-label {
            font-size: 12px;
            color: var(--text-light);
            font-weight: 500;
        }

        .reservation-id {
            font-size: 12px;
            color: #8a9aaf;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            font-family: 'Courier New', monospace;
            letter-spacing: 0.5px;
        }
        
        .reservation-id::before {
            content: '#';
            color: var(--primary-color);
            margin-right: 3px;
            font-weight: bold;
        }

        .action-menu {
            position: relative;
            display: inline-block;
        }

        .action-btn {
            background: white;
            border: 1px solid var(--border-color);
            padding: 8px 14px;
            border-radius: 20px;
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
        }
        
        .action-btn:hover {
            border-color: var(--primary-color);
            color: var(--primary-color);
            box-shadow: 0 3px 8px rgba(78, 145, 251, 0.1);
        }
        
        .action-btn i {
            margin-right: 5px;
            font-size: 16px;
        }

        .refresh-btn {
            background: none;
            border: none;
            color: white;
            font-size: 20px;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
        }

        .refresh-btn:hover {
            transform: rotate(180deg) scale(1.1);
            background: rgba(255, 255, 255, 0.3);
        }
        
        .refresh-btn:active {
            transform: rotate(180deg) scale(0.95);
        }
        
        /* 科技感背景元素 */
        .tech-background {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -2;
            overflow: hidden;
            pointer-events: none;
        }
        
        .tech-circle {
            position: absolute;
            border-radius: 50%;
            opacity: 0.1;
        }
        
        .tech-circle-1 {
            top: -10%;
            right: -10%;
            width: 300px;
            height: 300px;
            background: var(--primary-color);
            animation: float-slow 15s infinite alternate ease-in-out;
        }
        
        .tech-circle-2 {
            bottom: -15%;
            left: -15%;
            width: 400px;
            height: 400px;
            background: var(--accent-color);
            animation: float-slow 20s infinite alternate-reverse ease-in-out;
        }
        
        .tech-circle-3 {
            top: 40%;
            right: -20%;
            width: 200px;
            height: 200px;
            background: var(--primary-color);
            animation: float-slow 18s infinite alternate ease-in-out;
        }
        
        @keyframes float-slow {
            0% { transform: translate(0, 0); }
            100% { transform: translate(-30px, 30px); }
        }
        
        .tech-dots {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }
        
        .tech-dot {
            position: absolute;
            width: 3px;
            height: 3px;
            background: var(--primary-color);
            border-radius: 50%;
            opacity: 0.2;
            animation: pulse 3s infinite alternate;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); opacity: 0.1; }
            50% { transform: scale(1.5); opacity: 0.3; }
            100% { transform: scale(1); opacity: 0.1; }
        }
        
        /* 响应式修复 */
        @media (max-width: 480px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 10px;
            }
            
            .btn {
                padding: 8px 16px;
                min-width: 80px;
            }
            
            .filter-tab {
                padding: 8px 10px;
                font-size: 13px;
            }
            
            .reservation-actions {
                justify-content: center;
            }
        }
        
        /* 科技感背景元素 */
        .tech-background {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -2;
            overflow: hidden;
            pointer-events: none;
        }
        
        .tech-circle {
            position: absolute;
            border-radius: 50%;
            opacity: 0.1;
        }
        
        .tech-circle-1 {
            top: -10%;
            right: -10%;
            width: 300px;
            height: 300px;
            background: var(--primary-color);
            animation: float-slow 15s infinite alternate ease-in-out;
        }
        
        .tech-circle-2 {
            bottom: -15%;
            left: -15%;
            width: 400px;
            height: 400px;
            background: var(--accent-color);
            animation: float-slow 20s infinite alternate-reverse ease-in-out;
        }
        
        .tech-circle-3 {
            top: 40%;
            right: -20%;
            width: 200px;
            height: 200px;
            background: var(--primary-color);
            animation: float-slow 18s infinite alternate ease-in-out;
        }
        
        @keyframes float-slow {
            0% { transform: translate(0, 0); }
            100% { transform: translate(-30px, 30px); }
        }
        
        .tech-dots {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }
        
        .tech-dot {
            position: absolute;
            width: 3px;
            height: 3px;
            background: var(--primary-color);
            border-radius: 50%;
            opacity: 0.2;
            animation: pulse 3s infinite alternate;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); opacity: 0.1; }
            50% { transform: scale(1.5); opacity: 0.3; }
            100% { transform: scale(1); opacity: 0.1; }
        }
        
        /* 响应式修复 */
        @media (max-width: 480px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 10px;
            }
            
            .btn {
                padding: 8px 16px;
                min-width: 80px;
            }
            
            .filter-tab {
                padding: 8px 10px;
                font-size: 13px;
            }
            
            .reservation-actions {
                justify-content: center;
            }
        }
        
        /* 更强的移动端压缩 */
        @media (max-width: 480px) {
            .container {
                box-shadow: none;
            }
            
            .header {
                padding: 8px 12px;
            }
            
            .header h1 {
                font-size: 15px;
            }
            
            .user-welcome {
                padding: 8px 12px;
            }
            
            .user-welcome h3 {
                font-size: 14px;
                margin-bottom: 2px;
            }
            
            .user-welcome p {
                font-size: 12px;
            }
            
            .filter-section {
                padding: 8px 12px;
            }
            
            .filter-tabs {
                margin-bottom: 8px;
            }
            
            .filter-tab {
                padding: 6px 8px;
                font-size: 12px;
            }
            
            .search-input {
                padding: 6px 30px 6px 10px;
                font-size: 12px;
            }
            
            .reservation-list {
                padding: 8px 12px;
            }
            
            .reservation-item {
                margin-bottom: 8px;
                padding: 8px;
                border-radius: 8px;
            }
            
            .reservation-header {
                margin-bottom: 6px;
            }
            
            .reservation-type {
                padding: 2px 6px;
                font-size: 10px;
            }
            
            .reservation-status {
                padding: 2px 6px;
                font-size: 10px;
            }
            
            .reservation-details {
                padding: 6px;
                font-size: 12px;
                margin: 3px 0;
            }
            
            .reservation-details div {
                margin-bottom: 4px;
            }
            
            .reservation-details strong {
                min-width: 60px;
                font-size: 11px;
            }
            
            .reservation-actions {
                margin-top: 8px;
                gap: 6px;
            }
            
            .btn {
                padding: 6px 12px;
                font-size: 12px;
                min-width: 70px;
            }
            
            .pass-code-info {
                padding: 8px 10px;
                margin-top: 8px;
                font-size: 11px;
            }
            
            .pass-code {
                font-size: 14px;
                padding: 3px 6px;
            }
            
            .empty-state, .login-required-state {
                padding: 40px 15px;
            }
            
            .empty-state i, .login-required-state i {
                font-size: 48px;
                margin-bottom: 15px;
            }
            
            .empty-state h3, .login-required-state h3 {
                font-size: 18px;
                margin-bottom: 8px;
            }
            
            .empty-state p, .login-required-state p {
                font-size: 13px;
                margin-bottom: 20px;
            }
            
            .new-reservation-btn {
                padding: 10px 16px;
                margin: 15px auto;
                width: 90%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- 头部 -->
        <header class="header">
            <button class="back-btn" data-action="back">
                <i class="fas fa-arrow-left"></i>
            </button>
            <h1>我的预约</h1>
            <button class="refresh-btn" data-action="refresh" title="刷新">
                <i class="fas fa-sync-alt"></i>
            </button>
        </header>

        <!-- 用户欢迎信息 -->
        <c:if test="${not empty username}">
            <div class="user-welcome">
                <h3>欢迎回来，${username}</h3>
                <p>您可以在这里查看和管理您的所有预约</p>
            </div>
        </c:if>

        <!-- 统计信息 -->
        <div class="stats-section" id="statsSection">
            <div class="stats-grid">
                <div class="stat-item">
                    <div class="stat-number" id="totalCount">-</div>
                    <div class="stat-label">总预约</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number" id="approvedCount">-</div>
                    <div class="stat-label">已通过</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number" id="pendingCount">-</div>
                    <div class="stat-label">待审核</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number" id="rejectedCount">-</div>
                    <div class="stat-label">已拒绝</div>
                </div>
            </div>
        </div>

        <!-- 筛选器 -->
        <div class="filter-section">
            <div class="filter-tabs">
                <div class="filter-tab active" data-status="all">全部</div>
                <div class="filter-tab" data-status="pending">待审核</div>
                <div class="filter-tab" data-status="approved">已通过</div>
                <div class="filter-tab" data-status="rejected">已拒绝</div>
            </div>
            <div class="search-box">
                <input type="text" class="search-input" id="searchInput" placeholder="搜索预约记录...">
                <button class="search-btn" data-action="search">
                    <i class="fas fa-search"></i>
                </button>
            </div>
        </div>

        <!-- 预约列表 -->
        <div class="reservation-list">
            <div id="loadingIndicator" class="loading" style="display: none;">
                <div class="loading-spinner">
                    <div class="spinner-ring outer"></div>
                    <div class="spinner-ring middle"></div>
                    <div class="spinner-ring inner"></div>
                    <i class="fas fa-sync-alt"></i>
                </div>
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
                                    <div><strong>校区：</strong>
                                        <c:choose>
                                            <c:when test="${reservation.campus == 'main'}">主校区</c:when>
                                            <c:when test="${reservation.campus == 'east'}">东校区</c:when>
                                            <c:when test="${reservation.campus == 'west'}">西校区</c:when>
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
                                    <c:if test="${not empty reservation.phone}">
                                        <div><strong>联系电话：</strong>${reservation.phone}</div>
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
                                       class="btn btn-primary">
                                        <i class="fas fa-eye"></i> 查看详情
                                    </a>
                                    
                                    <c:if test="${reservation.status == 'approved' && not empty reservation.passCode}">
                                        <a href="/mobile/pages/qrcode/pass-code.jsp?reservationId=${reservation.id}" 
                                           class="btn btn-success">
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
                            <i class="fas fa-calendar-alt"></i>
                            <h3>暂无预约记录</h3>
                            <p>您还没有任何预约记录<br>点击下方按钮创建您的第一个预约</p>
                            <div class="empty-state-hint" style="margin-top:20px; font-size:14px; color:var(--primary-color);">
                                <i class="fas fa-lightbulb" style="font-size:16px; margin-right:5px; opacity:0.7;"></i> 
                                预约成功后将获得专属校园通行码
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- 新建预约按钮 -->
        <a href="/mobile/pages/reservation/reserve.jsp" class="new-reservation-btn">
            <i class="fas fa-plus"></i> 新建预约
        </a>
        
        <!-- 底部导航 -->
        <nav class="bottom-nav">
            <div class="nav-item" onclick="location.href='/mobile/'">
                <i class="fas fa-home"></i>
                <span>首页</span>
            </div>
            <div class="nav-item active">
                <i class="fas fa-calendar"></i>
                <span>预约</span>
            </div>
            <div class="nav-item" onclick="location.href='/mobile/pages/qrcode/pass-code.jsp'">
                <i class="fas fa-qrcode"></i>
                <span>通行码</span>
            </div>
            <div class="nav-item" onclick="location.href='/mobile/pages/profile/index.jsp'">
                <i class="fas fa-user"></i>
                <span>我的</span>
            </div>
        </nav>
    </div>

    <!-- 引入JavaScript文件 -->
    <script src="/mobile/js/my-reservations.js"></script>
</body>


</html>