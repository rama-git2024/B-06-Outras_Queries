WITH processos AS (
SELECT
	MAX(d.F14474) AS dossie,
	MAX(d.F01062) AS criado_em,
	MAX(s.F00227) AS desdobramento_nome,
	MAX(
		CASE
			WHEN j.F01132 = 'BA 6.1 - Conversão para execução deferida' THEN a.F00385
			ELSE NULL
		END) AS evento_conversao,
	MAX(
		CASE
			WHEN j.F01132 = 'CS 1.2 - Iniciado o cumprimento de sentença' THEN a.F00385
			ELSE NULL
		END) AS evento_monitoria,
	MAX(
		CASE
			WHEN j.F01132 IN ('Pesquisa Patrimonial Positiva', 'Pesquisa Patrimonial Negativa', 'Análise de Pesquisa Patrimonial', 'Execução 13.1 - Pesquisa patrimonial negativa',
				'Execução 2.10 Pesquisa patrimonial negativa', 'Execução 2.9 - Pesquisa Patrimonial Positiva')
			THEN a.F00385
			ELSE NULL
		END) AS evento_pesquisa_patrimonial
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
GROUP BY a.F04461
HAVING 
	MAX(f.F25017) = 1 

	AND

	(
		(MAX(s.F00227) = 'Execução de Título Extrajudicial') OR
		(MAX(s.F00227) = 'Busca e Apreensão convertida em Execução' AND MAX(CASE WHEN j.F01132 = 'BA 6.1 - Conversão para execução deferida' THEN j.F01132 ELSE NULL END) IS NOT NULL) OR
		(MAX(s.F00227) = 'Ação Monitória' AND MAX(CASE WHEN j.F01132 = 'CS 1.2 - Iniciado o cumprimento de sentença' THEN j.F01132 ELSE NULL END) IS NOT NULL) 
	) 

	AND

	(
		CASE
			WHEN 	
			MAX(
				CASE
					WHEN j.F01132 IN ('Pesquisa Patrimonial Positiva', 'Pesquisa Patrimonial Negativa', 'Análise de Pesquisa Patrimonial', 'Execução 13.1 - Pesquisa patrimonial negativa',
						'Execução 2.10 Pesquisa patrimonial negativa', 'Execução 2.9 - Pesquisa Patrimonial Positiva')
					THEN a.F00385
					ELSE NULL
				END) IS NULL AND MAX(s.F00227) = 'Execução de Título Extrajudicial'
			THEN 
			DATEDIFF(DAY, MAX(d.F01062), GETDATE()),
			WHEN 
			MAX(
				CASE
					WHEN j.F01132 IN ('Pesquisa Patrimonial Positiva', 'Pesquisa Patrimonial Negativa', 'Análise de Pesquisa Patrimonial', 'Execução 13.1 - Pesquisa patrimonial negativa',
						'Execução 2.10 Pesquisa patrimonial negativa', 'Execução 2.9 - Pesquisa Patrimonial Positiva')
					THEN a.F00385
					ELSE NULL
				END) IS NULL AND MAX(s.F00227) = 'Busca e Apreensão convertida em Execução'
			THEN DATEDIFF(DAY, MAX(CASE WHEN j.F01132 = 'BA 6.1 - Conversão para execução deferida' THEN a.F00385 ELSE NULL	END), GETDATE())
			WHEN 
			MAX(
				CASE
					WHEN j.F01132 IN ('Pesquisa Patrimonial Positiva', 'Pesquisa Patrimonial Negativa', 'Análise de Pesquisa Patrimonial', 'Execução 13.1 - Pesquisa patrimonial negativa',
						'Execução 2.10 Pesquisa patrimonial negativa', 'Execução 2.9 - Pesquisa Patrimonial Positiva')
					THEN a.F00385
					ELSE NULL
				END) IS NOT NULL
			THEN 
			DATEDIFF(DAY, 
				MAX(CASE WHEN j.F01132 IN ('Pesquisa Patrimonial Positiva', 'Pesquisa Patrimonial Negativa', 'Análise de Pesquisa Patrimonial', 'Execução 13.1 - Pesquisa patrimonial negativa',
						'Execução 2.10 Pesquisa patrimonial negativa', 'Execução 2.9 - Pesquisa Patrimonial Positiva') THEN a.F00385
					ELSE NULL END),
				GETDATE())
			ELSE NULL
		END
	) >= 395




	
),
providencias AS (
SELECT
	c.F14474 AS dossie,
	f.F00091 AS resp2,
	b.F00446 AS providencia,
	CASE
		WHEN MAX(a.F00445) = 1 THEN 'Inserido'
		WHEN MAX(a.F00445) = 2 THEN 'Sugestão'
		WHEN MAX(a.F00445) = 3 THEN 'A cumprir'
		WHEN MAX(a.F00445) = 4 THEN 'Cumprido'
		WHEN MAX(a.F00445) = 5 THEN 'Cancelado'
	END AS situacao,
	MAX(a.F05342) AS data,
	MAX(d.F00689) AS criado_por,
	CAST(MAX(a.F00453) AS DATE) AS data_inicio,
	CAST(MAX(a.F17598) AS DATE) AS data_inicio_contagem,
	CAST(MAX(a.F00455) AS DATE) AS data_final,
	CAST(MAX(a.F00451) AS DATE) AS cumprido_em,
	MAX(F06337) AS cumprido_em_log
FROM [ramaprod].[dbo].T00076 AS a
LEFT JOIN [ramaprod].[dbo].T00077 AS b ON a.F00447 = b.ID
LEFT JOIN [ramaprod].[dbo].T00041 AS c ON a.F06982 = c.ID
LEFT JOIN [ramaprod].[dbo].T00003 AS d ON a.F05341 = d.ID
LEFT JOIN [ramaprod].[dbo].T00557 AS e ON a.F05633 = e.ID
LEFT JOIN [ramaprod].[dbo].T00030 AS f ON e.F05200 = f.ID
WHERE c.F14474 IS NOT NULL
GROUP BY c.F14474, f.F00091, b.F00446
HAVING 
	YEAR(CAST(MAX(a.F00453) AS DATE)) >= 2022 AND 
	MAX(c.F01187) IN (8,17,7,29,30,33,12,13,4,24,22,23,5,10,31,11,9,25,20,21,26) AND 
	b.F00446 = 'Solicitar Pesquisa Patrimonial'
),



Processos nos desdobramentos específicos 
com mais de 365 dias sem pesquisa patrimonial efetivada ou sem pesquisa evento_pesquisa_patrimonial

PRocessos com as mesmas características anteriores e quenão possuem a providência solicitar pesquisa aptrimonial cadastrada

fazer a primeira consulta com os dossiês que se encaixam nestas regras, validar e testar o retorno

depois fazer um Join entre as tabelas de processos e providencias para pegar apenas os processos com as regras selecionadas e que não tenham o evento de pesquisa evento_pesquisa_patrimonial





