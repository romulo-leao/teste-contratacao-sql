-- Crie uma query que obtenha a lista de produtos (ProductName, UnitPrice) que tem pre�o acima da m�dia

WITH AveragePrice AS (
    -- Calcula o pre�o m�dio dos produtos
    SELECT AVG(UnitPrice) AS [Pre�o M�dio]
    FROM dbo.Products
)

SELECT 
    ProductName AS [Nome do Produto],
    UnitPrice AS [Pre�o Unit�rio],
    CASE
        WHEN Discontinued = 0 THEN 'Ativo'
        WHEN Discontinued = 1 THEN 'Descontinuado'
        ELSE 'Desconhecido'
    END AS [Status do Produto]          -- Como a quest�o n�o espec�ficou se queria apenas produtos ativos ou descontinuados, inseri ambos os produtos e adicionei uma coluna para f�cil identifica��o do status

FROM 
    dbo.Products
CROSS JOIN 
    AveragePrice
WHERE 
    UnitPrice > AveragePrice.[Pre�o M�dio] -- Filtra produtos com pre�o acima da m�dia
ORDER BY -- Ordena os produtos por status e em seguida por pre�o
    CASE 
        WHEN Discontinued = 0 THEN 1
        WHEN Discontinued = 1 THEN 2
        ELSE 3
    END,
    UnitPrice DESC                       -- Ordena por pre�o do maior para o menor