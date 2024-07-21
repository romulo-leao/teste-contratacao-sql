-- Crie uma query que obtenha a lista de produtos (ProductName), e a quantidade por unidade (QuantityPerUnit)

SELECT 
    ProductID AS [ID do Produto],
    ProductName AS [Nome do Produto],
    QuantityPerUnit AS [Quantidade por Unidade]
FROM 
    dbo.Products;