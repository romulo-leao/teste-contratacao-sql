-- Crie uma query que obtenha a lista de produtos descontinuados (ProductID e ProductName)

SELECT 
    ProductID AS [ID do Produto],
    ProductName AS [Nome do Produto]
FROM 
    dbo.Products
WHERE 
    Discontinued = 1;                   -- Filtra produtos que foram descontinuados (0 = ativos; 1 = descontinuados)