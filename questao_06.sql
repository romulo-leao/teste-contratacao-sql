-- Crie uma query que obtenha a lista de produtos (ProductName, UnitPrice) que tem preço acima da média

WITH AveragePrice AS (
    -- Calcula o preço médio dos produtos
    SELECT AVG(UnitPrice) AS [Preço Médio]
    FROM dbo.Products
)

SELECT 
    ProductName AS [Nome do Produto],
    UnitPrice AS [Preço Unitário],
    CASE
        WHEN Discontinued = 0 THEN 'Ativo'
        WHEN Discontinued = 1 THEN 'Descontinuado'
        ELSE 'Desconhecido'
    END AS [Status do Produto]          -- Como a questão não específicou se queria apenas produtos ativos ou descontinuados, inseri ambos os produtos e adicionei uma coluna para fácil identificação do status

FROM 
    dbo.Products
CROSS JOIN 
    AveragePrice
WHERE 
    UnitPrice > AveragePrice.[Preço Médio] -- Filtra produtos com preço acima da média
ORDER BY -- Ordena os produtos por status e em seguida por preço
    CASE 
        WHEN Discontinued = 0 THEN 1
        WHEN Discontinued = 1 THEN 2
        ELSE 3
    END,
    UnitPrice DESC                       -- Ordena por preço do maior para o menor