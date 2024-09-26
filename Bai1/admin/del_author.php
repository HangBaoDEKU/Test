<?php
    include '../db.php'; // include your database connection

    // Check if category ID is provided via GET
    if (isset($_GET['id'])) {
        $author_id = $_GET['id'];

        // Delete query to remove the category
        $sql = "DELETE FROM tacgia WHERE ma_tgia = $author_id";

        // Execute the delete query
        if (mysqli_query($conn, $sql)) {
            echo "Xóa tác giả thành công.";
            header("Location: author.php"); // Redirect back to the category listing
            exit();
        } else {
            echo "Xóa tác giả thất bại " . mysqli_error($conn);
        }
    } 

    // Close the connection
    mysqli_close($conn);
?>