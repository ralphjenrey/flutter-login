<?php

// Include the database connection file
require 'db_conn.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");

// Check if the required data is sent
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $userId = isset($_POST['id']) ? intval($_POST['id']) : 0;

    // Validate the input
    if ($userId > 0) {
        try {
            // Prepare and execute the SQL query to delete the user
            $stmt = $pdo->prepare("DELETE FROM users WHERE id = :id");
            $stmt->bindParam(':id', $userId);
            $stmt->execute();

            // Check the number of affected rows to confirm the deletion
            $rowCount = $stmt->rowCount();
            if ($rowCount > 0) {
                // Deletion successful
                echo json_encode(['status' => 'success', 'message' => 'User deleted successfully']);
            } else {
                // No rows were deleted, likely the user ID was not found
                echo json_encode(['status' => 'error', 'message' => 'User not found']);
            }

        } catch (PDOException $e) {
            // Handle database errors
            echo json_encode(['status' => 'error', 'message' => 'Database error']);
        }
    } else {
        // Invalid input
        echo json_encode(['status' => 'error', 'message' => 'Invalid input']);
    }
} else {
    // Invalid request method
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}

?>
