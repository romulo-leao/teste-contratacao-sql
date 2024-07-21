-- Crie uma query que obtenha a lista de produtos ativos (ProductID e ProductName)

SELECT 
    ProductID AS [ID do Produto],
    ProductName AS [Nome do Produto]
FROM 
    dbo.Products
WHERE 
    Discontinued = 0;                   -- Filtra produtos ativos (0 = ativos; 1 = descontinuados)