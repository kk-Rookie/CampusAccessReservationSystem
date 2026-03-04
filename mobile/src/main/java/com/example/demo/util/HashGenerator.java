package com.example.demo.util;

import org.bouncycastle.jce.provider.BouncyCastleProvider;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.Security;

/**
 * 测试生成SM3哈希
 */
public class HashGenerator {
    static {
        Security.addProvider(new BouncyCastleProvider());
    }

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

    public static void main(String[] args) {
        String password = "123456";
        String hashValue = hash(password);
        System.out.println("Password: " + password);
        System.out.println("SM3 Hash: " + hashValue);
        
        // 生成SQL更新语句
        System.out.println();
        System.out.println("SQL UPDATE statement:");
        System.out.println("UPDATE users SET password_hash = '" + hashValue + "' WHERE username IN ('20241001001', '20241001002', '20241001003', '20241001004', '20241001005');");
    }
}
