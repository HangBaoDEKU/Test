<?php
include '../db.php';

if (isset($_SERVER['REQUEST_METHOD']) && $_SERVER['REQUEST_METHOD'] === 'POST') {

    $post_id = $_POST['post_id'];

    $stmt = $conn->prepare("DELETE FROM baiviet WHERE id = ?");
    $stmt->bind_param("i", $post_id);

    if ($stmt->execute()) {
        echo "Bài viết đã được xóa!";
        header('Location: index.php');
        exit;
    } else {
        echo "Xóa bài viết thất bại: " . $stmt->error;
    }

    $stmt->close();
    $conn->close();
}
?>