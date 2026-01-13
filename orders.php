<?php
require_once 'config.php';

if (!isLoggedIn()) {
    redirect('login.php');
}

$userId = getUserId();

$stmt = $pdo->prepare("
    SELECT o.*, 
           (SELECT COUNT(*) FROM order_items WHERE order_id = o.id) as items_count
    FROM orders o
    WHERE o.user_id = ?
    ORDER BY o.created_at DESC
");
$stmt->execute([$userId]);
$orders = $stmt->fetchAll();

include 'header.php';
?>

<title>Meus Pedidos - <?php echo SITE_NAME; ?></title>

<section class="products-section">
    <div class="container">
        <h2 class="section-title">Meus Pedidos</h2>
        
        <?php if (empty($orders)): ?>
            <p>Você ainda não fez nenhum pedido. <a href="catalog.php">Comece a comprar!</a></p>
        <?php else: ?>
            <table style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr style="background: var(--gray-light); text-align: left;">
                        <th style="padding: 1rem;">Pedido #</th>
                        <th style="padding: 1rem;">Data</th>
                        <th style="padding: 1rem;">Total</th>
                        <th style="padding: 1rem;">Status</th>
                        <th style="padding: 1rem;">Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($orders as $order): ?>
                        <tr style="border-bottom: 1px solid var(--border);">
                            <td style="padding: 1rem;">#<?php echo $order['id']; ?></td>
                            <td style="padding: 1rem;"><?php echo date('d/m/Y H:i', strtotime($order['created_at'])); ?></td>
                            <td style="padding: 1rem;"><?php echo formatPrice($order['total_amount']); ?></td>
                            <td style="padding: 1rem;">
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
                            </td>
                            <td style="padding: 1rem;">
                                <a href="order_details.php?id=<?php echo $order['id']; ?>" class="btn btn-primary">Ver Detalhes</a>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        <?php endif; ?>
    </div>
</section>

<?php include 'footer.php'; ?>
