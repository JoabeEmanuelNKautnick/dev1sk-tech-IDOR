<?php
require_once 'config.php';

if (!isLoggedIn()) {
    redirect('login.php');
}

$userId = getUserId();

// Get cart items
$stmt = $pdo->prepare("
    SELECT c.*, p.name, p.price, p.stock_quantity,
           (c.quantity * p.price) as subtotal
    FROM cart c
    JOIN products p ON c.product_id = p.id
    WHERE c.user_id = ?
");
$stmt->execute([$userId]);
$items = $stmt->fetchAll();

if (empty($items)) {
    redirect('cart.php');
}

$total = array_sum(array_column($items, 'subtotal'));

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $paymentMethod = $_POST['payment_method'] ?? 'credit_card';
    
    $pdo->beginTransaction();
    
    try {
        // Create order
        $stmt = $pdo->prepare("INSERT INTO orders (user_id, total_amount, status, payment_method) VALUES (?, ?, 'pending', ?)");
        $stmt->execute([$userId, $total, $paymentMethod]);
        $orderId = $pdo->lastInsertId();
        
        // Create order items
        foreach ($items as $item) {
            $stmt = $pdo->prepare("INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)");
            $stmt->execute([$orderId, $item['product_id'], $item['quantity'], $item['price']]);
            
            // Update stock
            $stmt = $pdo->prepare("UPDATE products SET stock_quantity = stock_quantity - ? WHERE id = ?");
            $stmt->execute([$item['quantity'], $item['product_id']]);
        }
        
        // Clear cart
        $stmt = $pdo->prepare("DELETE FROM cart WHERE user_id = ?");
        $stmt->execute([$userId]);
        
        $pdo->commit();
        
        setFlash('Pedido realizado com sucesso! Número do pedido: ' . $orderId);
        redirect('orders.php');
        
    } catch (Exception $e) {
        $pdo->rollBack();
        setFlash('Erro ao processar pedido', 'error');
    }
}

include 'header.php';
?>

<title>Finalizar Pedido - <?php echo SITE_NAME; ?></title>

<section class="products-section">
    <div class="container">
        <h2 class="section-title">Finalizar Pedido</h2>
        
        <div style="max-width: 600px; margin: 0 auto;">
            <h3>Resumo do Pedido</h3>
            <div class="cart-items">
                <?php foreach ($items as $item): ?>
                    <div class="cart-item">
                        <div class="cart-item-info">
                            <h4><?php echo htmlspecialchars($item['name']); ?></h4>
                            <p><?php echo formatPrice($item['price']); ?> x <?php echo $item['quantity']; ?> = <?php echo formatPrice($item['subtotal']); ?></p>
                        </div>
                    </div>
                <?php endforeach; ?>
            </div>
            
            <div class="cart-total">
                Total: <?php echo formatPrice($total); ?>
            </div>
            
            <form method="POST" style="margin-top: 2rem;">
                <div class="form-group">
                    <label>Forma de Pagamento</label>
                    <select name="payment_method" required>
                        <option value="credit_card">Cartão de Crédito</option>
                        <option value="debit_card">Cartão de Débito</option>
                        <option value="pix">PIX</option>
                        <option value="boleto">Boleto</option>
                    </select>
                </div>
                
                <button type="submit" class="btn btn-primary" style="width: 100%;">Confirmar Pedido</button>
            </form>
        </div>
    </div>
</section>

<?php include 'footer.php'; ?>
