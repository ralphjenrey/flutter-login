<?php

// Database connection parameters
$host = 'localhost';
$db_name = 'flutter_login';
$username = 'root';
$password = '';

// PDO connection string
$dsn = "mysql:host=$host;dbname=$db_name;charset=utf8mb4";

try {
    // Create a PDO instance
    $pdo = new PDO($dsn, $username, $password);

    // Set PDO attributes
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

    // Optionally, you can set other attributes or perform additional setup here if needed.

} catch (PDOException $e) {
    // Handle connection errors
    die("Connection failed: " . $e->getMessage());
}

?>
