-- Crie uma query que obtenha a lista de produtos (ProductID, ProductName, UnitPrice) ativos, onde o custo dos produtos são menores que $20

SELECT 
    ProductID AS [ID do Produto],
    ProductName AS [Nome do Produto],
    UnitPrice AS [Preço Unitário]
FROM 
    dbo.Products                        -- Especifica o esquema da tabela
WHERE 
    Discontinued = 0                    -- Filtra produtos ativos (0 = ativos; 1 = descontinuados)
    AND UnitPrice < 20;                 -- Filtra produtos com preço abaixo de 20