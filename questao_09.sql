-- Crie uma query que obtenha o(s) produto(s) mais caro(s) e o(s) mais barato(s) da lista (ProductName e UnitPrice);

/* Pra não ficar uma consulta muito básica, decidi colocar o produto mais barato e mais caro de cada categoria e adicionei também o fornecedor
Acredito que essa seria uma consulta mais rica e que poderia gerar mais insights no dia a dia */ 

WITH ProductPrices AS (
    SELECT 
        P.CategoryID,
        P.ProductID,
        P.ProductName,
        P.UnitPrice,
        P.SupplierID,
        C.CategoryName,
        S.CompanyName AS SupplierName,
        ROW_NUMBER() OVER (PARTITION BY P.CategoryID ORDER BY P.UnitPrice DESC) AS rn_max,
        ROW_NUMBER() OVER (PARTITION BY P.CategoryID ORDER BY P.UnitPrice ASC) AS rn_min
    FROM 
        dbo.Products P
    INNER JOIN 
        dbo.Categories C ON P.CategoryID = C.CategoryID
    INNER JOIN 
        dbo.Suppliers S ON P.SupplierID = S.SupplierID
),
FilteredProducts AS (
    SELECT 
        CategoryID,
        ProductID,
        ProductName,
        UnitPrice,
        SupplierID,
        CategoryName,
        SupplierName,
        CASE 
            WHEN rn_max = 1 THEN 'Mais Caro'
            WHEN rn_min = 1 THEN 'Mais Barato'
        END AS Status
    FROM 
        ProductPrices
    WHERE 
        rn_max = 1 OR rn_min = 1
)
SELECT 
    CategoryName AS Categoria,
    ProductID AS [ID Produto],
    ProductName AS [Nome do Produto],
    Status,
    UnitPrice AS [Preço Unitário],
    SupplierName AS [Nome do Fornecedor]
FROM 
    FilteredProducts
ORDER BY 
    CategoryName,
    Status DESC;