#!/bin/sh
# 测试脚本：验证 ERR_INCOMPLETE_CHUNKED_ENCODING 修复

echo "==========================================="
echo "测试校园通行证系统 API 响应修复"
echo "==========================================="

# 测试 API 响应
echo "\n1. 测试基本 API 响应..."
curl -v -H "Content-Type: application/json" "http://localhost:8080/api/test/echo" 2>&1 | grep -E "Transfer-Encoding:|Content-Length:"

echo "\n2. 测试 reservation API 响应..."
curl -v -H "Content-Type: application/json" "http://localhost:8080/api/reservation/my" 2>&1 | grep -E "Transfer-Encoding:|Content-Length:"

echo "\n3. 测试大型响应（固定大小）..."
curl -v -H "Content-Type: application/json" "http://localhost:8080/api/test/fixed-output?size=1024" 2>&1 | grep -E "Transfer-Encoding:|Content-Length:"

echo "\n4. 完整测试 API 请求-响应周期..."
curl -s -H "Content-Type: application/json" "http://localhost:8080/api/test/echo" | jq

echo "\n==========================================="
echo "测试完成。如果上述请求都显示了 Content-Length 而不是 Transfer-Encoding: chunked，"
echo "并且 JSON 响应格式正确完整，则表明修复成功。"
echo "==========================================="
