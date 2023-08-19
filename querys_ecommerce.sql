-- Requisição 1
SELECT c.Fname, COUNT(o.idOrder) AS num_orders
FROM client c
LEFT JOIN orders o ON c.idClient = o.idOrderClient
GROUP BY c.idClient;

-- Requisição 2
SELECT s.socialName AS seller_name, f.socialName AS supplier_name
FROM seller s
INNER JOIN productSupplier ps ON s.idSeller = ps.idPSeller
INNER JOIN supplier f ON ps.idPSupplier = f.idSupplier;

-- Requisição 3
SELECT p.Pname, f.socialName AS supplier_name, s.storageLocation, sl.location AS storage_location
FROM product p
INNER JOIN productSupplier ps ON p.idProduct = ps.idPsProduct
INNER JOIN supplier f ON ps.idPSupplier = f.idSupplier
INNER JOIN storage s ON p.idProduct = s.idProdStorage
INNER JOIN storageLocation sl ON s.idProdStorage = sl.idLproduct;

-- Requisição 4
SELECT f.socialName AS supplier_name, GROUP_CONCAT(p.Pname SEPARATOR ', ') AS products_supplied
FROM supplier f
INNER JOIN productSupplier ps ON f.idSupplier = ps.idPSupplier
INNER JOIN product p ON ps.idPsProduct = p.idProduct
GROUP BY f.idSupplier;

-- Requisição 5
SELECT c.Fname, c.Lname, p.Pname, o.orderStatus
FROM client c
INNER JOIN orders o ON c.idClient = o.idOrderClient
INNER JOIN productOrder po ON o.idOrder = po.idPOrder
INNER JOIN product p ON po.idPOProduct = p.idProduct
WHERE p.category = 'Eletrônico';