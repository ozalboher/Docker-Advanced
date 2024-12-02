<?php
try {
    $pdo = new PDO('mysql:host=mysql;dbname=homestead', 'homestead', 'secret');
    echo 'Connection successful!';
} catch (PDOException $e) {
    echo 'Connection failed: ' . $e->getMessage();
}
?>
