<?php
    include '../db.php'; // include your database connection

    // Check if category ID is provided via GET
    if (isset($_GET['id'])) {
        $category_id = $_GET['id'];

        // Delete query to remove the category
        $sql = "DELETE FROM theloai WHERE ma_tloai = $category_id";

        // Execute the delete query
        if (mysqli_query($conn, $sql)) {
            echo "Xóa thể loại thành công.";
            header("Location: category.php"); // Redirect back to the category listing
            exit();
        } else {
            echo "Xóa thể loại thất bại." . mysqli_error($conn);
        }
    } 
    // Close the connection
    mysqli_close($conn);
?>