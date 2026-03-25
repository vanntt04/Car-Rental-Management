package com.example.carrental.model.util;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

/**
 * Tiện ích lưu ảnh upload từ máy lên thư mục uploads.
 * Ảnh được resize để không vượt quá 500x500 pixels (giữ tỉ lệ).
 * Trả về đường dẫn tương đối: /uploads/cars/xxx.jpg
 */
public final class ImageUploadUtil {

    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList("jpg", "jpeg", "png", "gif", "webp");
    private static final String SUB_DIR = "cars";
    private static final long MAX_SIZE_BYTES = 5 * 1024 * 1024; // 5MB
    private static final int MAX_DIMENSION = 500; // pixels

    /**
     * Lưu Part (file ảnh) vào thư mục uploads/cars.
     * Ảnh được resize nếu kích thước vượt quá 500x500 pixels.
     * @param part Part từ request (name="imageFile")
     * @param servletContext ServletContext để lấy real path
     * @return Đường dẫn tương đối "/uploads/cars/filename" hoặc null nếu lỗi/empty
     */
    public static String saveCarImage(Part part, ServletContext servletContext) throws IOException {
        if (part == null || part.getSize() == 0) return null;

        String submittedFileName = part.getSubmittedFileName();
        if (submittedFileName == null || submittedFileName.isBlank()) return null;

        String ext = getExtension(submittedFileName);
        if (ext == null || !ALLOWED_EXTENSIONS.contains(ext.toLowerCase())) return null;
        if (part.getSize() > MAX_SIZE_BYTES) return null;

        String safeName = UUID.randomUUID().toString().replace("-", "").substring(0, 12) + "." + ext;
        Path uploadDir = getUploadDir(servletContext);
        if (uploadDir == null) return null;

        Files.createDirectories(uploadDir);
        Path target = uploadDir.resolve(safeName);

        try (InputStream in = part.getInputStream()) {
            BufferedImage original = ImageIO.read(in);
            if (original == null) return null;

            int w = original.getWidth();
            int h = original.getHeight();
            if (w <= MAX_DIMENSION && h <= MAX_DIMENSION) {
                ImageIO.write(original, getFormatName(ext), target.toFile());
            } else {
                double scale = Math.min((double) MAX_DIMENSION / w, (double) MAX_DIMENSION / h);
                int newW = (int) Math.round(w * scale);
                int newH = (int) Math.round(h * scale);
                int type = original.getColorModel().hasAlpha() ? BufferedImage.TYPE_INT_ARGB : BufferedImage.TYPE_INT_RGB;
                BufferedImage resized = new BufferedImage(newW, newH, type);
                Graphics2D g = resized.createGraphics();
                g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
                g.drawImage(original, 0, 0, newW, newH, null);
                g.dispose();
                ImageIO.write(resized, getFormatName(ext), target.toFile());
            }
        }
        return "/uploads/" + SUB_DIR + "/" + safeName;
    }

    private static String getFormatName(String ext) {
        if ("jpg".equalsIgnoreCase(ext) || "jpeg".equalsIgnoreCase(ext)) return "jpg";
        return ext.toLowerCase();
    }

    private static String getExtension(String fileName) {
        int i = fileName.lastIndexOf('.');
        return i > 0 ? fileName.substring(i + 1) : null;
    }

    private static Path getUploadDir(ServletContext ctx) {
        String base = ctx.getRealPath("/");
        if (base != null) {
            return Paths.get(base, "uploads", SUB_DIR);
        }
        return Paths.get(System.getProperty("java.io.tmpdir"), "car-rental-uploads", SUB_DIR);
    }
}
