--Crie uma query que obtenha a lista de produtos (ProductID, ProductName, UnitPrice) ativos, onde o custo dos produtos s�o entre $15 e $25;

SELECT 
    ProductID AS [ID do Produto],
    ProductName AS [Nome do Produto],
    UnitPrice AS [Pre�o Unit�rio]
FROM 
    dbo.Products
WHERE 
    Discontinued = 0                    -- Filtra produtos ativos (0 = ativos; 1 = descontinuados)
    AND UnitPrice BETWEEN 15 AND 25;   -- Filtra produtos com pre�o entre 15 e 25