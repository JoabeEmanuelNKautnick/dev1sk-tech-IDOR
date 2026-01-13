<?php
require_once 'config.php';

if (!isLoggedIn()) {
    redirect('login.php');
}

$userId = getUserId();

// Handle cart actions
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';
    $cartId = $_POST['cart_id'] ?? 0;
    
    if ($action === 'remove') {
        $stmt = $pdo->prepare("DELETE FROM cart WHERE id = ? AND user_id = ?");
        $stmt->execute([$cartId, $userId]);
        setFlash('Item removido do carrinho');
    } elseif ($action === 'update') {
        $quantity = $_POST['quantity'] ?? 1;
        $stmt = $pdo->prepare("UPDATE cart SET quantity = ? WHERE id = ? AND user_id = ?");
        $stmt->execute([$quantity, $cartId, $userId]);
        setFlash('Carrinho atualizado');
    }
    redirect('cart.php');
}

// Get cart items
$stmt = $pdo->prepare("
    SELECT c.*, p.name, p.price, p.image, p.stock_quantity,
           (c.quantity * p.price) as subtotal
    FROM cart c
    JOIN products p ON c.product_id = p.id
    WHERE c.user_id = ?
");
$stmt->execute([$userId]);
$items = $stmt->fetchAll();

$total = array_sum(array_column($items, 'subtotal'));

include 'header.php';
?>

<title>Carrinho - <?php echo SITE_NAME; ?></title>

<section class="products-section">
    <div class="container">
        <h2 class="section-title">Meu Carrinho</h2>
        
        <?php if (empty($items)): ?>
            <p>Seu carrinho está vazio. <a href="catalog.php">Continue comprando</a></p>
        <?php else: ?>
            <div class="cart-items">
                <?php foreach ($items as $item): ?>
                    <div class="cart-item">
                        <img src="<?php echo htmlspecialchars($item['image']); ?>" 
                             alt="<?php echo htmlspecialchars($item['name']); ?>">
                        
                        <div class="cart-item-info">
                            <h3><?php echo htmlspecialchars($item['name']); ?></h3>
                            <p><?php echo formatPrice($item['price']); ?> x <?php echo $item['quantity']; ?></p>
                            <p><strong><?php echo formatPrice($item['subtotal']); ?></strong></p>
                        </div>
                        
                        <div>
                            <form method="POST" style="display: inline;">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="cart_id" value="<?php echo $item['id']; ?>">
                                <input type="number" name="quantity" value="<?php echo $item['quantity']; ?>" min="1" max="<?php echo $item['stock_quantity']; ?>" style="width: 60px;">
                                <button type="submit" class="btn btn-primary">Atualizar</button>
                            </form>
                            
                            <form method="POST" style="display: inline;">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="cart_id" value="<?php echo $item['id']; ?>">
                                <button type="submit" class="btn btn-outline" style="background: #dc3545; border-color: #dc3545; color: white;">Remover</button>
                            </form>
                        </div>
                    </div>
                <?php endforeach; ?>
            </div>
            
            <div class="cart-total">
                Total: <?php echo formatPrice($total); ?>
            </div>
            
            <div style="text-align: right;">
                <a href="catalog.php" class="btn btn-outline">Continuar Comprando</a>
                <a href="checkout.php" class="btn btn-primary">Finalizar Pedido</a>
            </div>
        <?php endif; ?>
    </div>
</section>

<?php include 'footer.php'; ?>
