-- Cria a stored procedure para retornar produtos e pre�os

CREATE PROCEDURE GetProductPrices
AS
BEGIN
    -- Seleciona o nome e o pre�o de cada produto
    SELECT 
        ProductName AS [Nome do Produto],
        UnitPrice AS [Pre�o Unit�rio]
    FROM 
        dbo.Products;
END
GO