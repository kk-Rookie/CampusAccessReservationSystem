<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="编辑部门" />
<%@ include file="../../common/header.jsp" %>

<div class="page-content">
    <div class="content-header">
        <div class="d-flex justify-content-between align-items-center">
            <h1><i class="bi bi-pencil-square me-2"></i>编辑部门</h1>
            <a href="${pageContext.request.contextPath}/admin/department/list" class="btn btn-outline-light">
                <i class="bi bi-arrow-left me-2"></i>返回列表
            </a>
        </div>
    </div>
    <div class="page-content-body">
        <!-- 错误消息 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- 表单卡片 -->
        <div class="card-custom mb-4">
            <div class="card-header-custom">
                <h5 class="mb-0">
                    <i class="bi bi-building me-2"></i>部门信息
                </h5>
            </div>
            <div class="card-body-custom">
                <form id="editDepartmentForm" method="post" action="${pageContext.request.contextPath}/admin/department/edit" class="needs-validation" novalidate>
                    <input type="hidden" name="deptId" value="${department.deptId}">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="deptName" class="form-label">
                                    <i class="bi bi-building me-1"></i>部门名称 <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="deptName" name="deptName" required value="${department.deptName != null ? department.deptName : ''}" placeholder="请输入部门名称">
                                <div class="invalid-feedback">请输入部门名称</div>
                                <div class="form-text text-light"><i class="bi bi-info-circle me-1"></i>部门名称在系统中必须唯一</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="deptType" class="form-label">
                                    <i class="bi bi-bookmark me-1"></i>部门类型 <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="deptType" name="deptType" required>
                                    <option value="" disabled>-- 请选择部门类型 --</option>
                                    <option value="行政部门" ${department.deptType eq '行政部门' ? 'selected' : ''}>行政部门</option>
                                    <option value="直属部门" ${department.deptType eq '直属部门' ? 'selected' : ''}>直属部门</option>
                                    <option value="学院" ${department.deptType eq '学院' ? 'selected' : ''}>学院</option>
                                </select>
                                <div class="invalid-feedback">请选择部门类型</div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="status" class="form-label">
                                    <i class="bi bi-toggle-on me-1"></i>状态
                                </label>
                                <select class="form-select" id="status" name="status">
                                    <option value="1" ${department.status == 1 ? 'selected' : ''}>启用</option>
                                    <option value="0" ${department.status == 0 ? 'selected' : ''}>禁用</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="createTime" class="form-label">
                                    <i class="bi bi-calendar-event me-1"></i>创建时间
                                </label>
                                <input type="text" class="form-control" value="${department.createTime != null ? department.createTime : ''}" readonly>
                                <div class="form-text text-light"><i class="bi bi-info-circle me-1"></i>创建时间不可修改</div>
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">
                            <i class="bi bi-card-text me-1"></i>部门描述
                        </label>
                        <textarea class="form-control" id="description" name="description" rows="4" placeholder="请输入部门描述信息（可选）">${department.description != null ? department.description : ''}</textarea>
                    </div>
                    <div class="mb-4">
                        <div class="form-text text-light">
                            <i class="bi bi-info-circle text-info me-2"></i>
                            <strong>部门类型说明：</strong>
                            <ul class="mt-2 mb-0">
                                <li><strong>行政部门：</strong>如教务处、学生处、人事处等管理部门</li>
                                <li><strong>直属部门：</strong>如图书馆、实验中心、网络中心等服务部门</li>
                                <li><strong>学院：</strong>如信息学院、管理学院、理学院等教学部门</li>
                            </ul>
                        </div>
                    </div>
                    <div class="d-flex justify-content-end gap-2 mt-4">
                        <a href="${pageContext.request.contextPath}/admin/department/list" class="btn btn-outline-light">
                            <i class="bi bi-x-circle me-2"></i>取消
                        </a>
                        <button type="reset" class="btn btn-outline-warning">
                            <i class="bi bi-arrow-clockwise me-2"></i>重置
                        </button>
                        <button type="submit" class="btn btn-outline-primary">
                            <i class="bi bi-check-circle me-2"></i>保存修改
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- 部门统计信息 -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="stats-card stats-primary">
                    <div class="stats-icon"><i class="bi bi-people-fill"></i></div>
                    <div class="stats-content">
                        <div class="stats-number">${adminCount != null ? adminCount : 0}</div>
                        <div class="stats-label">管理员数量</div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card stats-success">
                    <div class="stats-icon"><i class="bi bi-calendar-check"></i></div>
                    <div class="stats-content">
                        <div class="stats-number">${monthlyReservations != null ? monthlyReservations : 0}</div>
                        <div class="stats-label">本月预约</div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card stats-warning">
                    <div class="stats-icon"><i class="bi bi-clock-history"></i></div>
                    <div class="stats-content">
                        <div class="stats-number">${department.createTime != null ? department.createTime : '未设置'}</div>
                        <div class="stats-label">创建时间</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 操作提示 -->
        <div class="card-custom mt-4">
            <div class="card-header-custom">
                <h6 class="mb-0">
                    <i class="bi bi-lightbulb text-warning me-2"></i>操作提示
                </h6>
            </div>
            <div class="card-body-custom">
                <div class="row">
                    <div class="col-md-6">
                        <div class="d-flex align-items-center mb-2">
                            <i class="bi bi-check2-circle text-success me-2"></i>
                            <span>修改部门名称需确保唯一性</span>
                        </div>
                        <div class="d-flex align-items-center mb-2">
                            <i class="bi bi-check2-circle text-success me-2"></i>
                            <span>禁用部门将影响相关预约功能</span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="d-flex align-items-center mb-2">
                            <i class="bi bi-exclamation-triangle text-warning me-2"></i>
                            <span>删除部门前请确保无关联数据</span>
                        </div>
                        <div class="d-flex align-items-center mb-2">
                            <i class="bi bi-info-circle text-info me-2"></i>
                            <span>可在部门管理中查看详细统计</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div> <!-- 关闭 page-content-body -->
</div> <!-- 关闭 page-content -->

<style>

</style>
