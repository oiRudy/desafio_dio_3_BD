-- Cria o Banco de Dados
CREATE DATABASE ecommerce;

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