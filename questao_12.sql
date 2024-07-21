/* Crie uma query que obtenha todos os dados de pedidos (Orders) que envolvam os fornecedores 
da cidade 'Manchester' e foram enviados pela empresa 'Speedy Express'; */

SELECT 
    O.OrderID AS [ID do Pedido],
    O.CustomerID AS [ID do Cliente],
    C.CompanyName AS [Cliente],
	O.ShipName AS [Destinatário],
    O.ShipAddress AS [Endereço Destino],
    O.ShipCity AS [Cidade Destino],
    ISNULL(O.ShipRegion, 'N/ Especificado') AS [Região Destino], -- Tratando valores nulos
    O.ShipPostalCode AS [Código Postal],
    O.ShipCountry AS [País Destino],
	O.ShipVia AS [Tipo de Envio],
    SP.CompanyName AS [Transportadora],
	FORMAT(O.OrderDate, 'dd/MM/yy') AS [Data do Pedido],
	FORMAT(O.RequiredDate, 'dd/MM/yy') AS [Data da Requisição],
	FORMAT(O.ShippedDate, 'dd/MM/yy') AS [Data do Envio],
    P.ProductID AS [Id do Produto],
    P.ProductName AS [Produto],
	P.QuantityPerUnit AS [Unidade de Medida],
	S.CompanyName AS [Fornecedor],
	S.City AS [Cidade do Fornecedor],
	S.CompanyName AS [Fornecedor],
	S.City AS [Cidade do Fornecedor],
    OD.UnitPrice AS [Preço Unitário],
    OD.Quantity AS [Quantidade],
    OD.Discount AS [Desconto],
	O.Freight AS [Valor do Frete],
	(((OD.UnitPrice - (OD.UnitPrice * OD.Discount)) * OD.Quantity) + O.Freight) AS [Total do Pedido]

FROM 
    Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
INNER JOIN Products P ON OD.ProductID = P.ProductID
INNER JOIN Suppliers S ON P.SupplierID = S.SupplierID
INNER JOIN Shippers SP ON O.ShipVia = SP.ShipperID
INNER JOIN Customers C ON O.CustomerID = C.CustomerID
INNER JOIN Employees E ON O.EmployeeID = E.EmployeeID
WHERE 
    SP.CompanyName = 'Speedy Express'
    AND S.City = 'Manchester'
ORDER BY 
    O.OrderID;