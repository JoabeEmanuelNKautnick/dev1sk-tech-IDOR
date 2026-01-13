<?php
require_once 'config.php';

echo "<h1>Teste de Imagens - Dev1sk TECH</h1>";
echo "<p>Verificando imagens do banco de dados:</p>";

$products = $pdo->query("SELECT id, name, image FROM products LIMIT 5")->fetchAll();

foreach ($products as $p) {
    echo "<div style='border: 1px solid #ccc; margin: 10px; padding: 10px;'>";
    echo "<h3>" . htmlspecialchars($p['name']) . "</h3>";
    echo "<p><strong>URL da imagem:</strong> " . htmlspecialchars($p['image']) . "</p>";
    echo "<img src='" . htmlspecialchars($p['image']) . "' style='max-width: 300px; border: 1px solid red;' onerror='this.style.border=\"3px solid red\"; this.alt=\"ERRO AO CARREGAR\"'>";
    echo "</div>";
}
?>
