/* Adicione à procedure, criada na questão anterior, os parâmetros 'Codigo_Fornecedor' (permitindo escolher 1 ou mais) e 
'Codigo_Categoria' (permitindo escolher 1 ou mais) e altere-a para atender a passagem desses parâmetros; */

ALTER PROCEDURE dbo.GetProductPrices
    @Codigo_Fornecedor VARCHAR(MAX),   -- Parâmetro para escolher um ou mais fornecedores
    @Codigo_Categoria VARCHAR(MAX)     -- Parâmetro para escolher um ou mais categorias
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica se o parâmetro @Codigo_Fornecedor está vazio ou nulo
    IF TRIM(@Codigo_Fornecedor) = ''
    BEGIN
        PRINT 'Código do fornecedor está vazio. Forneça um código ou escreva NULL para selecionar todos os fornecedores';
        RETURN;
    END

    -- Verifica se o parâmetro @Codigo_Categoria está vazio ou nulo
    IF TRIM(@Codigo_Categoria) = ''
    BEGIN
        PRINT 'Código da categoria está vazio. Forneça um código ou escreva NULL para selecionar todos as categorias';
        RETURN;
    END

    -- Seleciona o nome e o preço de cada produto com base nos fornecedores e categorias fornecidos
    SELECT 
        ProductName AS [Nome do Produto],
        UnitPrice AS [Preço Unitário],
		SupplierID as [Código do Fornecedor],
		CategoryID as [Código da Categoria],
        CASE 
            WHEN Discontinued = 0 THEN 'Ativo'
            WHEN Discontinued = 1 THEN 'Descontinuado'
            ELSE 'Desconhecido'
        END AS [Status do Produto]
    FROM 
        dbo.Products
    WHERE 
        (@Codigo_Fornecedor IS NULL OR SupplierID IN (SELECT value FROM STRING_SPLIT(@Codigo_Fornecedor, ',')))
        AND (@Codigo_Categoria IS NULL OR CategoryID IN (SELECT value FROM STRING_SPLIT(@Codigo_Categoria, ',')))
    ORDER BY 
        CASE 
            WHEN Discontinued = 0 THEN 1
            WHEN Discontinued = 1 THEN 2
            ELSE 3
        END,
        UnitPrice DESC;
END
GO