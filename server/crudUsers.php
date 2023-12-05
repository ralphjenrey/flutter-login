<?php

// Include the database connection file
require 'db_conn.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");

// Check if the required data is sent
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $userId = isset($_POST['id']) ? intval($_POST['id']) : 0;
    $newUsername = isset($_POST['username']) ? $_POST['username'] : '';
    $newEmail = isset($_POST['email']) ? $_POST['email'] : '';

    // Validate the input
    if ($userId > 0 && !empty($newUsername) && !empty($newEmail)) {
        try {
            // Prepare and execute the SQL query to update the user data
            $stmt = $pdo->prepare("UPDATE users SET username = :username, email = :email WHERE id = :id");
            $stmt->bindParam(':id', $userId);
            $stmt->bindParam(':username', $newUsername);
            $stmt->bindParam(':email', $newEmail);
            $stmt->execute();

            // Check the number of affected rows to confirm the update
            $rowCount = $stmt->rowCount();
            if ($rowCount > 0) {
                // Update successful
                echo json_encode(['status' => 'success', 'message' => 'User data updated successfully']);
            } else {
                // No rows were updated, likely the user ID was not found
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
