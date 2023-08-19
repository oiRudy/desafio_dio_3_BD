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
