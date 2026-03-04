package com.example.demo.controller;

import com.example.demo.model.ApiResponse;
import com.example.demo.model.Reservation;
import com.example.demo.service.ReservationService;
import com.example.demo.util.QRCodeUtils;
import com.example.demo.util.CryptoUtils;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

/**
* 通行码控制器 - 处理二维码生成和验证
*/
@WebServlet("/api/passcode/*")
public class PassCodeController extends HttpServlet {

   private ReservationService reservationService = new ReservationService();
   private ObjectMapper objectMapper = new ObjectMapper();
   private SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");

   @Override
   protected void doGet(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {

       setResponseHeaders(request, response);
       String pathInfo = request.getPathInfo();

       try {
           if ("/generate".equals(pathInfo)) {
               generatePassCode(request, response);
           } else if ("/verify".equals(pathInfo)) {
               verifyPassCode(request, response);
           } else {
               writeResponse(response, ApiResponse.error("接口不存在"));
           }
       } catch (Exception e) {
           e.printStackTrace();
           writeResponse(response, ApiResponse.error("服务器内部错误: " + e.getMessage()));
       }
   }

   @Override
   protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
       doGet(request, response);
   }

   /**
    * 生成通行码二维码
    */
   private void generatePassCode(HttpServletRequest request, HttpServletResponse response)
           throws IOException {

       String reservationIdStr = request.getParameter("reservationId");

       if (reservationIdStr == null || reservationIdStr.trim().isEmpty()) {
           writeResponse(response, ApiResponse.error("预约ID不能为空"));
           return;
       }

       try {
           Long reservationId = Long.parseLong(reservationIdStr);

           // 查询预约信息
           Reservation reservation = reservationService.getReservationById(reservationId);

           if (reservation == null) {
               writeResponse(response, ApiResponse.error("预约记录不存在"));
               return;
           }

           if (!"approved".equals(reservation.getStatus())) {
               writeResponse(response, ApiResponse.error("预约尚未审核通过，无法生成通行码"));
               return;
           }

           // 生成或获取通行码
           String passCode = reservation.getPassCode();
           if (passCode == null || passCode.trim().isEmpty()) {
               passCode = reservationService.generatePassCode(reservationId);
           }

           // 检查通行码是否有效
           if (!reservationService.isPassCodeValid(reservationId)) {
               writeResponse(response, ApiResponse.error("通行码已过期，请重新申请"));
               return;
           }

           // 生成二维码内容
           String visitTime = dateFormat.format(reservation.getVisitTime());
           String qrContent = QRCodeUtils.generatePassCodeContentJson(
               reservationId,
               passCode,
               reservation.getName(),
               CryptoUtils.maskIdCard(reservation.getIdCard()),
               visitTime
           );

           // 生成二维码图片
           String qrCodeBase64 = QRCodeUtils.generateQRCodeWithLogo(qrContent, "通行码", 300, 300);

           // 准备返回数据
           Map<String, Object> data = new HashMap<>();
           data.put("qrCodeImage", "data:image/png;base64," + qrCodeBase64);
           data.put("passCode", passCode);
           data.put("reservationId", reservationId);
           data.put("name", reservation.getName());
           data.put("idCard", CryptoUtils.maskIdCard(reservation.getIdCard()));
           data.put("visitTime", visitTime);
           data.put("campus", reservation.getCampus());

           if (reservation.getPassCodeExpireTime() != null) {
               data.put("expireTime", dateFormat.format(reservation.getPassCodeExpireTime()));
           } else {
               data.put("expireTime", "24小时后");
           }

           writeResponse(response, ApiResponse.success("通行码生成成功", data));

       } catch (NumberFormatException e) {
           writeResponse(response, ApiResponse.error("预约ID格式错误"));
       } catch (Exception e) {
           e.printStackTrace();
           writeResponse(response, ApiResponse.error("生成通行码失败: " + e.getMessage()));
       }
   }

   /**
    * 验证通行码
    */
   private void verifyPassCode(HttpServletRequest request, HttpServletResponse response)
           throws IOException {

       String passCode = request.getParameter("passCode");
       String reservationIdStr = request.getParameter("reservationId");

       if (passCode == null || reservationIdStr == null) {
           writeResponse(response, ApiResponse.error("参数不完整"));
           return;
       }

       try {
           Long reservationId = Long.parseLong(reservationIdStr);

           // 验证通行码
           boolean isValid = reservationService.validatePassCode(reservationId, passCode);

           if (isValid) {
               Reservation reservation = reservationService.getReservationById(reservationId);

               Map<String, Object> data = new HashMap<>();
               data.put("valid", true);
               data.put("name", reservation.getName());
               data.put("idCard", CryptoUtils.maskIdCard(reservation.getIdCard()));
               data.put("visitTime", dateFormat.format(reservation.getVisitTime()));
               data.put("campus", reservation.getCampus());
               data.put("reservationType", reservation.getReservationType());

               writeResponse(response, ApiResponse.success("通行码验证成功", data));
           } else {
               Map<String, Object> data = new HashMap<>();
               data.put("valid", false);
               writeResponse(response, ApiResponse.error("通行码无效或已过期", data));
           }

       } catch (Exception e) {
           e.printStackTrace();
           writeResponse(response, ApiResponse.error("验证失败: " + e.getMessage()));
       }
   }

   /**
    * 设置响应头
    */
   private void setResponseHeaders(HttpServletRequest request, HttpServletResponse response) {
       response.setContentType("application/json;charset=UTF-8");
       response.setHeader("Access-Control-Allow-Origin", "*");
       response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
       response.setHeader("Access-Control-Allow-Headers", "Content-Type");
   }

   /**
    * 写入响应
    */
   private void writeResponse(HttpServletResponse response, ApiResponse apiResponse) throws IOException {
       // 设置响应内容长度以避免分块传输问题
       String jsonResponse = objectMapper.writeValueAsString(apiResponse);
       byte[] responseBytes = jsonResponse.getBytes("UTF-8");
       response.setContentLength(responseBytes.length);
       
       // 确保响应设置了正确的状态码
       if (!apiResponse.isSuccess()) {
           response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
       } else {
           response.setStatus(HttpServletResponse.SC_OK);
       }
       
       // 写入响应数据
       response.getOutputStream().write(responseBytes);
       response.getOutputStream().flush();
   }
}