/* Crie uma query que obtenha a lista de empregados e seus liderados, 
caso o empregado não possua liderado, informar 'Não possui liderados'. */

SELECT 
    E.EmployeeID AS [ID Empregado],
    E.LastName AS [Nome],
    E.FirstName AS [Sobrenome],
    E.Title AS [Cargo],
    ISNULL(
        STUFF(
            (SELECT ', ' + CONCAT(R.FirstName, ' ', R.LastName)
             FROM dbo.Employees R
             WHERE R.ReportsTo = E.EmployeeID
             FOR XML PATH('')), 
            1, 2, ''
        ),
        'Não possui liderados'
    ) AS Liderados
FROM 
    dbo.Employees E
GROUP BY 
    E.EmployeeID,
    E.LastName,
    E.FirstName,
    E.Title;