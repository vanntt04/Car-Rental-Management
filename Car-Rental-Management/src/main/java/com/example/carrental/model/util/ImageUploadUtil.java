package com.example.carrental.model.util;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

/**
 * Tiện ích lưu ảnh upload từ máy lên thư mục uploads.
 * Trả về đường dẫn tương đối để lưu DB và hiển thị: /uploads/cars/xxx.jpg
 */
public final class ImageUploadUtil {

    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList("jpg", "jpeg", "png", "gif", "webp");
    private static final String SUB_DIR = "cars";
    private static final long MAX_SIZE_BYTES = 5 * 1024 * 1024; // 5MB

    /**
     * Lưu Part (file ảnh) vào thư mục uploads/cars.
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
            Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
        }
        return "/uploads/" + SUB_DIR + "/" + safeName;
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
