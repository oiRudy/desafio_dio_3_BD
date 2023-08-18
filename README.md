# Desafio: Construindo Projeto Lógico de Banco de Dados de um E-Commerce 

Criar um banco de dados relacional de um e-commerce

## Objetivo

Replique a modelagem do projeto lógico de banco de dados para o cenário de e-commerce. Fique atento as definições de chave primária e estrangeira, assim como as constraints presentes no cenário modelado. Perceba que dentro desta modelagem haverá relacionamentos presentes no modelo EER. Sendo assim, consulte como proceder para estes casos. Além disso, aplique o mapeamento de modelos aos refinamentos propostos no módulo de modelagem conceitual.

Assim como demonstrado durante o desafio, realize a criação do Script SQL para criação do esquema do banco de dados. Posteriormente, realize a persistência de dados para realização de testes. Especifique ainda queries mais complexas dos que apresentadas durante a explicação do desafio. 

Sendo assim, crie queries SQL com as diretrizes abaixo:

 - Não há um mínimo de queries a serem realizadas;
 - Elabore perguntas que podem ser respondidas pelas consultas;
 - As cláusulas podem estar presentes em mais de uma query;
 - Avaliação do desafio de projeto: Adicione ao Readme a descrição do projeto lógico para fornecer o contexto sobre seu esquema lógico apresentado.

## Resolução

