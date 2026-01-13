<?php
require_once 'config.php';

if (isLoggedIn()) {
    redirect('index.php');
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = $_POST['name'] ?? '';
    $email = $_POST['email'] ?? '';
    $password = $_POST['password'] ?? '';
    $cpf = $_POST['cpf'] ?? '';
    $phone = $_POST['phone'] ?? '';
    $address = $_POST['address'] ?? '';
    
    // Check if email exists
    $stmt = $pdo->prepare("SELECT id FROM users WHERE email = ?");
    $stmt->execute([$email]);
    
    if ($stmt->fetch()) {
        $error = 'Email já cadastrado';
    } else {
        $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
        $stmt = $pdo->prepare("INSERT INTO users (full_name, email, password, cpf, phone, address) VALUES (?, ?, ?, ?, ?, ?)");
        $stmt->execute([$name, $email, $hashedPassword, $cpf, $phone, $address]);
        
        setFlash('Cadastro realizado com sucesso! Faça login.');
        redirect('login.php');
    }
}

include 'header.php';
?>

<title>Cadastro - <?php echo SITE_NAME; ?></title>

<div class="form-container">
    <h2>Cadastrar</h2>
    
    <?php if (isset($error)): ?>
        <div class="flash flash-error"><?php echo $error; ?></div>
    <?php endif; ?>
    
    <form method="POST">
        <div class="form-group">
            <label>Nome Completo</label>
            <input type="text" name="name" required>
        </div>
        
        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" required>
        </div>
        
        <div class="form-group">
            <label>Senha</label>
            <input type="password" name="password" required minlength="6">
        </div>
        
        <div class="form-group">
            <label>CPF</label>
            <input type="text" name="cpf" placeholder="000.000.000-00" maxlength="14">
        </div>
        
        <div class="form-group">
            <label>Telefone</label>
            <input type="text" name="phone">
        </div>
        
        <div class="form-group">
            <label>Endereço</label>
            <input type="text" name="address">
        </div>
        
        <button type="submit" class="btn btn-primary" style="width: 100%;">Cadastrar</button>
    </form>
    
    <p style="text-align: center; margin-top: 1rem;">
        Já tem conta? <a href="login.php">Faça login</a>
    </p>
</div>

<?php include 'footer.php'; ?>
