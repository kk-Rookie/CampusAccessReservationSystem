<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 错误 - 页面未找到</title>
    <link rel="stylesheet" href="../../css/common.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            line-height: 1.6;
            color: #333;
            background: #f8f9fa;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        
        .error-container {
            max-width: 425px;
            background: white;
            border-radius: 10px;
            padding: 30px;
            text-align: center;
            box-shadow: 0 3px 15px rgba(0, 0, 0, 0.1);
        }
        
        .error-code {
            font-size: 72px;
            font-weight: bold;
            color: rgba(106, 246, 59, 0.8);
            margin: 0;
            line-height: 1;
        }
        
        .error-title {
            font-size: 24px;
            margin: 10px 0 20px;
            color: #1e293b;
        }
        
        .error-message {
            color: #64748b;
            margin-bottom: 30px;
        }
        
        .error-action {
            margin-top: 20px;
        }
        
        .btn-primary {
            background: rgba(84, 246, 59, 0.66);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            background: rgba(80, 235, 37, 0.44);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(59, 130, 246, 0.2);
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1 class="error-code">404</h1>
        <h2 class="error-title">页面未找到</h2>
        <p class="error-message">
            很抱歉，您请求的页面不存在。可能是链接已过期或您输入的地址有误。
        </p>
        <div class="error-action">
            <a href="/mobile/index.jsp" class="btn-primary">返回首页</a>
        </div>
    </div>
</body>
</html>
