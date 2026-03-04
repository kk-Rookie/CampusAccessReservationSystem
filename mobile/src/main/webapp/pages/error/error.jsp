<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>系统错误</title>
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
        
        .error-icon {
            font-size: 64px;
            color: #f59e0b;
            margin-bottom: 20px;
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
            background: rgba(59, 246, 90, 0.65);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            background: #25eb2f;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(59, 130, 246, 0.2);
        }
        
        .error-details {
            margin-top: 30px;
            background: #f1f5f9;
            padding: 15px;
            border-radius: 5px;
            text-align: left;
            max-height: 150px;
            overflow-y: auto;
            font-family: monospace;
            font-size: 12px;
            display: none;
        }
        
        .show-details-btn {
            background: none;
            border: 1px solid #cbd5e1;
            color: #64748b;
            padding: 5px 10px;
            border-radius: 5px;
            margin-top: 15px;
            cursor: pointer;
            font-size: 12px;
        }
        
        .show-details-btn:hover {
            background: #f1f5f9;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">⚠️</div>
        <h2 class="error-title">发生错误</h2>
        <p class="error-message">
            很抱歉，系统在处理您的请求时发生了错误。我们已经记录了此问题并将尽快修复。
        </p>
        <div class="error-action">
            <a href="/mobile/index.jsp" class="btn-primary">返回首页</a>
        </div>
        
        <button class="show-details-btn" onclick="toggleErrorDetails()">显示错误详情</button>
        
        <div id="errorDetails" class="error-details">
            <% if(exception != null) { %>
                <strong>错误类型:</strong> <%= exception.getClass().getName() %><br>
                <strong>错误信息:</strong> <%= exception.getMessage() %><br>
                <strong>堆栈跟踪:</strong><br>
                <% 
                    java.io.StringWriter stringWriter = new java.io.StringWriter();
                    java.io.PrintWriter printWriter = new java.io.PrintWriter(stringWriter);
                    exception.printStackTrace(printWriter);
                    out.println(stringWriter);
                    printWriter.close();
                    stringWriter.close();
                %>
            <% } else { %>
                错误详情不可用
            <% } %>
        </div>
    </div>
    
    <script>
        function toggleErrorDetails() {
            const details = document.getElementById('errorDetails');
            if(details.style.display === 'none' || details.style.display === '') {
                details.style.display = 'block';
            } else {
                details.style.display = 'none';
            }
        }
    </script>
</body>
</html>
