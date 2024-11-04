SELECT
	a.F01504 AS pasta,
	ROW_NUMBER() OVER (PARTITION BY a.F01504 ORDER BY a.F18650) AS rownum,
	b.F00227 AS desdobramento,
	CAST(a.F18650 AS DATE) AS criado_em,
	d.F00091 AS advogado_interno,
	CASE
		WHEN a.F00489 = 1 THEN 'Não'
		WHEN a.F00489 = 2 THEN 'Sim' 
		ELSE NULL
	END AS encerrado
FROM [ramaprod].[dbo].T00083 AS a
LEFT JOIN [ramaprod].[dbo].T00046 AS b ON a.F00488 = b.ID
LEFT JOIN [ramaprod].[dbo].T00041 AS c ON a.F00496 = c.ID
LEFT JOIN [ramaprod].[dbo].T00030 AS d ON c.F11578 = d.ID
WHERE 
	b.F00227 IN ('Embargos de Terceiro', 'Embargos à Execução')
	AND a.F00489 = 1
ORDER BY rownum DESC;