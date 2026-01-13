<?php
require_once 'config.php';

$categoryId = $_GET['cat'] ?? null;
$search = $_GET['q'] ?? '';

$sql = "SELECT p.*, c.name as category_name FROM products p LEFT JOIN categories c ON p.category_id = c.id WHERE 1=1";
$params = [];

if ($categoryId) {
    $sql .= " AND p.category_id = ?";
    $params[] = $categoryId;
}

if ($search) {
    $sql .= " AND (p.name LIKE ? OR p.description LIKE ?)";
    $params[] = "%$search%";
    $params[] = "%$search%";
}

$sql .= " ORDER BY p.id DESC";

$stmt = $pdo->prepare($sql);
$stmt->execute($params);
$products = $stmt->fetchAll();

include 'header.php';
?>

<title>Catálogo - <?php echo SITE_NAME; ?></title>

<section class="products-section">
    <div class="container">
        <h2 class="section-title">Catálogo de Produtos</h2>
        
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