#### > Mapeamento do esquema ERRelacional
![Dio3](https://github.com/oiRudy/desafio_dio_3_BD/assets/139499341/d28cb683-425a-4fec-a703-7df5e91a0e3b)

As principais informações que podem ser extradas e adiciandas apartir do modelo apresentado são:

 - client: Representa os clientes do e-commerce, incluindo informações como nome, CPF, CNPJ, endereço, etc.

 - product: Representa os produtos disponíveis no e-commerce, incluindo informações como nome, classificação, categoria, avaliação, etc.

 - orders: Representa os pedidos feitos pelos clientes, incluindo informações como status do pedido, descrição do pedido, valor do envio, etc.

 - productOrder: Uma tabela de relacionamento entre os produtos e os pedidos, indicando quantidades e status dos produtos em cada pedido.

 - storage: Representa o estoque dos produtos, incluindo informações sobre a localização do estoque e a quantidade disponível.

 - storageLocation: Uma tabela de relacionamento entre produtos e localizações de estoque, indicando onde cada produto está armazenado.

 - supplier: Representa os fornecedores dos produtos, incluindo informações como nome social, CNPJ, contato, etc.

 - productSupplier: Uma tabela de relacionamento entre produtos e fornecedores, indicando quais produtos são fornecidos por quais fornecedores.

 - seller: Representa os vendedores associados ao e-commerce, incluindo informações como nome social, CNPJ, CPF, etc.

 - productSeller: Uma tabela de relacionamento entre produtos e vendedores, indicando quais produtos são vendidos por quais vendedores.

 - payments: Representa os métodos de pagamento disponíveis para os clientes, incluindo informações como tipo de pagamento e limite disponível.

 - delivery: Representa as informações de entrega para os pedidos, incluindo o status da entrega e o código de rastreio.

Essas são as principais tabelas apresentadas no código SQL, cada uma com seu propósito específico dentro do cenário de e-commerce.
#### > Definição do script SQL para criação do esquema de banco de dados

1.Criação do banco de dados para cenario de E-Commerce
```sql
CREATE DATABASE ecommerce;
```

2.Criação das tabelas do banco de dados para cenario de E-Commerce
```sql
-- cria tabela cliente
CREATE TABLE client (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(10),
    Minit CHAR(3),
    Lname VARCHAR(20),
    CPF CHAR(11),
    CNPJ CHAR(15),
    Address VARCHAR(100),
    CONSTRAINT unique_cpf_client UNIQUE (CPF),
    CONSTRAINT unique_cnpj_client UNIQUE (CNPJ),
    CONSTRAINT check_cpf_cnpj CHECK ((CPF IS NOT NULL AND CNPJ IS NULL) OR (CPF IS NULL AND CNPJ IS NOT NULL))
);

-- cria tabela produto
CREATE TABLE product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(100) NOT NULL,
    classification_kids BOOLEAN DEFAULT FALSE,
    category ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') NOT NULL,
    avaliation FLOAT DEFAULT 0,
    size VARCHAR(10)
);

-- cria tabela pedidos
CREATE TABLE orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT,
    orderStatus ENUM('Cancelado', 'Confirmado', 'Em Processamento') NOT NULL,
    orderDescription VARCHAR(255),
    sendValue FLOAT DEFAULT 10,
    paymentCash BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_orders_client FOREIGN KEY (idOrderClient) REFERENCES client(idClient)
);

-- cria a tabela pedido/produto
CREATE TABLE productOrder (
    idPOProduct INT,
    idPOrder INT,
    podQuantity INT DEFAULT 1,
    poStatus ENUM('Em Estoque', 'Sem Estoque') DEFAULT 'Em Estoque',
    PRIMARY KEY (idPOProduct, idPOrder),
    CONSTRAINT fk_productorder_product FOREIGN KEY (idPOProduct) REFERENCES product(idProduct),
    CONSTRAINT fk_productorder_order FOREIGN KEY (idPOrder) REFERENCES orders(idOrder)
);

-- cria a tabela estoque
CREATE TABLE storage (
    idProdStorage INT AUTO_INCREMENT PRIMARY KEY,
    storageLocation VARCHAR(255),
    quantity INT DEFAULT 0
);

-- cria tabela localização de estoque
CREATE TABLE storageLocation (
    idLproduct INT,
    idStorage INT,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (idLproduct, idStorage),
    CONSTRAINT fk_storage_location_product FOREIGN KEY (idLproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_storage_location_storage FOREIGN KEY (idStorage) REFERENCES storage(idProdStorage)
);

-- cria a tabela fornecedor
CREATE TABLE supplier (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);

-- cria a tabela produto/fornecedor
CREATE TABLE productSupplier (
    idPSupplier INT,
    idPsProduct INT,
    quantity INT NOT NULL,
    PRIMARY KEY (idPSupplier, idPsProduct),
    CONSTRAINT fk_product_supplier_supplier FOREIGN KEY (idPSupplier) REFERENCES supplier(idSupplier),
    CONSTRAINT fk_product_supplier_product FOREIGN KEY (idPsProduct) REFERENCES product(idProduct)
);

-- cria a tabela vendedor
CREATE TABLE seller (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL,
    AbstName VARCHAR(255),
    CNPJ CHAR(15) NOT NULL,
    CPF CHAR(11),
    location VARCHAR(255),
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_seller UNIQUE (CNPJ),
    CONSTRAINT unique_cpf_seller UNIQUE (CPF)
);

-- cria a tabela produto/vendedor
CREATE TABLE productSeller (
    idPSeller INT,
    idpProduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY (idPSeller, idpProduct),
    CONSTRAINT fk_product_seller FOREIGN KEY (idPSeller) REFERENCES seller(idSeller),
    CONSTRAINT fk_product_product FOREIGN KEY (idpProduct) REFERENCES product(idProduct)
);

-- cria a tabela pagamentos
CREATE TABLE payments (
    idClient INT,
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    typePayment ENUM('Boleto', 'Debito', 'Credito'),
    limitAvailable FLOAT,
    CONSTRAINT fk_payments_client FOREIGN KEY (idClient) REFERENCES client(idClient)
);

-- cria a tabela entrega
CREATE TABLE delivery (
    idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    deliveryStatus ENUM('Pendente', 'Em Trânsito', 'Entregue'),
    trackingCode VARCHAR(50),
    CONSTRAINT fk_delivery_order FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);
```

#### > Persistência de dados para teste
```sql
USE ecommerce;

--Tabela Cliente
INSERT INTO client (Fname, Minit, Lname, CPF, CNPJ,  Address)
VALUES  ('Marcia', 'M', 'Silva', '98765432100', null, 'rua silva de prata 29, Caragola-Cidade das flores'),
        ('João', 'A', 'Santos', null, '12345678900', 'Av. das Palmeiras 123, Centro'),
        ('Maria', 'C', 'Oliveira', '45678912300', null, 'Rua das Flores 567, Jardim'),
        ('Pedro', 'R', 'Silveira', null,'98765432101', 'Rua das Pedras 45, Praia'),
        ('Ana', 'G', 'Pereira', '98765432102', null, 'Av. do Sol 789, Recanto');

--Tabela Pagamento
INSERT INTO payments (idClient, typePayment, limitAvailable)
VALUES  (1, 'Boleto', 500),
        (2, 'Debito', 1000),
        (3, 'Credito', 750),
        (4, 'Credito', 300),
        (5, 'Boleto', 200);

--Tabela Produto
INSERT INTO product (Pname, classification_kids, category, avaliation, size)
VALUES  ('Headphone', false, 'Eletrônico', 4, null),
        ('Barbie', true, 'Brinquedos', 5, null),
        ('Smartphone', false, 'Eletrônico', 4.5, null),
        ('Camiseta', false, 'Vestimenta', 4, 'M'),
        ('TV LED', false, 'Eletrônico', 4.8, '55 polegadas');

--Tabela Pedido
INSERT INTO orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash)
VALUES  (1, 'Confirmado', 'Debito', null, 1),
        (2, 'Confirmado', 'Credito', 50, 0),
        (3, 'Em Processamento', 'Boleto', 25, 0),
        (4, 'Em Processamento', 'Debito', 15, 0),
        (5, 'Cancelado', 'Credito', 30, 1);

--Tabela PedidoProduto
INSERT INTO productOrder (idPOProduct, idPOrder, podQuantity, poStatus)
VALUES  (1, 1, 2, 'Em Estoque'),
        (2, 1, 1, 'Sem Estoque'),
        (3, 2, 3, 'Em Estoque'),
        (4, 3, 2, 'Sem Estoque'),
        (5, 4, 1, 'Em Estoque');

--Tabela Estoque
INSERT INTO storage (storageLocation, quantity)
VALUES  ('Rio de Janeiro', 1000),
        ('São Paulo', 500),
        ('Belo Horizonte', 750),
        ('Curitiba', 300),
        ('Recife', 200);

--Tabela Locazação de Estoque
INSERT INTO storageLocation (idLproduct, idStorage, location)
VALUES  (1, 2, 'RJ'),
        (2, 1, 'SP'),
        (3, 4, 'MG'),
        (4, 3, 'PR'),
        (5, 5, 'PE');

--Tabela Fornecedor
INSERT INTO supplier (socialName, CNPJ, contact)
VALUES  ('Almeida e Filhos', '123456789123456', '21982191712'),
        ('ABC Brinquedos', '987654321987654', '21953218888'),
        ('Tech Eletrônicos', '456789123456789', '11999887766'),
        ('Moda Fashion', '789012345678901', '3199556677'),
        ('Móveis de Luxo', '111222333444555', '4199887766');

--Tabela produto/fornecedor
INSERT INTO productSupplier (idPSupplier, idPsProduct, quantity)
VALUES  (1, 1, 1000),
        (1, 2, 500),
        (2, 2, 800),
        (3, 3, 1500),
        (4, 4, 300),
        (5, 5, 100);

--Tabela vendedor
INSERT INTO seller (socialName, AbstName, CNPJ, CPF, location, contact)
VALUES  ('Tech Eletrônicos', null, '123456789123456', null, 'Rio de Janeiro', '2198291712'),
        ('Moda Fashion', null, null, '12345678900', 'São Paulo', '2195251515'),
        ('ABC Brinquedos', null, '987654321987654', null, 'Belo Horizonte', '3198887777'),
        ('Diversões Kids', null, null, '98765432101', 'Recife', '81977665544'),
        ('Móveis de Luxo', null, '111222333444555', null, 'Curitiba', '4199887766');

--Tabela produto/vendedor
INSERT INTO productSeller (idPSeller, idpProduct, prodQuantity)
VALUES  (1, 1, 1000),
        (1, 2, 500),
        (2, 2, 800),
        (3, 3, 1500),
        (4, 4, 300),
        (5, 5, 100);

--Tabela Entrega
INSERT INTO delivery (idOrder, deliveryStatus, trackingCode)
VALUES  (1, 'Em Trânsito', 'ABCD1234'),
        (2, 'Pendente', 'EFGH5678'),
        (3, 'Entregue', 'IJKL9012'),
        (4, 'Pendente', 'MNOP3456'),
        (5, 'Entregue', 'QRST7890');

```
#### > Recuperação de informação com queries SQL
O projeto solicitou os seguintes requisitos para essa etapa: 

 - Recuperações simples com SELECT Statement
 - Filtros com WHERE Statement
 - Crie expressões para gerar atributos derivados
 - Defina ordenações dos dados com ORDER BY
 - Condições de filtros aos grupos – HAVING Statement
 - Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados

Em adição as requisitos foi solicitado responder algumas perguntas, que seguem abaixo:

Pergunta 1: Quantos pedidos foram feitos por cada cliente?
```sql
-- Requisição 1
SELECT c.Fname, COUNT(o.idOrder) AS num_orders
FROM client c
LEFT JOIN orders o ON c.idClient = o.idOrderClient
GROUP BY c.idClient;
```
Resposta 1: 
```
+--------+------------+
| Fname  | num_orders |
+--------+------------+
| Marcia |          2 |
| João   |          1 |
| Maria  |          2 |
| Pedro  |          0 |
| Ana    |          0 |
+--------+------------+
```

Pergunta 2: Algum vendedor também é fornecedor?
```sql
-- Requisição 2
SELECT s.socialName AS seller_name, f.socialName AS supplier_name
FROM seller s
INNER JOIN productSupplier ps ON s.idSeller = ps.idPSeller
INNER JOIN supplier f ON ps.idPSupplier = f.idSupplier;
```
Resposta 2: 
```
+------------------+------------------+
| seller_name | supplier_name         |
+------------------+------------------+
| Tech Eletrônicos | Almeida e Filhos |
| Moda Fashion     | ABC Brinquedos   |
| ABC Brinquedos   | ABC Brinquedos   |
| ABC Brinquedos   | ABC Brinquedos   |
| Móveis de Luxo   | Móveis de Luxo   |
+------------------+------------------+
```

Pergunta 3: Algum vendedor também é fornecedor?
```sql
-- Requisição 3
SELECT p.Pname, f.socialName AS supplier_name, s.storageLocation, sl.location AS storage_location
FROM product p
INNER JOIN productSupplier ps ON p.idProduct = ps.idPsProduct
INNER JOIN supplier f ON ps.idPSupplier = f.idSupplier
INNER JOIN storage s ON p.idProduct = s.idProdStorage
INNER JOIN storageLocation sl ON s.idProdStorage = sl.idLproduct;
```
Resposta 3: 
```
+------------+------------------+-----------------+------------------+
| Pname      | supplier_name    | storageLocation | storage_location|
+------------+------------------+-----------------+------------------+
| Headphone  | Almeida e Filhos | Rio de Janeiro  | RJ               |
| Barbie     | Almeida e Filhos | São Paulo       | SP               |
| Barbie     | ABC Brinquedos   | Belo Horizonte  | MG               |
| Smartphone | Tech Eletrônicos | Curitiba        | PR               |
| Camiseta   | Moda Fashion     | Recife          | PE               |
+------------+------------------+-----------------+------------------+
```

Pergunta 4: Relação de nomes dos fornecedores e nomes dos produtos;
```sql
-- Requisição 4
SELECT f.socialName AS supplier_name, GROUP_CONCAT(p.Pname SEPARATOR ', ') AS products_supplied
FROM supplier f
INNER JOIN productSupplier ps ON f.idSupplier = ps.idPSupplier
INNER JOIN product p ON ps.idPsProduct = p.idProduct
GROUP BY f.idSupplier;

```
Resposta 4: 
```
+------------------+---------------------------+
| supplier_name    | products_supplied         |
+------------------+---------------------------+
| Almeida e Filhos | Headphone, Barbie         |
| ABC Brinquedos   | Barbie                    |
| Tech Eletrônicos | Smartphone                |
| Moda Fashion     | Camiseta                  |
| Móveis de Luxo   | TV LED                    |
+------------------+---------------------------+
```

Pergunta 5: Quais clientes fizeram pedidos de produtos da categoria 'Eletrônico'?
```sql
-- Requisição 5
SELECT c.Fname, c.Lname, p.Pname, o.orderStatus
FROM client c
INNER JOIN orders o ON c.idClient = o.idOrderClient
INNER JOIN productOrder po ON o.idOrder = po.idPOrder
INNER JOIN product p ON po.idPOProduct = p.idProduct
WHERE p.category = 'Eletrônico';
```
Resposta 5: 
```
+--------+----------+------------+------------------+
| Fname  | Lname    | Pname      | orderStatus      |
+--------+----------+------------+------------------+
| Marcia | Silva    | Headphone  | Confirmado       |
| Marcia | Silva    | Smartphone | Em Processamento |
| João   | Santos   | Headphone  | Confirmado       |
| Pedro  | Silveira | Smartphone | Em Processamento |
+--------+----------+------------+------------------+
```

## Aprendizados

Durante o desafio, tive a chance de aplicar meus conhecimentos em SQL e criar um sistema funcional que simula um banco de dados de e-commerce. Fui capaz de aprimorar minhas habilidades e demonstrei minha capacidade de desenvolver soluções práticas e eficientes.

![SQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white) 
![Git](https://img.shields.io/badge/Git-000?style=for-the-badge&logo=git&logoColor=E94D5F) 

## Referência

 - [Potência Tech powered by iFood: Ciência de Dados com Python](https://web.dio.me/track/potencia-tech-powered-ifood-ciencias-de-dados-com-python)
