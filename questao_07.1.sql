-- Cria a stored procedure para retornar produtos e preços

CREATE PROCEDURE GetProductPrices
AS
BEGIN
    -- Seleciona o nome e o preço de cada produto
    SELECT 
        ProductName AS [Nome do Produto],
        UnitPrice AS [Preço Unitário]
    FROM 
        dbo.Products;
END
GO