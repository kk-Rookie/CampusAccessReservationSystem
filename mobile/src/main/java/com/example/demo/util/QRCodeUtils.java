package com.example.demo.util;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

/**
 * 二维码生成工具类
 */
public class QRCodeUtils {
    
    private static final int DEFAULT_WIDTH = 300;
    private static final int DEFAULT_HEIGHT = 300;
    private static final int BLACK = 0xFF000000;
    private static final int WHITE = 0xFFFFFFFF;
    
    /**
     * 生成二维码图片（返回Base64编码）
     */
    public static String generateQRCodeBase64(String content, int width, int height) {
        try {
            Map<EncodeHintType, Object> hints = new HashMap<>();
            hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
            hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.M);
            hints.put(EncodeHintType.MARGIN, 1);
            
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            BitMatrix bitMatrix = qrCodeWriter.encode(content, BarcodeFormat.QR_CODE, width, height, hints);
            
            BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
            
            for (int x = 0; x < width; x++) {
                for (int y = 0; y < height; y++) {
                    image.setRGB(x, y, bitMatrix.get(x, y) ? BLACK : WHITE);
                }
            }
            
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(image, "PNG", baos);
            byte[] imageBytes = baos.toByteArray();
            
            return Base64.getEncoder().encodeToString(imageBytes);
            
        } catch (WriterException | IOException e) {
            e.printStackTrace();
            throw new RuntimeException("生成二维码失败: " + e.getMessage());
        }
    }
    
    /**
     * 生成二维码图片（默认尺寸）
     */
    public static String generateQRCodeBase64(String content) {
        return generateQRCodeBase64(content, DEFAULT_WIDTH, DEFAULT_HEIGHT);
    }
    
    /**
     * 生成带Logo的二维码
     */
    public static String generateQRCodeWithLogo(String content, String logoText, int width, int height) {
        try {
            Map<EncodeHintType, Object> hints = new HashMap<>();
            hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
            hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H);
            hints.put(EncodeHintType.MARGIN, 1);
            
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            BitMatrix bitMatrix = qrCodeWriter.encode(content, BarcodeFormat.QR_CODE, width, height, hints);
            
            BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
            Graphics2D graphics = image.createGraphics();
            
            graphics.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            graphics.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
            
            for (int x = 0; x < width; x++) {
                for (int y = 0; y < height; y++) {
                    image.setRGB(x, y, bitMatrix.get(x, y) ? BLACK : WHITE);
                }
            }
            
            if (logoText != null && !logoText.trim().isEmpty()) {
                addLogoText(graphics, logoText, width, height);
            }
            
            graphics.dispose();
            
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(image, "PNG", baos);
            byte[] imageBytes = baos.toByteArray();
            
            return Base64.getEncoder().encodeToString(imageBytes);
            
        } catch (WriterException | IOException e) {
            e.printStackTrace();
            throw new RuntimeException("生成带Logo二维码失败: " + e.getMessage());
        }
    }
    
    /**
     * 在二维码中心添加Logo文字
     */
    private static void addLogoText(Graphics2D graphics, String logoText, int width, int height) {
        int logoSize = width / 5;
        int logoX = (width - logoSize) / 2;
        int logoY = (height - logoSize) / 2;
        
        graphics.setColor(Color.WHITE);
        graphics.fillRoundRect(logoX, logoY, logoSize, logoSize, 10, 10);
        
        graphics.setColor(Color.GRAY);
        graphics.setStroke(new BasicStroke(2));
        graphics.drawRoundRect(logoX, logoY, logoSize, logoSize, 10, 10);
        
        graphics.setColor(Color.BLACK);
        Font font = new Font("微软雅黑", Font.BOLD, logoSize / 4);
        graphics.setFont(font);
        
        FontMetrics fm = graphics.getFontMetrics();
        int textWidth = fm.stringWidth(logoText);
        int textHeight = fm.getHeight();
        
        int textX = logoX + (logoSize - textWidth) / 2;
        int textY = logoY + (logoSize + textHeight) / 2 - fm.getDescent();
        
        graphics.drawString(logoText, textX, textY);
    }
    
    /**
     * 生成JSON格式的通行码内容
     */
    public static String generatePassCodeContentJson(Long reservationId, String passCode, 
                                                   String name, String idCard, String visitTime) {
        
        return String.format(
            "{\"type\":\"campus_pass\",\"reservationId\":%d,\"passCode\":\"%s\"," +
            "\"name\":\"%s\",\"idCard\":\"%s\",\"visitTime\":\"%s\",\"timestamp\":%d}",
            reservationId, passCode, name, idCard, visitTime, System.currentTimeMillis()
        );
    }
}