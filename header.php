<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="<?php echo LOGO_ICON; ?>">
    <link rel="stylesheet" href="style.css">
</head>
<body>
<header>
    <div class="container">
        <div class="header-content">
            <div class="logo">
                <a href="index.php">
                    <img src="<?php echo LOGO_FULL; ?>" alt="<?php echo SITE_NAME; ?>">
                </a>
            </div>
            
            <div class="search-box">
                <form method="GET" action="index.php">
                    <input type="text" name="q" placeholder="Buscar produtos..." value="<?php echo htmlspecialchars($_GET['q'] ?? ''); ?>">
                    <button type="submit">Buscar</button>
                </form>
            </div>
            
            <div class="header-actions">
                <?php if (isLoggedIn()): ?>
                    <span>Olá, <?php echo htmlspecialchars(getUsername()); ?></span>
                    <a href="cart.php" class="cart-icon">
                        🛒
                        <span class="cart-count" id="cartCount">0</span>
                    </a>
                    <a href="logout.php" class="btn btn-outline">Sair</a>
                <?php else: ?>
                    <a href="login.php" class="btn btn-outline">Entrar</a>
                    <a href="register.php" class="btn btn-primary">Cadastrar</a>
                <?php endif; ?>
            </div>
        </div>
    </div>
</header>

<nav>
    <div class="container">
        <ul>
            <li><a href="index.php">Início</a></li>
            <li><a href="catalog.php">Catálogo</a></li>
            <?php
            $categories = $pdo->query("SELECT * FROM categories ORDER BY name")->fetchAll();
            foreach ($categories as $cat):
            ?>
                <li><a href="catalog.php?cat=<?php echo $cat['id']; ?>"><?php echo htmlspecialchars($cat['name']); ?></a></li>
            <?php endforeach; ?>
        </ul>
    </div>
</nav>

<?php $flash = getFlash(); if ($flash): ?>
    <div class="container">
        <div class="flash flash-<?php echo $flash['type']; ?>">
            <?php echo htmlspecialchars($flash['message']); ?>
        </div>
    </div>
<?php endif; ?>
