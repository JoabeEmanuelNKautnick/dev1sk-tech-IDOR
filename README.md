***

# Dev1sk TECH – E‑Commerce

Dev1sk TECH é um e‑commerce focado em hardware de alto desempenho (CPUs, GPUs, memórias, armazenamento e periféricos), desenvolvido em PHP com MySQL para fins educacionais e práticos.

## Visão geral

- Catálogo de produtos organizado por categorias e itens em destaque.[^10][^9]
- Autenticação de usuários com registro, login e gerenciamento de sessão.[^11][^12][^1]
- Carrinho de compras por usuário logado, com validação de estoque.[^3][^9]
- Fluxo de checkout com criação de pedidos e itens de pedido.[^13][^2][^9]
- Retorno de detalhes de pedidos em JSON para uso no front.[^2][^8]


## Tecnologias

- **Backend:** PHP (PDO para acesso ao banco).[^14][^5][^3][^4]
- **Banco de Dados:** MySQL/MariaDB (`schema.sql`).[^9]
- **Frontend:** HTML, CSS e JavaScript vanilla.[^5][^6][^7][^4]


## Funcionalidades principais

### Catálogo e produtos

- Listagem de categorias (processadores, placas de vídeo, memórias, armazenamento, periféricos, etc.).[^9]
- Página de produto com descrição, especificações, preço, imagem e botão “Adicionar ao carrinho”.[^5][^9]


### Usuários e autenticação

- Cadastro de usuário com dados pessoais (CPF, telefone, endereço).[^12][^9]
- Login/logout baseado em sessão PHP.[^15][^1][^11]


### Carrinho de compras

- Adição de produtos ao carrinho com checagem de `stock_quantity`.[^3][^9]
- Consolidação de itens por usuário+produto via chave única em `cart`.[^3][^9]
- Endpoint para retornar a contagem de itens do carrinho e atualizar o front.[^16][^6]


### Pedidos

- Criação de registros em `orders` e `order_items` a partir do carrinho.[^13][^2][^9]
- Cálculo de total e armazenamento de subtotais por item.[^2][^9]
- Endpoint `orders.php` que retorna dados completos de um pedido em JSON.[^8][^2]


## Estrutura do banco de dados

O banco é criado pelo script `schema.sql` com o nome `dev1sk_tech`.[^9]

Principais tabelas:

- **users** – dados de login e perfil do cliente.[^9]
- **categories** – categorias de produtos com `slug` único.[^9]
- **products** – produtos com preço, estoque, especificações e flags `featured`/`active`.[^9]
- **cart** – itens do carrinho por usuário, com constraint única `(user_id, product_id)`.[^9]
- **orders** – cabeçalho do pedido (valor total, status, endereço de entrega, método de pagamento).[^9]
- **order_items** – itens do pedido com quantidade, preço e subtotal.[^9]

O script também popula categorias e vários produtos de exemplo (Intel i9, Ryzen 9, RTX 4090, memórias DDR5, etc.).[^9]

## Estrutura de arquivos

- `config.php` – conexão PDO e funções auxiliares (sessão, redirecionamento, mensagens).[^17][^1]
- `index.php` – página inicial com destaques.[^4]
- `catalog.php` – listagem de produtos por categoria.[^10]
- `product.php` – detalhes de produto e integração com o carrinho.[^5][^3]
- `register.php` / `login.php` / `logout.php` – fluxo de autenticação de usuários.[^11][^15][^12]
- `add_to_cart.php` – lógica de adicionar ao carrinho com validação de estoque.[^3]
- `get_cart_count.php` – retorno da contagem de itens do carrinho.[^16]
- `checkout.php` – criação de pedidos a partir do carrinho.[^13]
- `orders.php` / `order_details.php` – consulta e exibição de pedidos.[^8][^2]
- `style.css` – estilos e layout do site.[^7]
- `script.js` – interações de front-end (ex.: contador do carrinho).[^6]
- `placeholder.php`, `test_images.php` – geração de imagens de placeholder para produtos.[^18][^19]


## Como executar

1. Importar o arquivo `schema.sql` em um servidor MySQL/MariaDB.[^9]
2. Ajustar as credenciais de banco em `config.php` (host, database, usuário, senha).[^1]
3. Colocar os arquivos do projeto em um servidor web com suporte a PHP (Apache, Nginx+PHP-FPM, XAMPP, etc.).[^4][^5][^3]
4. Acessar `index.php` no navegador para utilizar o sistema.[^4]

## Segurança

O endpoint `orders.php` contém uma vulnerabilidade proposital (sem checagem de autenticação e de propriedade do pedido), permitindo acesso indevido a pedidos via manipulação de ID (*IDOR*).[^8]

Para uso real em produção, é necessário:

- Garantir que apenas usuários autenticados acessem detalhes de pedidos.[^1][^8]
- Filtrar pedidos por `order_id` **e** `user_id` do usuário logado na consulta SQL.[^8][^9]


## Licença

MIT License

<div align="center">⁂</div>

[^1]: config.php

[^2]: order_details.php

[^3]: add_to_cart.php

[^4]: index.php

[^5]: product.php

[^6]: script.js

[^7]: style.css

[^8]: orders.php

[^9]: schema.sql

[^10]: catalog.php

[^11]: login.php

[^12]: register.php

[^13]: checkout.php

[^14]: orders.php

[^15]: logout.php

[^16]: get_cart_count.php

[^17]: config.php

[^18]: placeholder.php

[^19]: test_images.php

[^20]: add_to_cart.php

[^21]: footer.php

[^22]: login.php

[^23]: logo.jpg

[^24]: logonome.jpg

[^25]: logout.php

[^26]: placeholder.php

[^27]: script.js

[^28]: style.css

[^29]: register.php

[^30]: test_images.php

[^31]: orders.php

[^32]: schema.sql

[^33]: placeholder.jpg

[^34]: footer.php

[^35]: logonome.jpg

[^36]: logo.jpg

[^37]: orders.php

[^38]: order_details.php

[^39]: orders.php

[^40]: schema.sql

[^41]: placeholder.jpg

[^42]: placeholder.jpg

