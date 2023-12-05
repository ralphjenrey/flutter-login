<?php

// Include the database connection file
require 'db_conn.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");

// Check if the required data is sent
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = isset($_POST['username']) ? $_POST['username'] : '';
    $email = isset($_POST['email']) ? $_POST['email'] : '';
    $password = isset($_POST['password']) ? $_POST['password'] : '';

    // Validate the input
    if (!empty($username) && !empty($email) && !empty($password)) {
        // Check if the email is valid
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            echo json_encode(['status' => 'error', 'message' => 'Invalid email format']);
            exit; // Terminate the script
        }

        // Check if the username or email already exists
        $stmtCheck = $pdo->prepare("SELECT COUNT(*) FROM users WHERE username = :username OR email = :email");
        $stmtCheck->bindParam(':username', $username);
        $stmtCheck->bindParam(':email', $email);
        $stmtCheck->execute();
        $userCount = $stmtCheck->fetchColumn();

        if ($userCount > 0) {
            // Username or email already exists, return an error
            echo json_encode(['status' => 'error', 'message' => 'Username or email already exists']);
        } else {
            // Hash the password (you should use password_hash() in a production environment)
            // For now, we're storing the plain text password for demonstration purposes
            $hashedPassword = $password;

            try {
                // Prepare and execute the SQL query for registration
                $stmt = $pdo->prepare("INSERT INTO users (username, email, password) VALUES (:username, :email, :password)");
                $stmt->bindParam(':username', $username);
                $stmt->bindParam(':email', $email);
                $stmt->bindParam(':password', $hashedPassword); // Use $hashedPassword in a production environment
                $stmt->execute();

                // Registration successful
                echo json_encode(['status' => 'success', 'message' => 'Registration successful']);

            } catch (PDOException $e) {
                // Handle database errors
                echo json_encode(['status' => 'error', 'message' => 'Database error']);
            }
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
