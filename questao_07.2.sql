/* Adicione � procedure, criada na quest�o anterior, os par�metros 'Codigo_Fornecedor' (permitindo escolher 1 ou mais) e 
'Codigo_Categoria' (permitindo escolher 1 ou mais) e altere-a para atender a passagem desses par�metros; */

ALTER PROCEDURE dbo.GetProductPrices
    @Codigo_Fornecedor VARCHAR(MAX),   -- Par�metro para escolher um ou mais fornecedores
    @Codigo_Categoria VARCHAR(MAX)     -- Par�metro para escolher um ou mais categorias
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica se o par�metro @Codigo_Fornecedor est� vazio ou nulo
    IF TRIM(@Codigo_Fornecedor) = ''
    BEGIN
        PRINT 'C�digo do fornecedor est� vazio. Forne�a um c�digo ou escreva NULL para selecionar todos os fornecedores';
        RETURN;
    END

    -- Verifica se o par�metro @Codigo_Categoria est� vazio ou nulo
    IF TRIM(@Codigo_Categoria) = ''
    BEGIN
        PRINT 'C�digo da categoria est� vazio. Forne�a um c�digo ou escreva NULL para selecionar todos as categorias';
        RETURN;
    END

    -- Seleciona o nome e o pre�o de cada produto com base nos fornecedores e categorias fornecidos
    SELECT 
        ProductName AS [Nome do Produto],
        UnitPrice AS [Pre�o Unit�rio],
		SupplierID as [C�digo do Fornecedor],
		CategoryID as [C�digo da Categoria],
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