<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>校园通行码管理系统</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    html, body {
      height: 100%;
      font-family: 'Microsoft YaHei', sans-serif;
    }

    body {
      background: linear-gradient(to right, #eafafa, #d4fc79);
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      overflow-x: hidden;
      padding: 1rem;
    }

    .main-container {
      position: relative;
      z-index: 10;
      width: 100%;
      max-width: 600px;
      padding: 2rem;
      background: rgba(255, 255, 255, 0.95);
      border-radius: 25px;
      box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
      text-align: center;
    }

    .system-title {
      color: #4caf50;
      font-weight: 700;
      margin-bottom: 1rem;
      font-size: 2.5rem;
    }

    .system-subtitle {
      color: #6c757d;
      font-size: 1.1rem;
      margin-bottom: 2.5rem;
      line-height: 1.6;
    }

    .icon-container {
      margin-bottom: 1rem;
      font-size: 4rem;
      color: #4caf50;
    }

    .btn-access {
      background: linear-gradient(to right, #4caf50, #8bc34a);
      border: none;
      border-radius: 15px;
      padding: 1rem 2.5rem;
      font-weight: 600;
      font-size: 1.1rem;
      color: white;
      transition: all 0.3s ease;
      margin: 0.5rem auto;
      box-shadow: 0 5px 15px rgba(76, 175, 80, 0.4);
      position: relative;
      overflow: hidden;
      display: inline-block;
      width: 300px;
    }

    .btn-access:hover {
      transform: translateY(-3px);
      box-shadow: 0 15px 30px rgba(76, 175, 80, 0.4);
    }

    .button-container {
      margin: 2rem 0;
    }

    .system-footer {
      margin-top: 2rem;
      padding-top: 2rem;
      border-top: 1px solid rgba(76, 175, 80, 0.2);
      color: #6c757d;
      font-size: 0.9rem;
    }
  </style>
</head>
<body>
<div class="main-container">
  <div class="welcome-card">
    <div class="icon-container">
      <i class="bi bi-qr-code-scan"></i>
    </div>
    <h1 class="system-title">校园通行码管理后台</h1>
    <p class="system-subtitle">- 高效便捷的校园通行解决方案 -</p>

    <div class="button-container">
      <div class="d-grid gap-3">
        <a href="${pageContext.request.contextPath}/admin/login" class="btn btn-access">
          <b>- 管理员登录 -</b>
        </a>
      </div>
    </div>

    <div class="system-footer">
      <div>
        <small>- 校园通行码管理系统 -</small>
      </div>
    </div>
  </div>
</div>
</body>
</html>



