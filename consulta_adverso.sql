SELECT
	MAX(n.F00091) AS adverso,
	MAX(CASE
		WHEN n.F00148 = 1 THEN 'PF'
		WHEN n.F00148 = 2 THEN 'PJ'
		WHEN n.F00148 = 3 THEN 'Espólio'
	END) AS tipo_pessoa,
	MAX(n.F27086) AS cpf_cnpj,
	MAX(n.F37317) AS ddd_comercial,
	MAX(n.F00143) AS tel_comercial,
	MAX(n.F37318) AS ddd_residencial,
	MAX(n.F00147) AS tel_residencial,
	MAX(n.F04584) AS tel_2,
	max(N.F04583) AS tel_3,
	MAX(n.F01546) AS email,
	MAX(s.F00227) AS desdobramento_nome,
	MAX(f.F00179) AS valor_causa,
	MAX(k.F02568) AS comarca,
	MAX(CASE
		WHEN l.F02571 LIKE '%Grande do sul%' THEN 'Rio Grande do Sul'
		WHEN l.F02571 LIKE '%Paraná%' THEN 'Paraná'
		WHEN l.F02571 LIKE '%Catarina%' THEN 'Santa Catarina'
		WHEN l.F02571 LIKE '%Distrito%' THEN 'Distrito Federal'
		WHEN l.F02571 LIKE '%Paulo%' THEN 'São Paulo'
		WHEN l.F02571 LIKE '%Janeiro%' THEN 'Rio de Janeiro'
		WHEN l.F02571 LIKE '%Bahia%' THEN 'Bahia'
		WHEN l.F02571 LIKE '%Cear%' THEN 'Ceará'
		WHEN l.F02571 LIKE '%Mato Grosso do Sul%' THEN 'Mato Grosso do Sul'
		WHEN l.F02571 LIKE '%Goiás%' THEN 'Goiás'
		WHEN l.F02571 LIKE '%Pern%' THEN 'Pernambuco'
		WHEN l.F02571 LIKE '%Rond%' THEN 'Rondônia'
		ELSE 'Outro'
	END) AS estado
FROM [ramaprod].[dbo].T00069 AS a
LEFT JOIN [ramaprod].[dbo].T00003 AS b ON a.F08501 = b.ID
LEFT JOIN [ramaprod].[dbo].T00064 AS c ON a.F01133 = c.ID
LEFT JOIN [ramaprod].[dbo].T00041 AS d ON a.F02003 = d.ID
LEFT JOIN [ramaprod].[dbo].T00041 AS e ON a.F02003 = e.ID
LEFT JOIN [ramaprod].[dbo].T00041 AS f ON a.F02003 = f.ID
LEFT JOIN [ramaprod].[dbo].T02682 AS g ON f.F43687 = g.ID
LEFT JOIN [ramaprod].[dbo].T00037 AS h ON f.F00177 = h.ID
LEFT JOIN [ramaprod].[dbo].T00030 AS i ON f.F11578 = i.ID
LEFT JOIN [ramaprod].[dbo].T00064 AS j ON a.F01133 = j.ID
LEFT JOIN [ramaprod].[dbo].T00041 AS k ON a.F02003 = k.ID
LEFT JOIN [ramaprod].[dbo].T00041 AS l ON a.F02003 = l.ID
LEFT JOIN [ramaprod].[dbo].T00035 AS m ON f.F01187 = m.ID
LEFT JOIN [ramaprod].[dbo].T00030 AS n ON f.F05220 = n.ID
LEFT JOIN [ramaprod].[dbo].T00045 AS o ON f.F00217 = o.ID
LEFT JOIN [ramaprod].[dbo].T01777 AS p ON f.F34969 = p.ID
LEFT JOIN [ramaprod].[dbo].T00035 AS q ON p.F24930 = q.ID
LEFT JOIN [ramaprod].[dbo].T00083 AS r ON f.F14465 = r.ID
LEFT JOIN [ramaprod].[dbo].T00046 AS s ON r.F00488 = s.ID
GROUP BY d.F14474