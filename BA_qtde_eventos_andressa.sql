SELECT
	d.ID AS id,
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
	END)  AS situacao,
	MAX(aa.F00156) AS tipo_acao,
	MAX(x.F47448) AS segmento,
	MAX(m.F01130) AS carteira,
	MAX(
		CASE 
		WHEN m.F01130 IN ('E1', 'Massificado PJ', 'PF', 'Massificado PJ - E2', 'E2', 'Autos Santander', 'Alto Ticket', 'Massificado PJ','Diligência Varejo Massificado') THEN 'Varejo'
		WHEN m.F01130 = 'Créditos Especiais - Special Credits' AND x.F47448 IN ('E2 POLO', 'BAIXO TICKET') THEN 'Varejo'
		WHEN m.F01130 IN ('Empresas 3 - Judicial Especializado', 'Empresas 3 - Núcleo Massificado', 'Créditos Especiais - Special Credit') AND x.F47448 = 'E3' THEN 'E3'
		WHEN m.F01130 IN ('Falência', 'Falência - Créditos Especiai', 'Falência - Empresas 1 e 2', 'Falência - Empresas 3', 'Recuperação Judicial', 'Recuperação Judicial - Créditos Especiais',
            'Recuperação Judicial - Empresas 1 e 2', 'Recuperação Judicial - Empresas 3', 'Recuperação Judicial - Empresas 1 e 2 Baixo Ticket', 'Recuperação Judicial - Produtor Rural') THEN 'Falência e RJ'
		WHEN m.F01130 = 'Credito Rural' THEN 'Agro'
		ELSE 'Outro'
    END )AS setor,
	MAX(
		CASE
			WHEN d.F47441 = 1 THEN 'E1'
			WHEN d.F47441 = 2 THEN 'PF'
			WHEN d.F47441 = 3 THEN 'E2 Risco menor que 500K'
			WHEN d.F47441 = 4 THEN 'E2 Risco maior que 500K'
			WHEN d.F47441 = 5 THEN 'E3'
			WHEN d.F47441 = 6 THEN 'GIU'
			WHEN d.F47441 = 7 THEN 'FAMPE'
			WHEN d.F47441 = 8 THEN 'PRIVATE'
		END ) AS segmento,
	MAX(h.F00162) AS fase,
	MAX(g.F43686) AS subfase,
	MAX(f.F34969) AS tipo_acao,
	MAX(f.F00179) AS valor_causa,
	MAX(i.F00091) AS advogado_interno,
	MAX(k.F02568) AS comarca,
    MAX(SUBSTRING(l.F02571, CHARINDEX('/', l.F02571 + '/') + 1, LEN(l.F02571))) AS cartorio,
    MAX(SUBSTRING(l.F02571, CHARINDEX('/', l.F02571 + '/') + 1, LEN(l.F02571)) + '-' + k.F02568) AS comarca_cartorio,
	CASE
		WHEN MAX(l.F02571) LIKE '%Grande do sul%' THEN 'Rio Grande do Sul'
		WHEN MAX(l.F02571) LIKE '%Paraná%' THEN 'Paraná'
		WHEN MAX(l.F02571) LIKE '%Catarina%' THEN 'Santa Catarina'
		WHEN MAX(l.F02571) LIKE '%Distrito%' THEN 'Distrito Federal'
		WHEN MAX(l.F02571) LIKE '%Paulo%' THEN 'São Paulo'
		WHEN MAX(l.F02571) LIKE '%Janeiro%' THEN 'Rio de Janeiro'
		WHEN MAX(l.F02571) LIKE '%Bahia%' THEN 'Bahia'
		WHEN MAX(l.F02571) LIKE '%Cear%' THEN 'Ceará'
		WHEN MAX(l.F02571) LIKE '%Mato Grosso do Sul%' THEN 'Mato Grosso do Sul'
		WHEN MAX(l.F02571) LIKE '%Goiás%' THEN 'Goiás'
		WHEN MAX(l.F02571) LIKE '%Pern%' THEN 'Pernambuco'
		WHEN MAX(l.F02571) LIKE '%Rond%' THEN 'Rondônia'
		ELSE 'Outro'
	END AS estado,
	MAX(n.F00091) AS adverso,
	MAX(
		CASE
			WHEN n.F00148 = 1 THEN 'PF'
			WHEN n.F00148 = 2 THEN 'PJ'
			WHEN n.F00148 = 3 THEN 'Espólio'
		END) AS tipo_pessoa,
	MAX(n.F27086) AS cpf_cnpj,
	SUM(CASE WHEN j.F01132 = 'BA 2.1 - Deferida liminar de BA/RP' THEN 1 ELSE 0 END) AS BA_21,
	SUM(CASE WHEN j.F01132 = 'BA 3.4 - Mandado negativo' THEN 1 ELSE 0 END) AS BA_34,
	SUM(CASE WHEN j.F01132 = 'BA 4.7 - Novo mandado para novos endereços' THEN 1 ELSE 0 END) AS BA_47,
	SUM(CASE WHEN j.F01132 = 'BA 6.1 - Conversão para execução deferida' THEN 1 ELSE 0 END) AS BA_61
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
LEFT JOIN [ramaprod].[dbo].T00034 AS aa ON d.F01122 = aa.ID
GROUP BY a.F04461, d.ID
HAVING
	MAX(f.F25017) <> 2 AND
	MAX(x.F47448) <> 'E3' AND
	MAX(aa.F00156) IN ('Ação de Busca e Apreensão', 'Ação de Busca e Apreensão convertida em Execução', 'Ação de Reintegração convertida em Execução', 'Apreensão e Reintegração')
ORDER BY criado_em DESC;