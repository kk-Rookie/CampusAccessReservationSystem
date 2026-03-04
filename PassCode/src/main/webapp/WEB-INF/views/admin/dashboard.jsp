<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="总览" />
<%@ include file="../common/header.jsp" %>

<div class="page-content">

    <div id="dashboard">
        <div class="feature-banner text-center mb-4">
            <h1 class="display-5 fw-bold" style="top:50px;color: #005000;">校园通行码管理系统</h1>
            <p class="lead" style="color: #006600;">高效管理校园人员进出，助力疫情防控常态化</p>

        </div>
        <!-- 统计卡片 -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-icon"><i class="bi bi-calendar-check"></i></div>
                    <div class="stats-content">
                        <div class="stats-number">${totalReservations}</div>
                        <div class="stats-label">总预约数</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-icon"><i class="bi bi-check-circle"></i></div>
                    <div class="stats-content">
                        <div class="stats-number">${approvedReservations}</div>
                        <div class="stats-label">已通过预约数</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-icon"><i class="bi bi-building"></i></div>
                    <div class="stats-content">
                        <div class="stats-number">${totalDepartments}</div>
                        <div class="stats-label">部门数量</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-icon"><i class="bi bi-people"></i></div>
                    <div class="stats-content">
                        <div class="stats-number">${totalManagers}</div>
                        <div class="stats-label">管理员数</div>
                    </div>
                </div>
            </div>
        </div>
        <!-- 快捷操作区 -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card-custom">
                    <div class="card-header-custom">
                        <h5 class="mb-0"><i class="bi bi-lightning me-2"></i>功能区</h5>
                    </div>
                    <div class="card-body-custom">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <a href="${pageContext.request.contextPath}/admin/reservation/list?status=PENDING" class="btn btn-outline-warning w-100 quick-btn">
                                    <i class="bi bi-clock-history"></i><br>待审核预约
                                </a>
                            </div>
                            <div class="col-md-3">
                                <a href="${pageContext.request.contextPath}/admin/reservation/statistics" class="btn btn-outline-info w-100 quick-btn">
                                    <i class="bi bi-graph-up"></i><br>统计分析
                                </a>
                            </div>
                            <div class="col-md-3">
                                <a href="${pageContext.request.contextPath}/admin/department/list" class="btn btn-outline-primary w-100 quick-btn">
                                    <i class="bi bi-building"></i><br>部门管理
                                </a>
                            </div>
                            <div class="col-md-3">
                                <a href="${pageContext.request.contextPath}/admin/manager/list" class="btn btn-outline-success w-100 quick-btn">
                                    <i class="bi bi-people"></i><br>管理员管理
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row mb-4">

            <!-- 系统信息卡片 -->
            <div class="col-lg-4 mb-4">
                <div class="card-custom system-info-card">
                    <div class="card-header-custom">
                        <h5 class="mb-0"><i class="bi bi-info-circle me-2"></i>系统信息</h5>
                    </div>
                    <div class="card-body-custom">
                        <ul class="system-info-list">
                            <li>
                                <span class="info-icon-lg"><i class="bi bi-calendar3 text-primary"></i></span>
                                <span class="info-label">系统时间</span>
                                <span class="info-value" id="currentTime"></span>
                            </li>
                            <li>
                                <span class="info-icon-lg"><i class="bi bi-person-badge text-success"></i></span>
                                <span class="info-label">当前管理员</span>
                                <span class="info-value">${sessionScope.admin.name}</span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
// 当前时间
function updateCurrentTime() {
    const now = new Date();
    const timeString = now.toLocaleString('zh-CN', {
        year: 'numeric', month: '2-digit', day: '2-digit',
        hour: '2-digit', minute: '2-digit', second: '2-digit'
    });
    document.getElementById('currentTime').textContent = timeString;
}
setInterval(updateCurrentTime, 1000); updateCurrentTime();

</script>
<style>
    body {
        font-family: 'Microsoft YaHei', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        background: linear-gradient(135deg, #f9fff9 0%, #e6f7e6 100%);
        margin-top: 60px;
        color:black;
    }

    .navbar-custom {
        background: linear-gradient(135deg, rgba(220, 255, 220, 0.95), rgba(190, 255, 190, 0.95));
        box-shadow: 0 4px 12px rgba(0, 90, 10, 0.1);
        position: fixed;
        top: 0;
        width: 100%;
        z-index: 1000;
        border-bottom: 2px solid #d5ffd5;
        border-radius: 0 0 20px 20px;
        backdrop-filter: blur(4px);
    }

    .navbar-custom .navbar-brand {
        font-weight: 700;
        font-size: 1.5rem;
        display: flex;
        align-items: center;
        transition: all 0.3s ease;
        color: #005000;
    }

    .navbar-custom .navbar-brand i {
        margin-right: 10px;
        font-size: 1.8rem;
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

    .main-content {
        padding: 2rem;
    }

    .feature-banner {
        background: linear-gradient(135deg, rgba(220, 255, 220, 0.6), rgba(200, 255, 200, 0.8));
        border-radius: 20px;
        padding: 2rem;
        margin-bottom: 2rem;
        box-shadow: 0 8px 20px rgba(0, 90, 10, 0.1);
        border: 1px solid rgba(100, 255, 100, 0.2);
        text-align: center;
    }

    .dashboard-card {
        background: white;
        border-radius: 20px;
        padding: 1.5rem;
        box-shadow: 0 6px 15px rgba(0, 128, 0, 0.08);
        margin-bottom: 1.5rem;
        transition: all 0.3s ease;
        border: none;
        height: 100%;
    }

    .dashboard-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 20px rgba(0, 128, 0, 0.15);
    }

    .dashboard-card .bi {
        font-size: 2.5rem;
        background: linear-gradient(135deg, #88ff88, #66ff66);
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
        margin-bottom: 1rem;
    }

    .stat-number {
        font-size: 1.8rem;
        font-weight: 700;
        color: #005000;
    }

    .stat-title {
        color: #006600;
        font-size: 0.95rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .card-header {
        background: linear-gradient(135deg, rgba(220, 255, 220, 0.5), rgba(200, 255, 200, 0.6));
        border-bottom: 1px solid rgba(100, 255, 100, 0.3);
        font-weight: 600;
        font-size: 1.1rem;
        color: #005000;
        border-radius: 15px 15px 0 0 !important;
        padding: 1rem 1.5rem;
    }

    .notification-badge {
        position: absolute;
        top: 5px;
        right: 10px;
        background: linear-gradient(135deg, #ff5555, #ff2222);
        border-radius: 10px;
        color: white;
        font-size: 0.7rem;
        padding: 0.2rem 0.5rem;
        min-width: 20px;
        text-align: center;
    }

    .geometric-bg {
        position: fixed;
        bottom: 0;
        left: 0;
        width: 100%;
        height: 30%;
        background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100"><rect width="10" height="10" fill="rgba(100,255,100,0.05)"/></svg>');
        z-index: -1;
        opacity: 0.7;
    }

    @media (max-width: 992px) {
        .navbar-custom .navbar-collapse {
            background: linear-gradient(135deg, rgba(220, 255, 220, 0.95), rgba(190, 255, 190, 0.95));
            padding: 0.5rem 1rem;
            border-radius: 0 0 15px 15px;
            box-shadow: 0 6px 15px rgba(0, 100, 0, 0.1);
        }
    }
</style>