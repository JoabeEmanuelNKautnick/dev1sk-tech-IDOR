<?php
require_once 'config.php';

if (isLoggedIn()) {
    redirect('index.php');
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = $_POST['email'] ?? '';
    $password = $_POST['password'] ?? '';
    
    $stmt = $pdo->prepare("SELECT * FROM users WHERE email = ?");
    $stmt->execute([$email]);
    $user = $stmt->fetch();
    
    if ($user && password_verify($password, $user['password'])) {
        $_SESSION['user_id'] = $user['id'];
        $_SESSION['username'] = $user['name'];
        setFlash('Login realizado com sucesso!');
        redirect('index.php');
    } else {
        $error = 'Email ou senha incorretos';
    }
}

include 'header.php';
?>

<title>Login - <?php echo SITE_NAME; ?></title>

<div class="form-container">
    <h2>Entrar</h2>
    
    <?php if (isset($error)): ?>
        <div class="flash flash-error"><?php echo $error; ?></div>
    <?php endif; ?>
    
    <form method="POST">
        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" required>
        </div>
        
        <div class="form-group">
            <label>Senha</label>
            <input type="password" name="password" required>
        </div>
        
        <button type="submit" class="btn btn-primary" style="width: 100%;">Entrar</button>
    </form>
    
    <p style="text-align: center; margin-top: 1rem;">
        Não tem conta? <a href="register.php">Cadastre-se</a>
    </p>
</div>

<?php include 'footer.php'; ?>
