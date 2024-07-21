/* Crie uma query que obtenha os números de pedidos e a lista de clientes (CompanyName, ContactName, Address e Phone), 
que possuam 171 como código de área do telefone e que o frete dos pedidos custem entre $6.00 e $13.00; */

-- CTE para obter IDs dos clientes com código de área (171) no telefone

WITH Clientes171 AS (
    SELECT DISTINCT CustomerID AS ID
    FROM Customers
    WHERE LEFT(Phone, 5) = '(171)'
)
-- Consulta principal para obter os pedidos e detalhes dos clientes filtrados
SELECT 
    O.OrderID AS [Número do Pedido],
	FORMAT(O.OrderDate, 'dd/MM/yy') AS [Data do Pedido],
    C.CompanyName AS [Nome da Empresa],
    C.Address AS [Endereço],
    C.Phone AS [Telefone],
    S.CompanyName AS [Nome da Transportadora],
    P.ProductID AS [ID do Produto], 
    P.ProductName AS [Nome do Produto],
    SP.CompanyName AS [Nome do Fornecedor],
    CA.CategoryName AS [Nome da Categoria],
    OD.UnitPrice AS [Preço Unitário],
    OD.Quantity AS [Quantidade],
    OD.Discount AS [Desconto],
    O.Freight AS [Frete],
	(((OD.UnitPrice - (OD.UnitPrice * OD.Discount)) * OD.Quantity) + O.Freight) AS [Total do Pedido]
FROM 
    Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
INNER JOIN Products P ON P.ProductID = OD.ProductID
INNER JOIN Suppliers SP ON SP.SupplierID = P.SupplierID
INNER JOIN Categories CA ON CA.CategoryID = P.CategoryID
INNER JOIN Shippers S ON S.ShipperID = O.ShipVia
INNER JOIN Customers C ON C.CustomerID = O.CustomerID 
WHERE 
    C.CustomerID IN (SELECT ID FROM Clientes171)
    AND O.Freight BETWEEN 6.00 AND 13.00
ORDER BY 
    O.OrderID DESC, 
    C.CompanyName, 
    P.ProductName;