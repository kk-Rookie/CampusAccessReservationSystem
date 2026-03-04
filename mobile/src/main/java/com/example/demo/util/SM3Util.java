package com.example.demo.util;

import org.bouncycastle.jce.provider.BouncyCastleProvider;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.Security;

/**
 * SM3哈希工具类
 */
public class SM3Util {
    static {
        Security.addProvider(new BouncyCastleProvider());
    }

    /**
     * 使用SM3算法对输入字符串进行哈希处理
     */
    public static String hash(String input) {
        if (input == null || input.trim().isEmpty()) {
            return "";
        }

        try {
            MessageDigest digest = MessageDigest.getInstance("SM3", "BC");
            byte[] hashBytes = digest.digest(input.getBytes(StandardCharsets.UTF_8));

            StringBuilder hexString = new StringBuilder();
            for (byte b : hashBytes) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("SM3哈希计算失败", e);
        }
    }
}