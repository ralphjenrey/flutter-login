<?php

// Include the database connection file
require 'db_conn.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header('Content-Type: application/json');

try {
    // Prepare and execute the SQL query to fetch users
    $stmt = $pdo->query("SELECT * FROM users");
    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Output the result as JSON
    echo json_encode($users);

} catch (PDOException $e) {
    // Handle database errors
    echo json_encode(['error' => 'Database error']);
}

?>
