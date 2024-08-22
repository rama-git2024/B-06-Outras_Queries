	SELECT
		a.F04461 AS pasta,
		MAX(d.F14474) AS dossie,
		MAX(e.F01062) AS criado_em,
		MAX(
			CASE
				WHEN f.F25017 = 1 THEN 'Ativo'
				WHEN f.F25017 = 2 THEN 'Encerrado'
				WHEN f.F25017 = 3 THEN 'Acordo'
				WHEN f.F25017 = 4 THEN 'Em encerramento'
				ELSE 'Em precatório (Ativo)'
			END
		)  AS situacao,
		MAX(s.F00227) AS desdobramento_nome,
		MAX(m.F01130) AS carteira,
		MAX(x.F47448) AS segmento_novo_pessoa,
		MAX(h.F00162) AS fase,
		MAX(g.F43686) AS subfase,
		MAX(f.F34969) AS tipo_acao,
		MAX(f.F00179) AS valor_causa,
		MAX(i.F00091) AS advogado_interno,
		MAX(k.F02568) AS comarca,
		MAX(n.F00091) AS adverso,
		MAX(
			CASE
				WHEN n.F00148 = 1 THEN 'PF'
				WHEN n.F00148 = 2 THEN 'PJ'
				WHEN n.F00148 = 3 THEN 'Espólio'
			END) AS tipo_pessoa,
		MAX(n.F27086) AS cpf_cnpj	
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
	LEFT JOIN [ramaprod].[dbo].T02913 AS t ON d.F47450 = t.ID
	LEFT JOIN [ramaprod].[dbo].T00030 AS v ON f.F05220 = v.ID
	LEFT JOIN [ramaprod].[dbo].T02913 AS x ON v.F47449 = x.ID
	LEFT JOIN [ramaprod].[dbo].T02676 AS z ON d.F43645 = z.ID
	LEFT JOIN [ramaprod].[dbo].T02678 AS w ON d.F43647 = w.ID
	LEFT JOIN [ramaprod].[dbo].T02677 AS y ON d.F43646 = y.ID
	GROUP BY a.F04461
	HAVING
		(MONTH(max(e.F01062)) = MONTH(GETDATE()) AND YEAR(max(e.F01062)) = YEAR(GETDATE())) AND
		MAX(x.F47448) IN ('E3', 'AGRO')
