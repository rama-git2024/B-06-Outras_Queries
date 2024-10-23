WITH DossieEventos AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY ev.F09582 DESC) AS rn,
        p.F27086 AS cpf,
        p.F00091 AS nome,
        ev.F09582 AS data_andamento,
        n.F09562 AS andamento,
        dv.F00213 AS divisao_nome,
        ev.F09578 AS complemento
    FROM [ramaprod].[dbo].T00930 AS ev
    LEFT JOIN [ramaprod].[dbo].T00927 AS n ON ev.F13752 = n.ID
    LEFT JOIN [ramaprod].[dbo].T01166 AS cb ON ev.F13753 = cb.ID
    LEFT JOIN [ramaprod].[dbo].T00030 AS p ON cb.F27938 = p.ID
    LEFT JOIN [ramaprod].[dbo].T00045 AS dv ON cb.F31050 = dv.ID
    WHERE 
        ev.F09582 >= CAST('2024-08-28' AS DATE) AND ev.F09582 <= CAST('2024-09-30' AS DATE)
        n.F09562 IN ('Acordo cancelado', 'Acordo externo')
)