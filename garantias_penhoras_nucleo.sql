SELECT
    a.F14474 AS dossie_2,
    MAX(CASE 
        WHEN a.F25017 = 1 THEN 'Ativo'
        WHEN a.F25017 = 2 THEN 'Encerrado'
        WHEN a.F25017 = 3 THEN 'Acordo'
        WHEN a.F25017 = 6 THEN 'Em encerramento'
        WHEN a.F25017 = 4 THEN 'Em precatório (Ativo)'
    END) AS situacao,
    MAX(a.F05314) AS nucleo_pr_2,
    MAX(aa.F00156) AS tipo_acao,
    MAX(m.F01130) AS carteira,
    MAX(b.F11574) AS valor_garantia,
    MAX(b.F15678) AS valor,
    MAX(c.F15703) AS tipo_garantia
FROM [ramaprod].[dbo].T00041 AS a
LEFT JOIN [ramaprod].[dbo].T00074 AS b ON a.ID = b.F15674
LEFT JOIN [ramaprod].[dbo].T01292 AS c ON b.F15677 = c.ID
LEFT JOIN [ramaprod].[dbo].T00034 AS aa ON a.F01122 = aa.ID
LEFT JOIN [ramaprod].[dbo].T00035 AS m ON a.F01187 = m.ID
GROUP BY a.F14474
HAVING MAX(a.F05314) = 10 AND MAX(c.F15703) is null AND MAX(a.F25017) <> 2