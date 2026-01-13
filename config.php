<?php
// Dev1sk TECH - Configuration
session_start();

// Database Configuration
define('DB_HOST', 'localhost');
define('DB_NAME', 'dev1sk_tech');
define('DB_USER', 'root');
define('DB_PASS', '');

// Site Configuration
define('SITE_NAME', 'Dev1sk TECH');
define('SITE_URL', 'http://localhost/dev1sk-tech/');

// Paths
define('LOGO_ICON', 'logo.png');
define('LOGO_FULL', 'logonome.png');

// Database Connection
try {
    $pdo = new PDO(
        "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=utf8mb4",
        DB_USER,
        DB_PASS,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false
        ]
    );
    $pdo->exec("SET NAMES utf8mb4");
} catch (PDOException $e) {
    die("Erro de conexão: " . $e->getMessage());
}

// Helper Functions
function isLoggedIn() {
    return isset($_SESSION['user_id']);
}

function getUserId() {
    return $_SESSION['user_id'] ?? null;
}

function getUsername() {
    return $_SESSION['username'] ?? '';
}

function redirect($url) {
    header("Location: " . SITE_URL . $url);
    exit;
}

function formatPrice($price) {
    return 'R$ ' . number_format($price, 2, ',', '.');
}

function setFlash($message, $type = 'success') {
    $_SESSION['flash'] = ['message' => $message, 'type' => $type];
}

function getFlash() {
    if (isset($_SESSION['flash'])) {
        $flash = $_SESSION['flash'];
        unset($_SESSION['flash']);
        return $flash;
    }
    return null;
}
