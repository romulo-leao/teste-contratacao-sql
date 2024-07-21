-- Crie uma query que obtenha a lista de pedidos dos funcionários da região 'Western'

-- CTE para obter IDs dos funcionários na região 'Western'
WITH EmployeesWestern AS (
    SELECT DISTINCT E.EmployeeID, E.FirstName, E.LastName
    FROM Employees E
    INNER JOIN EmployeeTerritories ET ON ET.EmployeeID = E.EmployeeID
    INNER JOIN Territories T ON T.TerritoryID = ET.TerritoryID
    INNER JOIN Region R ON R.RegionID = T.RegionID
    WHERE R.RegionDescription = 'Western'
)
-- Consulta principal
SELECT 
    O.OrderID AS [ID Pedido],
    P.ProductID AS [ID Produto],
    P.ProductName AS [Produto],
    SP.CompanyName AS [Fornecedor],
    C.CategoryName AS [Categoria],
    OD.UnitPrice AS [Preço Unitário],
    OD.Quantity AS [Quantidade],
    OD.Discount AS [Desconto],
	(OD.UnitPrice - (OD.UnitPrice * OD.Discount)) AS [Preço Final com Desconto],
    O.EmployeeID AS [ID Vendedor],
    CONCAT(EW.FirstName, ' ', EW.LastName) AS [Vendedor],
    CU.CompanyName AS [Cliente],
	SH.CompanyName AS [Transportadora]
FROM 
    Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
INNER JOIN Products P ON P.ProductID = OD.ProductID
INNER JOIN Suppliers SP ON SP.SupplierID = P.SupplierID
INNER JOIN Categories C ON C.CategoryID = P.CategoryID
INNER JOIN Shippers SH ON SH.ShipperID = O.ShipVia
INNER JOIN EmployeesWestern EW ON O.EmployeeID = EW.EmployeeID
INNER JOIN Customers CU ON CU.CustomerID = O.CustomerID
ORDER BY 
    O.OrderID DESC -- Ordenar pelos pedidos mais recentes