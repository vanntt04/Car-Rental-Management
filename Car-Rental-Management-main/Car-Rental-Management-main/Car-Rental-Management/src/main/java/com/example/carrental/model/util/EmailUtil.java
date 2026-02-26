package com.example.carrental.model.util;

import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

/**
 * Tiện ích gửi email xác thực đăng ký tài khoản.
 */
public class EmailUtil {

    private static Session mailSession;
    private static String fromAddress;

    static {
        try {
            Properties props = new Properties();
            InputStream input = EmailUtil.class.getClassLoader().getResourceAsStream("mail.properties");

            if (input != null) {
                props.load(input);
                input.close();
            } else {
                throw new RuntimeException("mail.properties not found in classpath");
            }

            String username = props.getProperty("mail.username");
            String password = props.getProperty("mail.password");
            fromAddress = username;

            // Ghi đè bằng biến môi trường nếu có (an toàn hơn)
            String envUser = System.getenv("MAIL_USERNAME");
            String envPass = System.getenv("MAIL_PASSWORD");
            if (envUser != null && !envUser.isEmpty()) {
                username = envUser;
                fromAddress = envUser;
            }
            if (envPass != null && !envPass.isEmpty()) {
                password = envPass;
            }

            final String finalUsername = username;
            final String finalPassword = password;

            mailSession = Session.getInstance(props, new jakarta.mail.Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(finalUsername, finalPassword);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Cannot initialize EmailUtil: " + e.getMessage(), e);
        }
    }

    /**
     * Gửi email xác nhận đăng ký.
     */
    public static void sendVerificationEmail(String toEmail, String fullName, String verifyLink) throws MessagingException, UnsupportedEncodingException {
        MimeMessage message = new MimeMessage(mailSession);
        message.setFrom(new InternetAddress(fromAddress, "Car Rental", StandardCharsets.UTF_8.name()));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("Xác nhận đăng ký tài khoản Car Rental", StandardCharsets.UTF_8.name());

        String html = "<!DOCTYPE html>" +
                "<html lang='vi'><head><meta charset='UTF-8'></head><body>" +
                "<p>Xin chào <strong>" + escape(fullName) + "</strong>,</p>" +
                "<p>Cảm ơn bạn đã đăng ký tài khoản tại hệ thống Car Rental.</p>" +
                "<p>Vui lòng nhấn vào nút bên dưới để <strong>kích hoạt tài khoản</strong>:</p>" +
                "<p style='margin:24px 0;'>" +
                "<a href='" + verifyLink + "' " +
                "style='display:inline-block;padding:10px 18px;background:#22c55e;color:white;" +
                "text-decoration:none;border-radius:999px;font-weight:600;'>" +
                "Kích hoạt tài khoản</a></p>" +
                "<p>Nếu bạn không thực hiện đăng ký, vui lòng bỏ qua email này.</p>" +
                "<p>Trân trọng,<br/>Đội ngũ Car Rental</p>" +
                "</body></html>";

        message.setContent(html, "text/html; charset=UTF-8");

        Transport.send(message);
        System.out.println("Verification email sent to " + toEmail);
    }

    private static String escape(String input) {
        if (input == null) return "";
        return input.replace("<", "&lt;").replace(">", "&gt;");
    }
}

