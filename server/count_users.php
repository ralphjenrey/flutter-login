<?php

// Include the database connection file
require 'db_conn.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");

try {
    // Prepare and execute the SQL query to count the number of users
    $stmt = $pdo->prepare("SELECT COUNT(*) as count FROM users");
    $stmt->execute();

    // Fetch the count
    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    // Return the count as JSON response
    echo json_encode(['count' => $result['count']]);
} catch (PDOException $e) {
    // Handle database errors
    echo json_encode(['status' => 'error', 'message' => 'Database error']);
}
?>
