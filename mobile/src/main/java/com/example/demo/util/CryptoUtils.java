package com.example.demo.util;

import org.bouncycastle.crypto.engines.SM4Engine;
import org.bouncycastle.crypto.modes.CBCBlockCipher;
import org.bouncycastle.crypto.paddings.PaddedBufferedBlockCipher;
import org.bouncycastle.crypto.params.KeyParameter;
import org.bouncycastle.crypto.params.ParametersWithIV;
import org.bouncycastle.util.encoders.Hex;
import java.util.Base64;

/**
 * 数据安全加密工具类
 */
public class CryptoUtils {
    
    // ✅ 修复：SM4 密钥和IV必须是正确长度
    // SM4 密钥：32个字符（16字节）
    // SM4 IV：32个字符（16字节）
    private static final String SM4_KEY = "0123456789abcdeffedcba9876543210"; // 32字符
    private static final String SM4_IV = "fedcba9876543210fedcba9876543210";   // 32字符
    
    /**
     * SM4加密敏感数据
     */
    public static String encryptSM4(String plainText) {
        if (plainText == null || plainText.trim().isEmpty()) {
            return "";
        }
        
        try {
            SM4Engine engine = new SM4Engine();
            PaddedBufferedBlockCipher cipher = new PaddedBufferedBlockCipher(new CBCBlockCipher(engine));
            
            // ✅ 修复：确保密钥和IV长度正确
            byte[] keyBytes = Hex.decode(SM4_KEY);
            byte[] ivBytes = Hex.decode(SM4_IV);
            
            System.out.println("密钥长度: " + keyBytes.length + " 字节");
            System.out.println("IV长度: " + ivBytes.length + " 字节");
            
            KeyParameter keyParam = new KeyParameter(keyBytes);
            ParametersWithIV params = new ParametersWithIV(keyParam, ivBytes);
            
            cipher.init(true, params);
            
            byte[] input = plainText.getBytes("UTF-8");
            byte[] output = new byte[cipher.getOutputSize(input.length)];
            
            int length = cipher.processBytes(input, 0, input.length, output, 0);
            length += cipher.doFinal(output, length);
            
            byte[] result = new byte[length];
            System.arraycopy(output, 0, result, 0, length);
            
            String encrypted = Base64.getEncoder().encodeToString(result);
            System.out.println("加密成功，原文长度: " + plainText.length() + ", 密文长度: " + encrypted.length());
            
            return encrypted;
            
        } catch (Exception e) {
            System.err.println("SM4加密失败，输入: " + plainText + ", 错误: " + e.getMessage());
            e.printStackTrace();
            return "";
        }
    }
    
    /**
     * SM4解密敏感数据
     */
    public static String decryptSM4(String cipherText) {
        if (cipherText == null || cipherText.trim().isEmpty()) {
            return "";
        }
        
        try {
            SM4Engine engine = new SM4Engine();
            PaddedBufferedBlockCipher cipher = new PaddedBufferedBlockCipher(new CBCBlockCipher(engine));
            
            byte[] keyBytes = Hex.decode(SM4_KEY);
            byte[] ivBytes = Hex.decode(SM4_IV);
            
            KeyParameter keyParam = new KeyParameter(keyBytes);
            ParametersWithIV params = new ParametersWithIV(keyParam, ivBytes);
            
            cipher.init(false, params);
            
            byte[] input = Base64.getDecoder().decode(cipherText);
            byte[] output = new byte[cipher.getOutputSize(input.length)];
            
            int length = cipher.processBytes(input, 0, input.length, output, 0);
            length += cipher.doFinal(output, length);
            
            return new String(output, 0, length, "UTF-8");
            
        } catch (Exception e) {
            System.err.println("SM4解密失败，输入: " + cipherText + ", 错误: " + e.getMessage());
            e.printStackTrace();
            return "";
        }
    }
    
