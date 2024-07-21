/* Adicione à procedure, criada na questão anterior, o parâmetro 'Codigo_Transportadora' (permitindo escolher 1 ou mais) 
e um outro parâmetro 'Tipo_Saida' para se optar por uma saída OLTP (Transacional) ou OLAP (Pivot). */

ALTER PROCEDURE GetProductPrices 
    @Codigo_Fornecedor NVARCHAR(MAX),   -- Parâmetro para escolher um ou mais fornecedores
    @Codigo_Categoria NVARCHAR(MAX),    -- Parâmetro para escolher um ou mais categorias
    @Codigo_Transportadora NVARCHAR(MAX), -- Parâmetro para escolher um ou mais transportadoras
    @Tipo_Saida CHAR(4)                 -- Parâmetro para escolher o tipo de saída: 'OLTP' ou 'OLAP'
AS
BEGIN
    SET NOCOUNT ON;

    -- Validação dos parâmetros
    IF @Codigo_Fornecedor IS NULL OR TRIM(@Codigo_Fornecedor) = '' 
    BEGIN 
        PRINT 'Código do fornecedor está vazio. Forneça um código ou escreva NULL para selecionar todos os fornecedores'; 
        RETURN; 
    END
    IF @Codigo_Categoria IS NULL OR TRIM(@Codigo_Categoria) = '' 
    BEGIN 
        PRINT 'Código da categoria está vazio. Forneça um código ou escreva NULL para selecionar todas as categorias'; 
        RETURN; 
    END
    IF @Codigo_Transportadora IS NULL OR TRIM(@Codigo_Transportadora) = '' 
    BEGIN 
        PRINT 'Código da transportadora está vazio. Forneça um código ou escreva NULL para selecionar todas as transportadoras'; 
        RETURN; 
    END
    IF @Tipo_Saida NOT IN ('OLTP','OLAP') 
    BEGIN 
        PRINT 'Tipo de saída inválida'; 
        RETURN; 
    END

    -- Consulta para o tipo OLTP
    IF @Tipo_Saida = 'OLTP'
    BEGIN
        SELECT 
            O.OrderID AS [ID do Pedido],
            P.ProductID AS [ID do Produto],
            P.ProductName AS [Produto],
            SP.CompanyName AS [Fornecedor],
            C.CategoryName AS [Categoria],
			S.CompanyName AS [Transportadora],
            OD.UnitPrice AS [Preço Unitário],
            OD.Quantity AS [Quantidade],
            OD.Discount AS [Desconto Aplicado],
			(OD.UnitPrice - (OD.UnitPrice * OD.Discount)) AS [Preço Final com Desconto ($)],
            CASE 
                WHEN P.Discontinued = 0 THEN 'Ativo'
                WHEN P.Discontinued = 1 THEN 'Descontinuado'
                ELSE 'Desconhecido'
            END AS [Status do Produto]
        FROM 
            Products P
        INNER JOIN 
            Suppliers SP ON SP.SupplierID = P.SupplierID
        INNER JOIN 
            Categories C ON C.CategoryID = P.CategoryID
        INNER JOIN 
            [Order Details] OD ON OD.ProductID = P.ProductID
        INNER JOIN 
            Orders O ON O.OrderID = OD.OrderID
        INNER JOIN 
            Shippers S ON S.ShipperID = O.ShipVia
        WHERE 
            (@Codigo_Fornecedor IS NULL OR P.SupplierID IN (SELECT value FROM STRING_SPLIT(@Codigo_Fornecedor, ',')))
            AND (@Codigo_Categoria IS NULL OR P.CategoryID IN (SELECT value FROM STRING_SPLIT(@Codigo_Categoria, ',')))
            AND (@Codigo_Transportadora IS NULL OR S.ShipperID IN (SELECT value FROM STRING_SPLIT(@Codigo_Transportadora, ',')))
        ORDER BY 
            P.ProductID, 
            S.CompanyName, 
            OD.Quantity;
    END

    -- Consulta para o tipo OLAP
    ELSE
    BEGIN
        SELECT DISTINCT  
            P.ProductID AS [ID do Produto],
            P.ProductName AS [Produto],
            S.CompanyName AS [Transportadora],
            COUNT(O.OrderID) AS [Qtd de Pedidos],
            ROUND(SUM((OD.UnitPrice - (OD.UnitPrice * OD.Discount)) * OD.Quantity),2) AS [Total Vendido ($)],
            ROUND(AVG(OD.UnitPrice),2) AS [Preço Médio Unitário ($)],
            ROUND(AVG(OD.UnitPrice - (OD.UnitPrice * OD.Discount)),2) AS [Preço Médio com Desconto ($)],
            MAX(OD.Discount) AS [Desconto Máximo],
			MIN(OD.Discount) AS [Desconto Mínimo],
            CASE 
                WHEN P.Discontinued = 0 THEN 'Ativo'
                WHEN P.Discontinued = 1 THEN 'Descontinuado'
                ELSE 'Desconhecido'
            END AS [Status do Produto]
        FROM 
            Products P
        INNER JOIN 
            Suppliers SP ON SP.SupplierID = P.SupplierID
        INNER JOIN 
            Categories C ON C.CategoryID = P.CategoryID
        INNER JOIN 
            [Order Details] OD ON OD.ProductID = P.ProductID
        INNER JOIN 
            Orders O ON O.OrderID = OD.OrderID
        INNER JOIN 
            Shippers S ON S.ShipperID = O.ShipVia
        WHERE 
            (@Codigo_Fornecedor IS NULL OR P.SupplierID IN (SELECT value FROM STRING_SPLIT(@Codigo_Fornecedor, ',')))
            AND (@Codigo_Categoria IS NULL OR P.CategoryID IN (SELECT value FROM STRING_SPLIT(@Codigo_Categoria, ',')))
            AND (@Codigo_Transportadora IS NULL OR S.ShipperID IN (SELECT value FROM STRING_SPLIT(@Codigo_Transportadora, ',')))
        GROUP BY 
            P.ProductID,
            P.ProductName,
            S.CompanyName,
            P.Discontinued
        ORDER BY
			P.ProductID, 
            [Total Vendido ($)] DESC;
    END
END
GO