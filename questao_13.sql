/* Crie uma query que obtenha a lista de Produtos (ProductName) constantes nos Detalhe dos Pedidos (Order Details),
calculando o valor total de cada produto já aplicado o desconto % (se tiver algum); */

SELECT
    P.ProductName AS [Nome do Produto],
    S.CompanyName AS [Fornecedor],
    C.CategoryName AS [Categoria],
    FORMAT(
        SUM(
            ROUND((OD.UnitPrice - (OD.UnitPrice * OD.Discount)) * OD.Quantity, 2)
        ), 
        'N2', 
        'pt-BR'
    ) AS [Total Liquido ($)]
FROM
    dbo.[Order Details] OD
INNER JOIN
    Products P ON OD.ProductID = P.ProductID
INNER JOIN
    Suppliers S ON P.SupplierID = S.SupplierID
INNER JOIN
    Categories C ON P.CategoryID = C.CategoryID
GROUP BY
    P.ProductName,
    S.CompanyName,
    C.CategoryName
ORDER BY
    SUM(
        ROUND((OD.UnitPrice - (OD.UnitPrice * OD.Discount)) * OD.Quantity, 2)
    ) DESC;  -- Ordena os produtos pelo valor total em ordem decrescente
