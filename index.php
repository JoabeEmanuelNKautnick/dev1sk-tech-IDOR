<?php
require_once 'config.php';

// Get search query
$search = $_GET['q'] ?? '';
$products = [];

if ($search) {
    $stmt = $pdo->prepare("
        SELECT p.*, c.name as category_name 
        FROM products p 
        LEFT JOIN categories c ON p.category_id = c.id 
        WHERE p.name LIKE ? OR p.description LIKE ?
        LIMIT 20
    ");
    $stmt->execute(["%$search%", "%$search%"]);
    $products = $stmt->fetchAll();
} else {
    // Get featured products
    $products = $pdo->query("
        SELECT p.*, c.name as category_name 
        FROM products p 
        LEFT JOIN categories c ON p.category_id = c.id 
        ORDER BY p.id DESC 
        LIMIT 12
    ")->fetchAll();
}

include 'header.php';
?>

<title><?php echo SITE_NAME; ?> - Loja de Informática</title>

<?php if (!$search): ?>
<section class="hero">
    <div class="container">
        <h1>Bem-vindo à <?php echo SITE_NAME; ?></h1>
        <p>Os melhores produtos de informática para você</p>
        <a href="catalog.php" class="btn btn-primary">Ver Catálogo Completo</a>
    </div>
</section>
<?php endif; ?>

<section class="products-section">
    <div class="container">
        <h2 class="section-title"><?php echo $search ? 'Resultados para: "' . htmlspecialchars($search) . '"' : 'Produtos em Destaque'; ?></h2>
        
        <?php if (empty($products)): ?>
            <p>Nenhum produto encontrado.</p>
        <?php else: ?>
            <div class="products-grid">
                <?php foreach ($products as $p): ?>
                    <div class="product-card">
                        <div class="product-image">
                            <img src="<?php echo htmlspecialchars($p['image']); ?>" 
                                 alt="<?php echo htmlspecialchars($p['name']); ?>">
                        </div>
                        <div class="product-info">
                            <p class="product-category"><?php echo htmlspecialchars($p['category_name']); ?></p>
                            <h3><?php echo htmlspecialchars($p['name']); ?></h3>
                            <p class="product-price"><?php echo formatPrice($p['price']); ?></p>
                            <a href="product.php?id=<?php echo $p['id']; ?>" class="btn btn-primary">Ver Detalhes</a>
                        </div>
                    </div>
                <?php endforeach; ?>
            </div>
        <?php endif; ?>
    </div>
</section>

<?php include 'footer.php'; ?>
