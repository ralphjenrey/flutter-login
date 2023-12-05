<?php

// Include the database connection file
require 'db_conn.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");

// Check if the required data is sent
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = isset($_POST['username']) ? $_POST['username'] : '';
    $currentPassword = isset($_POST['currentPassword']) ? $_POST['currentPassword'] : '';
    $newPassword = isset($_POST['newPassword']) ? $_POST['newPassword'] : '';
    $confirmPassword = isset($_POST['confirmPassword']) ? $_POST['confirmPassword'] : '';

    // Validate the input
    if (!empty($username) && !empty($currentPassword) && !empty($newPassword)) {
        try {
            // Prepare and execute the SQL query to fetch the user's current password
            $stmt = $pdo->prepare("SELECT * FROM users WHERE username = :username");
            $stmt->bindParam(':username', $username);
            $stmt->execute();

            // Fetch the user data
            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($user && $currentPassword === $user['password']) {
                if($confirmPassword !== $newPassword){
                    echo json_encode(['status' => 'error', 'message' => 'Password do not match']);
                }else{
                                    // Current password is correct, update the password
                $updateStmt = $pdo->prepare("UPDATE users SET password = :newPassword WHERE username = :username");
                $updateStmt->bindParam(':newPassword', $newPassword);
                $updateStmt->bindParam(':username', $username);
                $updateStmt->execute();

                echo json_encode(['status' => 'success', 'message' => 'Password updated successfully']);
                }

            } else {
                // Incorrect current password
                echo json_encode(['status' => 'error', 'message' => 'Incorrect current password']);
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