    /**
     * 生成安全通行码
     */
    public static String generatePassCode(String name, String idCard, long timestamp) {
        try {
            String data = name + "|" + idCard + "|" + timestamp;
            String hash = SM3Util.hash(data);
            return hash.substring(0, 16).toUpperCase();
        } catch (Exception e) {
            System.err.println("生成通行码失败，使用备用方案: " + e.getMessage());
            return String.format("%08d", Math.abs((name + idCard + timestamp).hashCode()) % 100000000);
        }
    }
    
    /**
     * 生成数据完整性校验值
     */
    public static String generateDataIntegrity(String... fields) {
        try {
            StringBuilder data = new StringBuilder();
            for (String field : fields) {
                data.append(field != null ? field : "NULL").append("|");
            }
            return SM3Util.hash(data.toString());
        } catch (Exception e) {
            System.err.println("生成数据完整性校验失败: " + e.getMessage());
            return "";
        }
    }
    
    /**
     * 姓名脱敏
     */
    public static String maskName(String name) {
        if (name == null || name.length() <= 1) return name;
        if (name.length() == 2) return name.charAt(0) + "*";
        return name.charAt(0) + "*".repeat(name.length() - 2) + name.charAt(name.length() - 1);
    }
    
    /**
     * 身份证号脱敏
     */
    public static String maskIdCard(String idCard) {
        if (idCard == null || idCard.length() < 8) return idCard;
        return idCard.substring(0, 6) + "********" + idCard.substring(idCard.length() - 4);
    }
    
    /**
     * 手机号脱敏
     */
    public static String maskPhone(String phone) {
        if (phone == null || phone.length() < 7) return phone;
        return phone.substring(0, 3) + "****" + phone.substring(phone.length() - 4);
    }
    
    /**
     * ✅ 新增：身份证号格式验证
     */
    public static boolean isValidIdCard(String idCard) {
        if (idCard == null) {
            System.out.println("身份证验证：输入为null");
            return false;
        }
        
        // 去除空格
        idCard = idCard.trim();
        
        if (idCard.length() != 18) {
            System.out.println("身份证验证：长度不正确，当前长度: " + idCard.length());
            return false;
        }
        
        // 检查前17位是否为数字，最后一位是否为数字或X
        for (int i = 0; i < 17; i++) {
            if (!Character.isDigit(idCard.charAt(i))) {
                System.out.println("身份证验证：第" + (i+1) + "位不是数字");
                return false;
            }
        }
        
        char lastChar = idCard.charAt(17);
        if (!Character.isDigit(lastChar) && lastChar != 'X' && lastChar != 'x') {
            System.out.println("身份证验证：最后一位格式错误");
            return false;
        }
        
        System.out.println("身份证验证：格式正确");
        return true;
    }
    
    /**
     * ✅ 新增：手机号格式验证
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null) {
            System.out.println("手机号验证：输入为null");
            return false;
        }
        
        phone = phone.trim();
        
        if (phone.length() != 11) {
            System.out.println("手机号验证：长度不正确，当前长度: " + phone.length());
            return false;
        }
        
        if (!phone.startsWith("1")) {
            System.out.println("手机号验证：不以1开头");
            return false;
        }
        
        for (char c : phone.toCharArray()) {
            if (!Character.isDigit(c)) {
                System.out.println("手机号验证：包含非数字字符");
                return false;
            }
        }
        
        System.out.println("手机号验证：格式正确");
        return true;
    }
    
    /**
     * 测试加密解密功能
     */
    public static boolean testCrypto() {
        try {
            String original = "测试数据123";
            System.out.println("=== 开始加密测试 ===");
            
            String encrypted = encryptSM4(original);
            System.out.println("加密结果: " + encrypted);
            
            if (encrypted.isEmpty()) {
                System.out.println("加密失败，返回空字符串");
                return false;
            }
            
            String decrypted = decryptSM4(encrypted);
            System.out.println("解密结果: " + decrypted);
            
            boolean success = original.equals(decrypted);
            System.out.println("测试结果: " + (success ? "成功" : "失败"));
            
            return success;
            
        } catch (Exception e) {
            System.err.println("加密测试失败: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}