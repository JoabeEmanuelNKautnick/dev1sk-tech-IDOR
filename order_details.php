<?php
require_once 'config.php';

if (!isLoggedIn()) {
    redirect('login.php');
}

$orderId = $_GET['id'] ?? 0;

// Get order details - IDOR VULNERABILITY: Not checking if user owns this order!
$stmt = $pdo->prepare("
    SELECT o.*, u.name as user_name, u.email, u.phone, u.address
    FROM orders o
    JOIN users u ON o.user_id = u.id
    WHERE o.id = ?
");
$stmt->execute([$orderId]);
$order = $stmt->fetch();

if (!$order) {
    setFlash('Pedido não encontrado', 'error');
    redirect('orders.php');
}

// Get order items
$stmt = $pdo->prepare("
    SELECT oi.*, p.name, p.image
    FROM order_items oi
    JOIN products p ON oi.product_id = p.id
    WHERE oi.order_id = ?
");
$stmt->execute([$orderId]);
$items = $stmt->fetchAll();

include 'header.php';
?>

<title>Pedido #<?php echo $order['id']; ?> - <?php echo SITE_NAME; ?></title>

<section class="products-section">
    <div class="container">
        <h2 class="section-title">Detalhes do Pedido #<?php echo $order['id']; ?></h2>
        
        <div style="max-width: 800px; margin: 0 auto;">
            <div style="background: var(--gray-light); padding: 1.5rem; border-radius: 8px; margin-bottom: 2rem;">
                <h3>Informações do Pedido</h3>
                <p><strong>Data:</strong> <?php echo date('d/m/Y H:i', strtotime($order['created_at'])); ?></p>
                <p><strong>Status:</strong> 
                    <?php
                    $statusLabels = [
                        'pending' => 'Pendente',
                        'processing' => 'Processando',
                        'shipped' => 'Enviado',
                        'delivered' => 'Entregue',
                        'cancelled' => 'Cancelado'
                    ];
                    echo $statusLabels[$order['status']] ?? $order['status'];
                    ?>
                </p>
                <p><strong>Forma de Pagamento:</strong> 
                    <?php
                    $paymentLabels = [
                        'credit_card' => 'Cartão de Crédito',
                        'debit_card' => 'Cartão de Débito',
                        'pix' => 'PIX',
                        'boleto' => 'Boleto'
                    ];
                    echo $paymentLabels[$order['payment_method']] ?? $order['payment_method'];
                    ?>
                </p>
            </div>
            
            <div style="background: var(--gray-light); padding: 1.5rem; border-radius: 8px; margin-bottom: 2rem;">
                <h3>Dados do Cliente</h3>
                <p><strong>Nome:</strong> <?php echo htmlspecialchars($order['user_name']); ?></p>
                <p><strong>Email:</strong> <?php echo htmlspecialchars($order['email']); ?></p>
                <p><strong>Telefone:</strong> <?php echo htmlspecialchars($order['phone']); ?></p>
                <p><strong>Endereço:</strong> <?php echo htmlspecialchars($order['address']); ?></p>
            </div>
            
            <h3>Itens do Pedido</h3>
            <div class="cart-items">
                <?php foreach ($items as $item): ?>
                    <div class="cart-item">
                        <img src="<?php echo htmlspecialchars($item['image']); ?>" 
                             alt="<?php echo htmlspecialchars($item['name']); ?>">
                        
                        <div class="cart-item-info">
                            <h4><?php echo htmlspecialchars($item['name']); ?></h4>
                            <p><?php echo formatPrice($item['price']); ?> x <?php echo $item['quantity']; ?></p>
                            <p><strong>Subtotal: <?php echo formatPrice($item['price'] * $item['quantity']); ?></strong></p>
                        </div>
                    </div>
                <?php endforeach; ?>
            </div>
            
            <div class="cart-total">
                Total: <?php echo formatPrice($order['total_amount']); ?>
            </div>
            
            <div style="text-align: center; margin-top: 2rem;">
                <a href="orders.php" class="btn btn-primary">Voltar aos Meus Pedidos</a>
            </div>
        </div>
    </div>
</section>

<?php include 'footer.php'; ?>
