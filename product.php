<?php
require_once 'config.php';

$id = $_GET['id'] ?? 0;

$stmt = $pdo->prepare("SELECT p.*, c.name as category_name FROM products p LEFT JOIN categories c ON p.category_id = c.id WHERE p.id = ?");
$stmt->execute([$id]);
$product = $stmt->fetch();

if (!$product) {
    redirect('index.php');
}

include 'header.php';
?>

<title><?php echo htmlspecialchars($product['name']); ?> - <?php echo SITE_NAME; ?></title>

<section class="products-section">
    <div class="container">
        <div class="product-detail-grid">
            <div>
                <div class="product-image" style="height: 400px;">
                    <img src="<?php echo htmlspecialchars($product['image']); ?>" 
                         alt="<?php echo htmlspecialchars($product['name']); ?>">
                </div>
            </div>
            
            <div>
                <p class="product-category"><?php echo htmlspecialchars($product['category_name']); ?></p>
                <h1 style="font-size: 2rem; margin: 0.5rem 0;"><?php echo htmlspecialchars($product['name']); ?></h1>
                <p class="product-price" style="font-size: 2rem; margin: 1rem 0;"><?php echo formatPrice($product['price']); ?></p>
                
                <p style="margin: 1.5rem 0; line-height: 1.8;"><?php echo nl2br(htmlspecialchars($product['description'])); ?></p>
                
                <p style="margin: 1rem 0;">
                    <strong>Estoque:</strong> <?php echo $product['stock_quantity']; ?> unidades
                </p>
                
                <?php if (isLoggedIn()): ?>
                    <?php if ($product['stock_quantity'] > 0): ?>
                        <form method="POST" action="add_to_cart.php" style="margin-top: 2rem;">
                            <input type="hidden" name="product_id" value="<?php echo $product['id']; ?>">
                            <div class="form-group">
                                <label>Quantidade</label>
                                <input type="number" name="quantity" value="1" min="1" max="<?php echo $product['stock_quantity']; ?>" style="width: 100px;">
                            </div>
                            <button type="submit" class="btn btn-primary">Adicionar ao Carrinho</button>
                        </form>
                    <?php else: ?>
                        <p style="color: #dc3545; font-weight: bold;">Produto fora de estoque</p>
                    <?php endif; ?>
                <?php else: ?>
                    <p><a href="login.php">Faça login</a> para comprar este produto.</p>
                <?php endif; ?>
            </div>
        </div>
    </div>
</section>

<?php include 'footer.php'; ?>
