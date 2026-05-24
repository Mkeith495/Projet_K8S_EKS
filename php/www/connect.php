<?php
$driver = getenv('DB_DRIVER') ?: 'mysql';
$host = getenv('DB_HOST') ?: 'db';
$dbname = getenv('DB_NAME') ?: 'gestion_produits';
$username = getenv('DB_USER') ?: 'root';
$password = getenv('DB_PASSWORD') ?: 'root';

if ($driver === 'pgsql' || $driver === 'postgres' || $driver === 'postgresql') {
    $dsn = "pgsql:host=$host;dbname=$dbname";
} else {
    $dsn = "mysql:host=$host;dbname=$dbname;charset=utf8mb4";
}

$db = new PDO($dsn, $username, $password);
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$db->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
?>
