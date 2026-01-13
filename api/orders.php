<?php
require_once '../config.php';

header('Content-Type: application/json');

// IDOR VULNERABILITY: API endpoint that doesn't validate user ownership
// Example: /api/orders.php?id=123 will show order details for ANY order ID

$orderId = $_GET['id'] ?? 0;

if (!$orderId) {
    echo json_encode(['success' => false, 'message' => 'ID do pedido não fornecido']);
    exit;
}

// VULNERABILITY: No authentication check, no ownership validation
// Any user (even not logged in) can access any order by changing the ID

$stmt = $pdo->prepare("
    SELECT o.*, 
           u.full_name as customer_name, 
           u.email as customer_email,
           u.cpf as customer_cpf,
           u.phone as customer_phone,
           u.address as customer_address
    FROM orders o
    JOIN users u ON o.user_id = u.id
    WHERE o.id = ?
");

$stmt->execute([$orderId]);
$order = $stmt->fetch();

if (!$order) {
    echo json_encode(['success' => false, 'message' => 'Pedido não encontrado']);
    exit;
}

// Get order items separately
$itemsStmt = $pdo->prepare("
    SELECT p.name as product_name, 
           oi.quantity, 
           oi.price,
           (oi.quantity * oi.price) as subtotal
    FROM order_items oi
    JOIN products p ON oi.product_id = p.id
    WHERE oi.order_id = ?
");
$itemsStmt->execute([$orderId]);
$order['items'] = $itemsStmt->fetchAll();

echo json_encode([
    'success' => true,
    'order' => $order
]);
