-- Dev1sk TECH E-Commerce Database Schema
-- Drop existing database if exists
DROP DATABASE IF EXISTS dev1sk_tech;
CREATE DATABASE dev1sk_tech CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE dev1sk_tech;

-- Users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    cpf VARCHAR(14),
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Categories table
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    image VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Products table
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    slug VARCHAR(200) UNIQUE NOT NULL,
    description TEXT,
    specifications TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    image VARCHAR(255),
    featured BOOLEAN DEFAULT FALSE,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    INDEX idx_category (category_id),
    INDEX idx_slug (slug),
    INDEX idx_featured (featured),
    INDEX idx_active (active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Shopping cart table
CREATE TABLE cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_product (user_id, product_id),
    INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Orders table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    shipping_address TEXT NOT NULL,
    shipping_city VARCHAR(50),
    shipping_state VARCHAR(50),
    shipping_zip VARCHAR(10),
    payment_method VARCHAR(50),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_order_number (order_number),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Order items table
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    product_name VARCHAR(200) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert sample categories
INSERT INTO categories (name, slug, description, image) VALUES
('Processadores', 'processadores', 'CPUs Intel e AMD para alto desempenho', 'cpu.jpg'),
('Placas de Video', 'placas-de-video', 'GPUs NVIDIA e AMD para gaming e trabalho', 'gpu.jpg'),
('Memorias RAM', 'memorias-ram', 'Memorias DDR4 e DDR5 de alta velocidade', 'ram.jpg'),
('Armazenamento', 'armazenamento', 'SSDs NVMe, SATA e HDDs', 'storage.jpg'),
('Placas-Mae', 'placas-mae', 'Motherboards para diferentes plataformas', 'motherboard.jpg'),
('Perifericos', 'perifericos', 'Teclados, mouses e headsets gamer', 'peripherals.jpg'),
('Monitores', 'monitores', 'Monitores gaming e profissionais', 'monitor.jpg');

-- Insert sample products
INSERT INTO products (category_id, name, slug, description, specifications, price, stock_quantity, image, featured) VALUES
-- Processadores
(1, 'Intel Core i9-14900K', 'intel-core-i9-14900k', 'Processador Intel de 14a geracao com 24 cores', '24 cores, 32 threads, 6.0GHz turbo, LGA1700', 3499.99, 15, 'placeholder.php?text=Intel+i9&color=1a75ff', TRUE),
(1, 'AMD Ryzen 9 7950X', 'amd-ryzen-9-7950x', 'Processador AMD topo de linha com 16 cores', '16 cores, 32 threads, 5.7GHz boost, AM5', 3199.99, 12, 'placeholder.php?text=AMD+Ryzen+9&color=ed1c24', TRUE),
(1, 'Intel Core i7-14700K', 'intel-core-i7-14700k', 'Excelente processador para gaming e produtividade', '20 cores, 28 threads, 5.6GHz turbo, LGA1700', 2499.99, 20, 'placeholder.php?text=Intel+i7&color=1a75ff', FALSE),
(1, 'AMD Ryzen 7 7800X3D', 'amd-ryzen-7-7800x3d', 'Melhor CPU para gaming com 3D V-Cache', '8 cores, 16 threads, 5.0GHz boost, AM5', 2699.99, 18, 'placeholder.php?text=AMD+Ryzen+7&color=ed1c24', TRUE),

-- Placas de Video
(2, 'NVIDIA GeForce RTX 4090', 'nvidia-rtx-4090', 'A placa de video mais poderosa da NVIDIA', '24GB GDDR6X, 16384 CUDA cores, Ray Tracing', 12999.99, 8, 'placeholder.php?text=RTX+4090&color=76b900', TRUE),
(2, 'AMD Radeon RX 7900 XTX', 'amd-rx-7900-xtx', 'GPU AMD de alta performance com 24GB', '24GB GDDR6, RDNA 3, Ray Tracing', 8999.99, 10, 'placeholder.php?text=RX+7900+XTX&color=ed1c24', TRUE),
(2, 'NVIDIA GeForce RTX 4070 Ti', 'nvidia-rtx-4070-ti', 'Placa de video de alta performance para 1440p', '12GB GDDR6X, 7680 CUDA cores, DLSS 3', 5499.99, 25, 'placeholder.php?text=RTX+4070+Ti&color=76b900', FALSE),
(2, 'AMD Radeon RX 7800 XT', 'amd-rx-7800-xt', 'Excelente custo-beneficio para gaming', '16GB GDDR6, RDNA 3, FSR 3', 3999.99, 30, 'placeholder.php?text=RX+7800+XT&color=ed1c24', FALSE),

-- Memorias RAM
(3, 'Corsair Vengeance DDR5 32GB', 'corsair-vengeance-ddr5-32gb', 'Kit 2x16GB DDR5 6000MHz RGB', '32GB (2x16GB), DDR5, 6000MHz, CL30, RGB', 899.99, 40, 'placeholder.php?text=Corsair+DDR5&color=ffcc00', TRUE),
(3, 'Kingston Fury Beast DDR5 64GB', 'kingston-fury-ddr5-64gb', 'Kit 2x32GB DDR5 5600MHz', '64GB (2x32GB), DDR5, 5600MHz, CL36', 1499.99, 25, 'placeholder.php?text=Kingston+DDR5&color=000000', FALSE),
(3, 'G.Skill Trident Z5 RGB 32GB', 'gskill-trident-z5-32gb', 'Memoria premium DDR5 com RGB', '32GB (2x16GB), DDR5, 6400MHz, CL32, RGB', 1099.99, 30, 'placeholder.php?text=G.Skill+DDR5&color=333333', FALSE),

-- Armazenamento
(4, 'Samsung 990 PRO 2TB NVMe', 'samsung-990-pro-2tb', 'SSD NVMe PCIe 4.0 de altissima velocidade', '2TB, NVMe PCIe 4.0, 7450MB/s leitura', 1299.99, 35, 'placeholder.php?text=Samsung+990&color=1428a0', TRUE),
(4, 'WD Black SN850X 1TB', 'wd-black-sn850x-1tb', 'SSD gaming de alta performance', '1TB, NVMe PCIe 4.0, 7300MB/s leitura', 699.99, 45, 'placeholder.php?text=WD+Black&color=000000', FALSE),
(4, 'Crucial P5 Plus 500GB', 'crucial-p5-plus-500gb', 'SSD NVMe rapido e acessivel', '500GB, NVMe PCIe 4.0, 6600MB/s leitura', 399.99, 50, 'placeholder.php?text=Crucial+P5&color=cc0000', FALSE),

-- Placas-Mae
(5, 'ASUS ROG Maximus Z790 Hero', 'asus-rog-z790-hero', 'Placa-mae premium para Intel 14a geracao', 'LGA1700, DDR5, PCIe 5.0, WiFi 6E, RGB', 3299.99, 12, 'placeholder.php?text=ASUS+ROG&color=000000', TRUE),
(5, 'MSI MPG X670E Carbon WiFi', 'msi-x670e-carbon', 'Placa-mae topo para AMD Ryzen 7000', 'AM5, DDR5, PCIe 5.0, WiFi 6E, RGB', 2999.99, 15, 'placeholder.php?text=MSI+MPG&color=000000', TRUE),
(5, 'Gigabyte B760 AORUS Elite', 'gigabyte-b760-elite', 'Otimo custo-beneficio para Intel', 'LGA1700, DDR5, PCIe 4.0, WiFi 6', 1499.99, 20, 'placeholder.php?text=Gigabyte+B760&color=ff6600', FALSE),

-- Perifericos
(6, 'Logitech G Pro X Superlight', 'logitech-g-pro-superlight', 'Mouse gamer wireless ultra leve', 'Wireless, 25600 DPI, 63g, HERO sensor', 899.99, 60, 'placeholder.php?text=Logitech+G+Pro&color=0070c9', TRUE),
(6, 'Razer BlackWidow V4 Pro', 'razer-blackwidow-v4', 'Teclado mecanico premium com RGB', 'Mecanico, Green Switch, RGB, wireless', 1299.99, 40, 'placeholder.php?text=Razer+V4+Pro&color=000000', TRUE),
(6, 'HyperX Cloud III', 'hyperx-cloud-3', 'Headset gamer confortavel e imersivo', '7.1 surround, USB, microfone destacavel', 699.99, 55, 'placeholder.php?text=HyperX+Cloud&color=ee0000', FALSE),
(6, 'SteelSeries Apex Pro TKL', 'steelseries-apex-pro-tkl', 'Teclado mecanico com switches ajustaveis', 'Mecanico, OmniPoint switches, TKL, OLED', 1199.99, 35, 'placeholder.php?text=SteelSeries+Apex&color=ff6600', FALSE),

-- Monitores
(7, 'LG UltraGear 27GR95QE-B', 'lg-ultragear-27gr95qe', 'Monitor OLED 240Hz para gaming', '27", 2560x1440, OLED, 240Hz, 0.03ms', 6999.99, 15, 'placeholder.php?text=LG+UltraGear&color=a50034', TRUE),
(7, 'Samsung Odyssey G7 32"', 'samsung-odyssey-g7-32', 'Monitor curvo QHD 240Hz', '32", 2560x1440, VA, 240Hz, 1ms, curvo', 3499.99, 20, 'placeholder.php?text=Samsung+Odyssey&color=1428a0', TRUE),
(7, 'ASUS TUF Gaming VG27AQ', 'asus-tuf-vg27aq', 'Monitor gaming IPS 165Hz', '27", 2560x1440, IPS, 165Hz, 1ms', 1999.99, 30, 'placeholder.php?text=ASUS+TUF&color=999999', FALSE);

-- Insert sample users (password is 'password123' hashed with bcrypt)
INSERT INTO users (username, email, password, full_name, phone, address, city, state, zip_code) VALUES
('admin', 'admin@dev1sk.tech', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Administrador Sistema', '(11) 98765-4321', 'Rua Admin, 100', 'São Paulo', 'SP', '01234-567'),
('joaosilva', 'joao.silva@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'João Silva', '(11) 91234-5678', 'Rua das Flores, 123', 'São Paulo', 'SP', '01310-100'),
('mariasantos', 'maria.santos@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Maria Santos', '(21) 92345-6789', 'Av. Atlântica, 456', 'Rio de Janeiro', 'RJ', '22070-002'),
('pedrocosta', 'pedro.costa@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Pedro Costa', '(31) 93456-7890', 'Rua da Bahia, 789', 'Belo Horizonte', 'MG', '30160-011'),
('anaoliveira', 'ana.oliveira@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Ana Oliveira', '(11) 94567-8901', 'Av. Paulista, 1500', 'São Paulo', 'SP', '01310-200'),
('carlosrodrigues', 'carlos.rodrigues@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Carlos Rodrigues', '(21) 95678-9012', 'Rua do Catete, 234', 'Rio de Janeiro', 'RJ', '22220-001'),
('julianaalves', 'juliana.alves@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Juliana Alves', '(11) 96789-0123', 'Rua Augusta, 890', 'São Paulo', 'SP', '01305-100'),
('rafaelferreira', 'rafael.ferreira@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Rafael Ferreira', '(41) 97890-1234', 'Av. Batel, 567', 'Curitiba', 'PR', '80420-090'),
('patricialima', 'patricia.lima@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Patrícia Lima', '(85) 98901-2345', 'Rua Dragão do Mar, 321', 'Fortaleza', 'CE', '60060-080'),
('brunogomes', 'bruno.gomes@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Bruno Gomes', '(51) 99012-3456', 'Av. Ipiranga, 678', 'Porto Alegre', 'RS', '90160-093'),
('camilasousa', 'camila.sousa@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Camila Sousa', '(71) 90123-4567', 'Rua Chile, 145', 'Salvador', 'BA', '40020-060'),
('fernandocarvalho', 'fernando.carvalho@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Fernando Carvalho', '(61) 91234-5670', 'SQN 308, Bloco A', 'Brasília', 'DF', '70747-010'),
('beatrizpereira', 'beatriz.pereira@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Beatriz Pereira', '(81) 92345-6781', 'Av. Boa Viagem, 999', 'Recife', 'PE', '51021-000'),
('gustavomartins', 'gustavo.martins@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Gustavo Martins', '(27) 93456-7892', 'Av. Nossa Senhora da Penha, 234', 'Vitória', 'ES', '29055-131'),
('larissabarbosa', 'larissa.barbosa@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Larissa Barbosa', '(48) 94567-8903', 'Rua Felipe Schmidt, 567', 'Florianópolis', 'SC', '88010-001'),
('thiagosantos', 'thiago.santos@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Thiago Santos', '(11) 95678-9014', 'Rua Oscar Freire, 432', 'São Paulo', 'SP', '01426-001'),
('vanessaoliveira', 'vanessa.oliveira@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Vanessa Oliveira', '(21) 96789-0125', 'Av. Vieira Souto, 123', 'Rio de Janeiro', 'RJ', '22420-002'),
('marcosribeiro', 'marcos.ribeiro@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Marcos Ribeiro', '(19) 97890-1236', 'Av. das Amoreiras, 890', 'Campinas', 'SP', '13100-001'),
('leticiasilveira', 'leticia.silveira@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Letícia Silveira', '(31) 98901-2347', 'Av. Afonso Pena, 1234', 'Belo Horizonte', 'MG', '30130-005'),
('rodrigoazevedo', 'rodrigo.azevedo@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Rodrigo Azevedo', '(47) 99012-3458', 'Rua XV de Novembro, 765', 'Blumenau', 'SC', '89010-000'),
('gabrielacastro', 'gabriela.castro@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Gabriela Castro', '(62) 90123-4569', 'Av. T-9, 456', 'Goiânia', 'GO', '74063-010'),
('danielnunes', 'daniel.nunes@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Daniel Nunes', '(91) 91234-5681', 'Av. Presidente Vargas, 234', 'Belém', 'PA', '66017-000'),
('isabelafreitas', 'isabela.freitas@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Isabela Freitas', '(84) 92345-6792', 'Av. Eng. Roberto Freire, 567', 'Natal', 'RN', '59090-000');

-- Insert sample orders with IDOR vulnerability demonstration
INSERT INTO orders (user_id, order_number, total_amount, status, shipping_address, shipping_city, shipping_state, shipping_zip, payment_method) VALUES
(2, 'ORD-2024-0001', 4199.98, 'delivered', 'Rua das Flores, 123', 'São Paulo', 'SP', '01310-100', 'Cartão de Crédito'),
(2, 'ORD-2024-0002', 13899.98, 'processing', 'Rua das Flores, 123', 'São Paulo', 'SP', '01310-100', 'PIX'),
(3, 'ORD-2024-0003', 9899.97, 'shipped', 'Av. Atlântica, 456', 'Rio de Janeiro', 'RJ', '22070-002', 'Cartão de Crédito'),
(3, 'ORD-2024-0004', 2699.99, 'pending', 'Av. Atlântica, 456', 'Rio de Janeiro', 'RJ', '22070-002', 'Boleto'),
(4, 'ORD-2024-0005', 7698.97, 'delivered', 'Rua da Bahia, 789', 'Belo Horizonte', 'MG', '30160-011', 'PIX'),
(5, 'ORD-2024-0006', 5999.98, 'delivered', 'Av. Paulista, 1500', 'São Paulo', 'SP', '01310-200', 'Cartão de Crédito'),
(5, 'ORD-2024-0007', 3199.99, 'processing', 'Av. Paulista, 1500', 'São Paulo', 'SP', '01310-200', 'PIX'),
(6, 'ORD-2024-0008', 8999.99, 'shipped', 'Rua do Catete, 234', 'Rio de Janeiro', 'RJ', '22220-001', 'Cartão de Crédito'),
(6, 'ORD-2024-0009', 1999.98, 'delivered', 'Rua do Catete, 234', 'Rio de Janeiro', 'RJ', '22220-001', 'Boleto'),
(7, 'ORD-2024-0010', 12999.99, 'processing', 'Rua Augusta, 890', 'São Paulo', 'SP', '01305-100', 'PIX'),
(7, 'ORD-2024-0011', 2499.99, 'pending', 'Rua Augusta, 890', 'São Paulo', 'SP', '01305-100', 'Cartão de Crédito'),
(8, 'ORD-2024-0012', 6799.98, 'delivered', 'Av. Batel, 567', 'Curitiba', 'PR', '80420-090', 'PIX'),
(9, 'ORD-2024-0013', 4599.99, 'shipped', 'Rua Dragão do Mar, 321', 'Fortaleza', 'CE', '60060-080', 'Cartão de Crédito'),
(9, 'ORD-2024-0014', 1299.99, 'delivered', 'Rua Dragão do Mar, 321', 'Fortaleza', 'CE', '60060-080', 'Boleto'),
(10, 'ORD-2024-0015', 9599.97, 'processing', 'Av. Ipiranga, 678', 'Porto Alegre', 'RS', '90160-093', 'PIX'),
(10, 'ORD-2024-0016', 3999.99, 'shipped', 'Av. Ipiranga, 678', 'Porto Alegre', 'RS', '90160-093', 'Cartão de Crédito'),
(11, 'ORD-2024-0017', 7299.98, 'delivered', 'Rua Chile, 145', 'Salvador', 'BA', '40020-060', 'PIX'),
(12, 'ORD-2024-0018', 5499.99, 'processing', 'SQN 308, Bloco A', 'Brasília', 'DF', '70747-010', 'Cartão de Crédito'),
(12, 'ORD-2024-0019', 2199.98, 'pending', 'SQN 308, Bloco A', 'Brasília', 'DF', '70747-010', 'Boleto'),
(13, 'ORD-2024-0020', 11899.97, 'shipped', 'Av. Boa Viagem, 999', 'Recife', 'PE', '51021-000', 'PIX'),
(14, 'ORD-2024-0021', 3499.99, 'delivered', 'Av. Nossa Senhora da Penha, 234', 'Vitória', 'ES', '29055-131', 'Cartão de Crédito'),
(14, 'ORD-2024-0022', 6999.98, 'processing', 'Av. Nossa Senhora da Penha, 234', 'Vitória', 'ES', '29055-131', 'PIX'),
(15, 'ORD-2024-0023', 4899.98, 'delivered', 'Rua Felipe Schmidt, 567', 'Florianópolis', 'SC', '88010-001', 'Cartão de Crédito'),
(16, 'ORD-2024-0024', 8599.97, 'shipped', 'Rua Oscar Freire, 432', 'São Paulo', 'SP', '01426-001', 'PIX'),
(16, 'ORD-2024-0025', 1899.99, 'pending', 'Rua Oscar Freire, 432', 'São Paulo', 'SP', '01426-001', 'Boleto'),
(17, 'ORD-2024-0026', 9999.98, 'delivered', 'Av. Vieira Souto, 123', 'Rio de Janeiro', 'RJ', '22420-002', 'Cartão de Crédito'),
(17, 'ORD-2024-0027', 2699.99, 'processing', 'Av. Vieira Souto, 123', 'Rio de Janeiro', 'RJ', '22420-002', 'PIX'),
(18, 'ORD-2024-0028', 5799.98, 'shipped', 'Av. das Amoreiras, 890', 'Campinas', 'SP', '13100-001', 'Cartão de Crédito'),
(19, 'ORD-2024-0029', 7499.97, 'delivered', 'Av. Afonso Pena, 1234', 'Belo Horizonte', 'MG', '30130-005', 'PIX'),
(19, 'ORD-2024-0030', 3899.98, 'processing', 'Av. Afonso Pena, 1234', 'Belo Horizonte', 'MG', '30130-005', 'Cartão de Crédito'),
(20, 'ORD-2024-0031', 6299.99, 'pending', 'Rua XV de Novembro, 765', 'Blumenau', 'SC', '89010-000', 'Boleto'),
(21, 'ORD-2024-0032', 4299.98, 'shipped', 'Av. T-9, 456', 'Goiânia', 'GO', '74063-010', 'PIX'),
(21, 'ORD-2024-0033', 9199.97, 'delivered', 'Av. T-9, 456', 'Goiânia', 'GO', '74063-010', 'Cartão de Crédito'),
(22, 'ORD-2024-0034', 2999.99, 'processing', 'Av. Presidente Vargas, 234', 'Belém', 'PA', '66017-000', 'PIX'),
(23, 'ORD-2024-0035', 8399.98, 'delivered', 'Av. Eng. Roberto Freire, 567', 'Natal', 'RN', '59090-000', 'Cartão de Crédito');

-- Insert sample order items
INSERT INTO order_items (order_id, product_id, product_name, quantity, price, subtotal) VALUES
-- Order 1 (João Silva)
(1, 7, 'NVIDIA GeForce RTX 4070 Ti', 1, 5499.99, 5499.99),
(1, 15, 'Logitech G Pro X Superlight', 3, 899.99, 2699.97),
-- Order 2 (João Silva)
(2, 5, 'NVIDIA GeForce RTX 4090', 1, 12999.99, 12999.99),
(2, 9, 'Corsair Vengeance DDR5 32GB', 1, 899.99, 899.99),
-- Order 3 (Maria Santos)
(3, 6, 'AMD Radeon RX 7900 XTX', 1, 8999.99, 8999.99),
(3, 15, 'Logitech G Pro X Superlight', 1, 899.99, 899.99),
-- Order 4 (Maria Santos)
(4, 4, 'AMD Ryzen 7 7800X3D', 1, 2699.99, 2699.99),
-- Order 5 (Pedro Costa)
(5, 2, 'AMD Ryzen 9 7950X', 1, 3199.99, 3199.99),
(5, 8, 'AMD Radeon RX 7800 XT', 1, 3999.99, 3999.99),
(5, 17, 'HyperX Cloud III', 1, 699.99, 699.99),
-- Order 6 (Ana Oliveira)
(6, 7, 'NVIDIA GeForce RTX 4070 Ti', 1, 5499.99, 5499.99),
(6, 11, 'Kingston Fury Beast DDR5 64GB', 1, 1499.99, 1499.99),
-- Order 7 (Ana Oliveira)
(7, 2, 'AMD Ryzen 9 7950X', 1, 3199.99, 3199.99),
-- Order 8 (Carlos Rodrigues)
(8, 6, 'AMD Radeon RX 7900 XTX', 1, 8999.99, 8999.99),
-- Order 9 (Carlos Rodrigues)
(9, 15, 'Logitech G Pro X Superlight', 1, 899.99, 899.99),
(9, 12, 'G.Skill Trident Z5 RGB 32GB', 1, 1099.99, 1099.99),
-- Order 10 (Juliana Alves)
(10, 5, 'NVIDIA GeForce RTX 4090', 1, 12999.99, 12999.99),
-- Order 11 (Juliana Alves)
(11, 3, 'Intel Core i7-14700K', 1, 2499.99, 2499.99),
-- Order 12 (Rafael Ferreira)
(12, 8, 'AMD Radeon RX 7800 XT', 1, 3999.99, 3999.99),
(12, 9, 'Corsair Vengeance DDR5 32GB', 1, 899.99, 899.99),
(12, 16, 'Razer BlackWidow V4 Pro', 1, 1299.99, 1299.99),
(12, 17, 'HyperX Cloud III', 1, 699.99, 699.99),
-- Order 13 (Patrícia Lima)
(13, 4, 'AMD Ryzen 7 7800X3D', 1, 2699.99, 2699.99),
(13, 16, 'Razer BlackWidow V4 Pro', 1, 1299.99, 1299.99),
(13, 17, 'HyperX Cloud III', 1, 699.99, 699.99),
-- Order 14 (Patrícia Lima)
(14, 12, 'G.Skill Trident Z5 RGB 32GB', 1, 1099.99, 1099.99),
-- Order 15 (Bruno Gomes)
(15, 5, 'NVIDIA GeForce RTX 4090', 1, 12999.99, 12999.99),
(15, 1, 'Intel Core i9-14900K', 1, 3499.99, 3499.99),
-- Order 16 (Bruno Gomes)
(16, 8, 'AMD Radeon RX 7800 XT', 1, 3999.99, 3999.99),
-- Order 17 (Camila Sousa)
(17, 7, 'NVIDIA GeForce RTX 4070 Ti', 1, 5499.99, 5499.99),
(17, 16, 'Razer BlackWidow V4 Pro', 1, 1299.99, 1299.99),
(17, 15, 'Logitech G Pro X Superlight', 1, 899.99, 899.99),
-- Order 18 (Fernando Carvalho)
(18, 7, 'NVIDIA GeForce RTX 4070 Ti', 1, 5499.99, 5499.99),
-- Order 19 (Fernando Carvalho)
(19, 15, 'Logitech G Pro X Superlight', 1, 899.99, 899.99),
(19, 13, 'Samsung 990 PRO 2TB NVMe', 1, 1299.99, 1299.99),
-- Order 20 (Beatriz Pereira)
(20, 5, 'NVIDIA GeForce RTX 4090', 1, 12999.99, 12999.99),
(20, 2, 'AMD Ryzen 9 7950X', 1, 3199.99, 3199.99),
-- Order 21 (Gustavo Martins)
(21, 1, 'Intel Core i9-14900K', 1, 3499.99, 3499.99),
-- Order 22 (Gustavo Martins)
(22, 6, 'AMD Radeon RX 7900 XTX', 1, 8999.99, 8999.99),
(22, 16, 'Razer BlackWidow V4 Pro', 1, 1299.99, 1299.99),
-- Order 23 (Larissa Barbosa)
(23, 7, 'NVIDIA GeForce RTX 4070 Ti', 1, 5499.99, 5499.99),
(23, 11, 'Kingston Fury Beast DDR5 64GB', 1, 1499.99, 1499.99),
-- Order 24 (Thiago Santos)
(24, 8, 'AMD Radeon RX 7800 XT', 1, 3999.99, 3999.99),
(24, 4, 'AMD Ryzen 7 7800X3D', 1, 2699.99, 2699.99),
(24, 16, 'Razer BlackWidow V4 Pro', 1, 1299.99, 1299.99),
(24, 17, 'HyperX Cloud III', 1, 699.99, 699.99),
-- Order 25 (Thiago Santos)
(25, 16, 'Razer BlackWidow V4 Pro', 1, 1299.99, 1299.99),
(25, 17, 'HyperX Cloud III', 1, 699.99, 699.99),
-- Order 26 (Vanessa Oliveira)
(26, 5, 'NVIDIA GeForce RTX 4090', 1, 12999.99, 12999.99),
(26, 9, 'Corsair Vengeance DDR5 32GB', 1, 899.99, 899.99),
-- Order 27 (Vanessa Oliveira)
(27, 4, 'AMD Ryzen 7 7800X3D', 1, 2699.99, 2699.99),
-- Order 28 (Marcos Ribeiro)
(28, 7, 'NVIDIA GeForce RTX 4070 Ti', 1, 5499.99, 5499.99),
(28, 12, 'G.Skill Trident Z5 RGB 32GB', 1, 1099.99, 1099.99),
-- Order 29 (Letícia Silveira)
(29, 6, 'AMD Radeon RX 7900 XTX', 1, 8999.99, 8999.99),
(29, 1, 'Intel Core i9-14900K', 1, 3499.99, 3499.99),
-- Order 30 (Letícia Silveira)
(30, 8, 'AMD Radeon RX 7800 XT', 1, 3999.99, 3999.99),
(30, 16, 'Razer BlackWidow V4 Pro', 1, 1299.99, 1299.99),
-- Order 31 (Rodrigo Azevedo)
(31, 7, 'NVIDIA GeForce RTX 4070 Ti', 1, 5499.99, 5499.99),
(31, 9, 'Corsair Vengeance DDR5 32GB', 1, 899.99, 899.99),
-- Order 32 (Gabriela Castro)
(32, 4, 'AMD Ryzen 7 7800X3D', 1, 2699.99, 2699.99),
(32, 15, 'Logitech G Pro X Superlight', 1, 899.99, 899.99),
(32, 17, 'HyperX Cloud III', 1, 699.99, 699.99),
-- Order 33 (Gabriela Castro)
(33, 5, 'NVIDIA GeForce RTX 4090', 1, 12999.99, 12999.99),
(33, 2, 'AMD Ryzen 9 7950X', 1, 3199.99, 3199.99),
-- Order 34 (Daniel Nunes)
(34, 2, 'AMD Ryzen 9 7950X', 1, 3199.99, 3199.99),
-- Order 35 (Isabela Freitas)
(35, 6, 'AMD Radeon RX 7900 XTX', 1, 8999.99, 8999.99),
(35, 16, 'Razer BlackWidow V4 Pro', 1, 1299.99, 1299.99);
